-- ============================================================
-- NOMII SCRIPTS - PULL A SWORD (NOMII UI V1)
-- Description: Fully Standalone, Embedded UI, Auto Farm Features
-- ============================================================

-- ==========================================
task.wait(2) -- Wait for game to fully load to prevent executor instant-crash
print("[DEBUG] Script Started Executing...")
-- NOMII UI LIBRARY (EMBEDDED)
-- ==========================================
local Library = {}

local function GetUIContainer()
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer or Players.PlayerAdded:Wait()
    return player:WaitForChild("PlayerGui")
end

print("[DEBUG] Fetching UI Container...")
local UIContainer = GetUIContainer()
print("[DEBUG] UI Container Found:", tostring(UIContainer))
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Theme = {
    Background = Color3.fromRGB(18, 16, 25),
    Sidebar = Color3.fromRGB(14, 12, 19),
    CardBackground = Color3.fromRGB(26, 23, 36),
    CardBorder = Color3.fromRGB(42, 37, 56),
    AccentPurple = Color3.fromRGB(168, 43, 240),
    AccentPurpleDark = Color3.fromRGB(120, 25, 180),
    GlowStroke = Color3.fromRGB(150, 45, 235),
    TextWhite = Color3.fromRGB(255, 255, 255),
    TextGray = Color3.fromRGB(160, 160, 175),
    TextSubLabel = Color3.fromRGB(120, 120, 140),
    StarYellow = Color3.fromRGB(255, 205, 45),
    FontBold = Enum.Font.GothamBold,
    FontMedium = Enum.Font.GothamMedium,
    FontRegular = Enum.Font.Gotham
}

