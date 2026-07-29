-- ============================================
-- [ Speed GUI - Lrt.lua ]
-- ============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- تحديد مكان الحاوية المضمون للظهور
local TargetParent = LocalPlayer:WaitForChild("PlayerGui")

-- إزالة أي واجهة قديمة
if TargetParent:FindFirstChild("VVOV_SpeedGUI") then
    TargetParent.VVOV_SpeedGUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VVOV_SpeedGUI"
ScreenGui.Parent = TargetParent
ScreenGui.ResetOnSpawn = false

-- الإطار الرئيسي (برتقالي زي الصورة)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 180, 0, 110)
MainFrame.Position = UDim2.new(0.5, -90, 0.4, 0) -- المنتصف تماماً لضمان رؤيتها
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.Active = true
MainFrame.Draggable = true

-- زر الإغلاق X
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Parent = MainFrame
CloseBtn.Size = UDim2.new(0, 22, 0, 22)
CloseBtn.Position = UDim2.new(1, -24, 0, 2)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 14
CloseBtn.BorderSizePixel = 1

-- زر التصغير -
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Parent = MainFrame
MinimizeBtn.Size = UDim2.new(0, 22, 0, 22)
MinimizeBtn.Position = UDim2.new(1, -48, 0, 2)
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MinimizeBtn.Font = Enum.Font.SourceSansBold
MinimizeBtn.TextSize = 14
MinimizeBtn.BorderSizePixel = 1

-- مربع إدخال السرعة (أبيض)
local SpeedTextBox = Instance.new("TextBox")
SpeedTextBox.Name = "SpeedTextBox"
SpeedTextBox.Parent = MainFrame
SpeedTextBox.Size = UDim2.new(0, 160, 0, 35)
SpeedTextBox.Position = UDim2.new(0, 10, 0, 28)
SpeedTextBox.Text = "1000"
SpeedTextBox.PlaceholderText = "السرعة..."
SpeedTextBox.TextColor3 = Color3.fromRGB(0, 0, 0)
SpeedTextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SpeedTextBox.Font = Enum.Font.SourceSans
SpeedTextBox.TextSize = 20
SpeedTextBox.BorderSizePixel = 1

-- زر تطبيق السرعة (أخضر Set Speed)
local SetSpeedBtn = Instance.new("TextButton")
SetSpeedBtn.Name = "SetSpeedBtn"
SetSpeedBtn.Parent = MainFrame
SetSpeedBtn.Size = UDim2.new(0, 160, 0, 35)
SetSpeedBtn.Position = UDim2.new(0, 10, 0, 68)
SetSpeedBtn.Text = "Set Speed"
SetSpeedBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
SetSpeedBtn.BackgroundColor3 = Color3.fromRGB(0, 230, 0)
SetSpeedBtn.Font = Enum.Font.SourceSansBold
SetSpeedBtn.TextSize = 22
SetSpeedBtn.BorderSizePixel = 1

local SpeedValue = 16
local SpeedActive = false

SetSpeedBtn.MouseButton1Click:Connect(function()
    local val = tonumber(SpeedTextBox.Text)
    if val then
        SpeedValue = val
        SpeedActive = (val > 16)
    end
end)

-- محرك تغيير السرعة
RunService.RenderStepped:Connect(function()
    if SpeedActive then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hum and hrp then
                hum.WalkSpeed = SpeedValue
                if hum.MoveDirection.Magnitude > 0 then
                    hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (SpeedValue / 100))
                end
            end
        end
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    SpeedActive = false
    ScreenGui:Destroy()
end)

local IsMinimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    IsMinimized = not IsMinimized
    if IsMinimized then
        SpeedTextBox.Visible = false
        SetSpeedBtn.Visible = false
        MainFrame.Size = UDim2.new(0, 180, 0, 26)
        MinimizeBtn.Text = "+"
    else
        SpeedTextBox.Visible = true
        SetSpeedBtn.Visible = true
        MainFrame.Size = UDim2.new(0, 180, 0, 110)
        MinimizeBtn.Text = "-"
    end
end)
