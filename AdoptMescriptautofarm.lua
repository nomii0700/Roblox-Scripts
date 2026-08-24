-- ============================================================
-- NOMII SCRIPTS - ADOPT ME SCRIPT (FULLY FUNCTIONAL V2)
-- Architecture: Uses Adopt Me's internal Fsys & RouterClient
-- UI Size: Compact Sidebar (500x320)
-- ============================================================

-- ==========================================
-- NOMII UI LIBRARY (EMBEDDED)
-- ==========================================
local Library = {}

local function GetUIContainer()
    if gethui then
        local ok, hui = pcall(gethui)
        if ok and hui then return hui end
    end
    
    local success, coreGui = pcall(function() return game:GetService("CoreGui") end)
    if success and coreGui then
        local testOk = pcall(function()
            local test = Instance.new("ScreenGui")
            test.Parent = coreGui
            test:Destroy()
        end)
        if testOk then return coreGui end
    end
    
    local player = game:GetService("Players").LocalPlayer
    if player then
        return player:WaitForChild("PlayerGui")
    end
    return game:GetService("CoreGui")
end

local UIContainer = GetUIContainer()
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
    local Title = config.Title or config.GameName or "Adopt Me Script"
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
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
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
    StarIcon.Name = "StarIcon"
    StarIcon.Parent = HeaderBar
    StarIcon.BackgroundTransparency = 1
    StarIcon.Position = UDim2.new(0, 0, 0, 0)
    StarIcon.Size = UDim2.new(0, 28, 1, 0)
    StarIcon.Font = Theme.FontBold
    StarIcon.Text = IconText
    StarIcon.TextColor3 = Theme.StarYellow
    StarIcon.TextSize = 22
    StarIcon.TextXAlignment = Enum.TextXAlignment.Center
    
    local HeaderTitle = Instance.new("TextLabel")
    HeaderTitle.Name = "HeaderTitle"
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
    
    CloseBtn.MouseButton1Click:Connect(function()
        NomiiUI:Destroy()
    end)
    
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Parent = MainFrame
    Sidebar.BackgroundTransparency = 1
    Sidebar.Position = UDim2.new(0, 16, 0, 56)
    Sidebar.Size = UDim2.new(0, 140, 1, -70)
    
    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.Parent = Sidebar
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarLayout.Padding = UDim.new(0, 6)
    SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Parent = MainFrame
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 168, 0, 56)
    ContentContainer.Size = UDim2.new(1, -184, 1, -70)
    
    local WindowObj = {
        Tabs = {},
        CurrentTab = nil
    }
    
    function WindowObj:CreateTab(tabName, iconText)
        iconText = iconText or "📄"
        
        local TabBtn = Instance.new("TextButton")
        TabBtn.Name = tabName.."_Tab"
        TabBtn.Parent = Sidebar
        TabBtn.BackgroundColor3 = Theme.Background
        TabBtn.BackgroundTransparency = 1
        TabBtn.Size = UDim2.new(1, 0, 0, 38)
        TabBtn.Font = Theme.FontMedium
        TabBtn.Text = "      " .. tabName
        TabBtn.TextColor3 = Theme.TextGray
        TabBtn.TextSize = 14
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        TabBtn.AutoButtonColor = false
        
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
        TabContent.Name = tabName.."_Content"
        TabContent.Parent = ContentContainer
        TabContent.BackgroundTransparency = 1
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.ScrollBarThickness = 3
        TabContent.ScrollBarImageColor3 = Theme.AccentPurple
        TabContent.Visible = false
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        
        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Parent = TabContent
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Padding = UDim.new(0, 12)
        
        TabBtn.MouseButton1Click:Connect(function()
            for _, t in pairs(WindowObj.Tabs) do
                t.Content.Visible = false
                TweenService:Create(t.Btn, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
                t.Btn.TextColor3 = Theme.TextGray
                t.Icon.TextColor3 = Theme.TextGray
            end
            TabContent.Visible = true
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.AccentPurple, BackgroundTransparency = 0}):Play()
            TabBtn.TextColor3 = Theme.TextWhite
            TabIcon.TextColor3 = Theme.TextWhite
        end)
        
        local Tab = {
            Btn = TabBtn,
            Icon = TabIcon,
            Content = TabContent
        }
        table.insert(WindowObj.Tabs, Tab)
        
        if #WindowObj.Tabs == 1 then
            TabContent.Visible = true
            TabBtn.BackgroundColor3 = Theme.AccentPurple
            TabBtn.BackgroundTransparency = 0
            TabBtn.TextColor3 = Theme.TextWhite
            TabIcon.TextColor3 = Theme.TextWhite
        end
        
        function Tab:CreateSection(sectionName)
            local SectionHeader = Instance.new("TextLabel")
            SectionHeader.Name = sectionName.."_Header"
            SectionHeader.Parent = TabContent
            SectionHeader.BackgroundTransparency = 1
            SectionHeader.Size = UDim2.new(1, 0, 0, 22)
            SectionHeader.Font = Theme.FontBold
            SectionHeader.Text = sectionName
            SectionHeader.TextColor3 = Theme.TextWhite
            SectionHeader.TextSize = 16
            SectionHeader.TextXAlignment = Enum.TextXAlignment.Left
            
            local SectionContainer = Instance.new("Frame")
            SectionContainer.Name = sectionName.."_Container"
            SectionContainer.Parent = TabContent
            SectionContainer.BackgroundTransparency = 1
            SectionContainer.Size = UDim2.new(1, -6, 0, 0)
            SectionContainer.AutomaticSize = Enum.AutomaticSize.Y
            
            local ContainerLayout = Instance.new("UIListLayout")
            ContainerLayout.Parent = SectionContainer
            ContainerLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ContainerLayout.Padding = UDim.new(0, 8)
            
            local Section = {}
            
            function Section:CreateToggle(tConfig)
                local tName = tConfig.Name or "Toggle"
                local tSub = tConfig.Subtitle or tConfig.Description or ""
                local tDefault = tConfig.Default or false
                local tCallback = tConfig.Callback or function() end
                local tState = tDefault
                
                local CardFrame = Instance.new("Frame")
                CardFrame.Name = tName.."_Card"
                CardFrame.Parent = SectionContainer
                CardFrame.BackgroundColor3 = Theme.CardBackground
                CardFrame.Size = UDim2.new(1, 0, 0, tSub ~= "" and 58 or 44)
                CardFrame.BorderSizePixel = 0
                
                local CardCorner = Instance.new("UICorner")
                CardCorner.CornerRadius = UDim.new(0, 10)
                CardCorner.Parent = CardFrame
                
                local CardStroke = Instance.new("UIStroke")
                CardStroke.Parent = CardFrame
                CardStroke.Color = Theme.CardBorder
                CardStroke.Thickness = 1
                CardStroke.Transparency = 0.5
                
                local TitleLabel = Instance.new("TextLabel")
                TitleLabel.Parent = CardFrame
                TitleLabel.BackgroundTransparency = 1
                TitleLabel.Position = UDim2.new(0, 14, 0, tSub ~= "" and 10 or 12)
                TitleLabel.Size = UDim2.new(1, -75, 0, 20)
                TitleLabel.Font = Theme.FontBold
                TitleLabel.Text = tName
                TitleLabel.TextColor3 = Theme.TextWhite
                TitleLabel.TextSize = 14
                TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                if tSub ~= "" then
                    local SubLabel = Instance.new("TextLabel")
                    SubLabel.Parent = CardFrame
                    SubLabel.BackgroundTransparency = 1
                    SubLabel.Position = UDim2.new(0, 14, 0, 30)
                    SubLabel.Size = UDim2.new(1, -75, 0, 16)
                    SubLabel.Font = Theme.FontRegular
                    SubLabel.Text = tSub
                    SubLabel.TextColor3 = Theme.TextSubLabel
                    SubLabel.TextSize = 12
                    SubLabel.TextXAlignment = Enum.TextXAlignment.Left
                end
                
                local SwitchBtn = Instance.new("TextButton")
                SwitchBtn.Parent = CardFrame
                SwitchBtn.BackgroundColor3 = tState and Theme.AccentPurple or Color3.fromRGB(40, 35, 52)
                SwitchBtn.Position = UDim2.new(1, -54, 0.5, -12)
                SwitchBtn.Size = UDim2.new(0, 44, 0, 24)
                SwitchBtn.Text = ""
                SwitchBtn.AutoButtonColor = false
                
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
                        TweenService:Create(SwitchKnob, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(1, -21, 0.5, -9)}):Play()
                        TweenService:Create(SwitchBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.AccentPurple}):Play()
                    else
                        TweenService:Create(SwitchKnob, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 3, 0.5, -9)}):Play()
                        TweenService:Create(SwitchBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 35, 52)}):Play()
                    end
                    tCallback(tState)
                end)
            end
            
            function Section:CreateButton(bConfig)
                local bName = bConfig.Name or "Button"
                local bSub = bConfig.Subtitle or bConfig.Description or ""
                local bCallback = bConfig.Callback or function() end
                
                local CardFrame = Instance.new("Frame")
                CardFrame.Parent = SectionContainer
                CardFrame.BackgroundColor3 = Theme.CardBackground
                CardFrame.Size = UDim2.new(1, 0, 0, bSub ~= "" and 54 or 42)
                
                local CardCorner = Instance.new("UICorner")
                CardCorner.CornerRadius = UDim.new(0, 10)
                CardCorner.Parent = CardFrame
                
                local ActionBtn = Instance.new("TextButton")
                ActionBtn.Parent = CardFrame
                ActionBtn.BackgroundTransparency = 1
                ActionBtn.Size = UDim2.new(1, 0, 1, 0)
                ActionBtn.Font = Theme.FontBold
                ActionBtn.Text = "   " .. bName
                ActionBtn.TextColor3 = Theme.TextWhite
                ActionBtn.TextSize = 14
                ActionBtn.TextXAlignment = Enum.TextXAlignment.Left
                
                if bSub ~= "" then
                    local SubLabel = Instance.new("TextLabel")
                    SubLabel.Parent = CardFrame
                    SubLabel.BackgroundTransparency = 1
                    SubLabel.Position = UDim2.new(0, 14, 0, 28)
                    SubLabel.Size = UDim2.new(1, -28, 0, 16)
                    SubLabel.Font = Theme.FontRegular
                    SubLabel.Text = bSub
                    SubLabel.TextColor3 = Theme.TextSubLabel
                    SubLabel.TextSize = 12
                    SubLabel.TextXAlignment = Enum.TextXAlignment.Left
                end
                
                ActionBtn.MouseButton1Click:Connect(function()
                    TweenService:Create(CardFrame, TweenInfo.new(0.1), {BackgroundColor3 = Theme.AccentPurple}):Play()
                    task.wait(0.1)
                    TweenService:Create(CardFrame, TweenInfo.new(0.2), {BackgroundColor3 = Theme.CardBackground}):Play()
                    bCallback()
                end)
            end
            
            function Section:CreateDropdown(dConfig)
                local dName = dConfig.Name or "Dropdown"
                local dOptions = dConfig.Options or {}
                local dDefault = dConfig.Default or ""
                local dCallback = dConfig.Callback or function() end
                
                local CardFrame = Instance.new("Frame")
                CardFrame.Parent = SectionContainer
                CardFrame.BackgroundColor3 = Theme.CardBackground
                CardFrame.Size = UDim2.new(1, 0, 0, 56)
                
                local CardCorner = Instance.new("UICorner")
                CardCorner.CornerRadius = UDim.new(0, 10)
                CardCorner.Parent = CardFrame
                
                local DTitle = Instance.new("TextLabel")
                DTitle.Parent = CardFrame
                DTitle.BackgroundTransparency = 1
                DTitle.Position = UDim2.new(0, 14, 0, 8)
                DTitle.Size = UDim2.new(1, -28, 0, 16)
                DTitle.Font = Theme.FontBold
                DTitle.Text = dName
                DTitle.TextColor3 = Theme.TextWhite
                DTitle.TextSize = 13
                DTitle.TextXAlignment = Enum.TextXAlignment.Left
                
                local DBtn = Instance.new("TextButton")
                DBtn.Parent = CardFrame
                DBtn.BackgroundColor3 = Theme.Background
                DBtn.Position = UDim2.new(0, 14, 0, 26)
                DBtn.Size = UDim2.new(1, -28, 0, 22)
                DBtn.Font = Theme.FontRegular
                DBtn.Text = "  " .. (dDefault ~= "" and dDefault or "Select...")
                DBtn.TextColor3 = Theme.TextGray
                DBtn.TextSize = 12
                DBtn.TextXAlignment = Enum.TextXAlignment.Left
                DBtn.AutoButtonColor = false
                
                local DCorner = Instance.new("UICorner")
                DCorner.CornerRadius = UDim.new(0, 6)
                DCorner.Parent = DBtn
                
                local DropList = Instance.new("ScrollingFrame")
                DropList.Parent = MainFrame
                DropList.BackgroundColor3 = Theme.CardBackground
                DropList.Size = UDim2.new(0, 0, 0, 0)
                DropList.Visible = false
                DropList.ZIndex = 25
                DropList.ScrollBarThickness = 2
                DropList.ScrollBarImageColor3 = Theme.AccentPurple
                
                local ListLayout = Instance.new("UIListLayout")
                ListLayout.Parent = DropList
                ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                
                for _, option in ipairs(dOptions) do
                    local OptBtn = Instance.new("TextButton")
                    OptBtn.Parent = DropList
                    OptBtn.BackgroundColor3 = Theme.CardBackground
                    OptBtn.Size = UDim2.new(1, 0, 0, 22)
                    OptBtn.Font = Theme.FontRegular
                    OptBtn.Text = "  " .. option
                    OptBtn.TextColor3 = Theme.TextWhite
                    OptBtn.TextSize = 12
                    OptBtn.TextXAlignment = Enum.TextXAlignment.Left
                    OptBtn.ZIndex = 26
                    
                    OptBtn.MouseButton1Click:Connect(function()
                        DBtn.Text = "  " .. option
                        DropList.Visible = false
                        dCallback(option)
                    end)
                end
                
                local listOpen = false
                DBtn.MouseButton1Click:Connect(function()
                    listOpen = not listOpen
                    if listOpen then
                        local absPos = DBtn.AbsolutePosition
                        local mainPos = MainFrame.AbsolutePosition
                        DropList.Position = UDim2.new(0, absPos.X - mainPos.X, 0, absPos.Y - mainPos.Y + 24)
                        DropList.Size = UDim2.new(0, DBtn.AbsoluteSize.X, 0, math.min(#dOptions * 22, 100))
                        DropList.CanvasSize = UDim2.new(0, 0, 0, #dOptions * 22)
                        DropList.Visible = true
                    else
                        DropList.Visible = false
                    end
                end)
            end
            
            return Section
        end
        return Tab
    end
    function WindowObj:SelectTab(tabObj)
        if tabObj and tabObj.Btn then
            -- Trigger click event equivalent
            for _, t in pairs(self.Tabs) do
                t.Content.Visible = false
                t.Btn.BackgroundTransparency = 1
                t.Btn.TextColor3 = Theme.TextGray
                t.Icon.TextColor3 = Theme.TextGray
            end
            tabObj.Content.Visible = true
            tabObj.Btn.BackgroundColor3 = Theme.AccentPurple
            tabObj.Btn.BackgroundTransparency = 0
            tabObj.Btn.TextColor3 = Theme.TextWhite
            tabObj.Icon.TextColor3 = Theme.TextWhite
        end
    end
    return WindowObj
end

-- ==========================================
-- ADOPT ME BACKEND LOGIC (FSYS)
-- ==========================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local getgenv = getgenv or function() return _G end

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

-- ==========================================
-- SCRIPT UI GENERATION
-- ==========================================
local Window = Library:CreateWindow({
    Title = "Adopt Me Script",
    Icon = "⭐",
    Width = 500,
    Height = 320
})

local HomeTab      = Window:CreateTab("Home", "🏠")
local PetsTab      = Window:CreateTab("Pets", "🐾")
local FarmingTab   = Window:CreateTab("Farming", "🎟️")
local TeleportsTab = Window:CreateTab("Teleports", "📍")
local MiscTab      = Window:CreateTab("Misc", "💬")
local SettingsTab  = Window:CreateTab("Settings", "⚙️")

local MainFeatures = HomeTab:CreateSection("Main Features")

MainFeatures:CreateToggle({
    Name = "Auto Farm Bucks",
    Subtitle = "Automatically farm bucks",
    Default = false,
    Callback = function(state)
        getgenv().AdoptAutoFarm = state
        if state then
            SafeInvoke("TeamAPI/ChooseTeam", "Babies", true)
            task.spawn(function()
                while getgenv().AdoptAutoFarm do
                    local petId = GetEquippedPet()
                    if petId then
                        SolveNeeds(petId)
                    end
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
        if state and ClientData then
            pcall(function() getrenv()._G.Cooldowns = {} end)
        end
    end
})

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

Window:SelectTab(HomeTab)
print("[NOMII SCRIPTS] Fully Functional Adopt Me Script Loaded!")
