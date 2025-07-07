-- Auto Pet Trade Script by Ding Ding
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- RemoteEvent setup
local tradeEvent = ReplicatedStorage:FindFirstChild("AutoTradeEvent") or Instance.new("RemoteEvent")
tradeEvent.Name = "AutoTradeEvent"
tradeEvent.Parent = ReplicatedStorage

-- Sample pets to use (make sure they exist in ServerStorage > Pets)
local function getRandomPet()
	local petNames = {"Dog", "Cat", "Dragon"}
	return petNames[math.random(1, #petNames)]
end

-- Inventory setup
Players.PlayerAdded:Connect(function(player)
	local inv = Instance.new("Folder")
	inv.Name = "PetInventory"
	inv.Parent = player

	for _, petName in pairs({"Dog", "Cat"}) do
		local pet = Instance.new("StringValue")
		pet.Name = petName
		pet.Parent = inv
	end
end)

-- Auto trade handler
tradeEvent.OnServerEvent:Connect(function(p1, p2)
	if not p2 or not p2:IsA("Player") then return end
	if not p1.Character or not p2.Character then return end

	local d = (p1.Character.PrimaryPart.Position - p2.Character.PrimaryPart.Position).Magnitude
	if d > 10 then return end

	local inv1 = p1:FindFirstChild("PetInventory")
	local inv2 = p2:FindFirstChild("PetInventory")
	if not inv1 or not inv2 then return end

	local pet1 = getRandomPet()
	local pet2 = getRandomPet()

	if inv1:FindFirstChild(pet1) and inv2:FindFirstChild(pet2) then
		inv1:FindFirstChild(pet1):Destroy()
		inv2:FindFirstChild(pet2):Destroy()

		local new1 = Instance.new("StringValue")
		new1.Name = pet2
		new1.Parent = inv1

		local new2 = Instance.new("StringValue")
		new2.Name = pet1
		new2.Parent = inv2

		print(p1.Name .. " traded " .. pet1 .. " with " .. p2.Name .. "'s " .. pet2)
	end
end)

-- Auto trading loop (client-side simulation)
if Players.LocalPlayer then
	local plr = Players.LocalPlayer
	while true do
		wait(3)
		if plr.Character then
			for _, other in pairs(Players:GetPlayers()) do
				if other ~= plr and other.Character then
					local d = (plr.Character.PrimaryPart.Position - other.Character.PrimaryPart.Position).Magnitude
					if d < 10 then
						ReplicatedStorage:WaitForChild("AutoTradeEvent"):FireServer(other)
					end
				end
			end
		end
	end
end
