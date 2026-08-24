-- Nomii Scripts UI Library
-- Matte Tech Design (Inspired by Quantum Mod Menu)
-- Made for Roblox Exploits (Synapse, Krnl, Fluxus, etc.)

local Library = {}
local success, CoreGui = pcall(function() return game:GetService("CoreGui") end)
if not success or not CoreGui then
    CoreGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Fonts & Colors (Matte Theme, No Heavy Glow)
local Theme = {
    Background = Color3.fromRGB(28, 30, 36), -- Deep Dark Matte
    Sidebar = Color3.fromRGB(28, 30, 36),
    SectionBackground = Color3.fromRGB(38, 41, 49), -- Lighter Matte for Sections
    AccentCyan = Color3.fromRGB(0, 229, 255),
    AccentPurple = Color3.fromRGB(157, 78, 221),
    TextWhite = Color3.fromRGB(240, 240, 240),
    TextGray = Color3.fromRGB(170, 175, 185),
    Font = Enum.Font.GothamBold, -- Clean Tech Font
    RegularFont = Enum.Font.Gotham
}

function Library:CreateWindow(config)
    config = config or {}
    local GameName = config.GameName
    
    -- Auto-detect Game Name if not provided
    if not GameName then
        local success, info = pcall(function()
            return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
        end)
        if success and info and info.Name then
            GameName = info.Name
        else
            GameName = "Unknown Game"
        end
    end
    local Version = config.Version or "v1.0.0"
    
    -- Destroy old instance if exists
    if CoreGui:FindFirstChild("NomiiScriptsUI") then
        CoreGui:FindFirstChild("NomiiScriptsUI"):Destroy()
    end
    
    local NomiiUI = Instance.new("ScreenGui")
    NomiiUI.Name = "NomiiScriptsUI"
    NomiiUI.Parent = CoreGui
    NomiiUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    NomiiUI.ResetOnSpawn = false
    
    local width = config.Width or 750
    local height = config.Height or 500
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = NomiiUI
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.Position = UDim2.new(0.5, -(width/2), 0.5, -(height/2))
    MainFrame.Size = UDim2.new(0, width, 0, height)
    MainFrame.ClipsDescendants = true
    MainFrame.BorderSizePixel = 0
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = MainFrame
    
    -- Dragging Logic
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

    -- Header (Top Left)
    local LogoImage = Instance.new("ImageLabel")
    LogoImage.Name = "Logo"
    LogoImage.Parent = MainFrame
    LogoImage.BackgroundTransparency = 1
    LogoImage.Position = UDim2.new(0, 20, 0, 18)
    LogoImage.Size = UDim2.new(0, 45, 0, 45)
    LogoImage.Image = "rbxassetid://1234567890" -- <-- Yahan Aapne Roblox me logo upload karke uski ID dalni hai
    LogoImage.ScaleType = Enum.ScaleType.Fit
    
    local HeaderTitle = Instance.new("TextLabel")
    HeaderTitle.Parent = MainFrame
    HeaderTitle.BackgroundTransparency = 1
    HeaderTitle.Position = UDim2.new(0, 75, 0, 20)
    HeaderTitle.Size = UDim2.new(0, 300, 0, 30)
    HeaderTitle.Font = Theme.Font
    HeaderTitle.Text = "NOMII SCRIPTS <font color='#00e5ff'>CONNECTED ["..Version.."]</font>"
    HeaderTitle.TextColor3 = Theme.TextWhite
    HeaderTitle.TextSize = 22
    HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
    HeaderTitle.RichText = true
    
    -- Add subtle glow effect to the title
    local TitleGlow = Instance.new("UIStroke")
    TitleGlow.Parent = HeaderTitle
    TitleGlow.Color = Theme.AccentCyan
    TitleGlow.Transparency = 0.6
    TitleGlow.Thickness = 1
    
    local HeaderSubtitle = Instance.new("TextLabel")
    HeaderSubtitle.Parent = MainFrame
    HeaderSubtitle.BackgroundTransparency = 1
    HeaderSubtitle.Position = UDim2.new(0, 75, 0, 48)
    HeaderSubtitle.Size = UDim2.new(0, 300, 0, 20)
    HeaderSubtitle.Font = Theme.RegularFont
    HeaderSubtitle.Text = GameName:upper()
    HeaderSubtitle.TextColor3 = Theme.TextGray
    HeaderSubtitle.TextSize = 13
    HeaderSubtitle.TextXAlignment = Enum.TextXAlignment.Left
    HeaderSubtitle.RichText = true
    
    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Parent = MainFrame
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Sidebar.Position = UDim2.new(0, 20, 0, 90)
    Sidebar.Size = UDim2.new(0, 160, 1, -110)
    Sidebar.BackgroundTransparency = 1
    
    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.Parent = Sidebar
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarLayout.Padding = UDim.new(0, 8)
    SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Parent = MainFrame
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 200, 0, 90)
    ContentContainer.Size = UDim2.new(1, -220, 1, -110)
    
    local Window = {
        Tabs = {},
        CurrentTab = nil
    }
    
    function Window:CreateTab(tabName)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Name = tabName.."_Btn"
        TabBtn.Parent = Sidebar
        TabBtn.BackgroundColor3 = Theme.SectionBackground
        TabBtn.Size = UDim2.new(1, 0, 0, 42)
        TabBtn.Font = Theme.Font
        TabBtn.Text = "    " .. tabName:upper()
        TabBtn.TextColor3 = Theme.TextGray
        TabBtn.TextSize = 14
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        TabBtn.AutoButtonColor = false
        
        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 6)
        BtnCorner.Parent = TabBtn
        
        local Indicator = Instance.new("Frame")
        Indicator.Parent = TabBtn
        Indicator.BackgroundColor3 = Theme.AccentCyan
        Indicator.Position = UDim2.new(0, 0, 0, 11)
        Indicator.Size = UDim2.new(0, 4, 0, 20)
        Indicator.BorderSizePixel = 0
        Indicator.BackgroundTransparency = 1
        
        local IndicatorCorner = Instance.new("UICorner")
        IndicatorCorner.CornerRadius = UDim.new(0, 2)
        IndicatorCorner.Parent = Indicator
        
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = tabName.."_Content"
        TabContent.Parent = ContentContainer
        TabContent.BackgroundTransparency = 1
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.ScrollBarThickness = 0
        TabContent.Visible = false
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        
        local ContentLayout = Instance.new("UIGridLayout")
        ContentLayout.Parent = TabContent
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.CellPadding = UDim2.new(0, 15, 0, 15)
        ContentLayout.CellSize = UDim2.new(0, 250, 0, 230)
        
        TabBtn.MouseButton1Click:Connect(function()
            for _, t in pairs(Window.Tabs) do
                t.Content.Visible = false
                t.Indicator.BackgroundTransparency = 1
                t.Btn.TextColor3 = Theme.TextGray
            end
            TabContent.Visible = true
            Indicator.BackgroundTransparency = 0
            TabBtn.TextColor3 = Theme.AccentCyan
        end)
        
        local Tab = {
            Btn = TabBtn,
            Content = TabContent,
            Indicator = Indicator
        }
        
        table.insert(Window.Tabs, Tab)
        
        -- Select first tab by default
        if #Window.Tabs == 1 then
            TabContent.Visible = true
            Indicator.BackgroundTransparency = 0
            TabBtn.TextColor3 = Theme.AccentCyan
        end
        
        function Tab:CreateSection(sectionName)
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Name = sectionName.."_Section"
            SectionFrame.Parent = TabContent
            SectionFrame.BackgroundColor3 = Theme.SectionBackground
            
            local SecCorner = Instance.new("UICorner")
            SecCorner.CornerRadius = UDim.new(0, 8)
            SecCorner.Parent = SectionFrame
            
            local SecTitle = Instance.new("TextLabel")
            SecTitle.Parent = SectionFrame
            SecTitle.BackgroundTransparency = 1
            SecTitle.Position = UDim2.new(0, 15, 0, 15)
            SecTitle.Size = UDim2.new(1, -30, 0, 20)
            SecTitle.Font = Theme.Font
            SecTitle.Text = sectionName:upper()
            SecTitle.TextColor3 = Theme.TextWhite
            SecTitle.TextSize = 16
            SecTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local ItemContainer = Instance.new("Frame")
            ItemContainer.Parent = SectionFrame
            ItemContainer.BackgroundTransparency = 1
            ItemContainer.Position = UDim2.new(0, 15, 0, 45)
            ItemContainer.Size = UDim2.new(1, -30, 1, -55)
            
            local ItemLayout = Instance.new("UIListLayout")
            ItemLayout.Parent = ItemContainer
            ItemLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ItemLayout.Padding = UDim.new(0, 12)
            
            local Section = {}
            
            function Section:CreateToggle(tConfig)
                local tName = tConfig.Name or "Toggle"
                local tCallback = tConfig.Callback or function() end
                local isPurple = tConfig.UsePurple or false
                local tState = false
                
                local ActiveColor = isPurple and Theme.AccentPurple or Theme.AccentCyan
                
                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Parent = ItemContainer
                ToggleFrame.BackgroundTransparency = 1
                ToggleFrame.Size = UDim2.new(1, 0, 0, 28)
                
                local TTitle = Instance.new("TextLabel")
                TTitle.Parent = ToggleFrame
                TTitle.BackgroundTransparency = 1
                TTitle.Size = UDim2.new(1, -50, 1, 0)
                TTitle.Font = Theme.RegularFont
                TTitle.Text = tName
                TTitle.TextColor3 = Theme.TextWhite
                TTitle.TextSize = 14
                TTitle.TextXAlignment = Enum.TextXAlignment.Left
                
                local TBtn = Instance.new("TextButton")
                TBtn.Parent = ToggleFrame
                TBtn.BackgroundColor3 = Theme.Background
                TBtn.Position = UDim2.new(1, -44, 0.5, -11)
                TBtn.Size = UDim2.new(0, 44, 0, 22)
                TBtn.Text = ""
                TBtn.AutoButtonColor = false
                
                local TCorner = Instance.new("UICorner")
                TCorner.CornerRadius = UDim.new(1, 0)
                TCorner.Parent = TBtn
                
                local TCircle = Instance.new("Frame")
                TCircle.Parent = TBtn
                TCircle.BackgroundColor3 = Theme.TextGray
                TCircle.Position = UDim2.new(0, 3, 0.5, -8)
                TCircle.Size = UDim2.new(0, 16, 0, 16)
                
                local CircleCorner = Instance.new("UICorner")
                CircleCorner.CornerRadius = UDim.new(1, 0)
                CircleCorner.Parent = TCircle
                
                TBtn.MouseButton1Click:Connect(function()
                    tState = not tState
                    if tState then
                        TweenService:Create(TCircle, TweenInfo.new(0.2), {Position = UDim2.new(1, -19, 0.5, -8), BackgroundColor3 = Theme.Background}):Play()
                        TweenService:Create(TBtn, TweenInfo.new(0.2), {BackgroundColor3 = ActiveColor}):Play()
                    else
                        TweenService:Create(TCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -8), BackgroundColor3 = Theme.TextGray}):Play()
                        TweenService:Create(TBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Background}):Play()
                    end
                    tCallback(tState)
                end)
            end
            
            function Section:CreateSlider(sConfig)
                local sName = sConfig.Name or "Slider"
                local sMin = sConfig.Min or 0
                local sMax = sConfig.Max or 100
                local sDef = sConfig.Default or 50
                local sSuffix = sConfig.Suffix or "%"
                local sCallback = sConfig.Callback or function() end
                
                local SliderFrame = Instance.new("Frame")
                SliderFrame.Parent = ItemContainer
                SliderFrame.BackgroundTransparency = 1
                SliderFrame.Size = UDim2.new(1, 0, 0, 40)
                
                local STitle = Instance.new("TextLabel")
                STitle.Parent = SliderFrame
                STitle.BackgroundTransparency = 1
                STitle.Size = UDim2.new(1, -40, 0, 15)
                STitle.Font = Theme.RegularFont
                STitle.Text = sName
                STitle.TextColor3 = Theme.TextWhite
                STitle.TextSize = 13
                STitle.TextXAlignment = Enum.TextXAlignment.Left
                
                local SVal = Instance.new("TextLabel")
                SVal.Parent = SliderFrame
                SVal.BackgroundTransparency = 1
                SVal.Position = UDim2.new(1, -50, 0, 0)
                SVal.Size = UDim2.new(0, 50, 0, 15)
                SVal.Font = Theme.RegularFont
                SVal.Text = tostring(sDef) .. sSuffix
                SVal.TextColor3 = Theme.TextGray
                SVal.TextSize = 13
                SVal.TextXAlignment = Enum.TextXAlignment.Right
                
                local SBarBg = Instance.new("Frame")
                SBarBg.Parent = SliderFrame
                SBarBg.BackgroundColor3 = Theme.Background
                SBarBg.Position = UDim2.new(0, 0, 0, 25)
                SBarBg.Size = UDim2.new(1, 0, 0, 6)
                SBarBg.BorderSizePixel = 0
                
                local BgCorner = Instance.new("UICorner")
                BgCorner.CornerRadius = UDim.new(1, 0)
                BgCorner.Parent = SBarBg
                
                local SBarFill = Instance.new("Frame")
                SBarFill.Parent = SBarBg
                SBarFill.BackgroundColor3 = Theme.AccentCyan
                SBarFill.Size = UDim2.new((sDef-sMin)/(sMax-sMin), 0, 1, 0)
                SBarFill.BorderSizePixel = 0
                
                local FillCorner = Instance.new("UICorner")
                FillCorner.CornerRadius = UDim.new(1, 0)
                FillCorner.Parent = SBarFill
                
                local SBtn = Instance.new("TextButton")
                SBtn.Parent = SBarBg
                SBtn.BackgroundColor3 = Theme.TextGray
                SBtn.Position = UDim2.new((sDef-sMin)/(sMax-sMin), -6, 0.5, -6)
                SBtn.Size = UDim2.new(0, 12, 0, 12)
                SBtn.Text = ""
                SBtn.AutoButtonColor = false
                
                local BtnCorner = Instance.new("UICorner")
                BtnCorner.CornerRadius = UDim.new(1, 0)
                BtnCorner.Parent = SBtn
                
                local dragging = false
                SBtn.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        local mousePos = UserInputService:GetMouseLocation().X
                        local barPos = SBarBg.AbsolutePosition.X
                        local barSize = SBarBg.AbsoluteSize.X
                        local percentage = math.clamp((mousePos - barPos) / barSize, 0, 1)
                        local value = math.floor(sMin + (sMax - sMin) * percentage)
                        
                        SBarFill.Size = UDim2.new(percentage, 0, 1, 0)
                        SBtn.Position = UDim2.new(percentage, -6, 0.5, -6)
                        SVal.Text = tostring(value) .. sSuffix
                        
                        sCallback(value)
                    end
                end)
            end
            
            return Section
        end
        
        return Tab
    end
    
    return Window
end

return Library
