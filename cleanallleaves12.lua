-- ============================================================
-- NOMII SCRIPTS - CLEAN ALL THE LEAVES (OPTIMIZED)
-- ============================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
end)
-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)
-- State
local State = {
    AutoFarm = false,
    AutoSell = false,
    AutoEquip = false,
    WalkSpeed = 16,
    JumpPower = 50,
    FarmMethod = "ClickDetector" -- ClickDetector, Touch, ProximityPrompt
}
-- UI Library (Minimal)
local function CreateUI()
    local sgui = Instance.new("ScreenGui")
    sgui.Name = "CleanLeavesUI"
    sgui.ResetOnSpawn = false
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    if PlayerGui:FindFirstChild("CleanLeavesUI") then
        PlayerGui.CleanLeavesUI:Destroy()
    end
    sgui.Parent = PlayerGui
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 350)
    frame.Position = UDim2.new(0.5, -150, 0.5, -175)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.fromRGB(255, 170, 0)
    frame.Active = true
    frame.Draggable = true
    frame.Parent = sgui
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    title.TextColor3 = Color3.fromRGB(255, 170, 0)
    title.Text = "Clean All The Leaves - Farm"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.Parent = frame
    local layout = Instance.new("UIListLayout")
    layout.Parent = frame
    layout.Padding = UDim.new(0, 5)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    title.LayoutOrder = 0
    local function CreateToggle(name, default, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -20, 0, 30)
        btn.Position = UDim2.new(0, 10, 0, 0)
        btn.BackgroundColor3 = default and Color3.fromRGB(40, 150, 40) or Color3.fromRGB(40, 40, 40)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Text = name .. (default and " [ON]" or " [OFF]")
        btn.Font = Enum.Font.GothamSemibold
        btn.TextSize = 14
        btn.Parent = frame
        
        local state = default
        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.BackgroundColor3 = state and Color3.fromRGB(40, 150, 40) or Color3.fromRGB(40, 40, 40)
            btn.Text = name .. (state and " [ON]" or " [OFF]")
            callback(state)
        end)
    end
    
    local function CreateSlider(name, min, max, default, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -20, 0, 40)
        frame.BackgroundTransparency = 1
        frame.Parent = frame.Parent -- Quick hack to put it in the list layout
        frame.Parent = title.Parent
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 20)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Text = name .. ": " .. default
        label.Font = Enum.Font.Gotham
        label.TextSize = 12
        label.Parent = frame
        
        -- Simple click to set values for now
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 20)
        btn.Position = UDim2.new(0, 0, 0, 20)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.Text = "Click to set " .. name .. " to Max"
        btn.Parent = frame
        btn.MouseButton1Click:Connect(function()
            label.Text = name .. ": " .. max
            callback(max)
        end)
    end
    CreateToggle("Auto Farm Leaves", false, function(v) State.AutoFarm = v end)
    CreateToggle("Auto Empty Bag (Sell)", false, function(v) State.AutoSell = v end)
    CreateToggle("Auto Equip Tool", false, function(v) State.AutoEquip = v end)
    
    CreateSlider("WalkSpeed", 16, 100, 16, function(v) State.WalkSpeed = v end)
    CreateSlider("JumpPower", 50, 200, 50, function(v) State.JumpPower = v end)
end
CreateUI()
-- ============================================================
-- HELPER FUNCTIONS
-- ============================================================
local function GetLeaves()
    local leaves = {}
    -- The game usually stores leaves in a folder or in Workspace
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            -- Look for leaf keywords or parts with ClickDetectors
            local name = v.Name:lower()
            if name:match("leaf") or name:match("leaves") or name == "meshpart" then
                if v:FindFirstChildOfClass("ClickDetector") or v:FindFirstChildOfClass("ProximityPrompt") then
                    table.insert(leaves, v)
                end
            end
        end
    end
    return leaves
end
local function GetTrashCans()
    local cans = {}
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Model") or v:IsA("BasePart") then
            local name = v.Name:lower()
            if name:match("trash") or name:match("bin") or name:match("dump") or name:match("sell") then
                table.insert(cans, v)
            end
        end
    end
    return cans
end
local function EquipBestTool()
    if not Character then return end
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if not backpack then return end
    
    -- In this game, tools like "Leaf Blower" are better than hand
    for _, tool in pairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            tool.Parent = Character
            break -- Equip first found tool, ideally we would sort by power if known
        end
    end
end
-- ============================================================
-- MAIN LOOP
-- ============================================================
task.spawn(function()
    while task.wait(0.1) do
        -- WalkSpeed and JumpPower
        if Character and Character:FindFirstChild("Humanoid") then
            Character.Humanoid.WalkSpeed = State.WalkSpeed
            Character.Humanoid.JumpPower = State.JumpPower
        end
        
        -- Auto Equip
        if State.AutoEquip then
            EquipBestTool()
        end
        
        -- Auto Farm
        if State.AutoFarm then
            pcall(function()
                local leaves = GetLeaves()
                for _, leaf in pairs(leaves) do
                    if not State.AutoFarm then break end
                    
                    -- Method 1: Click Detector
                    local cd = leaf:FindFirstChildOfClass("ClickDetector")
                    if cd then
                        fireclickdetector(cd)
                    end
                    
                    -- Method 2: Proximity Prompt
                    local pp = leaf:FindFirstChildOfClass("ProximityPrompt")
                    if pp then
                        fireproximityprompt(pp)
                    end
                    
                    -- Method 3: Touch (if game requires walking over them)
                    if Character and Character:FindFirstChild("HumanoidRootPart") then
                        -- Teleport slightly above the leaf to avoid getting stuck
                        Character.HumanoidRootPart.CFrame = leaf.CFrame + Vector3.new(0, 3, 0)
                        if typeof(firetouchinterest) == "function" then
                            firetouchinterest(Character.HumanoidRootPart, leaf, 0)
                            firetouchinterest(Character.HumanoidRootPart, leaf, 1)
                        end
                        task.wait(0.05)
                    end
                end
            end)
        end
        
        -- Auto Sell
        if State.AutoSell then
            pcall(function()
                local cans = GetTrashCans()
                if #cans > 0 and Character and Character:FindFirstChild("HumanoidRootPart") then
                    local can = cans[1] -- Go to first found trash can
                    local targetPart = can:IsA("Model") and can.PrimaryPart or can
                    if targetPart then
                        Character.HumanoidRootPart.CFrame = targetPart.CFrame + Vector3.new(0, 3, 0)
                        
                        -- Fire prompts if available
                        local prompt = can:FindFirstChildOfClass("ProximityPrompt", true)
                        if prompt then
                            fireproximityprompt(prompt)
                        end
                        
                        local cd = can:FindFirstChildOfClass("ClickDetector", true)
                        if cd then
                            fireclickdetector(cd)
                        end
                    end
                    task.wait(1) -- Wait a bit after selling
                end
            end)
        end
    end
end)
print("[NOMII SCRIPTS] Clean All The Leaves Loaded!")
