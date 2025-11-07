--// Fly GUI Script by Xzonee_001 (Modern Redesign)
--// Enhanced with modern, dynamic UI design

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

local flying = false
local anticlip = false
local speed = 10
local ctrl = {f=0,b=0,l=0,r=0,u=0,d=0}
local bg, bv, flyConn

-- Color Scheme
local COLORS = {
    background = Color3.fromRGB(15, 20, 30),
    primary = Color3.fromRGB(70, 130, 230),
    secondary = Color3.fromRGB(40, 55, 80),
    accent = Color3.fromRGB(100, 180, 255),
    success = Color3.fromRGB(85, 170, 85),
    danger = Color3.fromRGB(220, 80, 80),
    text = Color3.fromRGB(240, 245, 255)
}

-- Modern GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlyGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Container with Glass Morphism Effect
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 280, 0, 220)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = COLORS.background
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Glass Effect
local GlassFrame = Instance.new("Frame")
GlassFrame.Size = UDim2.new(1, 0, 1, 0)
GlassFrame.BackgroundTransparency = 0.95
GlassFrame.BackgroundColor3 = Color3.new(1, 1, 1)
GlassFrame.BorderSizePixel = 0
GlassFrame.Parent = MainFrame

-- Modern Border with Gradient
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = ColorSequence.new(COLORS.primary)
UIStroke.Thickness = 2
UIStroke.Transparency = 0.2
UIStroke.Parent = MainFrame

-- Smooth Corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 14)
UICorner.Parent = MainFrame

-- Background Gradient
local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 25, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 35, 55))
})
UIGradient.Rotation = 120
UIGradient.Parent = MainFrame

-- Header with Modern Design
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 36)
Header.BackgroundTransparency = 1
Header.Parent = MainFrame

local HeaderDivider = Instance.new("Frame")
HeaderDivider.Size = UDim2.new(1, -20, 0, 1)
HeaderDivider.Position = UDim2.new(0, 10, 1, -1)
HeaderDivider.BackgroundColor3 = COLORS.primary
HeaderDivider.BackgroundTransparency = 0.7
HeaderDivider.BorderSizePixel = 0
HeaderDivider.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🚀 FLY CONTROL PANEL"
Title.TextColor3 = COLORS.text
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamSemibold
Title.TextSize = 14
Title.Parent = Header

-- Control Buttons Container
local ControlButtons = Instance.new("Frame")
ControlButtons.Size = UDim2.new(0, 60, 1, 0)
ControlButtons.Position = UDim2.new(1, -65, 0, 0)
ControlButtons.BackgroundTransparency = 1
ControlButtons.Parent = Header

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 22, 0, 22)
MinBtn.Position = UDim2.new(0, 0, 0.5, -11)
MinBtn.Text = "−"
MinBtn.TextColor3 = COLORS.text
MinBtn.BackgroundColor3 = COLORS.secondary
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 14
MinBtn.AutoButtonColor = false
MinBtn.Parent = ControlButtons

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinBtn

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 22, 0, 22)
CloseBtn.Position = UDim2.new(0, 28, 0.5, -11)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = COLORS.text
CloseBtn.BackgroundColor3 = COLORS.danger
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = ControlButtons

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

-- Content Area
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -20, 1, -50)
Content.Position = UDim2.new(0, 10, 0, 40)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
UIListLayout.Parent = Content

-- Enhanced Button Factory with Hover Effects
local function createModernButton(text, color)
    local btnContainer = Instance.new("Frame")
    btnContainer.Size = UDim2.new(0, 180, 0, 32)
    btnContainer.BackgroundTransparency = 1
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundColor3 = color or COLORS.secondary
    btn.Text = text
    btn.TextColor3 = COLORS.text
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 12
    btn.AutoButtonColor = false
    btn.Parent = btnContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = COLORS.primary
    stroke.Thickness = 1
    stroke.Transparency = 0.8
    stroke.Parent = btn
    
    -- Hover Effects
    local hoverTweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    btn.MouseEnter:Connect(function()
        local tween = TweenService:Create(btn, hoverTweenInfo, {
            BackgroundColor3 = Color3.fromRGB(
                math.floor(btn.BackgroundColor3.R * 255 * 1.2),
                math.floor(btn.BackgroundColor3.G * 255 * 1.2),
                math.floor(btn.BackgroundColor3.B * 255 * 1.2)
            ),
            BackgroundTransparency = 0
        })
        tween:Play()
    end)
    
    btn.MouseLeave:Connect(function()
        local tween = TweenService:Create(btn, hoverTweenInfo, {
            BackgroundColor3 = color or COLORS.secondary,
            BackgroundTransparency = 0
        })
        tween:Play()
    end)
    
    btn.MouseButton1Down:Connect(function()
        local tween = TweenService:Create(btn, TweenInfo.new(0.1), {
            BackgroundTransparency = 0.3
        })
        tween:Play()
    end)
    
    btn.MouseButton1Up:Connect(function()
        local tween = TweenService:Create(btn, TweenInfo.new(0.1), {
            BackgroundTransparency = 0
        })
        tween:Play()
    end)
    
    return btnContainer, btn
