-- services
local userInput = game:GetService("UserInputService")
local tween = game:GetService("TweenService")
local promptService = game:GetService("ProximityPromptService")
local contentProvider = game:GetService("ContentProvider")

-- grabbing the screen object and its click detector from workspace
-- this is a separate interactive object in the game, not related to the prompt UI
local screen = workspace:WaitForChild("Screen")
local clickDetector = screen:WaitForChild("ClickDetector")

local cam = workspace.CurrentCamera
local plr = game.Players.LocalPlayer

-- activeTweens stores running tweens by element so we can cancel them before starting a new one
-- without this, overlapping tweens fight each other and the UI flickers
local activeTweens = {}

-- targetTransparency stores what each element's "visible" transparency should be
-- instead of hardcoding values in the fade function, each element registers its own target here
-- so fade-in always restores the right value, not just 0
local targetTransparency = {}

-- these are declared here so they can be referenced in both the build section and the prompt logic below
local touchButton
local keyText

-- preload
-- ContentProvider:PreloadAsync blocks until assets are ready, but we don't want to stall the script
-- so this runs in its own thread via task.spawn
-- the sound and image are created just to give PreloadAsync something to load from, then destroyed immediately
task.spawn(function()
    local preloadSound = Instance.new("Sound")
    preloadSound.SoundId = "rbxassetid://71299480774168"

    local preloadImage = Instance.new("ImageLabel")
    preloadImage.Image = "rbxassetid://76366625525168"

    contentProvider:PreloadAsync({ preloadSound, preloadImage })

    preloadSound:Destroy()
    preloadImage:Destroy()
end)

-- screen interaction
-- this block handles clicking on the in-world screen object
-- it locks the player in place, switches the camera to scriptable mode,
-- and tweens it to face the screen.
-- wrapped in do/end to keep these locals scoped and away from the rest of the script
do
    local screenGui = Instance.new("ScreenGui", plr.PlayerGui)
    screenGui.ResetOnSpawn = false
    screenGui.Enabled = false -- starts hidden, only shown when the screen is clicked

    -- back button, used on mobile since there's no keyboard to press X
    local backButton = Instance.new("TextButton", screenGui)
    backButton.BackgroundColor3 = Color3.new(1, 1, 1)
    backButton.Position = UDim2.fromScale(0.42, 0.88)
    backButton.Size = UDim2.fromScale(0.15, 0.1)
    backButton.TextScaled = true
    backButton.Text = ""

    local cornerRadius = Instance.new("UICorner", backButton)

    -- red gradient on the button to make it feel like a "danger / exit" action
    local gradient = Instance.new("UIGradient", backButton)
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(0.666667, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.new(0.333333, 0, 0)),
    })

    local backLabel = Instance.new("TextLabel", backButton)
    backLabel.Size = UDim2.fromScale(1, 1)
    backLabel.BackgroundTransparency = 1
    backLabel.TextScaled = true
    backLabel.Text = "Back"
    backLabel.TextColor3 = Color3.new(1, 0, 0)
    backLabel.TextTransparency = 0.7

    local buttonStroke = Instance.new("UIStroke", backButton)
    buttonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    buttonStroke.Color = Color3.fromRGB(191, 0, 0)
    buttonStroke.Thickness = 2

    -- keyboard hint label, only visible on PC, tells the player to press X to exit
    local keyLabel = Instance.new("TextLabel", screenGui)
    keyLabel.BackgroundTransparency = 1
    keyLabel.Position = UDim2.fromScale(0.485, 0.83)
    keyLabel.Size = UDim2.fromScale(0.02, 0.05)
    keyLabel.TextColor3 = Color3.new(1, 1, 1)
    keyLabel.TextScaled = true
    keyLabel.Text = "(X)"

    clickDetector.MouseClick:Connect(function()
        -- anchor the player so they don't drift while the camera is detached
        plr.Character.HumanoidRootPart.Anchored = true
        screenGui.Enabled = true

        -- switch to scriptable so we have full control over where the camera goes
        cam.CameraType = Enum.CameraType.Scriptable

        -- CFrame math: start from the screen's CFrame, rotate to face it correctly,
        -- then offset 5 studs back so the camera sits in front of the screen
        tween:Create(cam, TweenInfo.new(0.5), {CFrame = screen.CFrame * CFrame.Angles(math.rad(90), math.rad(180), math.rad(-90)) * CFrame.new(0, 0, 5)}):Play()

        if not userInput.KeyboardEnabled then
            -- mobile: use the back button, :Once so it only fires once and doesn't stack
            backButton.MouseButton1Click:Once(function()
                screenGui.Enabled = false
                local camTween = tween:Create(cam, TweenInfo.new(0.5), {CFrame = plr.Character:WaitForChild("Head").CFrame})
                camTween:Play()
                -- wait for the tween to finish before restoring camera control
                -- otherwise the camera snaps back instantly
                camTween.Completed:Once(function()
                    cam.CameraType = Enum.CameraType.Custom
                    plr.Character.HumanoidRootPart.Anchored = false
                end)
            end)
        else
            -- PC: disable the button visually and use a KeyDown connection instead
            backButton.Active = false
            local keyConnection
            keyConnection = plr:GetMouse().KeyDown:Connect(function(v)
                if v:lower() ~= "x" then
                    return
                end
                -- disconnect immediately so this doesn't keep listening after exit
                keyConnection:Disconnect()
                screenGui.Enabled = false
                local camTween = tween:Create(cam, TweenInfo.new(0.5), {CFrame = plr.Character:WaitForChild("Head").CFrame})
                camTween:Play()
                camTween.Completed:Once(function()
                    cam.CameraType = Enum.CameraType.Custom
                    plr.Character.HumanoidRootPart.Anchored = false
                end)
            end)
        end
    end)
