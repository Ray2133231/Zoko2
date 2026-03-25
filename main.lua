--[[
    =======================================================================
    ZOKO HUB - VERSION 8.0 (THE MASTERPIECE EDITION)
    DEVELOPED BY: ZOKO / aing73
    UI DESIGN: V3 CLASSIC GLASSMORPHISM (PREMIUM)
    BACKEND: FULLY REWRITTEN ANTI-CHEAT BYPASS & STABILITY
    =======================================================================
]]

local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

-- 1. إنشاء الواجهة الأساسية (التصميم الفخم القديم V3)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Zoko_Ultimate_Hub"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999 -- لضمان بقاء المنيو فوق كل شيء

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 0, 0, 0) -- يبدأ من الصفر للأنميشن
MainFrame.Position = UDim2.new(0.5, -135, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BackgroundTransparency = 0.25 -- الشفافية الفخمة
MainFrame.Visible = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner", MainFrame)
Corner.CornerRadius = UDim.new(0, 12)

local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(0, 212, 255)
Stroke.Thickness = 2

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
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 650) -- مساحة الأزرار كافية لكل شيء
ScrollFrame.Parent = MainFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Parent = ScrollFrame
ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ListLayout.Padding = UDim.new(0, 8)

-- 3. نظام الإشعارات الفخم (Notification System)
local function Notify(titleText, descText)
    task.spawn(function()
        local NotifFrame = Instance.new("Frame")
        NotifFrame.Size = UDim2.new(0, 250, 0, 70)
        NotifFrame.Position = UDim2.new(1, 10, 0.8, 0)
        NotifFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        NotifFrame.BackgroundTransparency = 0.2
        NotifFrame.Parent = ScreenGui
        
        Instance.new("UICorner", NotifFrame).CornerRadius = UDim.new(0, 10)
        local NStroke = Instance.new("UIStroke", NotifFrame)
        NStroke.Color = Color3.fromRGB(0, 212, 255)
        NStroke.Thickness = 1.5

        local NTitle = Instance.new("TextLabel", NotifFrame)
        NTitle.Size = UDim2.new(1, -10, 0, 25)
        NTitle.Position = UDim2.new(0, 10, 0, 5)
        NTitle.BackgroundTransparency = 1
        NTitle.Text = titleText
        NTitle.TextColor3 = Color3.fromRGB(0, 212, 255)
        NTitle.Font = Enum.Font.GothamBold
        NTitle.TextSize = 16
        NTitle.TextXAlignment = Enum.TextXAlignment.Left

        local NDesc = Instance.new("TextLabel", NotifFrame)
        NDesc.Size = UDim2.new(1, -10, 0, 30)
        NDesc.Position = UDim2.new(0, 10, 0, 30)
        NDesc.BackgroundTransparency = 1
        NDesc.Text = descText
        NDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
        NDesc.Font = Enum.Font.GothamMedium
        NDesc.TextSize = 13
        NDesc.TextXAlignment = Enum.TextXAlignment.Left
        NDesc.TextWrapped = true

        NotifFrame:TweenPosition(UDim2.new(1, -260, 0.8, 0), "Out", "Back", 0.5, true)
        task.wait(3.5)
        NotifFrame:TweenPosition(UDim2.new(1, 10, 0.8, 0), "In", "Back", 0.5, true)
        task.wait(0.5)
        NotifFrame:Destroy()
    end)
end

-- 4. المتغيرات والخصائص المحمية (Features Logic)
local Features = {
    GodMode = false, 
    Fly = false, 
    Invisible = false, 
    InfJump = false,
    Ghost = false,
    FakeMe = false,
    CustomSpeed = false, SpeedValue = 50,
    CustomJump = false, JumpValue = 100
}
local FakeClone = nil

-- 5. دوال إنشاء الأزرار (UI Generators)
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
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    return btn
end

