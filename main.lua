-- [[ Zoko Hub V3 - Ultimate Glass Edition ]]

local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- 1. إنشاء الواجهة الأساسية
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Zoko_UI"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- الإطار الزجاجي (Main Frame)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, -135, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BackgroundTransparency = 0.25
MainFrame.Visible = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = MainFrame

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(0, 212, 255)
Stroke.Thickness = 2
Stroke.Parent = MainFrame

-- عنوان المنيو
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "ZOKO HUB"
Title.TextColor3 = Color3.fromRGB(0, 212, 255)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 22
Title.Parent = MainFrame

-- 2. إعداد قائمة قابلة للتمرير (ScrollingFrame) للأزرار
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, 0, 1, -90)
ScrollFrame.Position = UDim2.new(0, 0, 0, 45)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 212, 255)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 450) -- مساحة الأزرار
ScrollFrame.Parent = MainFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Parent = ScrollFrame
ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ListLayout.Padding = UDim.new(0, 8)

-- 3. نظام الإشعارات الفخم (Notification System)
local function Notify(titleText, descText)
    local NotifFrame = Instance.new("Frame")
    NotifFrame.Size = UDim2.new(0, 250, 0, 70)
    NotifFrame.Position = UDim2.new(1, 10, 0.8, 0) -- يظهر من يمين الشاشة
    NotifFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    NotifFrame.BackgroundTransparency = 0.2
    NotifFrame.Parent = ScreenGui
    
    local NCorner = Instance.new("UICorner")
    NCorner.CornerRadius = UDim.new(0, 10)
    NCorner.Parent = NotifFrame
    
    local NStroke = Instance.new("UIStroke")
    NStroke.Color = Color3.fromRGB(0, 212, 255)
    NStroke.Thickness = 1.5
    NStroke.Parent = NotifFrame

    local NTitle = Instance.new("TextLabel")
    NTitle.Size = UDim2.new(1, -10, 0, 25)
    NTitle.Position = UDim2.new(0, 10, 0, 5)
    NTitle.BackgroundTransparency = 1
    NTitle.Text = titleText
    NTitle.TextColor3 = Color3.fromRGB(0, 212, 255)
    NTitle.Font = Enum.Font.GothamBold
    NTitle.TextSize = 16
    NTitle.TextXAlignment = Enum.TextXAlignment.Left
    NTitle.Parent = NotifFrame

    local NDesc = Instance.new("TextLabel")
    NDesc.Size = UDim2.new(1, -10, 0, 30)
    NDesc.Position = UDim2.new(0, 10, 0, 30)
    NDesc.BackgroundTransparency = 1
    NDesc.Text = descText
    NDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
    NDesc.Font = Enum.Font.GothamMedium
    NDesc.TextSize = 13
    NDesc.TextXAlignment = Enum.TextXAlignment.Left
    NDesc.TextWrapped = true
    NDesc.Parent = NotifFrame

    -- حركة الدخول والخروج
    NotifFrame:TweenPosition(UDim2.new(1, -260, 0.8, 0), "Out", "Back", 0.5, true)
    task.wait(4)
    NotifFrame:TweenPosition(UDim2.new(1, 10, 0.8, 0), "In", "Back", 0.5, true)
    task.wait(0.5)
    NotifFrame:Destroy()
end

-- 4. المتغيرات والخصائص
local Features = {
    GodMode = false, 
    AntiRagdoll = false,
    Fly = false, 
    Invisible = false, 
    Ghost = false,
    FakeMe = false,
    CustomSpeed = false, SpeedValue = 50,
    CustomJump = false, JumpValue = 100
}
local FakeClone = nil

-- 5. صنع الأزرار
local function CreateButton(text, parent)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.BackgroundTransparency = 0.4
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = parent
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    return btn
end

-- صنع زر مع خانة كتابة (للسرعة والقفز)
local function CreateInputRow(text, defaultValue, parent)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(0.9, 0, 0, 35)
    Row.BackgroundTransparency = 1
    Row.Parent = parent

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0.7, 0, 1, 0)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    ToggleBtn.BackgroundTransparency = 0.4
    ToggleBtn.Text = text
    ToggleBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.TextSize = 14
    ToggleBtn.Parent = Row
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)

    local InputBox = Instance.new("TextBox")
    InputBox.Size = UDim2.new(0.25, 0, 1, 0)
    InputBox.Position = UDim2.new(0.75, 0, 0, 0)
    InputBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    InputBox.BackgroundTransparency = 0.4
    InputBox.Text = tostring(defaultValue)
    InputBox.TextColor3 = Color3.fromRGB(0, 212, 255)
    InputBox.Font = Enum.Font.GothamBold
    InputBox.TextSize = 14
    InputBox.Parent = Row
    Instance.new("UICorner", InputBox).CornerRadius = UDim.new(0, 8)

    return ToggleBtn, InputBox
