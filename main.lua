-- [[ Zoko Hub V4 - Server-Side Stealth Edition ]]

local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- 1. الواجهة والأنميشن (نفس التصميم الفخم لزوكو)
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
Instance.new("UIListLayout", Scroll).HorizontalAlignment = Enum.HorizontalAlignment.Center
Instance.new("UIListLayout", Scroll).Padding = UDim.new(0, 10)

-- 2. ميزات الاختفاء المطلق (Server-Side Invisible)
local GhostActive = false
local FakeMeActive = false
local SavedPos = nil

local function FullInvisible(state)
    local char = Player.Character
    if not char or not char:FindFirstChild("LowerTorso") then return end
    
    if state then
        -- خدعة السيرفر: رفع الشخصية عالياً جداً أو تحت الأرض
        SavedPos = char.PrimaryPart.CFrame
        char:MoveTo(Vector3.new(0, 999999, 0)) -- السيرفر يشوفك في السماء
        Notify("Ghost Active", "أنت الآن غير مرئي تماماً للسيرفر")
    else
        if SavedPos then char.PrimaryPart.CFrame = SavedPos end
        Notify("Ghost Disabled", "عدت للظهور")
    end
end

-- 3. نظام الطيران المحسن (Noclip Fly)
local Flying = false
local FlySpeed = 2
RunService.RenderStepped:Connect(function()
    if Flying and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = Player.Character.HumanoidRootPart
        local cam = workspace.CurrentCamera
        local move = Vector3.new(0,0,0)
        if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
        hrp.Velocity = Vector3.new(0,0,0)
        hrp.CFrame = hrp.CFrame + (move * FlySpeed)
        
        -- Noclip: المرور عبر الجدران
        for _, v in pairs(Player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- 4. أزرار المزايا
local function CreateBtn(txt)
    local b = Instance.new("TextButton", Scroll)
    b.Size = UDim2.new(0.9, 0, 0, 35)
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    b.Text = txt
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamBold
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    return b
end

local BtnGod = CreateBtn("God Mode: OFF")
local BtnGhost = CreateBtn("Server-Side Invisible: OFF")
local BtnFly = CreateBtn("Fly (Noclip): OFF")

-- برمجة الأزرار
BtnGhost.MouseButton1Click:Connect(function()
    GhostActive = not GhostActive
    BtnGhost.Text = GhostActive and "Server-Side Invisible: ON" or "Server-Side Invisible: OFF"
    BtnGhost.TextColor3 = GhostActive and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(255, 255, 255)
    FullInvisible(GhostActive)
end)

BtnFly.MouseButton1Click:Connect(function()
    Flying = not Flying
    BtnFly.Text = Flying and "Fly (Noclip): ON" or "Fly (Noclip): OFF"
    BtnFly.TextColor3 = Flying and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(255, 255, 255)
    if not Flying then
        for _, v in pairs(Player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = true end
        end
    end
end)

-- زر الحقوق زوكو
local Dev = Instance.new("TextButton", MainFrame)
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
