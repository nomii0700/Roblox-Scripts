-- ============================================================
-- TOJI SCRIPTS - CHEATING DURING TESTING (TOJI UI V1)
-- Description: Minimalist, Stealth, 100% Executor Safe
-- ============================================================

-- ==========================================
-- 🛡️ ANTI-CRASH & LOAD DELAY
-- ==========================================
task.wait(2) -- Wait for game to fully load to prevent executor instant-crash
print("[TOJI SCRIPTS] Injecting...")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

-- SAFE GUI CONTAINER (No gethui / CoreGui to prevent silent crashes)
local function GetUIContainer()
    return LocalPlayer:WaitForChild("PlayerGui")
end

local UIContainer = GetUIContainer()

-- ==========================================
-- 🎨 TOJI UI THEME (Stealth / Minimalist / Green Accent)
-- ==========================================
local Theme = {
    Background = Color3.fromRGB(15, 15, 15),     -- Pitch Black
    Sidebar = Color3.fromRGB(20, 20, 20),        -- Dark Grey
    CardBackground = Color3.fromRGB(25, 25, 25), -- Slightly Lighter Grey
    CardBorder = Color3.fromRGB(40, 40, 40),     -- Subtle outline
    AccentGreen = Color3.fromRGB(45, 185, 110),  -- Toji Toxic/Emerald Green
    AccentGreenDark = Color3.fromRGB(30, 130, 75),
    TextWhite = Color3.fromRGB(240, 240, 240),
    TextGray = Color3.fromRGB(140, 140, 140),
    FontBold = Enum.Font.GothamBold,
    FontMedium = Enum.Font.GothamMedium,
    CornerSharpness = 4 -- Very sharp edges for Toji theme
}

local Library = {}

function Library:CreateWindow(config)
    config = config or {}
    local Title = config.Title or "TOJI SCRIPTS"
    local Width = config.Width or 480
    local Height = config.Height or 300
    
    -- Cleanup Old Instances
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
    
    -- Top Accent Line
    local TopLine = Instance.new("Frame")
    TopLine.Parent = MainFrame
    TopLine.BackgroundColor3 = Theme.AccentGreen
    TopLine.Size = UDim2.new(1, 0, 0, 2)
    TopLine.BorderSizePixel = 0
    
    -- Dragging Logic
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
    HeaderTitle.Size = UDim2.new(0, 200, 1, 0)
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
    Sidebar.Size = UDim2.new(0, 130, 1, -45)
    Sidebar.BorderSizePixel = 0
    
    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.Parent = Sidebar
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarLayout.Padding = UDim.new(0, 2)
    
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Parent = MainFrame
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 140, 0, 45)
    ContentContainer.Size = UDim2.new(1, -150, 1, -45)
    
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
        
        function Tab:CreateSlider(sConfig)
            local sName = sConfig.Name or "Slider"
            local sMin = sConfig.Min or 16
            local sMax = sConfig.Max or 100
            local sDefault = sConfig.Default or 16
            local sCallback = sConfig.Callback or function() end
            
            local Card = Instance.new("Frame")
            Card.Parent = TabContent
            Card.BackgroundColor3 = Theme.CardBackground
            Card.Size = UDim2.new(1, -6, 0, 55)
            Card.BorderSizePixel = 1
            Card.BorderColor3 = Theme.CardBorder
            
            local Label = Instance.new("TextLabel")
            Label.Parent = Card
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 12, 0, 8)
            Label.Size = UDim2.new(1, -24, 0, 14)
            Label.Font = Theme.FontMedium
            Label.Text = sName .. " - " .. tostring(sDefault)
            Label.TextColor3 = Theme.TextWhite
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
            
            local SliderBG = Instance.new("Frame")
            SliderBG.Parent = Card
            SliderBG.BackgroundColor3 = Theme.Sidebar
            SliderBG.Position = UDim2.new(0, 12, 0, 32)
            SliderBG.Size = UDim2.new(1, -24, 0, 6)
            SliderBG.BorderSizePixel = 0
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Parent = SliderBG
            SliderFill.BackgroundColor3 = Theme.AccentGreen
            SliderFill.Size = UDim2.new((sDefault - sMin) / (sMax - sMin), 0, 1, 0)
            SliderFill.BorderSizePixel = 0
            
            local SliderBtn = Instance.new("TextButton")
            SliderBtn.Parent = SliderBG
            SliderBtn.BackgroundTransparency = 1
            SliderBtn.Size = UDim2.new(1, 0, 1, 0)
            SliderBtn.Text = ""
            
            local dragging = false
            local function updateSlider(input)
                local pos = math.clamp((input.Position.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1)
                SliderFill.Size = UDim2.new(pos, 0, 1, 0)
                local val = math.floor(sMin + ((sMax - sMin) * pos))
                Label.Text = sName .. " - " .. tostring(val)
                sCallback(val)
            end
            
            SliderBtn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    updateSlider(input)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    updateSlider(input)
                end
            end)
        end
        
        return Tab
    end
    return WindowObj