end

-- prompt UI construction
-- one BillboardGui is built once and reused for every prompt
-- its Adornee gets swapped to whatever object the prompt is on when PromptShown fires
-- this is more efficient than creating a new GUI every time
local billboard = Instance.new("BillboardGui", plr.PlayerGui)
billboard.ResetOnSpawn = false
billboard.Size = UDim2.new(3, 0, 1, 0)
billboard.StudsOffset = Vector3.new(0, 0.5, 0) -- offset slightly above the part so it doesn't clip
billboard.AlwaysOnTop = true
billboard.Active = true -- must be true for touch input on ImageButtons inside it to work

-- icon container, the box that holds the key label or touch button
local iconFrame = Instance.new("Frame", billboard)
iconFrame.Name = "Icon"
iconFrame.Size = UDim2.new(0.2, 0, 0.6, 0)
iconFrame.Position = UDim2.new(0.4, 0, 0, 0)
iconFrame.BackgroundColor3 = Color3.new(0, 0, 0)
iconFrame.BackgroundTransparency = 1
targetTransparency[iconFrame] = 0.5 -- semi-transparent dark background when visible

local iconCorner = Instance.new("UICorner", iconFrame)

-- inner outline frame, the white bordered box inside the icon
local outlineFrame = Instance.new("Frame", iconFrame)
outlineFrame.Name = "Outline"
outlineFrame.Position = UDim2.new(0.15, 0, 0.15, 0)
outlineFrame.Size = UDim2.new(0.7, 0, 0.7, 0)
outlineFrame.BackgroundTransparency = 1

local outlineStroke = Instance.new("UIStroke", outlineFrame)
outlineStroke.Color = Color3.new(1, 1, 1)
outlineStroke.Thickness = 1.5
outlineStroke.Transparency = 1
targetTransparency[outlineStroke] = 0

local barCorner = Instance.new("UICorner", outlineFrame)

-- input element, either a tap button for touch or a key label for keyboard
-- built once here, since the input type doesn't change mid-session
if userInput.TouchEnabled then
    touchButton = Instance.new("ImageButton", outlineFrame)
    touchButton.Name = "Click"
    touchButton.Image = "rbxassetid://76366625525168"
    touchButton.Size = UDim2.new(1, 0, 1, 0)
    touchButton.BackgroundTransparency = 1
    touchButton.ImageTransparency = 1
    targetTransparency[touchButton] = 0
else
    -- on PC we just show the key name as text, no button needed
    keyText = Instance.new("TextLabel", outlineFrame)
    keyText.Name = "Key"
    keyText.Size = UDim2.new(1, 0, 1, 0)
    keyText.TextScaled = true
    keyText.BackgroundTransparency = 1
    keyText.TextColor3 = Color3.new(1, 1, 1)
    keyText.TextStrokeColor3 = Color3.new(1, 1, 1)
    keyText.TextStrokeTransparency = 0
    keyText.TextTransparency = 1
    targetTransparency[keyText] = 0
end

-- action and object text labels, pulled from the prompt's own ActionText and ObjectText properties
local actionText = Instance.new("TextLabel", billboard)
actionText.Name = "ActionText"
actionText.Position = UDim2.new(0.43, 0, 0.55, 0)
actionText.Size = UDim2.new(0.13, 0, 0.3, 0)
actionText.BackgroundTransparency = 1
actionText.TextColor3 = Color3.new(1, 1, 1)
actionText.TextScaled = true
actionText.Text = ""
actionText.TextTransparency = 1
targetTransparency[actionText] = 0

