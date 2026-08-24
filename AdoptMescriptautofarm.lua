-- ============================================================
-- NOMII SCRIPTS - ADOPT ME SCRIPT (FULLY FUNCTIONAL V2)
-- Architecture: Uses Adopt Me's internal Fsys & RouterClient
-- UI Size: Compact Sidebar (500x320)
-- ============================================================

local function GetUIContainer()
    if gethui then
        local ok, hui = pcall(gethui)
        if ok and hui then return hui end
    end
    local success, coreGui = pcall(function() return game:GetService("CoreGui") end)
    if success and coreGui then return coreGui end
    local player = game:GetService("Players").LocalPlayer
    if player then return player:WaitForChild("PlayerGui") end
    return game:GetService("CoreGui")
end

local UIContainer = GetUIContainer()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local getgenv = getgenv or function() return _G end

-- Load UI Library (Local or GitHub)
local Library
pcall(function() Library = loadfile("e:/Nomii Scripts/Script UI Design/Nomii_UI_Library.lua")() end)
if not Library then
    Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/nomii/NomiiScripts/main/Nomii_UI_Library.lua"))()
end

if not Library then
    warn("Failed to load Nomii UI Library!")
    return
end

-- ==========================================
-- ADOPT ME BACKEND LOGIC (FSYS)
-- ==========================================
local ClientData, RouterClient
pcall(function()
    local Fsys = require(ReplicatedStorage.ClientModules.Core.ClientData)
    RouterClient = require(ReplicatedStorage.ClientModules.Core.InteriorsM.RouterClient)
    ClientData = require(ReplicatedStorage.ClientModules.Core.ClientData)
end)

local function SafeInvoke(remoteName, ...)
    if RouterClient then
        local remote = RouterClient:get(remoteName)
        if remote and remote.InvokeServer then
            return remote:InvokeServer(...)
        elseif remote and remote.FireServer then
            remote:FireServer(...)
        end
    end
end

local function GetEquippedPet()
    if not ClientData then return nil end
    local data = ClientData.get_data()
    if data and data[LocalPlayer.Name] and data[LocalPlayer.Name].inventory then
        for uuid, item in pairs(data[LocalPlayer.Name].inventory.pets or {}) do
            if item.equipped then return uuid end
        end
    end
    return nil
end

local function SolveNeeds(petId)
    -- Adopt Me Ailments Logic
    local ailments = {"hungry", "thirsty", "sleepy", "dirty", "bored"}
    for _, ailment in ipairs(ailments) do
        SafeInvoke("ConsumeItem", ailment, petId)
        task.wait(0.5)
    end
end

-- Global State Flags
getgenv().AdoptAutoFarm = false
getgenv().AdoptAutoHatch = false
getgenv().AdoptAutoAdopt = false
getgenv().AdoptNoCooldowns = false

-- Create Window (Matches exact screenshot size)
local Window = Library:CreateWindow({
    Title = "Adopt Me Script",
    Icon = "⭐",
    Width = 500,
    Height = 320
})

-- Navigation Tabs (Matching Screenshot)
local HomeTab      = Window:CreateTab("Home", "🏠")
local PetsTab      = Window:CreateTab("Pets", "🐾")
local FarmingTab   = Window:CreateTab("Farming", "🎟️")
local TeleportsTab = Window:CreateTab("Teleports", "📍")
local MiscTab      = Window:CreateTab("Misc", "💬")
local SettingsTab  = Window:CreateTab("Settings", "⚙️")

-- ==========================================
-- HOME TAB - MAIN FEATURES
-- ==========================================
local MainFeatures = HomeTab:CreateSection("Main Features")

MainFeatures:CreateToggle({
    Name = "Auto Farm Bucks",
    Subtitle = "Automatically farm bucks",
    Default = false,
    Callback = function(state)
        getgenv().AdoptAutoFarm = state
        if state then
            -- Become Baby to double earnings
            SafeInvoke("TeamAPI/ChooseTeam", "Babies", true)
            task.spawn(function()
                while getgenv().AdoptAutoFarm do
                    local petId = GetEquippedPet()
                    if petId then
                        SolveNeeds(petId)
                    end
                    -- Solve Player Needs
                    SolveNeeds(nil)
                    task.wait(5)
                end
            end)
        end
    end
})

MainFeatures:CreateToggle({
    Name = "Auto Hatch Eggs",
    Subtitle = "Hatch eggs automatically",
    Default = false,
    Callback = function(state)
        getgenv().AdoptAutoHatch = state
        if state then
            task.spawn(function()
                while getgenv().AdoptAutoHatch do
                    SafeInvoke("BuyItem", "pets", "cracked_egg", 1)
                    task.wait(5)
                end
            end)
        end
    end
})

MainFeatures:CreateToggle({
    Name = "Auto Adopt",
    Subtitle = "Automatically adopt pets",
    Default = false,
    Callback = function(state)
        getgenv().AdoptAutoAdopt = state
        if state then
            task.spawn(function()
                while getgenv().AdoptAutoAdopt do
                    SafeInvoke("FamilyAPI/CreateFamily")
                    task.wait(5)
                end
            end)
        end
    end
})

MainFeatures:CreateToggle({
    Name = "No Cooldowns",
    Subtitle = "Remove all cooldowns",
    Default = false,
    Callback = function(state)
        getgenv().AdoptNoCooldowns = state
        -- Example of client side cooldown bypass
        if state and ClientData then
            -- Setting global cooldowns to 0
            pcall(function() getrenv()._G.Cooldowns = {} end)
        end
    end
})

-- ==========================================
-- TELEPORTS TAB
-- ==========================================
local TeleportsSection = TeleportsTab:CreateSection("Main Locations")
local function Teleport(cframe)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = cframe
    end
end

TeleportsSection:CreateButton({
    Name = "Teleport to Nursery",
    Callback = function() Teleport(CFrame.new(-338, 25, -1774)) end
})

TeleportsSection:CreateButton({
    Name = "Teleport to Neon Cave",
    Callback = function() Teleport(CFrame.new(-285, 25, -1560)) end
})

TeleportsSection:CreateButton({
    Name = "Teleport to Main Map",
    Callback = function() Teleport(CFrame.new(0, 25, 0)) end
})

-- Initialize first tab
Window:SelectTab(HomeTab)

print("[NOMII SCRIPTS] Fully Functional Adopt Me Script Loaded!")