end

-- ==========================================
-- 🛠️ BACKEND LOGIC (LOCAL STATE & BYPASSES)
-- ==========================================
local State = {
    AutoCheat = false,
    AutoSnack = false,
    AutoFarmCoins = false,
    AutoUpgrade = false,
    PlayerESP = false,
    NameESP = false,
    WalkSpeed = 16,
    JumpPower = 50
}

-- Prevent AFK Kick
LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

-- Character Mod Loop (Speed / Jump)
task.spawn(function()
    RunService.RenderStepped:Connect(function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = State.WalkSpeed
            char.Humanoid.JumpPower = State.JumpPower
        end
    end)
end)

-- Simple ESP Logic
local function CreateESP(player)
    if player == LocalPlayer then return end
    local highlight = Instance.new("Highlight")
    highlight.Name = "TojiESP"
    highlight.FillColor = Color3.fromRGB(200, 0, 0) -- Red for Danger (Teachers/Snitches)
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.Enabled = false
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "TojiNameESP"
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Enabled = false
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = billboard
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = player.Name
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextStrokeTransparency = 0
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextSize = 14
    
    local function apply()
        if player.Character then
            highlight.Parent = player.Character
            local head = player.Character:WaitForChild("Head", 2)
            if head then
                billboard.Parent = head
            end
        end
    end
    player.CharacterAdded:Connect(apply)
    apply()
end

task.spawn(function()
    while task.wait(1) do
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                if not p.Character:FindFirstChild("TojiESP") then
                    CreateESP(p)
                end
                
                local highlight = p.Character:FindFirstChild("TojiESP")
                if highlight then
                    highlight.Enabled = State.PlayerESP
                end
                
                local head = p.Character:FindFirstChild("Head")
                if head then
                    local nameEsp = head:FindFirstChild("TojiNameESP")
                    if nameEsp then
                        nameEsp.Enabled = State.NameESP
                    end
                end
            end
        end
    end
end)

-- ==========================================
-- ⚙️ SCRIPT UI GENERATION
-- ==========================================
local Window = Library:CreateWindow({
    Title = "TOJI SCRIPTS - CHEATING"
})

local FarmTab = Window:CreateTab("Automation")