function Library:CreateWindow(config)
    config = config or {}
    local Title = config.Title or "Nomii Scripts"
    local IconText = config.Icon or "⭐"
    local Width = config.Width or 500
    local Height = config.Height or 320
    
    pcall(function()
        if UIContainer:FindFirstChild("NomiiScriptsUI_V2") then
            UIContainer:FindFirstChild("NomiiScriptsUI_V2"):Destroy()
        end
    end)
    
    local NomiiUI = Instance.new("ScreenGui")
    NomiiUI.Name = "NomiiScriptsUI_V2"
    NomiiUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    NomiiUI.ResetOnSpawn = false
    NomiiUI.Parent = UIContainer
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = NomiiUI
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.Position = UDim2.new(0.5, -(Width/2), 0.5, -(Height/2))
    MainFrame.Size = UDim2.new(0, Width, 0, Height)
    MainFrame.ClipsDescendants = true
    MainFrame.BorderSizePixel = 0
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 14)
    UICorner.Parent = MainFrame
    
    local OuterStroke = Instance.new("UIStroke")
    OuterStroke.Parent = MainFrame
    OuterStroke.Color = Theme.GlowStroke
    OuterStroke.Thickness = 1.5
    OuterStroke.Transparency = 0.25
    
    local dragging, dragInput, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local HeaderBar = Instance.new("Frame")
    HeaderBar.Name = "HeaderBar"
    HeaderBar.Parent = MainFrame
    HeaderBar.BackgroundTransparency = 1
    HeaderBar.Position = UDim2.new(0, 16, 0, 14)
    HeaderBar.Size = UDim2.new(1, -32, 0, 32)
    
    local StarIcon = Instance.new("TextLabel")
    StarIcon.Parent = HeaderBar
    StarIcon.BackgroundTransparency = 1
    StarIcon.Size = UDim2.new(0, 28, 1, 0)
    StarIcon.Font = Theme.FontBold
    StarIcon.Text = IconText
    StarIcon.TextColor3 = Theme.StarYellow
    StarIcon.TextSize = 22
    
    local HeaderTitle = Instance.new("TextLabel")
    HeaderTitle.Parent = HeaderBar
    HeaderTitle.BackgroundTransparency = 1
    HeaderTitle.Position = UDim2.new(0, 34, 0, 0)
    HeaderTitle.Size = UDim2.new(0, 300, 1, 0)
    HeaderTitle.Font = Theme.FontBold
    HeaderTitle.Text = Title
    HeaderTitle.TextColor3 = Theme.TextWhite
    HeaderTitle.TextSize = 20
    HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Parent = HeaderBar
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Position = UDim2.new(1, -24, 0, 4)
    CloseBtn.Size = UDim2.new(0, 24, 0, 24)
    CloseBtn.Font = Theme.FontBold
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Theme.TextGray
    CloseBtn.TextSize = 16
    
    CloseBtn.MouseButton1Click:Connect(function() NomiiUI:Destroy() end)
    
    local Sidebar = Instance.new("Frame")
    Sidebar.Parent = MainFrame
    Sidebar.BackgroundTransparency = 1
    Sidebar.Position = UDim2.new(0, 16, 0, 56)
    Sidebar.Size = UDim2.new(0, 140, 1, -70)
    
    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.Parent = Sidebar
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarLayout.Padding = UDim.new(0, 6)
    
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Parent = MainFrame
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 168, 0, 56)
    ContentContainer.Size = UDim2.new(1, -184, 1, -70)
    
    local WindowObj = { Tabs = {} }
    
    function WindowObj:CreateTab(tabName, iconText)
        iconText = iconText or "📄"
        local TabBtn = Instance.new("TextButton")
        TabBtn.Parent = Sidebar
        TabBtn.BackgroundColor3 = Theme.Background
        TabBtn.BackgroundTransparency = 1
        TabBtn.Size = UDim2.new(1, 0, 0, 38)
        TabBtn.Font = Theme.FontMedium
        TabBtn.Text = "      " .. tabName
        TabBtn.TextColor3 = Theme.TextGray
        TabBtn.TextSize = 14
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        
        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 10)
        BtnCorner.Parent = TabBtn
        
        local TabIcon = Instance.new("TextLabel")
        TabIcon.Parent = TabBtn
        TabIcon.BackgroundTransparency = 1
        TabIcon.Position = UDim2.new(0, 12, 0, 0)
        TabIcon.Size = UDim2.new(0, 20, 1, 0)
        TabIcon.Font = Theme.FontBold
        TabIcon.Text = iconText
        TabIcon.TextColor3 = Theme.TextGray
        TabIcon.TextSize = 15
        
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Parent = ContentContainer
        TabContent.BackgroundTransparency = 1
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.ScrollBarThickness = 3
        TabContent.ScrollBarImageColor3 = Theme.AccentPurple
        TabContent.Visible = false
        
        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Parent = TabContent
        ContentLayout.Padding = UDim.new(0, 12)
        
        TabBtn.MouseButton1Click:Connect(function()
            for _, t in pairs(WindowObj.Tabs) do
                t.Content.Visible = false
                t.Btn.BackgroundTransparency = 1
                t.Btn.TextColor3 = Theme.TextGray
                t.Icon.TextColor3 = Theme.TextGray
            end
            TabContent.Visible = true
            TabBtn.BackgroundColor3 = Theme.AccentPurple
            TabBtn.BackgroundTransparency = 0
            TabBtn.TextColor3 = Theme.TextWhite
            TabIcon.TextColor3 = Theme.TextWhite
        end)
        
        local Tab = { Btn = TabBtn, Icon = TabIcon, Content = TabContent }
        table.insert(WindowObj.Tabs, Tab)
        
        if #WindowObj.Tabs == 1 then
            TabContent.Visible = true
            TabBtn.BackgroundColor3 = Theme.AccentPurple
            TabBtn.BackgroundTransparency = 0
            TabBtn.TextColor3 = Theme.TextWhite
            TabIcon.TextColor3 = Theme.TextWhite
        end
        
        function Tab:CreateSection(sectionName)
            local SecHeader = Instance.new("TextLabel")
            SecHeader.Parent = TabContent
            SecHeader.BackgroundTransparency = 1
            SecHeader.Size = UDim2.new(1, 0, 0, 22)
            SecHeader.Font = Theme.FontBold
            SecHeader.Text = sectionName
            SecHeader.TextColor3 = Theme.TextWhite
            SecHeader.TextSize = 16
            SecHeader.TextXAlignment = Enum.TextXAlignment.Left
            
            local SecContainer = Instance.new("Frame")
            SecContainer.Parent = TabContent
            SecContainer.BackgroundTransparency = 1
            SecContainer.Size = UDim2.new(1, -6, 0, 0)
            SecContainer.AutomaticSize = Enum.AutomaticSize.Y
            
            local ContainerLayout = Instance.new("UIListLayout")
            ContainerLayout.Parent = SecContainer
            ContainerLayout.Padding = UDim.new(0, 8)
            
            local Section = {}
            
            function Section:CreateToggle(tConfig)
                local tName = tConfig.Name or "Toggle"
                local tState = tConfig.Default or false
                local tCallback = tConfig.Callback or function() end
                
                local Card = Instance.new("Frame")
                Card.Parent = SecContainer
                Card.BackgroundColor3 = Theme.CardBackground
                Card.Size = UDim2.new(1, 0, 0, 44)
                
                local CardCorner = Instance.new("UICorner")
                CardCorner.CornerRadius = UDim.new(0, 10)
                CardCorner.Parent = Card
                
                local Label = Instance.new("TextLabel")
                Label.Parent = Card
                Label.BackgroundTransparency = 1
                Label.Position = UDim2.new(0, 14, 0, 12)
                Label.Size = UDim2.new(1, -75, 0, 20)
                Label.Font = Theme.FontBold
                Label.Text = tName
                Label.TextColor3 = Theme.TextWhite
                Label.TextSize = 14
                Label.TextXAlignment = Enum.TextXAlignment.Left
                
                local SwitchBtn = Instance.new("TextButton")
                SwitchBtn.Parent = Card
                SwitchBtn.BackgroundColor3 = tState and Theme.AccentPurple or Color3.fromRGB(40, 35, 52)
                SwitchBtn.Position = UDim2.new(1, -54, 0.5, -12)
                SwitchBtn.Size = UDim2.new(0, 44, 0, 24)
                SwitchBtn.Text = ""
                
                local SwitchCorner = Instance.new("UICorner")
                SwitchCorner.CornerRadius = UDim.new(1, 0)
                SwitchCorner.Parent = SwitchBtn
                
                local SwitchKnob = Instance.new("Frame")
                SwitchKnob.Parent = SwitchBtn
                SwitchKnob.BackgroundColor3 = Theme.TextWhite
                SwitchKnob.Position = tState and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
                SwitchKnob.Size = UDim2.new(0, 18, 0, 18)
                
                local KnobCorner = Instance.new("UICorner")
                KnobCorner.CornerRadius = UDim.new(1, 0)
                KnobCorner.Parent = SwitchKnob
                
                SwitchBtn.MouseButton1Click:Connect(function()
                    tState = not tState
                    if tState then
                        SwitchKnob.Position = UDim2.new(1, -21, 0.5, -9)
                        SwitchBtn.BackgroundColor3 = Theme.AccentPurple
                    else
                        SwitchKnob.Position = UDim2.new(0, 3, 0.5, -9)
                        SwitchBtn.BackgroundColor3 = Color3.fromRGB(40, 35, 52)
                    end
                    tCallback(tState)
                end)
            end
            
            return Section
        end
        return Tab
    end
    return WindowObj