end

-- إضافة الأزرار للواجهة
local BtnGod = CreateButton("God Mode & Anti-Ragdoll: OFF", ScrollFrame)
local BtnFly = CreateButton("Fly: OFF", ScrollFrame)
local BtnInvis = CreateButton("Sub: Invisible: OFF", ScrollFrame)
BtnInvis.Visible = false 
BtnInvis.Size = UDim2.new(0.8, 0, 0, 30)
BtnInvis.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

local BtnGhost = CreateButton("Ghost Mode: OFF", ScrollFrame)
local BtnFakeMe = CreateButton("Fake Me (Desync): OFF", ScrollFrame)

local BtnSpeed, BoxSpeed = CreateInputRow("Walk Speed: OFF", 50, ScrollFrame)
local BtnJump, BoxJump = CreateInputRow("Jump Power: OFF", 100, ScrollFrame)

-- 6. برمجة المزايا والتفعيل
-- حلقة التحديث المستمر (هنا السر اللي يمنع الموت والرقدول ويطبق السرعة)
RunService.RenderStepped:Connect(function()
    local char = Player.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end

    -- God Mode & Anti-Ragdoll Force Fix
    if Features.GodMode then
        pcall(function()
            hum.MaxHealth = math.huge
            hum.Health = math.huge
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        end)
    end

    -- Ghost Mode (True Invisibility)
    if Features.Ghost then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then
                v.Transparency = 1
            elseif v:IsA("BillboardGui") or v:IsA("SurfaceGui") then
                v.Enabled = false
            end
        end
    end

    -- Speed & Jump Override
    if Features.CustomSpeed then
        hum.WalkSpeed = Features.SpeedValue
    end
    if Features.CustomJump then
        hum.UseJumpPower = true
        hum.JumpPower = Features.JumpValue
    end
end)

BtnGod.MouseButton1Click:Connect(function()
    Features.GodMode = not Features.GodMode
    BtnGod.Text = Features.GodMode and "God Mode & Anti-Ragdoll: ON" or "God Mode & Anti-Ragdoll: OFF"
    BtnGod.TextColor3 = Features.GodMode and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(200, 200, 200)
end)

-- الطيران
local FlyLoop
BtnFly.MouseButton1Click:Connect(function()
    Features.Fly = not Features.Fly
    BtnFly.Text = Features.Fly and "Fly: ON" or "Fly: OFF"
    BtnFly.TextColor3 = Features.Fly and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(200, 200, 200)
    
    BtnInvis.Visible = Features.Fly
    local char = Player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if Features.Fly then
        char.Humanoid.PlatformStand = true
        FlyLoop = RunService.RenderStepped:Connect(function()
            local cam = workspace.CurrentCamera
            local move = Vector3.new(0,0,0)
            if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0,1,0) end
            hrp.Velocity = Vector3.new(0,0,0)
            hrp.CFrame = hrp.CFrame + (move * 2.0)
        end)
    else
        char.Humanoid.PlatformStand = false
        if FlyLoop then FlyLoop:Disconnect() end
    end
end)

-- الاختفاء التابع للطيران
BtnInvis.MouseButton1Click:Connect(function()
    Features.Invisible = not Features.Invisible
    BtnInvis.Text = Features.Invisible and "Sub: Invisible: ON" or "Sub: Invisible: OFF"
    BtnInvis.TextColor3 = Features.Invisible and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(200, 200, 200)
    local char = Player.Character
    if char then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then
                if v.Name ~= "HumanoidRootPart" then v.Transparency = Features.Invisible and 1 or 0 end
            end
        end
    end
end)