local function CreateInputRow(text, defaultValue, parent)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(0.9, 0, 0, 35)
    Row.BackgroundTransparency = 1
    Row.Parent = parent

    local ToggleBtn = Instance.new("TextButton", Row)
    ToggleBtn.Size = UDim2.new(0.7, 0, 1, 0)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    ToggleBtn.BackgroundTransparency = 0.4
    ToggleBtn.Text = text
    ToggleBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.TextSize = 14
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)

    local InputBox = Instance.new("TextBox", Row)
    InputBox.Size = UDim2.new(0.25, 0, 1, 0)
    InputBox.Position = UDim2.new(0.75, 0, 0, 0)
    InputBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    InputBox.BackgroundTransparency = 0.4
    InputBox.Text = tostring(defaultValue)
    InputBox.TextColor3 = Color3.fromRGB(0, 212, 255)
    InputBox.Font = Enum.Font.GothamBold
    InputBox.TextSize = 14
    Instance.new("UICorner", InputBox).CornerRadius = UDim.new(0, 8)

    return ToggleBtn, InputBox
end

-- ==========================================
-- إضافة الأزرار للواجهة
-- ==========================================
local BtnGod = CreateButton("God Mode & Anti-Ragdoll: OFF", ScrollFrame)
local BtnFly = CreateButton("Fly: OFF", ScrollFrame)

-- زر الاختفاء (مخفي برمجياً، ويظهر تحت الطيران فقط)
local BtnInvis = CreateButton("↳ Sub: Invisible: OFF", ScrollFrame)
BtnInvis.Visible = false 
BtnInvis.Size = UDim2.new(0.8, 0, 0, 30)
BtnInvis.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
BtnInvis.TextColor3 = Color3.fromRGB(150, 150, 150)

local BtnInfJump = CreateButton("Infinite Jump: OFF", ScrollFrame)
local BtnGhost = CreateButton("Ghost Mode: OFF", ScrollFrame)
local BtnFakeMe = CreateButton("Fake Me (Desync): OFF", ScrollFrame)

local BtnSpeed, BoxSpeed = CreateInputRow("Walk Speed: OFF", 50, ScrollFrame)
local BtnJump, BoxJump = CreateInputRow("Jump Power: OFF", 100, ScrollFrame)

-- ==========================================
-- 6. برمجة المزايا والتفعيل (The Backend)
-- ==========================================

-- نظام الحماية والتحديث المستمر (Core Loop)
RunService.Stepped:Connect(function()
    local char = Player.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end

    -- God Mode Fix: بدلاً من math.huge الذي يسبب الموت، نثبت الصحة على الماكس باستمرار
    if Features.GodMode then
        pcall(function()
            hum.Health = hum.MaxHealth
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        end)
    end

    -- Ghost Mode Fix
    if Features.Ghost then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then
                if v.Name ~= "HumanoidRootPart" then v.Transparency = 1 end
            elseif v:IsA("BillboardGui") or v:IsA("SurfaceGui") then
                v.Enabled = false
            end
        end
    end

    -- Speed Override
    if Features.CustomSpeed then
        hum.WalkSpeed = Features.SpeedValue
    end
    -- Jump Override
    if Features.CustomJump then
        hum.UseJumpPower = true
        hum.JumpPower = Features.JumpValue
    end
end)

-- قود مود
BtnGod.MouseButton1Click:Connect(function()
    Features.GodMode = not Features.GodMode
    BtnGod.Text = Features.GodMode and "God Mode & Anti-Ragdoll: ON" or "God Mode & Anti-Ragdoll: OFF"
    BtnGod.TextColor3 = Features.GodMode and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(200, 200, 200)
    if Features.GodMode then Notify("God Mode", "تم تفعيل القود مود! صحتك لن تنقص أبداً.") end
end)

-- الطيران + ظهور خيار الاختفاء
local FlyLoop
BtnFly.MouseButton1Click:Connect(function()
    Features.Fly = not Features.Fly
    BtnFly.Text = Features.Fly and "Fly: ON" or "Fly: OFF"
    BtnFly.TextColor3 = Features.Fly and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(200, 200, 200)
    
    -- إظهار/إخفاء زر الاختفاء بناءً على حالة الطيران
    BtnInvis.Visible = Features.Fly
    if not Features.Fly and Features.Invisible then
        -- إطفاء الاختفاء تلقائياً إذا طفينا الطيران
        Features.Invisible = false
        BtnInvis.Text = "↳ Sub: Invisible: OFF"
        BtnInvis.TextColor3 = Color3.fromRGB(150, 150, 150)
        local char = Player.Character
        if char then
            for _, v in pairs(char:GetDescendants()) do
                if (v:IsA("BasePart") or v:IsA("Decal")) and v.Name ~= "HumanoidRootPart" then 
                    v.Transparency = 0 
                end
            end
        end
    end
    
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
        Notify("Fly Mode", "تم تفعيل الطيران، يمكنك الآن استخدام خيار الاختفاء.")
    else
        char.Humanoid.PlatformStand = false
        if FlyLoop then FlyLoop:Disconnect() end
    end
end)

