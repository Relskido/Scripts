local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "Axion",
    Icon = "door-open",
    Author = "by @Rjay",
})

Window:Tag({
    Title = "v.1.0.5",
    Color = Color3.fromHex("#30ff6a"),
    Radius = 13,
})

Window:Tag({
    Title = "FIXING",
    Color = Color3.fromHex("#ffff00"),
    Radius = 13,
})

local Home = Window:Tab({
    Title = "Home",
    Icon = "house",
    Locked = false,
})

local TabDivider = Window:Divider()

local Main = Window:Tab({
    Title = "Main",
    Icon = "tool-case",
    Locked = false,
})

local BrainRots = Window:Tab({
    Title = "Brainrots",
    Icon = "circle-dollar-sign",
    Locked = false,
})

local Shop = Window:Tab({
    Title = "Shop",
    Icon = "store",
    Locked = false,
})

Window:SelectTab(Main)

-- // Variables \\ --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local HttpService = game:GetService("HttpService")
local Brainrots = workspace:WaitForChild("ScriptedMap"):WaitForChild("Brainrots")
local RS = game:GetService("ReplicatedStorage")
local AttackFolder = RS:WaitForChild("Remotes"):WaitForChild("AttacksServer")
local BridgeNet2 = RS:WaitForChild("BridgeNet2")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local BackPack = player:WaitForChild("BackPack")

local farming = false
local AutoPlantVar = false
local Equipped = false
local pos = nil

local connection
local plantConnection
local ShopConnection

local attackType = "None"
local selectedItem = ""
local selectedType = ""

local AttackRE = AttackFolder:WaitForChild("WeaponAttack")
local DataRE = BridgeNet2.dataRemoteEvent

-- Shops
local SeedsTables = {
    "Cactus Seed",
    "Strawberry Seed",
    "Pumpkin Seed",
    "Sunflower Seed",
    "Dragon Fruit Seed",
    "Eggplant Seed",
    "Watermelon Seed",
    "Cocotank Seed",
    "Carnivorous Plant Seed",
    "Mr Carrot Seed",
    "Tomatrio Seed",
}

local GearTables = {
    "Bat",
    "Banana Gun",
    "Carrot Launcher",
    "Frost Grenade",
    "Frost Blower",
    "Water Bucket",
    "Lucky Potion",
    "Speed Potion",
}

local AttackTypes = { Normal = "Normal", Instant = "Instant" }
local ShopType = { Seeds = "Seeds", Gears = "Gears" }

-- // Helper Functions \\ --
local function TeleportToBrainrot(brainrotModel)
    local enemyRoot = brainrotModel:FindFirstChild("HumanoidRootPart") or brainrotModel:FindFirstChild("RootPart")
    local charRoot = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("RootPart")
    if enemyRoot and charRoot then
        charRoot.CFrame = enemyRoot.CFrame
    end
end

local function EquipBat()
    local tool = BackPack:FindFirstChild("Bat")
    if not tool then return end

    if Equipped ~= true then
        if tool.Parent ~= character then
            Equipped = true
            character:WaitForChild("Humanoid"):EquipTool(tool)
        end
    end
end

local function GetMoney()
    
end

local function GetRebirth()
    
end

-- // Functions \\ --
function AutoFarmBrainrot(Type)
    if Type == AttackTypes.Normal then
            if not Equipped then
                EquipBat()
                    for _, v in ipairs(Brainrots:GetChildren()) do
                        if v:IsA("Model") then
                            local root = v:FindFirstChild("HumanoidRootPart") or v:FindFirstChild("RootPart")
                                if root then
                                    TeleportToBrainrot(v)
                                         AttackRE:FireServer({ v.Name })
                        break
                    end
                end
            end
        end
    elseif Type == AttackTypes.Instant then
        if not Equipped then
            EquipBat()
            for _, v in ipairs(Brainrots:GetChildren()) do
                if v:IsA("Model") then
                    local root = v:FindFirstChild("HumanoidRootPart") or v:FindFirstChild("RootPart")
                    if root then
                            TeleportToBrainrot(v)
                                local pos = UIS:GetMouseLocation()
                                    VIM:SendMouseButtonEvent(pos.X, pos.Y, 0, true, game, 0)
                                        VIM:SendMouseButtonEvent(pos.X, pos.Y, 0, false, game, 0)
                        break
                    end
                end
            end
        end
    end
end

function AutoPlant()
    
end

function AutoBuy(Item, Type)
    if Type == "" then
        print("AutoBuy: Invalid Type argument")
        return
    end
    
    if Item == "" then
        print("AutoBuy: Invalid Item argument")
        return
    end
    
    if Type == ShopType.Seeds then
        DataRE:FireServer({ Item, "\7" })
    elseif Type == ShopType.Gears then
        DataRE:FireServer({ Item, " " })
    end
end

-- // Main \\ --
Main:Section({ Title = "Auto Farm", Icon = "timer" })

Main:Dropdown({
    Title = "Attack Type",
    Values = { "None", "Normal", "Instant" },
    Value = "None",
    Callback = function(option)
        attackType = option
    end
})

Main:Toggle({
    Title = "Auto Equip Bat",
    Desc = "Improving",
    Icon = "checkmark",
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        EquipBat()
    end
})

Main:Toggle({
    Title = "Auto Farm",
    Desc = "Improving",
    Icon = "checkmark",
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        farming = state
        if not state and connection then
            connection:Disconnect()
            connection = nil
            return
        end
        if state and not connection then
            connection = RunService.Heartbeat:Connect(function()
                if farming then
                    character = player.Character or player.CharacterAdded:Wait()
                    AutoFarmBrainrot(attackType)
                end
            end)
        end
    end
})

Main:Button({
    Title = "Save Position",
    Desc = "Save's Your Position",
    Locked = true,
    Callback = function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            pos = player.Character.HumanoidRootPart.CFrame
        end
    end
})

Main:Toggle({
    Title = "Auto Plant",
    Desc = "Auto Plant",
    Icon = "checkmark",
    Type = "Checkbox",
    Default = true,
    Callback = function(state)
        AutoPlantVar = state
        if not state and plantConnection then
            plantConnection:Disconnect()
            plantConnection = nil
            return
        end
        if state and not plantConnection then
            plantConnection = RunService.Heartbeat:Connect(function()
                if AutoPlantVar then
                    AutoPlant()
                end
            end)
        end
    end
})

-- // Shop \\ --

Shop:Dropdown({
    Title = "Item Type",
    Values = { "None", "Seed", "Gear" },
    Value = "None",
    Callback = function(option)
        selectedType = option
    end
})

local ItemInput = Shop:Input({
    Title = "Item Name",
    Desc = "",
    Value = "",
    InputIcon = "shopping-basket",
    Type = "Input",
    Placeholder = "eg. Cactus Seed or Banana Gun",
    Callback = function(input) 
        selectedItem = input
    end
})

Shop:Toggle({
    Title = "Auto Buy Item",
    Desc = "Improving",
    Icon = "checkmark",
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        autobuy = state
        if not state and ShopConnection then
            ShopConnection:Disconnect()
            ShopConnection = nil
            return
        end
        if state and not ShopConnection then
            ShopConnection = RunService.Heartbeat:Connect(function()
                if selectedType ~= "None" and selectedItem ~= "" then
                    if selectedType == "Gear" then
                        AutoBuy(selectedItem, ShopType.Gears)
                elseif selectedType == "Seed" then
                        AutoBuy(selectedItem, ShopType.Seeds)
                    end
                end
            end)
        end
    end
})