-- الشبح (Ghost Mode)
BtnGhost.MouseButton1Click:Connect(function()
    Features.Ghost = not Features.Ghost
    BtnGhost.Text = Features.Ghost and "Ghost Mode: ON" or "Ghost Mode: OFF"
    BtnGhost.TextColor3 = Features.Ghost and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(200, 200, 200)
    if not Features.Ghost and Player.Character then
        -- إرجاع الشكل للطبيعي
        for _, v in pairs(Player.Character:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then v.Transparency = 0 end
        end
    end
end)

-- Fake Me (النسخة الوهمية والشبح الرصاصي)
BtnFakeMe.MouseButton1Click:Connect(function()
    Features.FakeMe = not Features.FakeMe
    BtnFakeMe.Text = Features.FakeMe and "Fake Me (Desync): ON" or "Fake Me (Desync): OFF"
    BtnFakeMe.TextColor3 = Features.FakeMe and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(200, 200, 200)
    
    local char = Player.Character
    if not char then return end

    if Features.FakeMe then
        -- تفعيل النسخة الوهمية
        char.Archivable = true
        FakeClone = char:Clone()
        FakeClone.Name = char.Name .. "_Fake"
        FakeClone.Parent = workspace
        FakeClone:SetPrimaryPartCFrame(char:GetPrimaryPartCFrame())
        
        -- تجميد النسخة عشان الناس تشوفها واقفة
        for _, v in pairs(FakeClone:GetDescendants()) do
            if v:IsA("BasePart") then v.Anchored = true end
        end
        
        -- تحويل شخصيتك الحقيقية لشبح رصاصي لك أنت فقط
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
                v.Transparency = 0.5
                v.Color = Color3.fromRGB(150, 150, 150)
                v.Material = Enum.Material.ForceField -- يعطي تأثير فخم
            elseif v:IsA("Decal") then
                v.Transparency = 0.5
            end
        end
    else
        -- إيقاف الميزة وحذف النسخة الوهمية
        if FakeClone then FakeClone:Destroy() end
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
                v.Transparency = 0
                v.Material = Enum.Material.Plastic
            elseif v:IsA("Decal") then
                v.Transparency = 0
            end
        end
    end
end)

-- إعدادات السرعة
BtnSpeed.MouseButton1Click:Connect(function()
    Features.CustomSpeed = not Features.CustomSpeed
    BtnSpeed.Text = Features.CustomSpeed and "Walk Speed: ON" or "Walk Speed: OFF"
    BtnSpeed.TextColor3 = Features.CustomSpeed and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(200, 200, 200)
    if not Features.CustomSpeed and Player.Character then Player.Character.Humanoid.WalkSpeed = 16 end
end)
BoxSpeed.FocusLost:Connect(function() Features.SpeedValue = tonumber(BoxSpeed.Text) or 50 end)

-- إعدادات القفز
BtnJump.MouseButton1Click:Connect(function()
    Features.CustomJump = not Features.CustomJump
    BtnJump.Text = Features.CustomJump and "Jump Power: ON" or "Jump Power: OFF"
    BtnJump.TextColor3 = Features.CustomJump and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(200, 200, 200)
    if not Features.CustomJump and Player.Character then Player.Character.Humanoid.UseJumpPower = false end
end)
BoxJump.FocusLost:Connect(function() Features.JumpValue = tonumber(BoxJump.Text) or 100 end)

-- 7. زر الحقوق بالأسفل (Developed by Zoko)
local DevBtn = Instance.new("TextButton")
DevBtn.Size = UDim2.new(1, 0, 0, 35)
DevBtn.Position = UDim2.new(0, 0, 1, -35)
DevBtn.BackgroundTransparency = 1
DevBtn.RichText = true
DevBtn.Text = [[Developed by <font color="rgb(0, 212, 255)"><b>Zoko</b></font>]]
DevBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
DevBtn.Font = Enum.Font.GothamMedium
DevBtn.TextSize = 13
DevBtn.Parent = MainFrame

DevBtn.MouseButton1Click:Connect(function()
    local site = "http://45.137.98.42:5000/"
    if setclipboard then
        setclipboard(site)
        Notify("Zoko Link Copied!", "تم نسخ الرابط! الصقه في المتصفح.")
    else
        Notify("Zoko Site", "الرابط: " .. site)
    end
end)

-- 8. زر الفتح والقفل الدائري
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 45, 0, 45)
OpenBtn.Position = UDim2.new(0, 15, 0.5, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 212, 255)
OpenBtn.Text = "Z"
OpenBtn.Font = Enum.Font.GothamBlack
OpenBtn.TextSize = 22
OpenBtn.TextColor3 = Color3.fromRGB(25, 25, 25)
OpenBtn.Parent = ScreenGui
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)

OpenBtn.MouseButton1Click:Connect(function()
    if MainFrame.Visible then
        MainFrame:TweenSize(UDim2.new(0, 0, 0, 0), "Out", "Quart", 0.3, true)
        task.wait(0.3)
        MainFrame.Visible = false
    else
        MainFrame.Visible = true
        MainFrame:TweenSize(UDim2.new(0, 270, 0, 400), "Out", "Back", 0.5, true)
    end
end)

-- تشغيل أنميشن الفتح تلقائياً أول ما يشتغل السكربت
MainFrame:TweenSize(UDim2.new(0, 270, 0, 400), "Out", "Back", 0.6, true)
