-- [[ Zoko Menu V1 - Glass Edition ]]

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- إنشاء الواجهة
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Zoko_Hub"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- الإطار الرئيسي (الزجاجي)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BackgroundTransparency = 0.3
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -160)
MainFrame.Size = UDim2.new(0, 0, 0, 0) -- للأنميشن
MainFrame.ClipsDescendants = true
MainFrame.Visible = false

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 15)
Corner.Parent = MainFrame

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(0, 212, 255) -- لون القائمة المضيء
Stroke.Thickness = 2
Stroke.Parent = MainFrame

-- المزايا الوظيفية
local GodMode = false
local Fly = false
local Invisible = false
local InfJump = false

-- وظيفة القفز اللانهائي
UIS.JumpRequest:Connect(function()
    if InfJump then
        Player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- وظيفة الـ Toggle (تغيير حالة الأزرار)
local function CreateButton(text, pos, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = MainFrame
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.BackgroundTransparency = 0.5
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 14
    
    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0, 8)
    bCorner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        callback(btn)
    end)
    return btn
end

-- إضافة الأزرار
CreateButton("God Mode: OFF", UDim2.new(0.05, 0, 0.1, 0), function(b)
    GodMode = not GodMode
    b.Text = GodMode and "God Mode: ON" or "God Mode: OFF"
    b.TextColor3 = GodMode and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(255, 255, 255)
    if GodMode then
        Player.Character.Humanoid.MaxHealth = math.huge
        Player.Character.Humanoid.Health = math.huge
    else
        Player.Character.Humanoid.MaxHealth = 100
        Player.Character.Humanoid.Health = 100
    end
end)

CreateButton("Fly: OFF", UDim2.new(0.05, 0, 0.3, 0), function(b)
    Fly = not Fly
    b.Text = Fly and "Fly: ON" or "Fly: OFF"
    b.TextColor3 = Fly and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(255, 255, 255)
    -- منطق الطيران (مبسط)
end)

CreateButton("Infinite Jump: OFF", UDim2.new(0.05, 0, 0.5, 0), function(b)
    InfJump = not InfJump
    b.Text = InfJump and "Inf Jump: ON" or "Inf Jump: OFF"
    b.TextColor3 = InfJump and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(255, 255, 255)
end)

-- زر الحقوق (Developed by Zoko)
local DevBtn = Instance.new("TextButton")
DevBtn.Parent = MainFrame
DevBtn.Size = UDim2.new(0.9, 0, 0, 40)
DevBtn.Position = UDim2.new(0.05, 0, 0.85, 0)
DevBtn.BackgroundTransparency = 1
DevBtn.RichText = true
DevBtn.Text = [[Developed by <font color="rgb(0, 212, 255)"><b>Zoko</b></font>]]
DevBtn.TextColor3 = Color3.fromRGB(176, 176, 176)
DevBtn.Font = Enum.Font.GothamBold
DevBtn.TextSize = 14
DevBtn.MouseButton1Click:Connect(function()
    print("Opening Site: http://45.137.98.42:5000/")
end)

-- زر الفتح الدائري
local OpenBtn = Instance.new("TextButton")
OpenBtn.Parent = ScreenGui
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 20, 0.5, -25)
OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 212, 255)
OpenBtn.Text = "Z"
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 24
local oCorner = Instance.new("UICorner")
oCorner.CornerRadius = UDim.new(1, 0)
oCorner.Parent = OpenBtn

-- أنميشن الفتح والقفل
OpenBtn.MouseButton1Click:Connect(function()
    if MainFrame.Visible then
        MainFrame:TweenSize(UDim2.new(0, 0, 0, 0), "Out", "Quart", 0.3, true)
        task.wait(0.3)
        MainFrame.Visible = false
    else
        MainFrame.Visible = true
        MainFrame:TweenSize(UDim2.new(0, 220, 0, 320), "Out", "Back", 0.5, true)
    end
end)
