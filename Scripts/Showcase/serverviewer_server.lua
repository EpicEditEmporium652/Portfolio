local streamEvent = Instance.new("RemoteEvent", game.ReplicatedStorage)
streamEvent.Name = "RemoteEvent"
local toggleEvent = Instance.new("RemoteEvent", game.ReplicatedStorage)
toggleEvent.Name = "tgl"
local connections = {}

toggleEvent.OnServerEvent:Connect(function(player)
    if connections[player] then
        connections[player]:Disconnect()
        connections[player] = nil
        return
    end
    connections[player] = game:GetService("RunService").Heartbeat:Connect(function()
        local cframeData = {}
        for _, v in workspace:GetDescendants() do
            if v:IsA("BasePart") and not v:IsA("SpawnLocation") and v.Name ~= "Baseplate" then
                local parentModel = v:FindFirstAncestorOfClass("Model")
                if parentModel and parentModel:FindFirstChild("Humanoid") and parentModel.Name ~= player.Name then
                    continue
                end
                cframeData[v:GetFullName()] = v.CFrame
            end
        end
        streamEvent:FireClient(player, cframeData)
    end)
end)