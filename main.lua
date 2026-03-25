-- [[ Zoko Hub V4 - Server-Side Stealth Edition ]]

local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- 1. إعداد الواجهة (تصميم زوكو الفخم)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Zoko_V4"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 270, 0, 420)
MainFrame.Position = UDim2.new(0.5, -135, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BackgroundTransparency = 0.2
MainFrame.Visible = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 15)
local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(0, 212, 255)
Stroke.Thickness = 2

local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(1, 0, 1, -80)
Scroll.Position = UDim2.new(0, 0, 0, 45)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 500)
Scroll.ScrollBarThickness = 3
Instance.new("UIListLayout", Scroll).HorizontalAlignment = Enum.HorizontalAlignment.Center
Instance.new("UIListLayout", Scroll).Padding = UDim.new(0, 10)

-- 2. دوال الإشعارات والمزايا
local function Notify(title, desc)
    -- نظام إشعارات مبسط وسريع
    game:GetService("StarterGui"):SetCore("SendNotification", {Title = title, Text = desc, Duration = 3})
end

local Features = {God = false, Ghost = false, Fly = false, Speed = 16}
local SavedPos = nil

-- 3. برمجة الاختفاء المطلق (Server-Side Invisible)
local function ToggleGhost(state)
    local char = Player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    if state then
        SavedPos = char.HumanoidRootPart.CFrame
        -- نقل الجسم لمكان بعيد جداً (السيرفر لن يرندر جسمك للاعبين)
        char.HumanoidRootPart.CFrame = CFrame.new(0, 50000, 0) 
        Notify("Ghost ON", "أنت الآن مخفي تماماً عن السيرفر واللاعبين")
    else
        if SavedPos then char.HumanoidRootPart.CFrame = SavedPos end
        Notify("Ghost OFF", "عدت للظهور مجدداً")
    end
end

-- 4. حلقة التحكم المستمر (فرض الخصائص)
RunService.RenderStepped:Connect(function()
    local char = Player.Character
    if not char or not char:FindFirstChild("Humanoid") then return end
    
    -- قود مود ثابت
    if Features.God then
        char.Humanoid.Health = char.Humanoid.MaxHealth
        char.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        char.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    end
    
    -- طيران واختراق جدران
    if Features.Fly then
        local hrp = char.HumanoidRootPart
        local cam = workspace.CurrentCamera
        local move = Vector3.new(0,0,0)
        if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
        hrp.Velocity = Vector3.new(0,0,0)
        hrp.CFrame = hrp.CFrame + (move * 2)
        
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- 5. إنشاء الأزرار
local function CreateBtn(txt, callback)
    local b = Instance.new("TextButton", Scroll)
    b.Size = UDim2.new(0.9, 0, 0, 35)
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    b.Text = txt
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamBold
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    b.MouseButton1Click:Connect(function() callback(b) end)
    return b
end

CreateBtn("God Mode: OFF", function(b)
    Features.God = not Features.God
    b.Text = Features.God and "God Mode: ON" or "God Mode: OFF"
    b.TextColor3 = Features.God and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(255, 255, 255)
end)

CreateBtn("Server-Side Ghost: OFF", function(b)
    Features.Ghost = not Features.Ghost
    b.Text = Features.Ghost and "Ghost: ON" or "Ghost: OFF"
    b.TextColor3 = Features.Ghost and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(255, 255, 255)
    ToggleGhost(Features.Ghost)
end)

CreateBtn("Fly (Noclip): OFF", function(b)
    Features.Fly = not Features.Fly
    b.Text = Features.Fly and "Fly: ON" or "Fly: OFF"
    b.TextColor3 = Features.Fly and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(255, 255, 255)
    if not Features.Fly then
        for _, v in pairs(Player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = true end
        end
    end
end)

-- زر الحقوق
local Dev = Instance.new("TextLabel", MainFrame)
Dev.Size = UDim2.new(1, 0, 0, 40)
Dev.Position = UDim2.new(0, 0, 1, -40)
Dev.BackgroundTransparency = 1
Dev.RichText = true
Dev.Text = "Developed by <font color='rgb(0, 212, 255)'><b>Zoko</b></font>"
Dev.TextColor3 = Color3.fromRGB(150, 150, 150)

-- زر الفتح الدائري
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 20, 0.5, -25)
OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 212, 255)
OpenBtn.Text = "Z"
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)
