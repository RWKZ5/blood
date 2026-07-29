-- ============================================
-- [ Speed GUI Script - Ryi.lua ]
-- ============================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

local TargetParent = (gethui and gethui()) or CoreGui or LocalPlayer:WaitForChild("PlayerGui")

-- إزالة الواجهة القديمة إن وجدت
if TargetParent:FindFirstChild("VVOV_SpeedGUI") then
    TargetParent.VVOV_SpeedGUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VVOV_SpeedGUI"
ScreenGui.Parent = TargetParent
ScreenGui.ResetOnSpawn = false

-- الإطار الرئيسي (برتقالي مثل الصورة)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 180, 0, 110)
MainFrame.Position = UDim2.new(0.7, 0, 0.6, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 170, 0) -- برتقالي
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.Active = true
MainFrame.Draggable = true

-- زر الإغلاق (X)
local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 22, 0, 22)
CloseBtn.Position = UDim2.new(1, -24, 0, 2)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 14
CloseBtn.BorderSizePixel = 1

-- زر التصغير (-)
local MinimizeBtn = Instance.new("TextButton", MainFrame)
MinimizeBtn.Size = UDim2.new(0, 22, 0, 22)
MinimizeBtn.Position = UDim2.new(1, -48, 0, 2)
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MinimizeBtn.Font = Enum.Font.SourceSansBold
MinimizeBtn.TextSize = 14
MinimizeBtn.BorderSizePixel = 1

-- مربع إدخال السرعة (أبيض)
local SpeedTextBox = Instance.new("TextBox", MainFrame)
SpeedTextBox.Size = UDim2.new(0, 160, 0, 35)
SpeedTextBox.Position = UDim2.new(0, 10, 0, 28)
SpeedTextBox.Text = "1000"
SpeedTextBox.PlaceholderText = "أدخل السرعة..."
SpeedTextBox.TextColor3 = Color3.fromRGB(0, 0, 0)
SpeedTextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SpeedTextBox.Font = Enum.Font.SourceSans
SpeedTextBox.TextSize = 20
SpeedTextBox.BorderSizePixel = 1

-- زر تطبيق السرعة (أخضر Set Speed)
local SetSpeedBtn = Instance.new("TextButton", MainFrame)
SetSpeedBtn.Size = UDim2.new(0, 160, 0, 35)
SetSpeedBtn.Position = UDim2.new(0, 10, 0, 68)
SetSpeedBtn.Text = "Set Speed"
SetSpeedBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
SetSpeedBtn.BackgroundColor3 = Color3.fromRGB(0, 230, 0) -- أخضر
SetSpeedBtn.Font = Enum.Font.SourceSansBold
SetSpeedBtn.TextSize = 22
SetSpeedBtn.BorderSizePixel = 1

-- متغير حفظ السرعة المحددة
local SelectedSpeed = 16

-- وظيفة تغيير السرعة
local function ApplySpeed()
    local val = tonumber(SpeedTextBox.Text)
    if val then
        SelectedSpeed = val
        local char = LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char:FindFirstChildOfClass("Humanoid").WalkSpeed = SelectedSpeed
        end
    end
end

-- تطبيق السرعة عند الضغط على الزر
SetSpeedBtn.MouseButton1Click:Connect(ApplySpeed)

-- الحفاظ على السرعة بشكل مستمر وعند إعادة الترسيبن (Respawn)
task.spawn(function()
    while task.wait(0.2) do
        local char = LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if SelectedSpeed ~= 16 and hum.WalkSpeed ~= SelectedSpeed then
                hum.WalkSpeed = SelectedSpeed
            end
        end
    end
end)

-- برمجة زر الإغلاق X
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- برمجة زر التصغير -
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
