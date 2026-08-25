-- ============================================================
-- NOMII SCRIPTS - CLEAN ALL THE LEAVES (TOJI UI)
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

-- Prevent AFK Kick
LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

-- ==========================================
-- 🎨 TOJI UI THEME & LIBRARY
-- ==========================================
local Theme = {
    Background = Color3.fromRGB(15, 15, 15),
    Sidebar = Color3.fromRGB(20, 20, 20),
    CardBackground = Color3.fromRGB(25, 25, 25),
    CardBorder = Color3.fromRGB(40, 40, 40),
    AccentGreen = Color3.fromRGB(45, 185, 110),
    TextWhite = Color3.fromRGB(240, 240, 240),
    TextGray = Color3.fromRGB(140, 140, 140),
    FontBold = Enum.Font.GothamBold,
    FontMedium = Enum.Font.GothamMedium,
    CornerSharpness = 4
}

local UIContainer = LocalPlayer:WaitForChild("PlayerGui")
local Library = {}

function Library:CreateWindow(config)
    config = config or {}
    local Title = config.Title or "NOMII SCRIPTS"
    local Width = config.Width or 480
    local Height = config.Height or 300
    
    pcall(function()
        if UIContainer:FindFirstChild("TojiUI_V1") then
            UIContainer:FindFirstChild("TojiUI_V1"):Destroy()
        end
    end)
    
    local TojiUI = Instance.new("ScreenGui")
    TojiUI.Name = "TojiUI_V1"
    TojiUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    TojiUI.ResetOnSpawn = false
    TojiUI.Parent = UIContainer
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = TojiUI
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.Position = UDim2.new(0.5, -(Width/2), 0.5, -(Height/2))
    MainFrame.Size = UDim2.new(0, Width, 0, Height)
    MainFrame.ClipsDescendants = true
    MainFrame.BorderSizePixel = 1
    MainFrame.BorderColor3 = Theme.CardBorder
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, Theme.CornerSharpness)
    UICorner.Parent = MainFrame
    
    local TopLine = Instance.new("Frame")
    TopLine.Parent = MainFrame
    TopLine.BackgroundColor3 = Theme.AccentGreen
    TopLine.Size = UDim2.new(1, 0, 0, 2)
    TopLine.BorderSizePixel = 0
    
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
    HeaderBar.Position = UDim2.new(0, 14, 0, 10)
    HeaderBar.Size = UDim2.new(1, -28, 0, 30)
    
    local HeaderTitle = Instance.new("TextLabel")
    HeaderTitle.Parent = HeaderBar
    HeaderTitle.BackgroundTransparency = 1
    HeaderTitle.Size = UDim2.new(0, 300, 1, 0)
    HeaderTitle.Font = Theme.FontBold
    HeaderTitle.Text = Title
    HeaderTitle.TextColor3 = Theme.TextWhite
    HeaderTitle.TextSize = 16
    HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Parent = HeaderBar
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Position = UDim2.new(1, -20, 0, 5)
    CloseBtn.Size = UDim2.new(0, 20, 0, 20)
    CloseBtn.Font = Theme.FontBold
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Theme.TextGray
    CloseBtn.TextSize = 14
    CloseBtn.MouseButton1Click:Connect(function() TojiUI:Destroy() end)
    
    local Sidebar = Instance.new("Frame")
    Sidebar.Parent = MainFrame
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Sidebar.Position = UDim2.new(0, 0, 0, 45)
    Sidebar.Size = UDim2.new(0, 140, 1, -45)
    Sidebar.BorderSizePixel = 0
    
    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.Parent = Sidebar
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarLayout.Padding = UDim.new(0, 2)
    
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Parent = MainFrame
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 150, 0, 45)
    ContentContainer.Size = UDim2.new(1, -160, 1, -45)
    
    local WindowObj = { Tabs = {} }
    
    function WindowObj:CreateTab(tabName)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Parent = Sidebar
        TabBtn.BackgroundColor3 = Theme.Sidebar
        TabBtn.BackgroundTransparency = 1
        TabBtn.Size = UDim2.new(1, 0, 0, 34)
        TabBtn.Font = Theme.FontMedium
        TabBtn.Text = "  " .. tabName
        TabBtn.TextColor3 = Theme.TextGray
        TabBtn.TextSize = 13
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        
        local ActiveIndicator = Instance.new("Frame")
        ActiveIndicator.Parent = TabBtn
        ActiveIndicator.BackgroundColor3 = Theme.AccentGreen
        ActiveIndicator.Size = UDim2.new(0, 3, 1, 0)
        ActiveIndicator.BorderSizePixel = 0
        ActiveIndicator.Visible = false
        
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Parent = ContentContainer
        TabContent.BackgroundTransparency = 1
        TabContent.Size = UDim2.new(1, 0, 1, -10)
        TabContent.ScrollBarThickness = 2
        TabContent.ScrollBarImageColor3 = Theme.AccentGreen
        TabContent.Visible = false
        
        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Parent = TabContent
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Padding = UDim.new(0, 10)
        
        TabBtn.MouseButton1Click:Connect(function()
            for _, t in pairs(WindowObj.Tabs) do
                t.Content.Visible = false
                t.Btn.TextColor3 = Theme.TextGray
                t.Indicator.Visible = false
            end
            TabContent.Visible = true
            TabBtn.TextColor3 = Theme.TextWhite
            ActiveIndicator.Visible = true
        end)
        
        local Tab = { Btn = TabBtn, Indicator = ActiveIndicator, Content = TabContent }
        table.insert(WindowObj.Tabs, Tab)
        
        if #WindowObj.Tabs == 1 then
            TabContent.Visible = true
            TabBtn.TextColor3 = Theme.TextWhite
            ActiveIndicator.Visible = true
        end
        
        function Tab:CreateToggle(tConfig)
            local tName = tConfig.Name or "Toggle"
            local tState = tConfig.Default or false
            local tCallback = tConfig.Callback or function() end
            
            local Card = Instance.new("Frame")
            Card.Parent = TabContent
            Card.BackgroundColor3 = Theme.CardBackground
            Card.Size = UDim2.new(1, -6, 0, 38)
            Card.BorderSizePixel = 1
            Card.BorderColor3 = Theme.CardBorder
            
            local Label = Instance.new("TextLabel")
            Label.Parent = Card
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.Size = UDim2.new(1, -60, 1, 0)
            Label.Font = Theme.FontMedium
            Label.Text = tName
            Label.TextColor3 = Theme.TextWhite
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
            
            local SwitchBtn = Instance.new("TextButton")
            SwitchBtn.Parent = Card
            SwitchBtn.BackgroundColor3 = tState and Theme.AccentGreen or Theme.Sidebar
            SwitchBtn.Position = UDim2.new(1, -45, 0.5, -9)
            SwitchBtn.Size = UDim2.new(0, 34, 0, 18)
            SwitchBtn.Text = ""
            SwitchBtn.BorderSizePixel = 1
            SwitchBtn.BorderColor3 = Theme.CardBorder
            
            local SwitchKnob = Instance.new("Frame")
            SwitchKnob.Parent = SwitchBtn
            SwitchKnob.BackgroundColor3 = Theme.TextWhite
            SwitchKnob.Position = tState and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
            SwitchKnob.Size = UDim2.new(0, 14, 0, 14)
            SwitchKnob.BorderSizePixel = 0
            
            SwitchBtn.MouseButton1Click:Connect(function()
                tState = not tState
                if tState then
                    SwitchKnob.Position = UDim2.new(1, -16, 0.5, -7)
                    SwitchBtn.BackgroundColor3 = Theme.AccentGreen
                else
                    SwitchKnob.Position = UDim2.new(0, 2, 0.5, -7)
                    SwitchBtn.BackgroundColor3 = Theme.Sidebar
                end
                tCallback(tState)
            end)
        end
        return Tab
    end
    return WindowObj
