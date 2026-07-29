-- ============================================
-- [ VVOV Instant Teleport Farm v3.0 ]
-- ============================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

local TargetParent = (gethui and gethui()) or CoreGui or LocalPlayer:WaitForChild("PlayerGui")

if TargetParent:FindFirstChild("VVOV_InstantFarmGUI") then
    TargetParent.VVOV_InstantFarmGUI:Destroy()
end

local CurrentFarmMode = "None"
local IsMinimized = false

-- Instant Prompt Bypass (تصفير وقت انتظار الدائرة)
task.spawn(function()
    while task.wait(1) do
        for _, prompt in ipairs(Workspace:GetDescendants()) do
            if prompt:IsA("ProximityPrompt") then
                prompt.HoldDuration = 0
            end
        end
    end
end)

-- UI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VVOV_InstantFarmGUI"
ScreenGui.Parent = TargetParent
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 270, 0, 270)
MainFrame.Position = UDim2.new(0.5, -135, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, -40, 0, 36)
Title.Text = "  ⚡ VVOV Instant Farm v3.0"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 11
Title.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 10)

local MinimizeBtn = Instance.new("TextButton", MainFrame)
MinimizeBtn.Size = UDim2.new(0, 35, 0, 36)
MinimizeBtn.Position = UDim2.new(1, -38, 0, 0)
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 16
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 10)

local Container = Instance.new("Frame", MainFrame)
Container.Size = UDim2.new(1, -20, 1, -46)
Container.Position = UDim2.new(0, 10, 0, 42)
Container.BackgroundTransparency = 1

local StatusLabel = Instance.new("TextLabel", Container)
StatusLabel.Size = UDim2.new(1, 0, 0, 35)
StatusLabel.Position = UDim2.new(0, 0, 0, 5)
StatusLabel.Text = "الحالة: متوقف ⏸️"
StatusLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
StatusLabel.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.TextSize = 10
Instance.new("UICorner", StatusLabel).CornerRadius = UDim.new(0, 6)

local PizzaFarmBtn = Instance.new("TextButton", Container)
PizzaFarmBtn.Size = UDim2.new(1, 0, 0, 38)
PizzaFarmBtn.Position = UDim2.new(0, 0, 0, 48)
PizzaFarmBtn.Text = "🍕 بيتزا سريعة (Teleport)"
PizzaFarmBtn.BackgroundColor3 = Color3.fromRGB(210, 105, 30)
PizzaFarmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PizzaFarmBtn.Font = Enum.Font.GothamBold
PizzaFarmBtn.TextSize = 11
Instance.new("UICorner", PizzaFarmBtn).CornerRadius = UDim.new(0, 6)

local BoxFarmBtn = Instance.new("TextButton", Container)
BoxFarmBtn.Size = UDim2.new(1, 0, 0, 38)
BoxFarmBtn.Position = UDim2.new(0, 0, 0, 92)
BoxFarmBtn.Text = "📦 صناديق سريعة (Teleport)"
BoxFarmBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
BoxFarmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BoxFarmBtn.Font = Enum.Font.GothamBold
BoxFarmBtn.TextSize = 11
Instance.new("UICorner", BoxFarmBtn).CornerRadius = UDim.new(0, 6)

local StopFarmBtn = Instance.new("TextButton", Container)
StopFarmBtn.Size = UDim2.new(1, 0, 0, 32)
StopFarmBtn.Position = UDim2.new(0, 0, 0, 136)
StopFarmBtn.Text = "🛑 إيقاف التجميع"
StopFarmBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
StopFarmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StopFarmBtn.Font = Enum.Font.GothamBold
StopFarmBtn.TextSize = 10
Instance.new("UICorner", StopFarmBtn).CornerRadius = UDim.new(0, 6)

-- Minimize Logic
MinimizeBtn.MouseButton1Click:Connect(function()
    IsMinimized = not IsMinimized
    if IsMinimized then
        Container.Visible = false
        MainFrame.Size = UDim2.new(0, 180, 0, 36)
        MinimizeBtn.Text = "+"
    else
        Container.Visible = true
        MainFrame.Size = UDim2.new(0, 270, 0, 270)
        MinimizeBtn.Text = "-"
    end
end)

-- Fast Teleport Farming Engine
local function StartInstantFarm(mode)
    CurrentFarmMode = mode

    task.spawn(function()
        while CurrentFarmMode == mode do
            local character = LocalPlayer.Character
            local hrp = character and character:FindFirstChild("HumanoidRootPart")

            if hrp then
                local foundPrompt = false

                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if CurrentFarmMode ~= mode then break end

                    if obj:IsA("ProximityPrompt") and obj.Enabled then
                        local objName = obj.Parent and obj.Parent.Name:lower() or ""
                        local promptName = obj.ObjectText:lower() .. " " .. obj.ActionText:lower()

                        local isMatch = false
                        if mode == "Pizza" and (objName:find("pizza") or promptName:find("pizza") or promptName:find("بيتزا")) then
                            isMatch = true
                        elseif mode == "Box" and (objName:find("box") or objName:find("store") or promptName:find("box") or promptName:find("صندوق")) then
                            isMatch = true
                        end

                        if isMatch and obj.Parent and obj.Parent:IsA("BasePart") then
                            foundPrompt = true
                            -- انتقال لحظي للأغراض والتفاعل المباشر
                            hrp.CFrame = obj.Parent.CFrame + Vector3.new(0, 3, 0)
                            task.wait(0.1)
                            fireproximityprompt(obj)
                            task.wait(0.2)
                        end
                    end
                end

                -- إذا كان يمسك غرض ينقله فوراً لنقطة التوصيل
                local tool = character:FindFirstChildOfClass("Tool")
                if tool then
                    for _, dropZone in ipairs(Workspace:GetDescendants()) do
                        if CurrentFarmMode ~= mode then break end

                        local zoneName = dropZone.Name:lower()
                        if zoneName:find("delivery") or zoneName:find("drop") or zoneName:find("sell") or zoneName:find("توصيل") then
                            if dropZone:IsA("BasePart") then
                                hrp.CFrame = dropZone.CFrame + Vector3.new(0, 3, 0)
                                task.wait(0.3)
                            end
                        end
                    end
                end

                if not foundPrompt then
                    task.wait(0.5)
                end
            end
            task.wait(0.1)
        end
    end)
end

PizzaFarmBtn.MouseButton1Click:Connect(function()
    StartInstantFarm("Pizza")
    StatusLabel.Text = "الحالة: تجميع بيتزا فوري ⚡🍕"
    StatusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
end)

BoxFarmBtn.MouseButton1Click:Connect(function()
    StartInstantFarm("Box")
    StatusLabel.Text = "الحالة: نقل صناديق فوري ⚡📦"
    StatusLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
end)

StopFarmBtn.MouseButton1Click:Connect(function()
    CurrentFarmMode = "None"
    StatusLabel.Text = "الحالة: متوقف ⏸️"
    StatusLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
end)
