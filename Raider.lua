pcall(function()
  local FindCore = game:GetService("CoreGui"):FindFirstChild("RaiderHub")
  FindCore:Destroy()
end) 

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Theme = {
    Header = Color3.fromRGB(0,255,255), 
    DropHeader = Color3.fromRGB(0,200,200),
    Scroll = Color3.fromRGB(0,255,255), 
    Text = Color3.fromRGB(255,255,255)
}

local Library = {}

function Library:Dragging(frame, parent)
    local gui = parent or frame
    local dragging
    local dragInput
    local dragStart
    local startPos
    local function update(input)
        local delta = input.Position - dragStart
        gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

function Library:Notification(Option) 
    local Title = Option.Title or "Title"
    local Text = Option.Text or "Description"
    local Duration = Option.Duration or 10
    getgenv().ThemeNotification = Theme.Header

    for i,v in pairs(game.CoreGui:GetChildren()) do
      if v.Name == "PortalNotify" then
        v:Destroy()
      end
    end

    local PortalNotify = Instance.new("ScreenGui")
    local NotificationFrame = Instance.new("Frame")
    local NotifyCorner = Instance.new("UICorner")
    local MainStroke = Instance.new("UIStroke")
    local NotificationTitle = Instance.new("TextLabel")
    local NotificationDesc = Instance.new("TextLabel") 

    PortalNotify.Name = "PortalNotify"
    PortalNotify.Parent = game.CoreGui
    
    NotificationFrame.Parent = PortalNotify
    NotificationFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    NotificationFrame.BackgroundTransparency = 1
    NotificationFrame.Position = UDim2.new(1, -25, 1, -25)
    NotificationFrame.AnchorPoint = Vector2.new(1, 1)
    NotificationFrame.Size = UDim2.new(0,280,0,100)
    NotificationFrame.AutomaticSize = Enum.AutomaticSize.Y
    NotificationFrame.Active = true
    NotificationFrame.BorderSizePixel = 2
    NotificationFrame.BorderColor3 = getgenv().ThemeNotification

    NotifyCorner.CornerRadius = UDim.new(0, 6)
    NotifyCorner.Parent = NotificationFrame

    MainStroke.Name = "MainStroke"
    MainStroke.Parent = NotificationFrame
    MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    MainStroke.Color = Theme.Header
    MainStroke.LineJoinMode = Enum.LineJoinMode.Round
    MainStroke.Thickness = 2
    MainStroke.Transparency = 0
    MainStroke.Enabled = true
    MainStroke.Archivable = true

    NotificationTitle.Parent = NotificationFrame
    NotificationTitle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    NotificationTitle.BorderSizePixel = 0
    NotificationTitle.BackgroundTransparency = 1
    NotificationTitle.TextTransparency = 1
    NotificationTitle.Position = UDim2.new(0,10.0,0,0)
    NotificationTitle.Size = UDim2.new(0.5,0,0.2)
    NotificationTitle.Font = Enum.Font.SourceSansBold
    NotificationTitle.Text = Title
    NotificationTitle.TextColor3 = Color3.fromRGB(255,255,255)
    NotificationTitle.TextScaled = true
    NotificationTitle.TextSize = 8
    NotificationTitle.TextWrapped = true
    NotificationTitle.TextXAlignment = Enum.TextXAlignment.Left

    NotificationDesc.Parent = NotificationFrame
    NotificationDesc.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    NotificationDesc.BorderSizePixel = 0
    NotificationDesc.BackgroundTransparency = 1
    NotificationDesc.TextTransparency = 1
    NotificationDesc.Position = UDim2.new(0.04,0,0.2,0)
    NotificationDesc.Size = UDim2.new(0,260,0,50)
    NotificationDesc.Font = Enum.Font.SourceSansBold
    NotificationDesc.Text = Text
    NotificationDesc.TextColor3 = Color3.fromRGB(255,255,255)
    NotificationDesc.TextSize = 16
    NotificationDesc.TextWrapped = true
    NotificationDesc.TextXAlignment = Enum.TextXAlignment.Left
    
    TweenService:Create(NotificationFrame, TweenInfo.new(.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play() 
    TweenService:Create(NotificationTitle, TweenInfo.new(.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play() 
    TweenService:Create(NotificationDesc, TweenInfo.new(.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play() 
    wait(Duration)
    TweenService:Create(NotificationFrame, TweenInfo.new(.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play() 
    TweenService:Create(NotificationTitle, TweenInfo.new(.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1}):Play() 
    TweenService:Create(NotificationDesc, TweenInfo.new(.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1}):Play() 
    wait(.7)
    PortalNotify:Destroy()
end

function Library:Window(Setting) 
    local Title = Setting.Name
    local Logo = Setting.Logo
    local UseRbxAsset = Setting.UseRbxAsset
    local UseTime = Setting.UseTime
    
    if Title == nil then
      Title = ""
    end

    if Title == "" then
      RaiderHub:Destroy()
      Library:Notification({
          Title = "Error",
          Text = "Please Insert Library Name!",
          Duration = 5
      })
    end

    if UseRbxAsset == true then
        UsedImages = "rbxassetid://"..tostring(Logo)
        TextPosition = UDim2.new(0, 32, 0.5, 0)
    else
        UsedImages = "rbxthumb://type=Asset&id="..tostring(Logo).."&w=150&h=150"
        TextPosition = UDim2.new(0, 32, 0.5, 0)
    end
    
    local RaiderHub = Instance.new("ScreenGui")
    local Main = Instance.new("Frame")
    local UICorner_9 = Instance.new("UICorner")
    local MainStroke = Instance.new("UIStroke")
    local tabs = Instance.new("Frame")
    local UICorner_2 = Instance.new("UICorner")
    local Cover = Instance.new("Frame")
    local TabsList = Instance.new("UIListLayout")
    local Top = Instance.new("Frame")
    local UICorner_5 = Instance.new("UICorner")
    local Cover_2 = Instance.new("Frame")
    local Line = Instance.new("Frame")
    local Logo = Instance.new("ImageLabel")
    local GameName = Instance.new("TextLabel")
    local Pages = Instance.new("Frame")
    local UICorner_2 = Instance.new("UICorner")
    local UICorner = Instance.new("UICorner")
    local TabsContainer = Instance.new("Frame")
    local TabsList = Instance.new("UIListLayout")
    local UIPadding = Instance.new("UIPadding")
    local tabs = Instance.new("Frame")
    local Cover = Instance.new("Frame")

    RaiderHub.Name = "RaiderHub"
    RaiderHub.Parent = game.CoreGui
    RaiderHub.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    Main.Name = "Main"
    Main.Parent = RaiderHub
    Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Main.BorderSizePixel = 0
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size = UDim2.new(0, 0, 0, 0)
    Main.ClipsDescendants = false
    Main:Visible = true

    Library:Dragging(Main, Main)

    UICorner_9.CornerRadius = UDim.new(0, 6)
    UICorner_9.Parent = Main

    MainStroke.Name = "MainStroke"
    MainStroke.Parent = Main
    MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    MainStroke.Color = Theme.Header
    MainStroke.LineJoinMode = Enum.LineJoinMode.Round
    MainStroke.Thickness = 2
    MainStroke.Transparency = 0
    MainStroke.Enabled = true
    MainStroke.Archivable = true

    tabs.Name = "tabs"
    tabs.Parent = Main
    tabs.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
    tabs.BorderSizePixel = 0
    tabs.Position = UDim2.new(0, 0, 0, 35)
    tabs.Size = UDim2.new(0, 122, 1, -35)

    UICorner_2.CornerRadius = UDim.new(0, 6)
    UICorner_2.Parent = tabs

    Cover.Name = "Cover"
    Cover.Parent = tabs
    Cover.AnchorPoint = Vector2.new(1, 0.5)
    Cover.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
    Cover.BorderSizePixel = 0
    Cover.Position = UDim2.new(1, 0, 0.5, 0)
    Cover.Size = UDim2.new(0, 5, 1, 0)
    
    UICorner_2.Parent = tabs

    Top.Name = "Top"
    Top.Parent = Main
    Top.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    Top.BorderSizePixel = 0
    Top.Size = UDim2.new(1, 0, 0, 34)

    UICorner_5.CornerRadius = UDim.new(0, 6)
    UICorner_5.Parent = Top

    Cover_2.Name = "Cover"
    Cover_2.Parent = Top
    Cover_2.AnchorPoint = Vector2.new(0.5, 1)
    Cover_2.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    Cover_2.BorderSizePixel = 0
    Cover_2.Position = UDim2.new(0.5, 0, 1, 0)
    Cover_2.Size = UDim2.new(1, 0, 0, 4)

    Line.Name = "Line"
    Line.Parent = Top
    Line.AnchorPoint = Vector2.new(0.5, 1)
    Line.BackgroundColor3 = Theme.Header
    Line.BackgroundTransparency = 1
    Line.Position = UDim2.new(0.5, 0, 1, 1)
    Line.Size = UDim2.new(1, 0, 0, 1)

    Logo.Name = "Logo"
    Logo.Parent = Top
    Logo.AnchorPoint = Vector2.new(0, 0.5)
    Logo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Logo.BackgroundTransparency = 1.000
    Logo.Position = UDim2.new(0, 4, 0.5, 0)
    Logo.Size = UDim2.new(0, 25, 0, 25)
    Logo.Image = UsedImages or ""
    Logo.ImageColor3 = Theme.Header
    
    GameName.Name = "GameName"
    GameName.Parent = Top 
    GameName.AnchorPoint = Vector2.new(0, 0.5)
    GameName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    GameName.BackgroundTransparency = 1.000
    GameName.Position = TextPosition or UDim2.new(0, 10, 0.5, 0) 
    GameName.Size = UDim2.new(0, 165, 0, 22)
    GameName.Font = Enum.Font.Gotham
    GameName.Text = Title
    GameName.TextColor3 = Theme.Text
    GameName.TextSize = 14.000
    GameName.TextXAlignment = Enum.TextXAlignment.Left

    Pages.Name = "Pages"
    Pages.Parent = Main
    Pages.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Pages.BorderSizePixel = 0
    Pages.Position = UDim2.new(0, 130, 0, 42)
    Pages.Size = UDim2.new(1, -138, 1, -50)
    
    tabs.Name = "tabs"
    tabs.Parent = Main
    tabs.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
    tabs.BorderSizePixel = 0
    tabs.Position = UDim2.new(0, 0, 0, 35)
    tabs.Size = UDim2.new(0, 122, 1, -35)
    
    TabsContainer.Name = "TabsContainer"
    TabsContainer.Parent = tabs
    TabsContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TabsContainer.BackgroundTransparency = 1.000
    TabsContainer.Size = UDim2.new(1, 0, 1, 0)
    
    TabsList.Name = "TabsList"
    TabsList.Parent = TabsContainer
    TabsList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabsList.SortOrder = Enum.SortOrder.LayoutOrder
    TabsList.Padding = UDim.new(0, 5)
    
    UIPadding.Parent = TabsContainer
    UIPadding.PaddingTop = UDim.new(0, 5)
    
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = tabs
    
    Cover.Name = "Cover"
    Cover.Parent = tabs
    Cover.AnchorPoint = Vector2.new(1, 0.5)
    Cover.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
    Cover.BorderSizePixel = 0
    Cover.Position = UDim2.new(1, 0, 0.5, 0)
    Cover.Size = UDim2.new(0, 5, 1, 0)
    
    Main:TweenSize(UDim2.new(0, 470, 0, 283), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, .2)

    local uitoggled = false
    UserInputService.InputBegan:Connect(
        function(io, p)
            if io.KeyCode == Enum.KeyCode.RightControl then
                if uitoggled == false then
                    Main.ClipsDescendants = true
                    Main:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .6, true)
                    wait(.5)
                    Main:Visible = false
                    uitoggled = true
                else
                    Main.ClipsDescendants = false
                    Main:TweenSize(
                        UDim2.new(0, 470, 0, 283),
                        Enum.EasingDirection.Out,
                        Enum.EasingStyle.Quart,
                        .6,
                        true
                    )
                    wait(.1)
                    Main:Visible = true
                    uitoggled = false
                end
            end
        end
    )

    if UseTime == true then
      local function TimeLabel(v)
          GameName.Text = tostring(Title).." | "..v
      end

      local function UpdateOS()
          local date = os.date("*t")
          local hour = (date.hour) % 24
          local ampm = hour < 12 and "AM" or "PM"
          local timezone = string.format("%02i:%02i:%02i %s", ((hour -1) % 12) + 1, date.min, date.sec, ampm)
          local datetime = string.format("%02d/%02d/%04d", date.day, date.month, date.year)
          TimeLabel(datetime.." | "..timezone)
      end

      spawn(function()
          while true do
              UpdateOS()
              game:GetService("RunService").RenderStepped:Wait()
          end
      end)
  end

    local Tabs = {}
    
    function Tabs:Tab(title)
        local UIListLayout = Instance.new('UIListLayout')
        local UIPadding = Instance.new("UIPadding")
        local Page = Instance.new("ScrollingFrame")
        local UICorner = Instance.new("UICorner")
        local TabButton = Instance.new("TextButton")
        
        TabButton.Name = "TabButton"
        TabButton.Parent = TabsContainer
        TabButton.BackgroundColor3 = Theme.Header
        TabButton.BackgroundTransparency = 1
        TabButton.Size = UDim2.new(1, -12, 0, 30)
        TabButton.AutoButtonColor = false
        TabButton.Font = Enum.Font.Gotham
        TabButton.Text = title
        TabButton.TextColor3 = Color3.fromRGB(72,72,72)
        TabButton.TextSize = 14.000
        
        UICorner.CornerRadius = UDim.new(0, 6)
        UICorner.Parent = TabButton
        
        Page.Name = "Page"
        Page.Visible = false
        Page.Parent = Pages
        Page.Active = true
        Page.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Page.BackgroundTransparency = 1.000
        Page.BorderSizePixel = 0
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.CanvasPosition = Vector2.new(0, 0)
        Page.ScrollBarThickness = 1
        Page.ScrollBarImageColor3 = Theme.Scroll
        
        UIListLayout.Parent = Page
        UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Padding = UDim.new(0, 5) 
        
        UIPadding.Parent = Page
        UIPadding.PaddingTop = UDim.new(0, 5)
        
        UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(0,0,0,UIListLayout.AbsoluteContentSize.Y + 1) 
        end)
        
        TabButton.MouseButton1Click:Connect(function()
            for _,v in next, Pages:GetChildren() do
                if v:IsA("ScrollingFrame") then
                    v.Visible = false
                end 
                Page.Visible = true
            end 
            for _,v in next, TabsContainer:GetChildren() do
                if v.Name == 'TabButton' then
                    TweenService:Create(v, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
                    TweenService:Create(v, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(72,72,72)}):Play()
                    TweenService:Create(TabButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.6}):Play()
                    TweenService:Create(TabButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
                end
            end
        end)

        local TabFunctions = {}
        
        function TabFunctions:Button(title, func)
            local lfunc = function() end
            local callback = func or lfunc

            local ButtonFunc = {}
            local Button = Instance.new("TextButton")
            local UICorner = Instance.new("UICorner")

            Button.Name = "Button"
            Button.Text = title
            Button.Parent = Page
            Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Button.BorderSizePixel = 0
            Button.Size = UDim2.new(1, -6, 0, 34)
            Button.AutoButtonColor = false
            Button.Font = Enum.Font.Gotham
            Button.TextColor3 = Theme.Text
            Button.TextSize = 14.000
            
            UICorner.CornerRadius = UDim.new(0, 6)
            UICorner.Parent = Button

            Button.MouseEnter:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextColor3 = Theme.Header}, true):Play()
            end)
    
            Button.MouseLeave:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextColor3 = Theme.Text}, true):Play()
            end)
            
            Button.MouseButton1Click:Connect(function()
                pcall(callback)
            end)

            function ButtonFunc:Refresh(v)
                Button.Text = v
            end
            return ButtonFunc
        end

        function TabFunctions:Toggle(name, value, func)
            local lfunc = function() end
            local callback = func or lfunc

            local Toggle = Instance.new("TextButton")
            local UICorner = Instance.new("UICorner")
            local Title = Instance.new("TextLabel")
            local Toggle_2 = Instance.new("Frame")
            local Stroke = Instance.new('UIStroke')
            local Checked = Instance.new("ImageLabel")
            local value = value or false

            Toggle.Name = "Toggle"
            Toggle.Parent = Page
            Toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Toggle.Size = UDim2.new(1, -6, 0, 34)
            Toggle.AutoButtonColor = false
            Toggle.Font = Enum.Font.SourceSans
            Toggle.Text = ""
            Toggle.TextColor3 = Color3.fromRGB(0, 0, 0)
            Toggle.TextSize = 14.000
            
            UICorner.CornerRadius = UDim.new(0, 6)
            UICorner.Parent = Toggle

            Title.Name = "Title"
            Title.Parent = Toggle
            Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Title.BackgroundTransparency = 1.000
            Title.Position = UDim2.new(0, 8, 0, 0)
            Title.Size = UDim2.new(1, -6, 1, 0)
            Title.Font = Enum.Font.Gotham
            Title.Text = name
            Title.TextColor3 = Theme.Text
            Title.TextSize = 14.000
            Title.TextXAlignment = Enum.TextXAlignment.Left
            
            Toggle_2.Name = "Toggle"
            Toggle_2.Parent = Toggle
            Toggle_2.AnchorPoint = Vector2.new(1, 0.5)
            Toggle_2.BackgroundColor3 = Theme.Header
            Toggle_2.BackgroundTransparency = 1.000
            Toggle_2.BorderSizePixel = 0
            Toggle_2.Position = UDim2.new(1, -8, 0.5, 0)
            Toggle_2.Size = UDim2.new(0, 15, 0, 15)
            
            Checked.Name = "Checked"
            Checked.Parent = Toggle_2
            Checked.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Checked.BackgroundTransparency = 1.000
            Checked.Position = UDim2.new(-0.214285731, 0, -0.214285731, 0)
            Checked.Size = UDim2.new(0, 20, 0, 20)
            Checked.Image = "http://www.roblox.com/asset/?id=7812909048"
            Checked.ImageTransparency = 1.000
            Checked.ImageColor3 = Theme.Header
            Checked.ScaleType = Enum.ScaleType.Fit
            
            Stroke.Parent = Toggle_2
            Stroke.LineJoinMode = Enum.LineJoinMode.Round
            Stroke.Thickness = 2
            Stroke.Color = Theme.Header

            local toggled = value
            if toggled then
            TweenService:Create(Checked, TweenInfo.new(.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{ImageTransparency = 0}, true):Play()
                pcall(callback, toggled)
            end
            
            Toggle.MouseButton1Click:Connect(function()
                if toggled then  
                    toggled = false 
                    --TweenService:Create(Toggle_2, TweenInfo.new(.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{BackgroundTransparency = 1}, true):Play()
                    TweenService:Create(Checked, TweenInfo.new(.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{ImageTransparency = 1}, true):Play()
                else
                    toggled = true
                    --TweenService:Create(Toggle_2, TweenInfo.new(.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{BackgroundTransparency = 0}, true):Play()
                    TweenService:Create(Checked, TweenInfo.new(.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{ImageTransparency = 0}, true):Play()
                end
                pcall(callback, toggled)
            end)
        end

        function TabFunctions:Slider(Name,Min,Max,func)
            local lfunc = function() end
            local Callback = func or lfunc
            
            local SliderFrame = Instance.new("Frame")
            local SliderFrameCorner = Instance.new("UICorner")
            local SliderButton = Instance.new("TextButton")
            local SliderButtonCorner = Instance.new("UICorner")
            local SliderTrail = Instance.new("Frame")
            local SliderTrailCorner = Instance.new("UICorner")
            local SliderName = Instance.new("TextLabel")
            local SliderNamePadding = Instance.new("UIPadding")
            local SliderValue = Instance.new("TextLabel")
            local SliderValuePadding = Instance.new("UIPadding")

            SliderFrame.Name = "SliderFrame"
            SliderFrame.Parent = Page
            SliderFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            SliderFrame.Size = UDim2.new(1, -6, 0, 34)

            SliderFrameCorner.Name = "SliderFrameCorner"
            SliderFrameCorner.Parent = SliderFrame

            local SliderButtonSized = 310
            SliderButton.Name = "SliderButton"
            SliderButton.Parent = SliderFrame
            SliderButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            SliderButton.BorderSizePixel = 0
            SliderButton.Position = UDim2.new(0.0242369417, 0, 0.639999986, 0)
            SliderButton.Size = UDim2.new(0, 310, 0, 10)
            SliderButton.Font = Enum.Font.SourceSans
            SliderButton.Text = ""
            SliderButton.TextColor3 = Theme.Header
            SliderButton.TextSize = 14.000

            SliderButtonCorner.Name = "SliderButtonCorner"
            SliderButtonCorner.Parent = SliderButton

            SliderTrail.Name = "SliderTrail"
            SliderTrail.Parent = SliderButton
            SliderTrail.BackgroundColor3 = Theme.Header
            SliderTrail.Size = UDim2.new(0, 0, 0, 10)
            SliderTrail.BorderSizePixel = 0

            SliderTrailCorner.Name = "SliderTrailCorner"
            SliderTrailCorner.Parent = SliderTrail

            SliderName.Name = "SliderName"
            SliderName.Parent = SliderFrame
            SliderName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SliderName.BackgroundTransparency = 1.000
            SliderName.BorderSizePixel = 0
            SliderName.Size = UDim2.new(1, -4, 0, 26)
            SliderName.Font = Enum.Font.Gotham
            SliderName.Text = Name
            SliderName.TextColor3 = Theme.Text
            SliderName.TextSize = 14.000
            SliderName.TextXAlignment = Enum.TextXAlignment.Left

            SliderNamePadding.Name = "SliderNamePadding"
            SliderNamePadding.Parent = SliderName
            SliderNamePadding.PaddingLeft = UDim.new(0, 10)

            SliderValue.Name = "SliderValue"
            SliderValue.Parent = SliderFrame
            SliderValue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SliderValue.BackgroundTransparency = 1.000
            SliderValue.BorderSizePixel = 0
            SliderValue.TextTransparency = 1.000
            SliderValue.Position = UDim2.new(0.752061796, 0, 0, 0)
            SliderValue.Size = UDim2.new(0, 80, 0, 26)
            SliderValue.Font = Enum.Font.Gotham
            SliderValue.Text = "..."
            SliderValue.TextColor3 = Theme.Text
            SliderValue.TextSize = 14.000
            SliderValue.TextXAlignment = Enum.TextXAlignment.Right

            SliderValuePadding.Name = "SliderValuePadding"
            SliderValuePadding.Parent = SliderValue
            SliderValuePadding.PaddingRight = UDim.new(0, 10)

            local ms = game.Players.LocalPlayer:GetMouse()
            local uis = game:GetService("UserInputService")
            local Value
            local mouse = game:GetService("Players").LocalPlayer:GetMouse();

            SliderButton.MouseButton1Down:Connect(function()
                game:GetService("TweenService"):Create(SliderValue, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
                    TextTransparency = 0
                }):Play()
                Value = math.floor((((tonumber(Max) - tonumber(Min)) / SliderButtonSized) * SliderTrail.AbsoluteSize.X) + tonumber(Min)) or 0
                pcall(function()
                    Callback(Value)
                end)
                SliderTrail:TweenSize(UDim2.new(0, math.clamp(mouse.X - SliderTrail.AbsolutePosition.X, 0, SliderButtonSized), 0, 10), "InOut", "Linear", 0.05, true)
                moveconnection = mouse.Move:Connect(function()
                    SliderValue.Text = Value
                    Value = math.floor((((tonumber(Max) - tonumber(Min)) / SliderButtonSized) * SliderTrail.AbsoluteSize.X) + tonumber(Min))
                    pcall(function()
                        Callback(Value)
                    end)
                    SliderTrail:TweenSize(UDim2.new(0, math.clamp(mouse.X - SliderTrail.AbsolutePosition.X, 0, SliderButtonSized), 0, 10), "InOut", "Linear", 0.05, true)
                end)
                releaseconnection = uis.InputEnded:Connect(function(Mouse)
                    if Mouse.UserInputType == Enum.UserInputType.MouseButton1 or Mouse.UserInputType == Enum.UserInputType.Touch then
                        Value = math.floor((((tonumber(Max) - tonumber(Min)) / SliderButtonSized) * SliderTrail.AbsoluteSize.X) + tonumber(Min))
                        pcall(function()
                            Callback(Value)
                        end)
                        SliderValue.Text = Value
                        game:GetService("TweenService"):Create(SliderValue, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
                            TextTransparency = 1
                        }):Play()
                        SliderTrail:TweenSize(UDim2.new(0, math.clamp(mouse.X - SliderTrail.AbsolutePosition.X, 0, SliderButtonSized), 0, 10), "InOut", "Linear", 0.05, true)
                        moveconnection:Disconnect()
                        releaseconnection:Disconnect()
                    end
                end)
            end)
        end

        function TabFunctions:Label(labeltext, color)
            local LabelFunc = {}
            local TextLabel = Instance.new("TextLabel")
            local UICorner_6 = Instance.new("UICorner")
            
            TextLabel.Parent = Page
            TextLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            TextLabel.BackgroundTransparency = 1.000
            TextLabel.BorderSizePixel = 0
            TextLabel.Size = UDim2.new(1, -6, 0, 34)
            TextLabel.Font = Enum.Font.Gotham
            TextLabel.Text = labeltext
            TextLabel.TextColor3 = color or Theme.Header
            TextLabel.TextSize = 14.000
            
            UICorner_6.CornerRadius = UDim.new(0, 6)
            UICorner_6.Parent = TextLabel

            function LabelFunc:Refresh(v)
                TextLabel.Text = v
            end
            return LabelFunc
        end

        function TabFunctions:Box(text, func)
            local lfunc = function() end
            local callback = func or lfunc
        
            local BoxFrame = Instance.new("TextButton")
            local UICorner_7 = Instance.new("UICorner")
            local Title = Instance.new("TextLabel")
            local CurrentBox = Instance.new("TextBox")
            local UICorner_8 = Instance.new("UICorner")

            BoxFrame.Name = "BoxFrame"
            BoxFrame.Parent = Page
            BoxFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            BoxFrame.Size = UDim2.new(1, -6, 0, 34)
            BoxFrame.AutoButtonColor = false
            BoxFrame.Font = Enum.Font.SourceSans
            BoxFrame.Text = ""
            BoxFrame.TextColor3 = Color3.fromRGB(0, 0, 0)
            BoxFrame.TextSize = 14.000
            
            UICorner_7.CornerRadius = UDim.new(0, 6)
            UICorner_7.Parent = BoxFrame

            Title.Name = "Title"
            Title.Parent = BoxFrame
            Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Title.BackgroundTransparency = 1.000
            Title.Position = UDim2.new(0, 8, 0, 0)
            Title.Size = UDim2.new(1, -6, 1, 0)
            Title.Font = Enum.Font.Gotham
            Title.Text = text
            Title.TextColor3 = Theme.Text
            Title.TextSize = 14.000
            Title.TextXAlignment = Enum.TextXAlignment.Left
            
            CurrentBox.Name = "CurrentBox"
            CurrentBox.Parent = BoxFrame
            CurrentBox.AnchorPoint = Vector2.new(1, 0.5)
            CurrentBox.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
            CurrentBox.Position = UDim2.new(1, -6, 0.5, 0)
            CurrentBox.Size = UDim2.new(-0, 46, 0, 24)
            CurrentBox.Font = Enum.Font.Gotham
            CurrentBox.Text = "Type Here"
            CurrentBox.TextColor3 = Theme.Text
            CurrentBox.TextSize = 14.000
            CurrentBox.TextScaled = true
            
            UICorner_8.CornerRadius = UDim.new(0, 4)
            UICorner_8.Parent = CurrentBox

            CurrentBox.FocusLost:Connect(function()
                pcall(callback, CurrentBox)
            end)
        end

        function TabFunctions:Bind(text, keypreset, func)
            local lfunc = function() end
            local callback = func or lfunc
        
            local binding = false
            local Key = keypreset.Name
            local KeyBind = Instance.new("TextButton")
            local UICorner_51 = Instance.new("UICorner")
            local Title = Instance.new("TextLabel")
            local CurrentKey = Instance.new("TextLabel")
            local UICorner_52 = Instance.new("UICorner")

            KeyBind.Name = "KeyBind"
            KeyBind.Parent = Page
            KeyBind.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            KeyBind.Size = UDim2.new(1, -6, 0, 34)
            KeyBind.AutoButtonColor = false
            KeyBind.Font = Enum.Font.SourceSans
            KeyBind.Text = ""
            KeyBind.TextColor3 = Color3.fromRGB(0, 0, 0)
            KeyBind.TextSize = 14.000
            
            UICorner_51.CornerRadius = UDim.new(0, 6)
            UICorner_51.Parent = KeyBind

            Title.Name = "Title"
            Title.Parent = KeyBind
            Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Title.BackgroundTransparency = 1.000
            Title.Position = UDim2.new(0, 8, 0, 0)
            Title.Size = UDim2.new(1, -6, 1, 0)
            Title.Font = Enum.Font.Gotham
            Title.Text = text
            Title.TextColor3 = Theme.Text
            Title.TextSize = 14.000
            Title.TextXAlignment = Enum.TextXAlignment.Left
            
            CurrentKey.Name = "CurrentKey"
            CurrentKey.Parent = KeyBind
            CurrentKey.AnchorPoint = Vector2.new(1, 0.5)
            CurrentKey.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
            CurrentKey.Position = UDim2.new(1, -6, 0.5, 0)
            CurrentKey.Size = UDim2.new(-0, 46, 0, 24)
            CurrentKey.Font = Enum.Font.Gotham
            CurrentKey.Text = Key
            CurrentKey.TextColor3 = Theme.Text
            CurrentKey.TextSize = 14.000
            
            UICorner_52.CornerRadius = UDim.new(0, 4)
            UICorner_52.Parent = CurrentKey

            KeyBind.MouseButton1Click:Connect(function()
            CurrentKey.Text = ". . .";
            
            local a, b = game:GetService('UserInputService').InputBegan:wait();
                if a.KeyCode.Name ~= "Unknown" then
                    CurrentKey.Text = a.KeyCode.Name
                    Key = a.KeyCode.Name;
                end
            end)
            
            game:GetService("UserInputService").InputBegan:connect(function(current, ok) 
                if not ok then 
                    if current.KeyCode.Name == Key then 
                        pcall(callback, key)
                    end
                end
            end)
        end

        function TabFunctions:Dropdown(title, list, func)
                local lfunc = function() end
                local callback = func or lfunc
                
                local DropdownFunc = {}
                local dropped = false
                local Dropdown = Instance.new("Frame")
                local UICorner723 = Instance.new("UICorner")
                local UIListLayout_69 = Instance.new("UIListLayout")
                local Choose = Instance.new("TextButton")
                local UICorner = Instance.new("UICorner")
                local Title = Instance.new("TextLabel")
                local arrow = Instance.new("ImageButton")
                local OptionHolder = Instance.new("Frame")
                local UICorner_2 = Instance.new("UICorner")
                local OptionList = Instance.new("UIListLayout")
                local UIPadding = Instance.new("UIPadding")

                Dropdown.Name = "Dropdown"
                Dropdown.Parent = Page
                Dropdown.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Dropdown.BackgroundTransparency = 1.000
                Dropdown.BorderColor3 = Color3.fromRGB(27, 42, 53)
                Dropdown.BorderSizePixel = 0
                Dropdown.ClipsDescendants = true
                Dropdown.Position = UDim2.new(0, 0, -0.296137333, 0)
                Dropdown.Size = UDim2.new(1, -6, 0, 34)

                UICorner723.CornerRadius = UDim.new(0, 6)
                UICorner723.Parent = Dropdown

                UIListLayout_69.Parent = Dropdown
                UIListLayout_69.HorizontalAlignment = Enum.HorizontalAlignment.Center
                UIListLayout_69.SortOrder = Enum.SortOrder.LayoutOrder
                UIListLayout_69.Padding = UDim.new(0, 5)

                Choose.Name = "Choose"
                Choose.Parent = Dropdown
                Choose.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                Choose.BorderSizePixel = 0
                Choose.Text = ""
                Choose.Size = UDim2.new(1, 0, 0, 34)
                Choose.AutoButtonColor = false

                UICorner.CornerRadius = UDim.new(0, 6)
                UICorner.Parent = Choose

                Title.Name = "Title"
                Title.Parent = Choose
                Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Title.BackgroundTransparency = 1.000
                Title.Position = UDim2.new(0, 8, 0, 0)
                Title.Size = UDim2.new(1, -6, 1, 0)
                Title.Font = Enum.Font.Gotham
                Title.Text = title or "Dropdowm"
                Title.TextColor3 = Theme.Text 
                Title.TextSize = 14.000
                Title.TextXAlignment = Enum.TextXAlignment.Left

                arrow.Name = "arrow"
                arrow.Parent = Choose
                arrow.AnchorPoint = Vector2.new(1, 0.5)
                arrow.BackgroundTransparency = 1.000
                arrow.LayoutOrder = 10
                arrow.Position = UDim2.new(1, -2, 0.5, 0)
                arrow.Size = UDim2.new(0, 28, 0, 28)
                arrow.ZIndex = 2
                arrow.Image = "rbxassetid://3926307971"
                arrow.ImageColor3 = Theme.Header
                arrow.ImageRectOffset = Vector2.new(324, 524)
                arrow.ImageRectSize = Vector2.new(36, 36)
                arrow.ScaleType = Enum.ScaleType.Crop

                OptionHolder.Name = "OptionHolder"
                OptionHolder.Parent = Dropdown
                OptionHolder.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                OptionHolder.BorderSizePixel = 0
                OptionHolder.Size = UDim2.new(1, 0, 1, -38)

                UICorner_2.CornerRadius = UDim.new(0, 6)
                UICorner_2.Parent = OptionHolder

                OptionList.Name = "OptionList"
                OptionList.Parent = OptionHolder
                OptionList.HorizontalAlignment = Enum.HorizontalAlignment.Center
                OptionList.SortOrder = Enum.SortOrder.LayoutOrder
                OptionList.Padding = UDim.new(0, 5)

                UIPadding.Parent = OptionHolder
                UIPadding.PaddingTop = UDim.new(0, 8)
                
                Choose.MouseButton1Click:Connect(function()
                        if not dropped then
                            Dropdown:TweenSize(UDim2.new(1, -6, 0, UIListLayout_69.AbsoluteContentSize.Y), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, .15, true)
                            TweenService:Create(arrow, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = 180}, true):Play()
			                dropped = true
                        else
                            TweenService:Create(arrow, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = 0}, true):Play()
                            Dropdown:TweenSize(UDim2.new(1, -6, 0, 34), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, .12)
                            dropped = false 
                        end
                end)
                
                for i,v in next, list do
                    local Option = Instance.new("TextButton")
                    local UICorner = Instance.new("UICorner")

                    Option.Name = "Option"
                    Option.Parent = OptionHolder
                    Option.BackgroundColor3 = Theme.DropHeader
                    Option.BorderSizePixel = 0
                    Option.Size = UDim2.new(1, -16, 0, 30)
                    Option.AutoButtonColor = false
                    Option.Font = Enum.Font.Gotham
                    Option.Text = v
                    Option.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Option.TextSize = 14.000

                    UICorner.CornerRadius = UDim.new(0, 6)
                    UICorner.Parent = Option

                    Option.MouseButton1Click:Connect(function()
                        pcall(callback, v)
                        dropped = false
                        TweenService:Create(arrow, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{Rotation = 0}):Play()
                        Dropdown:TweenSize(UDim2.new(1, -6, 0, 34), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .15, true)
                        Title.Text = title.." : "..v
                    end)
                    OptionHolder:TweenSize(UDim2.new(1, 0, 0, OptionList.AbsoluteContentSize.Y + 15), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .15, true)
            end

            function DropdownFunc:Clear(v)
                    for _,v  in next, OptionHolder:GetChildren() do
                      if v:IsA("TextButton") then
                        v:Destroy()
                      end
                    end
                    --TweenService:Create(Title, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextColor3 = Theme.Header}, true):Play()
                    Dropdown:TweenSize(UDim2.new(1, -6, 0, 34), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, .2)
                    OptionHolder:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, .2)
                    wait(.2)
                    --TweenService:Create(Title, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextColor3 = Theme.Text}, true):Play()
                    dropped = false
            end

            function DropdownFunc:Add(v)
                    local Option = Instance.new("TextButton")
                    local UICorner = Instance.new("UICorner")

                    Option.Name = "Option"
                    Option.Parent = OptionHolder
                    Option.BackgroundColor3 = Theme.DropHeader
                    Option.BorderSizePixel = 0
                    Option.Size = UDim2.new(1, -16, 0, 30)
                    Option.AutoButtonColor = false
                    Option.Font = Enum.Font.Gotham
                    Option.Text = v
                    Option.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Option.TextSize = 14.000

                    UICorner.CornerRadius = UDim.new(0, 6)
                    UICorner.Parent = Option

                    Option.MouseButton1Click:Connect(function()
                        pcall(callback, v)
                        dropped = false
                        TweenService:Create(arrow, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{Rotation = 0}):Play()
                        Dropdown:TweenSize(UDim2.new(1, -6,0, 34), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .15, true)
                        Title.Text = title.." : "..v
                    end)
                    OptionHolder:TweenSize(UDim2.new(1, 0, 0, OptionList.AbsoluteContentSize.Y + 15), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .15, true)
            end
            return DropdownFunc
        end
        return TabFunctions
    end
    return Tabs
end
return Library 
