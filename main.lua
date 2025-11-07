--// Fly GUI Script by Xzonee_001 (Optimized + Modern)
--// Fixed GUI Loading Issue + Optimized Performance

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

local flying = false
local anticlip = false
local speed = 10
local ctrl = {f=0,b=0,l=0,r=0,u=0,d=0}
local bg, bv, flyConn

-- Simple Color Scheme (Optimized)
local COLORS = {
    background = Color3.fromRGB(15, 20, 30),
    primary = Color3.fromRGB(70, 130, 230),
    secondary = Color3.fromRGB(40, 55, 80),
    success = Color3.fromRGB(85, 170, 85),
    danger = Color3.fromRGB(220, 80, 80),
    text = Color3.fromRGB(240, 245, 255)
}

-- Wait for PlayerGui to avoid loading issues
if not player:FindFirstChild("PlayerGui") then
    player.CharacterAdded:Wait()
end

-- Create GUI (Single Batch)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlyGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Container
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 200)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = COLORS.background
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Smooth Corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Border
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = COLORS.primary
UIStroke.Thickness = 2
UIStroke.Transparency = 0.3
UIStroke.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 32)
Header.BackgroundTransparency = 1
Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🚀 FLY CONTROL"
Title.TextColor3 = COLORS.text
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamSemibold
Title.TextSize = 13
Title.Parent = Header

-- Control Buttons
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 20, 0, 20)
MinBtn.Position = UDim2.new(1, -45, 0.5, -10)
MinBtn.Text = "_"
MinBtn.TextColor3 = COLORS.text
MinBtn.BackgroundColor3 = COLORS.secondary
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 12
MinBtn.AutoButtonColor = false
MinBtn.Parent = Header

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 4)
MinCorner.Parent = MinBtn

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.Position = UDim2.new(1, -20, 0.5, -10)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = COLORS.text
CloseBtn.BackgroundColor3 = COLORS.danger
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 4)
CloseCorner.Parent = CloseBtn

-- Header Divider
local HeaderDivider = Instance.new("Frame")
HeaderDivider.Size = UDim2.new(1, -20, 0, 1)
HeaderDivider.Position = UDim2.new(0, 10, 1, -1)
HeaderDivider.BackgroundColor3 = COLORS.primary
HeaderDivider.BackgroundTransparency = 0.6
HeaderDivider.BorderSizePixel = 0
HeaderDivider.Parent = Header

-- Content Area
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -20, 1, -45)
Content.Position = UDim2.new(0, 10, 0, 38)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
UIListLayout.Parent = Content

-- Optimized Button Creation Function
local function createButton(text, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 160, 0, 30)
    btn.BackgroundColor3 = color or COLORS.secondary
    btn.Text = text
    btn.TextColor3 = COLORS.text
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 11
    btn.AutoButtonColor = false
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = COLORS.primary
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    stroke.Parent = btn
    
    -- Simple Hover Effect (Optimized)
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(
            math.min(255, math.floor(btn.BackgroundColor3.R * 255 * 1.2)),
            math.min(255, math.floor(btn.BackgroundColor3.G * 255 * 1.2)),
            math.min(255, math.floor(btn.BackgroundColor3.B * 255 * 1.2))
        )
    end)
    
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = color or COLORS.secondary
    end)
    
    return btn
end

-- Create Control Buttons
local FlyToggle = createButton("✈️ FLY: OFF")
FlyToggle.Parent = Content

local ClipToggle = createButton("🛡️ ANTICLIP: OFF")
ClipToggle.Parent = Content

local SpeedSlider = createButton("⚡ SPEED: " .. speed, Color3.fromRGB(45, 65, 95))
SpeedSlider.Parent = Content

-- Speed Info
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(0, 160, 0, 15)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Click to cycle speed (5 → 50)"
SpeedLabel.TextColor3 = Color3.fromRGB(180, 190, 210)
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Center
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.TextSize = 9
SpeedLabel.Parent = Content

-- Mini Bubble
local MiniBubble = Instance.new("TextButton")
MiniBubble.Size = UDim2.new(0, 40, 0, 40)
MiniBubble.Position = UDim2.new(0.02, 0, 0.2, 0)
MiniBubble.Text = "🚀"
MiniBubble.TextColor3 = COLORS.text
MiniBubble.BackgroundColor3 = COLORS.background
MiniBubble.BorderSizePixel = 0
MiniBubble.Font = Enum.Font.GothamBold
MiniBubble.TextSize = 16
MiniBubble.Visible = false
MiniBubble.AutoButtonColor = false
MiniBubble.Parent = ScreenGui