local objectText = Instance.new("TextLabel", billboard)
objectText.Name = "ObjectText"
objectText.Position = UDim2.new(0.35, 0, 0.76, 0)
objectText.Size = UDim2.new(0.3, 0, 0.2, 0)
objectText.BackgroundTransparency = 1
objectText.TextColor3 = Color3.new(0.8, 0.8, 0.8)
objectText.TextScaled = true
objectText.Text = ""
objectText.TextTransparency = 1
targetTransparency[objectText] = 0

-- hold bar, appears when the player starts holding the prompt
-- hidden by default, only shown on PromptButtonHoldBegan
local barFrame = Instance.new("Frame", billboard)
barFrame.Name = "Bar"
barFrame.Position = UDim2.fromScale(0.38, 0.97)
barFrame.Size = UDim2.fromScale(0.25, 0.03)
barFrame.BackgroundTransparency = 1

local barCorner = Instance.new("UICorner", barFrame)
local barStroke = Instance.new("UIStroke", barFrame)
barStroke.Name = "uhm"
barStroke.Color = Color3.new(1, 1, 1)
barStroke.Thickness = 1.5
barStroke.Transparency = 1
targetTransparency[barStroke] = 1 -- bar outline stays invisible even when fully shown, only the fill animates

-- the actual fill inside the bar, starts at 0 width and grows to 0.9 on hold
local fillBar = Instance.new("Frame", barFrame)
fillBar.Name = "Filler"
fillBar.AnchorPoint = Vector2.new(0.5, 0) -- anchored to center-top so it grows from the middle
fillBar.Position = UDim2.fromScale(0.5, 0.2)
fillBar.Size = UDim2.fromScale(0, 0.6)
fillBar.BackgroundColor3 = Color3.new(1, 1, 1)
fillBar.BorderSizePixel = 0
fillBar.BackgroundTransparency = 1
targetTransparency[fillBar] = 0

-- fade function
-- fadeType 1 = fade in (restore each element to its target transparency)
-- fadeType 2 = fade out (set everything to fully transparent)
-- uses the activeTweens table to cancel any tween already running on an element before starting a new one
-- this prevents overlapping tweens from causing visual glitches when prompts switch quickly
local function fadeElements(fadeType)
    local guiElements = {}
    for _, v in billboard:GetDescendants() do
        -- skip the container frames for Outline and Bar, we only animate their children directly
        if (v:IsA("GuiObject") or v:IsA("UIStroke")) and v.Name ~= "Outline" and v.Name ~= "Bar" then
            table.insert(guiElements, v)
        end
    end

    task.wait() -- yield one frame so layout updates settle before we read element properties

    for _, v in guiElements do
        -- each GUI class uses a different property for transparency, so we resolve the right one here
        local propertyName = ((v:IsA("TextLabel") or v:IsA("TextButton")) and "TextTransparency")
            or (v:IsA("Frame") and "BackgroundTransparency")
            or (v:IsA("UIStroke") and "Transparency")
            or (v:IsA("ImageButton") and "ImageTransparency")

        if propertyName then
            if activeTweens[v] then
                activeTweens[v]:Cancel()
                activeTweens[v] = nil
            end

            local fadeTween = tween:Create(v, TweenInfo.new(0.2), {[propertyName] = (fadeType == 1) and targetTransparency[v] or 1})

            if activeTweens[v] then
                activeTweens[v]:Cancel()
            end
            activeTweens[v] = fadeTween
            fadeTween:Play()
            fadeTween.Completed:Once(function()
                activeTweens[v] = nil
            end)
        end
    end
end

-- highlight, one instance reused across all prompts, parented to whatever part is active
-- starts with full transparency on both outline and fill, fades in when a prompt shows
local highlight = Instance.new("Highlight")
highlight.OutlineTransparency = 1
highlight.FillTransparency = 1