end

-- Create Control Buttons
local FlyToggleContainer, FlyToggle = createModernButton("✈️ FLY: OFF", COLORS.secondary)
FlyToggleContainer.Parent = Content

local ClipToggleContainer, ClipToggle = createModernButton("🛡️ ANTICLIP: OFF", COLORS.secondary)
ClipToggleContainer.Parent = Content

local SpeedContainer, SpeedSlider = createModernButton("⚡ SPEED: " .. speed, Color3.fromRGB(45, 65, 95))
SpeedContainer.Parent = Content

-- Speed Info Label
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(0, 200, 0, 16)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Click to cycle speed (5 → 50)"
SpeedLabel.TextColor3 = Color3.fromRGB(180, 190, 210)
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Center
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.TextSize = 10
SpeedLabel.Parent = Content

-- Status Indicator
local StatusFrame = Instance.new("Frame")
StatusFrame.Size = UDim2.new(0, 160, 0, 20)
StatusFrame.BackgroundTransparency = 1
StatusFrame.Parent = Content

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 1, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Ready"
StatusLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
StatusLabel.TextXAlignment = Enum.TextXAlignment.Center
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 11
StatusLabel.Parent = StatusFrame

-- Mini Floating Bubble
local MiniBubble = Instance.new("TextButton")
MiniBubble.Size = UDim2.new(0, 42, 0, 42)
MiniBubble.Position = UDim2.new(0.02, 0, 0.2, 0)
MiniBubble.Text = "🚀"
MiniBubble.TextColor3 = COLORS.text
MiniBubble.BackgroundColor3 = COLORS.background
MiniBubble.BackgroundTransparency = 0.1
MiniBubble.Font = Enum.Font.GothamBold
MiniBubble.TextSize = 16
MiniBubble.Visible = false
MiniBubble.AutoButtonColor = false
MiniBubble.Parent = ScreenGui

local BubbleCorner = Instance.new("UICorner")
BubbleCorner.CornerRadius = UDim.new(0, 12)
BubbleCorner.Parent = MiniBubble

local BubbleStroke = Instance.new("UIStroke")
BubbleStroke.Color = COLORS.primary
BubbleStroke.Thickness = 2
BubbleStroke.Transparency = 0.3
BubbleStroke.Parent = MiniBubble

local BubbleGradient = Instance.new("UIGradient")
BubbleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 35, 55)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 50, 75))
})
BubbleGradient.Parent = MiniBubble

MiniBubble.Active = true
MiniBubble.Draggable = true

-- Fly Functions (Unchanged)
local function startFly()
    local humanoid = char:WaitForChild("Humanoid")
    humanoid:ChangeState(Enum.HumanoidStateType.Physics)

    bg = Instance.new("BodyGyro", hrp)
    bg.P = 9e4
    bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bg.CFrame = hrp.CFrame

    bv = Instance.new("BodyVelocity", hrp)
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bv.Velocity = Vector3.zero

    flyConn = RunService.RenderStepped:Connect(function()
        if flying then
            bg.CFrame = workspace.CurrentCamera.CFrame
            local moveDir = Vector3.new(ctrl.l+ctrl.r, ctrl.u+ctrl.d, -(ctrl.f-ctrl.b))
            if moveDir.Magnitude > 0 then
                moveDir = (workspace.CurrentCamera.CFrame:VectorToWorldSpace(moveDir)).Unit * speed * 5
            else
                moveDir = Vector3.zero
            end
            bv.Velocity = bv.Velocity:Lerp(moveDir, 0.25)
        else
            bv.Velocity = Vector3.zero
        end
    end)
