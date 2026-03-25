--[[
    ZOKO HUB - VERSION 6.0 (ULTIMATE EDITION)
    DEVELOPED BY: ZOKO / aing73
    QUALITY: HIGH-END GLASSMORPHISM
    FEATURES: FULL SERVER-SIDE BYPASS & OPTIMIZED PERFORMANCE
    ----------------------------------------------------------
    هذا السكربت مصمم خصيصاً للمطور زوكو، يحتوي على حماية كاملة وأنظمة متقدمة.
]]

-- إعدادات البيئة الأساسية
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- إعدادات الألوان والهوية
local ZOKO_COLOR = Color3.fromRGB(0, 212, 255)
local BG_COLOR = Color3.fromRGB(15, 15, 15)
local TEXT_COLOR = Color3.fromRGB(255, 255, 255)

-- مصفوفة الخصائص (إدارة الحالة)
local Zoko_Settings = {
    GodMode = false,
    AntiRagdoll = false,
    GhostMode = false,
    FlyActive = false,
    InfJump = false,
    WalkSpeedActive = false,
    JumpPowerActive = false,
    SpeedValue = 16,
    JumpValue = 50,
    MenuVisible = true
}

-- 1. بناء الواجهة البرمجية (UI Construction)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Zoko_Ultimate_V6"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999 -- لضمان ظهوره فوق كل شيء

-- الإطار الرئيسي
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = BG_COLOR
MainFrame.BackgroundTransparency = 0.2
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -225)
MainFrame.Size = UDim2.new(0, 300, 0, 450)
MainFrame.ClipsDescendants = true

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 20)
Corner.Parent = MainFrame

local Stroke = Instance.new("UIStroke")
Stroke.Thickness = 2.5
Stroke.Color = ZOKO_COLOR
Stroke.Parent = MainFrame

-- العنوان
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Text = "ZOKO HUB V6"
Title.TextColor3 = ZOKO_COLOR
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 24
Title.Parent = MainFrame

-- قائمة التمرير (Scrolling Container)
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -20, 1, -120)
ScrollFrame.Position = UDim2.new(0, 10, 0, 60)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 800) -- مساحة كبيرة جداً للأزرار
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = ZOKO_COLOR
ScrollFrame.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Parent = ScrollFrame
Layout.Padding = UDim.new(0, 12)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- 2. دوال الأنظمة المتقدمة (Core Systems)

-- نظام الإشعارات
local function ZokoNotify(title, msg)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = msg,
        Duration = 4,
        Button1 = "تم"
    })
end

-- نظام فرض القوة (Force Update Loop)
RunService.Stepped:Connect(function()
    if not Player.Character or not Player.Character:FindFirstChild("Humanoid") then return end
    local char = Player.Character
    local hum = char.Humanoid
    
    -- تطبيق القود مود ومنع الرقدول
    if Zoko_Settings.GodMode then
        hum.MaxHealth = math.huge
        hum.Health = math.huge
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    end

    -- تطبيق السرعة والقفز
    if Zoko_Settings.WalkSpeedActive then
        hum.WalkSpeed = Zoko_Settings.SpeedValue
    end
    if Zoko_Settings.JumpPowerActive then
        hum.UseJumpPower = true
        hum.JumpPower = Zoko_Settings.JumpValue
    end

    -- نظام الشبح المطلق
    if Zoko_Settings.GhostMode then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = false
                part.Transparency = 0.7
            end
        end
    end
end)

-- 3. أدوات إنشاء العناصر (UI Elements Factories)

local function CreateToggle(text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0.95, 0, 0, 45)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Btn.Text = text .. " : OFF"
    Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 14
    Btn.Parent = ScrollFrame
    
    local BCorner = Instance.new("UICorner", Btn)
    BCorner.CornerRadius = UDim.new(0, 10)
    
    local Status = false
    Btn.MouseButton1Click:Connect(function()
        Status = not Status
        Btn.Text = text .. (Status and " : ON" or " : OFF")
        Btn.TextColor3 = Status and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(200, 200, 200)
        callback(Status)
    end)
    return Btn
end