end

-- ==========================================
-- BACKEND LOGIC (PULL A SWORD)
-- ==========================================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

local State = {
    AutoTrain = false,
    AutoFight = false,
    AutoPull = false,
    AutoHatch = false
}

-- Cached Remotes to prevent extreme lag from GetDescendants() in fast loops
local CachedRemotes = {
    Train = {},
    Pull = {},
    Fight = {},
    Hatch = {}
}

task.spawn(function()
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            local name = v.Name:lower()
            if name:find("click") or name:find("train") or name:find("addstrength") then
                table.insert(CachedRemotes.Train, v)
            end
            if name:find("pull") or name:find("sword") then
                table.insert(CachedRemotes.Pull, v)
            end
            if name:find("fight") or name:find("attack") or name:find("boss") or name:find("battle") then
                table.insert(CachedRemotes.Fight, v)
            end
            if name:find("hatch") or name:find("open") or name:find("egg") then
                table.insert(CachedRemotes.Hatch, v)
            end
        end
    end
end)

-- ==========================================
-- SCRIPT UI GENERATION
-- ==========================================
print("[DEBUG] Generating UI...")
local Window = Library:CreateWindow({
    Title = "Pull A Sword",
    Icon = "⚔️",
    Width = 500,
    Height = 320
})

local MainTab = Window:CreateTab("Main", "🏠")
local FarmSection = MainTab:CreateSection("Auto Farming")

