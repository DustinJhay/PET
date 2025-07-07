-- Grow a Garden Auto Pet Trade (Client-Side for Executors)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Wait for event
local event = ReplicatedStorage:WaitForChild("AutoTradeEvent", 10)
if not event then
    warn("AutoTradeEvent not found in ReplicatedStorage")
    return
end

-- Auto trade every few seconds
local player = Players.LocalPlayer

while true do
    task.wait(5)

    for _, other in ipairs(Players:GetPlayers()) do
        if other ~= player and other.Character and player.Character then
            local pos1 = player.Character:FindFirstChild("HumanoidRootPart")
            local pos2 = other.Character:FindFirstChild("HumanoidRootPart")
            if pos1 and pos2 then
                local dist = (pos1.Position - pos2.Position).Magnitude
                if dist < 10 then
                    print("Auto trading with:", other.Name)
                    event:FireServer(other)
                end
            end
        end
    end
end
