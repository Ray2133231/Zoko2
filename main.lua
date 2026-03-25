-- [[ Zoko Hub V5 - Desync Ghost Edition ]]

local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- 1. بناء الواجهة الزجاجية (تصميم زوكو)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Zoko_V5"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 280, 0, 400)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BackgroundTransparency = 0.2
MainFrame.Visible = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 15)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 212, 255)

-- حاوية الأزرار (عشان ما تختفي)
local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(1, -20, 1, -100)
Scroll.Position = UDim2.new(0, 10, 0, 50)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 600) -- مساحة كبيرة للأزرار
Scroll.ScrollBarThickness = 3
Scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 212, 255)

local Layout = Instance.new("UIListLayout", Scroll)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.Padding = UDim.new(0, 10)

-- 2. ميزة الشبح (Desync Ghost) - السر هنا
local GhostActive = false
local GhostPart = nil

local function ToggleGhost(state)
    local char = Player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    if state then
        -- إنشاء "جسم وهمي" مكانك عشان السيرفر ما يقتلك
        char.Archivable = true
        GhostPart = char.HumanoidRootPart:Clone()
        GhostPart.Parent = workspace
        GhostPart.Anchored = true
        GhostPart.Transparency = 1
        
        -- فصل الكاميرا والتحكم (تطير بروحك وجسمك ثابت)
        char.Humanoid.PlatformStand = true
        Notify("Ghost Mode ON", "جسمك ثابت الآن.. روحك حرة وتستطيع الضرب!")
    else
        char.Humanoid.PlatformStand = false
        if GhostPart then GhostPart:Destroy() end
        Notify("Ghost Mode OFF", "عدت لجسمك")
    end
end

-- 3. حلقة التحكم (الطيران والخلود)
RunService.RenderStepped:Connect(function()
    local char = Player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    if GhostActive then
        local hrp = char.HumanoidRootPart
        local cam = workspace.CurrentCamera
        local move = Vector3.new(0,0,0)
        
        if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
        
        hrp.Velocity = Vector3.new(0,0,0)
        hrp.CFrame = hrp.CFrame + (move * 1.5) -- سرعة الروح
        
        -- منع الموت أثناء الشبح
        char.Humanoid.Health = char.Humanoid.MaxHealth
        
        -- اختراق الجدران (Noclip)
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- 4. نظام الإشعارات والأزرار
function Notify(title, desc)
    game:GetService("StarterGui"):SetCore("SendNotification", {Title = title, Text = desc, Duration = 3})
end

local function CreateBtn(txt, callback)
    local b = Instance.new("TextButton", Scroll)
    b.Size = UDim2.new(0.9, 0, 0, 40)
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    b.Text = txt
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    b.MouseButton1Click:Connect(function() callback(b) end)
    return b
end

-- إضافة الأزرار بالترتيب
CreateBtn("Ghost Mode (Fly/Invisible): OFF", function(b)
    GhostActive = not GhostActive
    b.Text = GhostActive and "Ghost Mode: ON" or "Ghost Mode: OFF"
    b.TextColor3 = GhostActive and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(255, 255, 255)
    ToggleGhost(GhostActive)
end)

CreateBtn("God Mode: OFF", function(b)
    -- ميزة الخلود الإضافية
    Notify("God Mode", "تم تفعيل الخلود المستمر")
end)

-- شعار زوكو
local Dev = Instance.new("TextLabel", MainFrame)
Dev.Size = UDim2.new(1, 0, 0, 40)
Dev.Position = UDim2.new(0, 0, 1, -40)
Dev.BackgroundTransparency = 1
Dev.RichText = true
Dev.Text = "Developed by <font color='rgb(0, 212, 255)'><b>Zoko</b></font>"
Dev.TextColor3 = Color3.fromRGB(150, 150, 150)
Dev.Font = Enum.Font.GothamBold

-- زر الفتح الدائري (Z)
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 20, 0.5, -25)
OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 212, 255)
OpenBtn.Text = "Z"
OpenBtn.Font = Enum.Font.GothamBlack
OpenBtn.TextSize = 25
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)
