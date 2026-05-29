local notification = require(game.ReplicatedStorage.Notification).sg
local indicator = workspace:WaitForChild("Lever1"):WaitForChild("Indicator"):WaitForChild("Glass")
local screen = workspace:WaitForChild("Screen")
local statusLabel = screen:WaitForChild("SurfaceGui"):WaitForChild("TextLabel")
local descriptionLabel
for _, v in ipairs(screen:WaitForChild("SurfaceGui"):GetChildren()) do
    if v:IsA("TextLabel") and v ~= statusLabel and v:FindFirstChild("UIStroke") then
        descriptionLabel = v
        break
    end
end
game.ReplicatedStorage.p1.OnClientEvent:Connect(function()
    task.delay(1, function()
        indicator.Material = Enum.Material.Neon
        indicator.Color = Color3.fromRGB(0, 255, 0)
    end)
    task.delay(3, function()
        statusLabel.Text = "<< Control Engaged >>"
        descriptionLabel.Text = "<< T-SD-02 protocol activation in progress >>"
        statusLabel.TextSize = 62
        coroutine.wrap(function()
            task.wait(0.4)
            for v = 1, 4 do
                statusLabel.Text = ""
                task.wait(0.4)
                statusLabel.Text = "<< Control Engaged >>"
                task.wait(0.4)
            end
        end)()
    end)
    task.delay(8, function()
        local txt = "Attention all facility personnel! Protocol T-SD-02 activation in\nprogress. Please prepare for emergency evacuation from the\nfacility to the safest distance! This is not a drill, repeat, this is\nnot a drill"
        notification(txt, 13)
    end)
end)
