local streamEvent = game.ReplicatedStorage.RemoteEvent
local toggleEvent = game.ReplicatedStorage.tgl
local toggleButton = script.Parent
local camera = workspace.CurrentCamera
local originalCameraType = camera.CameraType
local toggled = false
local partCache = {}
local connection

local function resolvePath(path)
    local pathParts = string.split(path, ".")
    local current = game
    for _, part in pairs(pathParts) do
        local found = current:FindFirstChild(part)
        if found then
            current = found
        else
            warn(part .. " doesn't exist")
            return nil
        end
    end
    partCache[path] = current
    return current
end

toggleButton.MouseButton1Click:Connect(function()
    toggled = not toggled
    if toggled then
        local ghostModel = Instance.new("Model", workspace)
        ghostModel.Name = game.Players.LocalPlayer.Character.Name .. "_fake"
        workspace[game.Players.LocalPlayer.Name].Name = game.Players.LocalPlayer.Name .. "_real"
        for _, v in game.Players.LocalPlayer.Character:GetDescendants() do
            if v:IsA("BasePart") then
                v:Clone().Parent = ghostModel
                v.Transparency = 1
            end
        end
        toggleButton.Text = "Server"
        camera.CameraType = Enum.CameraType.Scriptable
        camera.CFrame = CFrame.new(0, 20, 40) * CFrame.Angles(math.rad(-20), 0, 0)
        toggleEvent:FireServer(true)
        connection = streamEvent.OnClientEvent:Connect(function(cframeData)
            for path, cframe in pairs(cframeData) do
                local part = partCache[path] or resolvePath(path)
                if part then
                    part.CFrame = cframe
                end
            end
        end)
    else
        toggleEvent:FireServer(false)
        workspace[game.Players.LocalPlayer.Name .. "_fake"]:Destroy()
        workspace[game.Players.LocalPlayer.Name .. "_real"].Name = game.Players.LocalPlayer.Name
        for _, v in game.Players.LocalPlayer.Character:GetDescendants() do
            if v:IsA("BasePart") then
                v.Transparency = 0
            end
        end
        if connection then connection:Disconnect() end
        toggleButton.Text = "Client"
        camera.CameraType = originalCameraType
    end
end)