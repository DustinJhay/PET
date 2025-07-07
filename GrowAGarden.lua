-- Auto Pet Trade Script for Grow a Garden
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- RemoteEvent setup
local tradeEvent = ReplicatedStorage:FindFirstChild("AutoTradeEvent") or Instance.new("RemoteEvent")
tradeEvent.Name = "AutoTradeEvent"
tradeEvent.Parent = ReplicatedStorage

local function getRandomPet()
	local pets = {"Carrot", "Potato", "Corn"}
	return pets[math.random(1, #pets)]
end

Players.PlayerAdded:Connect(function(player)
	local inv = Instance.new("Folder")
	inv.Name = "PetInventory"
	inv.Parent = player

	for _, name in pairs({"Carrot", "Potato"}) do
		local p = Instance.new("StringValue")
		p.Name = name
		p.Parent = inv
	end
end)

tradeEvent.OnServerEvent:Connect(function(p1, p2)
	if not p2 or not p1.Character or not p2.Character then return end
	local dist = (p1.Character.PrimaryPart.Position - p2.Character.PrimaryPart.Position).Magnitude
	if dist > 10 then return end

	local inv1 = p1:FindFirstChild("PetInventory")
	local inv2 = p2:FindFirstChild("PetInventory")
	if not inv1 or not inv2 then return end

	local pet1 = getRandomPet()
	local pet2 = getRandomPet()

	if inv1:FindFirstChild(pet1) and inv2:FindFirstChild(pet2) then
		inv1:FindFirstChild(pet1):Destroy()
		inv2:FindFirstChild(pet2):Destroy()

		local n1 = Instance.new("StringValue")
		n1.Name = pet2
		n1.Parent = inv1

		local n2 = Instance.new("StringValue")
		n2.Name = pet1
		n2.Parent = inv2

		print(p1.Name .. " traded " .. pet1 .. " for " .. pet2)
	end
end)