-- main prompt logic
-- PromptShown fires whenever any ProximityPrompt in the game becomes visible to this client
-- we override the style to Custom so Roblox doesn't render its default UI on top of ours
promptService.PromptShown:Connect(function(prompt)
    prompt.Style = Enum.ProximityPromptStyle.Custom

    -- PlayOnRemove trick: attach the sound to the prompt's parent and destroy it immediately
    -- Roblox plays the sound when the instance is removed, so this fires exactly when the prompt appears
    local promptSound = Instance.new("Sound", prompt.Parent)
    promptSound.SoundId = "rbxassetid://71299480774168"
    promptSound.PlayOnRemove = true
    promptSound:Destroy()

    -- move the billboard to this prompt's parent part
    billboard.Adornee = prompt.Parent

    local holdBeganConn
    local holdEndedConn
    local holdStartConn
    local holdStopConn
    local triggeredConn

    if touchButton then
        -- on mobile, we manually call InputHoldBegin/End on the prompt
        -- because touch input doesn't trigger it automatically through ProximityPromptService
        holdBeganConn = touchButton.MouseButton1Down:Connect(function()
            prompt:InputHoldBegin()
        end)
        holdEndedConn = touchButton.MouseButton1Up:Connect(function()
            prompt:InputHoldEnd()
        end)
    else
        -- on PC, strip the "Enum.KeyCode." prefix from the key name so it displays cleanly (e.g. "E" not "Enum.KeyCode.E")
        keyText.Text = tostring(prompt.KeyboardKeyCode):gsub("Enum.KeyCode.", "")
    end

    highlight.Parent = prompt.Parent

    actionText.Text = prompt.ActionText
    objectText.Text = prompt.ObjectText

    local barTween
    local strokeTween
    local isHidden = false -- flag used to prevent re-showing the UI if the prompt hides mid-trigger

    fadeElements(1)

    -- fade the highlight outline in separately since it's not a GuiObject and isn't in the billboard
    if activeTweens[highlight] then
        activeTweens[highlight]:Cancel()
    end
    activeTweens[highlight] = tween:Create(highlight, TweenInfo.new(0.5), {OutlineTransparency = 0})
    activeTweens[highlight]:Play()

    -- hold bar animations
    holdStartConn = prompt.PromptButtonHoldBegan:Connect(function()
        if activeTweens[fillBar] then
            activeTweens[fillBar]:Cancel()
        end
        if activeTweens[barStroke] then
            activeTweens[barStroke]:Cancel()
        end

        -- show the bar outline as soon as holding starts
        strokeTween = tween:Create(barStroke, TweenInfo.new(0.2), {Transparency = 0})
        activeTweens[barStroke] = strokeTween
        strokeTween:Play()

        if prompt.HoldDuration == 0 then
            -- instant activate, skip the tween and just set the fill to full immediately
            fillBar.Size = UDim2.fromScale(0.9, 0.6)
        else
            -- tween the fill bar over the exact hold duration so it matches the prompt's timing
            barTween = tween:Create(fillBar, TweenInfo.new(prompt.HoldDuration, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Size = UDim2.fromScale(0.9, 0.6)})
            activeTweens[fillBar] = barTween
            barTween:Play()
        end
    end)

    -- if the player lets go before triggering, reset the bar back to empty
    holdStopConn = prompt.PromptButtonHoldEnded:Connect(function()
        if barTween then
            barTween:Cancel()
        end
        if strokeTween then
            strokeTween:Cancel()
        end
        tween:Create(fillBar, TweenInfo.new(0.2), {Size = UDim2.fromScale(0, 0.6)}):Play()
        tween:Create(barStroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
    end)

    -- on trigger: briefly hide the UI, then bring it back if the prompt is still showing
    -- this gives visual feedback that the action fired without fully removing the prompt
    triggeredConn = prompt.Triggered:Connect(function()
        fadeElements(2)
        task.wait(0.5)
        if isHidden then
            return -- prompt already hidden during the wait, don't re-show
        end
        fadeElements(1)
    end)

    -- cleanup when the prompt is no longer visible
    -- disconnect all connections tied to this prompt instance so they don't leak
    prompt.PromptHidden:Once(function()
        fadeElements(2)
        holdBeganConn:Disconnect()
        holdEndedConn:Disconnect()
        holdStartConn:Disconnect()
        holdStopConn:Disconnect()
        triggeredConn:Disconnect()
        isHidden = true

        if activeTweens[highlight] then
            activeTweens[highlight]:Cancel()
        end
        activeTweens[highlight] = tween:Create(highlight, TweenInfo.new(0.5), {OutlineTransparency = 1})
        activeTweens[highlight]:Play()

        -- wait for any active tweens to finish before clearing them
        -- avoids nil-indexing mid-tween if another prompt shows up immediately after
        task.wait(0.2)
        for _, v in billboard:GetDescendants() do
            if activeTweens[v] then
                activeTweens[v].Completed:Wait()
                activeTweens[v] = nil
            end
        end
    end)
end)