FarmTab:CreateToggle({
    Name = "Auto Cheat (Answer Sheet Clicker)",
    Default = false,
    Callback = function(val)
        State.AutoCheat = val
        if val then
            task.spawn(function()
                while State.AutoCheat do
                    pcall(function()
                        -- Universal UI Clicker (Clicks A, B, C, D buttons on Answer Sheet)
                        if LocalPlayer.PlayerGui then
                            for _, gui in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
                                if gui:IsA("TextButton") or gui:IsA("ImageButton") then
                                    -- Check if button is part of the answer sheet
                                    local name = gui.Name:lower()
                                    if name == "a" or name == "b" or name == "c" or name == "d" or name:find("answer") or name:find("option") then
                                        -- Fire all connections on the button
                                        for _, connection in pairs(getconnections(gui.MouseButton1Click)) do
                                            connection:Function()
                                        end
                                        for _, connection in pairs(getconnections(gui.MouseButton1Down)) do
                                            connection:Function()
                                        end
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(1) -- Slowed down slightly to look human and prevent lag
                end
            end)
        end
    end
})

FarmTab:CreateToggle({
    Name = "Auto Eat Snacks (Anxiety Control)",
    Default = false,
    Callback = function(val)
        State.AutoSnack = val
        if val then
            task.spawn(function()
                while State.AutoSnack do
                    pcall(function()
                        -- Auto Equip and Activate Snack from Backpack
                        local char = LocalPlayer.Character
                        if char then
                            for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                                if tool:IsA("Tool") then
                                    local tName = tool.Name:lower()
                                    -- Match common snack names
                                    if tName:find("chips") or tName:find("soda") or tName:find("water") or tName:find("snack") or tName:find("bar") then
                                        tool.Parent = char -- Equip
                                        task.wait(0.1)
                                        tool:Activate() -- Eat/Drink
                                        task.wait(0.5)
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(2) -- Check backpack every 2 seconds
                end
            end)
        end
    end
})

FarmTab:CreateToggle({
    Name = "Auto Farm Bucks / Coins",
    Default = false,
    Callback = function(val)
        State.AutoFarmCoins = val
        if val then
            task.spawn(function()
                while State.AutoFarmCoins do
                    pcall(function()
                        local char = LocalPlayer.Character
                        if char and char:FindFirstChild("HumanoidRootPart") then
                            -- Touch physical coins
                            for _, v in pairs(Workspace:GetDescendants()) do
                                if v:IsA("Part") or v:IsA("MeshPart") then
                                    local name = v.Name:lower()
                                    if name:match("coin") or name:match("buck") or name:match("money") or name:match("cash") then
                                        if v:FindFirstChild("TouchInterest") then
                                            firetouchinterest(char.HumanoidRootPart, v, 0)
                                            task.wait(0.01)
                                            firetouchinterest(char.HumanoidRootPart, v, 1)
                                        else
                                            char.HumanoidRootPart.CFrame = v.CFrame
                                        end
                                    end
                                end
                            end
                            -- Fire remote events for coins
                            for _, v in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                                if v:IsA("RemoteEvent") and (v.Name:lower():match("coin") or v.Name:lower():match("buck") or v.Name:lower():match("reward")) then
                                    v:FireServer()
                                end
                            end
                        end
                    end)
                    task.wait(0.5)
                end
            end)
        end
    end
})

FarmTab:CreateToggle({
    Name = "Auto Upgrade Gears / Stats",
    Default = false,
    Callback = function(val)
        State.AutoUpgrade = val
        if val then
            task.spawn(function()
                while State.AutoUpgrade do
                    pcall(function()
                        -- Fire remote events for upgrades
                        for _, v in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                            if v:IsA("RemoteEvent") and (v.Name:lower():match("upgrade") or v.Name:lower():match("stat") or v.Name:lower():match("gear")) then
                                v:FireServer("All")
                                v:FireServer()
                            end
                        end
                        -- Click UI buttons for upgrades
                        if LocalPlayer.PlayerGui then
                            for _, gui in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
                                if gui:IsA("TextButton") or gui:IsA("ImageButton") then
                                    local name = gui.Name:lower()
                                    local text = gui:IsA("TextButton") and gui.Text:lower() or ""
                                    if name:match("upgrade") or name:match("buy") or name:match("stat") or text:match("upgrade") or text:match("buy") then
                                        for _, connection in pairs(getconnections(gui.MouseButton1Click)) do
                                            connection:Function()
                                        end
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(1)
                end
            end)
        end
    end
})

local VisualsTab = Window:CreateTab("Visuals & ESP")

VisualsTab:CreateToggle({
    Name = "Player ESP (Highlight)",
    Default = false,
    Callback = function(val)
        State.PlayerESP = val
    end
})

VisualsTab:CreateToggle({
    Name = "Name ESP",
    Default = false,
    Callback = function(val)
        State.NameESP = val
    end
})

local PlayerTab = Window:CreateTab("Player Mod")

PlayerTab:CreateSlider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 150,
    Default = 16,
    Callback = function(val)
        State.WalkSpeed = val
    end
})

PlayerTab:CreateSlider({
    Name = "JumpPower",
    Min = 50,
    Max = 300,
    Default = 50,
    Callback = function(val)
        State.JumpPower = val
    end
})

print("[TOJI SCRIPTS] Successfully Injected!")