local BubbleCorner = Instance.new("UICorner")
BubbleCorner.CornerRadius = UDim.new(0, 8)
BubbleCorner.Parent = MiniBubble

local BubbleStroke = Instance.new("UIStroke")
BubbleStroke.Color = COLORS.primary
BubbleStroke.Thickness = 2
BubbleStroke.Transparency = 0.3
BubbleStroke.Parent = MiniBubble

MiniBubble.Active = true
MiniBubble.Draggable = true

-- Fly Functions (Optimized - No Changes)
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
    if flyConn then 
        flyConn:Disconnect() 
        flyConn = nil 
    end
    if bg then 
        bg:Destroy() 
        bg = nil 
    end
    if bv then 
        bv:Destroy() 
        bv = nil 
    end
end

-- Control Handlers (Optimized)
FlyToggle.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        FlyToggle.Text = "✈️ FLY: ON"
        FlyToggle.BackgroundColor3 = COLORS.success
        startFly()
    else
        FlyToggle.Text = "✈️ FLY: OFF"
        FlyToggle.BackgroundColor3 = COLORS.secondary
        stopFly()
    end
end)

ClipToggle.MouseButton1Click:Connect(function()
    anticlip = not anticlip
    if anticlip then
        ClipToggle.Text = "🛡️ ANTICLIP: ON"
        ClipToggle.BackgroundColor3 = COLORS.success
    else
        ClipToggle.Text = "🛡️ ANTICLIP: OFF"
        ClipToggle.BackgroundColor3 = COLORS.secondary
    end
end)

SpeedSlider.MouseButton1Click:Connect(function()
    speed = speed + 5
    if speed > 50 then 
        speed = 5 
    end
    SpeedSlider.Text = "⚡ SPEED: " .. tostring(speed)
end)

-- Window Controls
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

MinBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MiniBubble.Visible = true
end)

MiniBubble.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MiniBubble.Visible = false
end)

-- Control Button Hover Effects
MinBtn.MouseEnter:Connect(function()
    MinBtn.BackgroundColor3 = Color3.fromRGB(50, 70, 100)
end)

MinBtn.MouseLeave:Connect(function()
    MinBtn.BackgroundColor3 = COLORS.secondary
end)

CloseBtn.MouseEnter:Connect(function()
    CloseBtn.BackgroundColor3 = Color3.fromRGB(240, 80, 80)
end)

CloseBtn.MouseLeave:Connect(function()
    CloseBtn.BackgroundColor3 = COLORS.danger
end)

-- Controls (No Changes)
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.W then ctrl.f = 1 end
    if input.KeyCode == Enum.KeyCode.S then ctrl.b = 1 end
    if input.KeyCode == Enum.KeyCode.A then ctrl.l = -1 end
    if input.KeyCode == Enum.KeyCode.D then ctrl.r = 1 end
    if input.KeyCode == Enum.KeyCode.Space then ctrl.u = 1 end
    if input.KeyCode == Enum.KeyCode.LeftShift then ctrl.d = -1 end
end)

UserInputService.InputEnded:Connect(function(input, gp)
    if input.KeyCode == Enum.KeyCode.W then ctrl.f = 0 end
    if input.KeyCode == Enum.KeyCode.S then ctrl.b = 0 end
    if input.KeyCode == Enum.KeyCode.A then ctrl.l = 0 end
    if input.KeyCode == Enum.KeyCode.D then ctrl.r = 0 end
    if input.KeyCode == Enum.KeyCode.Space then ctrl.u = 0 end
    if input.KeyCode == Enum.KeyCode.LeftShift then ctrl.d = 0 end
end)

-- AntiClip System (Optimized)
local steppedConn
steppedConn = RunService.Stepped:Connect(function()
    if anticlip then
        -- Optimized: Only run when anticlip is active
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

-- Cleanup when GUI is destroyed
ScreenGui.Destroying:Connect(function()
    if steppedConn then
        steppedConn:Disconnect()
    end
    if flying then
        stopFly()
    end
end)

-- Force GUI to load properly (Safety Check)
task.spawn(function()
    wait(0.1) -- Small delay to ensure everything loads
    if MainFrame then
        MainFrame.Visible = true
    end
end)