FarmSection:CreateToggle({
    Name = "Auto Train (Clicker)",
    Default = false,
    Callback = function(state)
        State.AutoTrain = state
        if state then
            task.spawn(function()
                while State.AutoTrain do
                    pcall(function()
                        local char = LocalPlayer.Character
                        if char then
                            local tool = LocalPlayer.Backpack:FindFirstChildOfClass("Tool") or char:FindFirstChildOfClass("Tool")
                            if tool then
                                if tool.Parent ~= char then tool.Parent = char end
                                tool:Activate()
                            end
                        end
                        for _, remote in pairs(CachedRemotes.Train) do
                            remote:FireServer()
                        end
                    end)
                    task.wait(0.01)
                end
            end)
        end
    end
})

FarmSection:CreateToggle({
    Name = "Auto Pull Swords",
    Default = false,
    Callback = function(state)
        State.AutoPull = state
        if state then
            task.spawn(function()
                while State.AutoPull do
                    pcall(function()
                        for _, prompt in pairs(workspace:GetDescendants()) do
                            if prompt:IsA("ProximityPrompt") then
                                fireproximityprompt(prompt)
                            end
                        end
                        for _, remote in pairs(CachedRemotes.Pull) do
                            remote:FireServer()
                        end
                    end)
                    task.wait(0.1)
                end
            end)
        end
    end
})

FarmSection:CreateToggle({
    Name = "Auto Fight",
    Default = false,
    Callback = function(state)
        State.AutoFight = state
        if state then
            task.spawn(function()
                while State.AutoFight do
                    pcall(function()
                        local char = LocalPlayer.Character
                        if char then
                            local weapon = LocalPlayer.Backpack:FindFirstChildOfClass("Tool") or char:FindFirstChildOfClass("Tool")
                            if weapon and weapon.Parent ~= char then weapon.Parent = char end
                            if weapon then weapon:Activate() end
                        end
                        for _, remote in pairs(CachedRemotes.Fight) do
                            remote:FireServer()
                        end
                    end)
                    task.wait(0.1)
                end
            end)
        end
    end
})

local PetsSection = MainTab:CreateSection("Pets & Eggs")

PetsSection:CreateToggle({
    Name = "Auto Hatch Eggs",
    Default = false,
    Callback = function(state)
        State.AutoHatch = state
        if state then
            task.spawn(function()
                while State.AutoHatch do
                    pcall(function()
                        for _, remote in pairs(CachedRemotes.Hatch) do
                            remote:FireServer("Basic")
                        end
                    end)
                    task.wait(0.2)
                end
            end)
        end
    end
})

print("[NOMII SCRIPTS] Pull A Sword (Nomii UI 1) Loaded Successfully!")