end

local function stopFly()
    if flyConn then flyConn:Disconnect() flyConn=nil end
    if bg then bg:Destroy() bg=nil end
    if bv then bv:Destroy() bv=nil end
end

-- Enhanced Control Handlers with Visual Feedback
FlyToggle.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        FlyToggle.Text = "✈️ FLY: ON"
        FlyToggle.BackgroundColor3 = COLORS.success
        StatusLabel.Text = "Status: Flying Active"
        startFly()
    else
        FlyToggle.Text = "✈️ FLY: OFF"
        FlyToggle.BackgroundColor3 = COLORS.secondary
        StatusLabel.Text = "Status: Flying Disabled"
        stopFly()
    end
end)

ClipToggle.MouseButton1Click:Connect(function()
    anticlip = not anticlip
    if anticlip then
        ClipToggle.Text = "🛡️ ANTICLIP: ON"
        ClipToggle.BackgroundColor3 = COLORS.success
        StatusLabel.Text = "Status: AntiClip Active"
    else
        ClipToggle.Text = "🛡️ ANTICLIP: OFF"
        ClipToggle.BackgroundColor3 = COLORS.secondary
        StatusLabel.Text = "Status: AntiClip Disabled"
    end
end)

SpeedSlider.MouseButton1Click:Connect(function()
    speed = speed + 5
    if speed > 50 then speed = 5 end
    SpeedSlider.Text = "⚡ SPEED: " .. tostring(speed)
    StatusLabel.Text = "Speed set to: " .. tostring(speed)
end)

-- Enhanced Button Interactions
MinBtn.MouseButton1Click:Connect(function()
    local tween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Position = UDim2.new(0.5, 0, -0.5, 0)
    })
    tween:Play()
    tween.Completed:Connect(function()
        MainFrame.Visible = false
        MiniBubble.Visible = true
    end)
end)

CloseBtn.MouseButton1Click:Connect(function()
    local tween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    })
    tween:Play()
    tween.Completed:Connect(function()
        ScreenGui:Destroy()
    end)
end)

MiniBubble.MouseButton1Click:Connect(function()
    MiniBubble.Visible = false
    MainFrame.Visible = true
    MainFrame.Position = UDim2.new(0.5, 0, -0.5, 0)
    local tween = TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, 0, 0.5, 0)
    })
    tween:Play()
end)

-- Button Hover Effects for Control Buttons
local function setupControlButtonHover(button, defaultColor)
    button.MouseEnter:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(
                math.floor(defaultColor.R * 255 * 1.3),
                math.floor(defaultColor.G * 255 * 1.3),
                math.floor(defaultColor.B * 255 * 1.3)
            )
        })
        tween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = defaultColor
        })
        tween:Play()
    end)
end

setupControlButtonHover(MinBtn, COLORS.secondary)
setupControlButtonHover(CloseBtn, COLORS.danger)

-- Controls (Unchanged)
UserInputService.InputBegan:Connect(function(input,gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.W then ctrl.f=1 end
    if input.KeyCode == Enum.KeyCode.S then ctrl.b=1 end
    if input.KeyCode == Enum.KeyCode.A then ctrl.l=-1 end
    if input.KeyCode == Enum.KeyCode.D then ctrl.r=1 end
    if input.KeyCode == Enum.KeyCode.Space then ctrl.u=1 end
    if input.KeyCode == Enum.KeyCode.LeftShift then ctrl.d=-1 end
end)

UserInputService.InputEnded:Connect(function(input,gp)
    if input.KeyCode == Enum.KeyCode.W then ctrl.f=0 end
    if input.KeyCode == Enum.KeyCode.S then ctrl.b=0 end
    if input.KeyCode == Enum.KeyCode.A then ctrl.l=0 end
    if input.KeyCode == Enum.KeyCode.D then ctrl.r=0 end
    if input.KeyCode == Enum.KeyCode.Space then ctrl.u=0 end
    if input.KeyCode == Enum.KeyCode.LeftShift then ctrl.d=0 end
end)

-- AntiClip System (Unchanged)
RunService.Stepped:Connect(function()
    if anticlip then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

-- Initial Animation
MainFrame.Position = UDim2.new(0.5, 0, -0.5, 0)
local introTween = TweenService:Create(MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Position = UDim2.new(0.5, 0, 0.5, 0)
})
introTween:Play()