end

-- ==========================================
-- 🛠️ BACKEND LOGIC & BYPASSES
-- ==========================================
local State = {
    AutoFarm = false,
    AutoSell = false,
    AutoEquip = false
}

-- Fire ClickDetectors securely
local function FireCD(cd)
    if cd and cd:IsA("ClickDetector") then
        if typeof(fireclickdetector) == "function" then
            fireclickdetector(cd, 0)
        end
    end
end

-- Fire ProximityPrompts securely
local function FirePP(pp)
    if pp and pp:IsA("ProximityPrompt") then
        if typeof(fireproximityprompt) == "function" then
            fireproximityprompt(pp)
        end
    end
end

local function GetLeaves()
    local leaves = {}
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            local name = v.Name:lower()
            if name:match("leaf") or name:match("leaves") or name == "meshpart" then
                table.insert(leaves, v)
            end
        end
    end
    return leaves
end

-- Auto Equip Loop
task.spawn(function()
    while task.wait(1) do
        if State.AutoEquip then
            pcall(function()
                local backpack = LocalPlayer:FindFirstChild("Backpack")
                local char = LocalPlayer.Character
                if backpack and char then
                    for _, tool in pairs(backpack:GetChildren()) do
                        if tool:IsA("Tool") then
                            tool.Parent = char
                            break
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Farm Loop (No Character Teleporting, pure remote/event firing)
task.spawn(function()
    while task.wait(0.1) do
        if State.AutoFarm then
            pcall(function()
                local leaves = GetLeaves()
                
                -- Fire ClickDetectors & Prompts
                for _, leaf in pairs(leaves) do
                    if not State.AutoFarm then break end
                    FireCD(leaf:FindFirstChildOfClass("ClickDetector"))
                    FirePP(leaf:FindFirstChildOfClass("ProximityPrompt"))
                end
                
                -- Fire Potential RemoteEvents
                for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                    if remote:IsA("RemoteEvent") then
                        local rName = remote.Name:lower()
                        if rName:match("collect") or rName:match("leaf") or rName:match("gather") or rName:match("click") then
                            -- Try firing with and without leaf argument
                            for _, leaf in pairs(leaves) do
                                remote:FireServer(leaf)
                            end
                            remote:FireServer()
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Sell Loop
task.spawn(function()
    while task.wait(0.5) do
        if State.AutoSell then
            pcall(function()
                -- Check for bins in Workspace
                for _, v in pairs(Workspace:GetDescendants()) do
                    if v:IsA("Model") or v:IsA("BasePart") then
                        local name = v.Name:lower()
                        if name:match("trash") or name:match("bin") or name:match("dump") or name:match("sell") then
                            FireCD(v:FindFirstChildOfClass("ClickDetector", true))
                            FirePP(v:FindFirstChildOfClass("ProximityPrompt", true))
                        end
                    end
                end
                
                -- Fire Potential Sell RemoteEvents
                for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                    if remote:IsA("RemoteEvent") then
                        local rName = remote.Name:lower()
                        if rName:match("sell") or rName:match("empty") or rName:match("trash") or rName:match("deposit") then
                            remote:FireServer()
                        end
                    end
                end
            end)
        end
    end
end)

-- ==========================================
-- ⚙️ SCRIPT UI GENERATION
-- ==========================================
local Window = Library:CreateWindow({
    Title = "CLEAN THE LEAVES",
    Width = 480,
    Height = 320
})

local MainTab = Window:CreateTab("Auto Farm")

MainTab:CreateToggle({
    Name = "Auto Farm Leaves (Bypass)",
    Default = false,
    Callback = function(val)
        State.AutoFarm = val
    end
})

MainTab:CreateToggle({
    Name = "Auto Empty Bag (Sell)",
    Default = false,
    Callback = function(val)
        State.AutoSell = val
    end
})

MainTab:CreateToggle({
    Name = "Auto Equip Tool",
    Default = false,
    Callback = function(val)
        State.AutoEquip = val
    end
})

print("[NOMII SCRIPTS] Clean The Leaves script successfully loaded with Toji UI!")