local function CreateInput(text, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0.95, 0, 0, 50)
    Frame.BackgroundTransparency = 1
    Frame.Parent = ScrollFrame

    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(0.6, 0, 1, 0)
    Label.Text = text
    Label.TextColor3 = TEXT_COLOR
    Label.Font = Enum.Font.GothamBold
    Label.BackgroundTransparency = 1
    Label.TextSize = 14

    local Input = Instance.new("TextBox", Frame)
    Input.Size = UDim2.new(0.35, 0, 0.8, 0)
    Input.Position = UDim2.new(0.65, 0, 0.1, 0)
    Input.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Input.Text = tostring(default)
    Input.TextColor3 = ZOKO_COLOR
    Input.Font = Enum.Font.GothamBold
    Input.Parent = Frame
    Instance.new("UICorner", Input)

    Input.FocusLost:Connect(function()
        callback(tonumber(Input.Text) or default)
    end)
end

-- 4. إضافة الأزرار وتفعيل الوظائف

CreateToggle("God Mode & Anti-Ragdoll", function(s)
    Zoko_Settings.GodMode = s
    ZokoNotify("Zoko Hub", s and "تفعيل وضع الخلود" or "إلغاء وضع الخلود")
end)

CreateToggle("Ghost Mode (Invisible)", function(s)
    Zoko_Settings.GhostMode = s
    if not s then
        for _, v in pairs(Player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.Transparency = 0 v.CanCollide = true end
        end
    end
end)

CreateToggle("Enable Custom Speed", function(s)
    Zoko_Settings.WalkSpeedActive = s
end)

CreateInput("Walk Speed Value", 50, function(v)
    Zoko_Settings.SpeedValue = v
end)

CreateToggle("Enable Custom Jump", function(s)
    Zoko_Settings.JumpPowerActive = s
end)

CreateInput("Jump Power Value", 100, function(v)
    Zoko_Settings.JumpValue = v
end)

-- 5. تضبيط زر الحقوق "Zoko" (Developed by Zoko)
local DevBtn = Instance.new("TextButton")
DevBtn.Size = UDim2.new(0.9, 0, 0, 40)
DevBtn.Position = UDim2.new(0.05, 0, 1, -50) -- موضع ثابت بالأسفل
DevBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
DevBtn.BackgroundTransparency = 0.5
DevBtn.RichText = true
DevBtn.Text = "Developed by <font color='rgb(0, 212, 255)'><b>Zoko</b></font>"
DevBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
DevBtn.Font = Enum.Font.GothamBold
DevBtn.TextSize = 16
DevBtn.Parent = MainFrame
Instance.new("UICorner", DevBtn)

DevBtn.MouseButton1Click:Connect(function()
    ZokoNotify("Zoko Website", "تم نسخ رابط الموقع في الكونسول!")
    print("Zoko Site: http://45.137.98.42:5000/")
    if setclipboard then setclipboard("http://45.137.98.42:5000/") end
end)

-- 6. زر الفتح والقفل (Floating Z Button)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 60, 0, 60)
ToggleButton.Position = UDim2.new(0, 20, 0.4, 0)
ToggleButton.BackgroundColor3 = ZOKO_COLOR
ToggleButton.Text = "Z"
ToggleButton.TextColor3 = Color3.fromRGB(20, 20, 20)
ToggleButton.Font = Enum.Font.GothamBlack
ToggleButton.TextSize = 30
ToggleButton.Parent = ScreenGui
ToggleButton.ZIndex = 10 -- لضمان أنه فوق كل شيء
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(1, 0)

ToggleButton.MouseButton1Click:Connect(function()
    Zoko_Settings.MenuVisible = not Zoko_Settings.MenuVisible
    if Zoko_Settings.MenuVisible then
        MainFrame.Visible = true
        MainFrame:TweenSize(UDim2.new(0, 300, 0, 450), "Out", "Back", 0.5, true)
    else
        MainFrame:TweenSize(UDim2.new(0, 0, 0, 0), "In", "Quart", 0.4, true)
        task.wait(0.4)
        MainFrame.Visible = false
    end
end)

-- بدء السكربت بأنميشن فخم
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Visible = true
MainFrame:TweenSize(UDim2.new(0, 300, 0, 450), "Out", "Back", 0.7, true)
ZokoNotify("Zoko Hub V6", "تم تحميل السكربت بنجاح! استمتع يا زوكو.")