-- الاختفاء الفرعي (المرتبط بالطيران)
BtnInvis.MouseButton1Click:Connect(function()
    Features.Invisible = not Features.Invisible
    BtnInvis.Text = Features.Invisible and "↳ Sub: Invisible: ON" or "↳ Sub: Invisible: OFF"
    BtnInvis.TextColor3 = Features.Invisible and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(150, 150, 150)
    
    local char = Player.Character
    if char then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then
                if v.Name ~= "HumanoidRootPart" then 
                    v.Transparency = Features.Invisible and 1 or 0 
                end
            end
        end
    end
end)

-- القفز اللانهائي (Infinite Jump Fix)
BtnInfJump.MouseButton1Click:Connect(function()
    Features.InfJump = not Features.InfJump
    BtnInfJump.Text = Features.InfJump and "Infinite Jump: ON" or "Infinite Jump: OFF"
    BtnInfJump.TextColor3 = Features.InfJump and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(200, 200, 200)
end)

UIS.JumpRequest:Connect(function()
    if Features.InfJump and Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
        Player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- الشبح
BtnGhost.MouseButton1Click:Connect(function()
    Features.Ghost = not Features.Ghost
    BtnGhost.Text = Features.Ghost and "Ghost Mode: ON" or "Ghost Mode: OFF"
    BtnGhost.TextColor3 = Features.Ghost and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(200, 200, 200)
    if not Features.Ghost and Player.Character then
        for _, v in pairs(Player.Character:GetDescendants()) do
            if (v:IsA("BasePart") or v:IsA("Decal")) and v.Name ~= "HumanoidRootPart" then v.Transparency = 0 end
        end
    end
end)

-- النسخة الوهمية
BtnFakeMe.MouseButton1Click:Connect(function()
    Features.FakeMe = not Features.FakeMe
    BtnFakeMe.Text = Features.FakeMe and "Fake Me (Desync): ON" or "Fake Me (Desync): OFF"
    BtnFakeMe.TextColor3 = Features.FakeMe and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(200, 200, 200)
    
    local char = Player.Character
    if not char then return end

    if Features.FakeMe then
        char.Archivable = true
        FakeClone = char:Clone()
        FakeClone.Name = char.Name .. "_Fake"
        FakeClone.Parent = workspace
        FakeClone:SetPrimaryPartCFrame(char:GetPrimaryPartCFrame())
        
        for _, v in pairs(FakeClone:GetDescendants()) do
            if v:IsA("BasePart") then v.Anchored = true end
        end
        
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
                v.Transparency = 0.5
                v.Color = Color3.fromRGB(150, 150, 150)
                v.Material = Enum.Material.ForceField
            elseif v:IsA("Decal") then
                v.Transparency = 0.5
            end
        end
    else
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

-- السرعة
BtnSpeed.MouseButton1Click:Connect(function()
    Features.CustomSpeed = not Features.CustomSpeed
    BtnSpeed.Text = Features.CustomSpeed and "Walk Speed: ON" or "Walk Speed: OFF"
    BtnSpeed.TextColor3 = Features.CustomSpeed and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(200, 200, 200)
    if not Features.CustomSpeed and Player.Character then Player.Character.Humanoid.WalkSpeed = 16 end
end)
BoxSpeed.FocusLost:Connect(function() Features.SpeedValue = tonumber(BoxSpeed.Text) or 50 end)

-- القفز المخصص
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
        Notify("Zoko Site", "تم نسخ رابط الموقع الخاص بزوكو!")
    else
        Notify("Zoko Site", "الرابط: " .. site)
    end
end)

-- 8. زر الفتح والقفل الدائري (Z Button)
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
Notify("Zoko Hub V8", "مرحباً زوكو! تم تحميل النسخة النهائية.")
