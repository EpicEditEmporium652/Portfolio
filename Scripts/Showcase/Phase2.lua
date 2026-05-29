local screen = workspace:WaitForChild("Screen")
local statusLabel = screen:WaitForChild("SurfaceGui"):WaitForChild("TextLabel")
local descriptionLabel
for _, v in ipairs(screen:WaitForChild("SurfaceGui"):GetChildren()) do
    if v:IsA("TextLabel") and v ~= statusLabel and v:FindFirstChild("UIStroke") then
        descriptionLabel = v
        break
    end
end
local indicator = workspace:WaitForChild("Lever2"):WaitForChild("Indicator"):WaitForChild("Glass")
game.ReplicatedStorage.p2.OnClientEvent:Connect(function(v)
    indicator.Material = Enum.Material.Neon
    indicator.Color = Color3.fromRGB(0, 255, 0)
    statusLabel.Text = "<< Preparing systems.. >>"
    descriptionLabel.Text = "<< Connecting and preparing systems (0% finished) >>"
    task.wait(v)
    for t = 1, 100 do
        task.wait(v)
        descriptionLabel.Text = "<< Connecting and preparing systems (" .. t .. "% finished) >>"
    end
    task.wait(1)
    statusLabel.Text = "<< System Prepared >>"
    descriptionLabel.Text = "<< Awaiting start signal >>"
    statusLabel.TextSize = 66
end)
