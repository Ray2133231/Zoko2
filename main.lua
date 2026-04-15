-- [[ ZOKO PREMIUM CORE V2 - RED GLASS EDITION ]] --
local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Mouse = Player:GetMouse()

if _G.ZokoUI then pcall(function() _G.ZokoUI:Destroy() end) end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Zoko_UI_Premium"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
_G.ZokoUI = ScreenGui

-- ألوان الثيم الجديد (أحمر نيون زجاجي)
local Theme = {
    MainBg = Color3.fromRGB(15, 2, 2), -- أسود محمر غامق
    Stroke = Color3.fromRGB(255, 30, 30), -- أحمر نيون
    Text = Color3.fromRGB(255, 200, 200),
    Accent = Color3.fromRGB(255, 10, 10),
    Transparency = 0.35 -- شفافية زجاجية
}

-----------------------------------
-- نظام حفظ النقاط (Checkpoints) --
-----------------------------------
local CP_FileName = "Zoko_Checkpoints_V2.json"
local SavedCheckpoints = {}
local CurrentPlaceId = tostring(game.PlaceId)

local function LoadCheckpoints()
    if isfile and isfile(CP_FileName) then
        local s, r = pcall(function() return HttpService:JSONDecode(readfile(CP_FileName)) end)
        if s and type(r) == "table" then SavedCheckpoints = r end
    end
    if not SavedCheckpoints[CurrentPlaceId] then SavedCheckpoints[CurrentPlaceId] = {} end
    
    local maxOrder = 0
    for n, d in pairs(SavedCheckpoints[CurrentPlaceId]) do
        if d.Order and d.Order > maxOrder then maxOrder = d.Order end
    end
    for n, d in pairs(SavedCheckpoints[CurrentPlaceId]) do
        if not d.Order then
            maxOrder = maxOrder + 1
            d.Order = maxOrder
        end
    end
end

local function SaveCheckpoints()
    if writefile then
        pcall(function() writefile(CP_FileName, HttpService:JSONEncode(SavedCheckpoints)) end)
    end
end
LoadCheckpoints()

local function CleanupWands()
    pcall(function()
        for _, v in pairs(Player.Backpack:GetChildren()) do
            if v.Name == "Zoko Control" then v:Destroy() end
        end
        if Player.Character then
            for _, v in pairs(Player.Character:GetChildren()) do
                if v.Name == "Zoko Control" then v:Destroy() end
            end
        end
    end)
end
CleanupWands()

-----------------------------------
-- الواجهة الرئيسية الزجاجية -------
-----------------------------------
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, -135, 0.5, -200)
MainFrame.BackgroundColor3 = Theme.MainBg
MainFrame.BackgroundTransparency = Theme.Transparency
MainFrame.Visible = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- تأثير الزجاج (Blur) لو اللعبة تدعمه
local blur = Instance.new("UIBlurEffect", MainFrame)
blur.Size = 10

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 15)
local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Theme.Stroke
Stroke.Thickness = 1.5
Stroke.Transparency = 0.2

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundTransparency = 1
Title.Text = "ZOKO ENGINE V2"
Title.TextColor3 = Theme.Stroke
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 24
Title.Parent = MainFrame

local TitleGlow = Instance.new("UIStroke", Title)
TitleGlow.Color = Theme.Accent
TitleGlow.Thickness = 0.5
TitleGlow.Transparency = 0.5

local function MakeDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end
MakeDraggable(MainFrame)

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, 0, 1, -110) 
ScrollFrame.Position = UDim2.new(0, 0, 0, 45)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 3
ScrollFrame.ScrollBarImageColor3 = Theme.Accent
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 1100)
ScrollFrame.Parent = MainFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Parent = ScrollFrame
ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ListLayout.Padding = UDim.new(0, 10)

local function Notify(titleText, descText, color)
    local useColor = color or Theme.Stroke
    local NotifFrame = Instance.new("Frame")
    NotifFrame.Size = UDim2.new(0, 260, 0, 70)
    NotifFrame.Position = UDim2.new(1, 10, 0.8, 0)
    NotifFrame.BackgroundColor3 = Theme.MainBg
    NotifFrame.BackgroundTransparency = 0.2
    NotifFrame.ZIndex = 200
    NotifFrame.Parent = ScreenGui
    Instance.new("UICorner", NotifFrame).CornerRadius = UDim.new(0, 10)
    local NStroke = Instance.new("UIStroke", NotifFrame)
    NStroke.Color = useColor
    NStroke.Thickness = 1.5

    local NTitle = Instance.new("TextLabel", NotifFrame)
    NTitle.Size = UDim2.new(1, -10, 0, 25)
    NTitle.Position = UDim2.new(0, 10, 0, 5)
    NTitle.BackgroundTransparency = 1
    NTitle.Text = titleText
    NTitle.TextColor3 = useColor
    NTitle.Font = Enum.Font.GothamBold
    NTitle.TextSize = 16
    NTitle.ZIndex = 201
    NTitle.TextXAlignment = Enum.TextXAlignment.Left

    local NDesc = Instance.new("TextLabel", NotifFrame)
    NDesc.Size = UDim2.new(1, -10, 0, 30)
    NDesc.Position = UDim2.new(0, 10, 0, 30)
    NDesc.BackgroundTransparency = 1
    NDesc.Text = descText
    NDesc.TextColor3 = Color3.fromRGB(220, 220, 220)
    NDesc.Font = Enum.Font.GothamMedium
    NDesc.TextSize = 13
    NDesc.ZIndex = 201
    NDesc.TextXAlignment = Enum.TextXAlignment.Left
    NDesc.TextWrapped = true

    NotifFrame:TweenPosition(UDim2.new(1, -270, 0.8, 0), "Out", "Back", 0.5, true)
    task.wait(3.5)
    NotifFrame:TweenPosition(UDim2.new(1, 10, 0.8, 0), "In", "Back", 0.5, true)
    task.wait(0.5)
    NotifFrame:Destroy()
end

-----------------------------------
-- دوال إنشاء الأزرار بالتصميم الزجاجي --
-----------------------------------
local function CreateButton(text, parent)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(30, 5, 5)
    btn.BackgroundTransparency = 0.5
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    local btnStroke = Instance.new("UIStroke", btn)
    btnStroke.Color = Color3.fromRGB(80, 10, 10)
    btnStroke.Thickness = 1
    
    -- تأثير عند المرور بالماوس
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 10, 10)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 5, 5)}):Play()
    end)
    
    return btn
end

local function CreateInputRow(text, defaultValue, parent)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(0.9, 0, 0, 38)
    Row.BackgroundTransparency = 1
    Row.Parent = parent

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0.7, 0, 1, 0)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 5, 5)
    ToggleBtn.BackgroundTransparency = 0.5
    ToggleBtn.Text = text
    ToggleBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.TextSize = 14
    ToggleBtn.Parent = Row
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", ToggleBtn).Color = Color3.fromRGB(80, 10, 10)

    local InputBox = Instance.new("TextBox")
    InputBox.Size = UDim2.new(0.25, 0, 1, 0)
    InputBox.Position = UDim2.new(0.75, 0, 0, 0)
    InputBox.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
    InputBox.BackgroundTransparency = 0.5
    InputBox.Text = tostring(defaultValue)
    InputBox.TextColor3 = Theme.Accent
    InputBox.Font = Enum.Font.GothamBold
    InputBox.TextSize = 14
    InputBox.Parent = Row
    Instance.new("UICorner", InputBox).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", InputBox).Color = Color3.fromRGB(80, 10, 10)
    
    return ToggleBtn, InputBox
end

local Features = {
    Fly = false, FlyNoclip = false, GodMode = false, InfJump = false, Noclip = false, 
    InstantPrompt = false, SuperHit = false, AntiAFK = true, ControlWand = false, ESP = false,
    CustomSpeed = false, WalkSpeed = 100, CarSpeed = 100, FlySpeed = 100, CarFlySpeed = 100, 
    CustomJump = false, JumpValue = 100, Aimbot = false, AimbotFOV = 150
}

local BtnAimbot = CreateButton("Aimbot V2: OFF", ScrollFrame)
local BtnWand = CreateButton("Control Wand : OFF", ScrollFrame)
local BtnFly = CreateButton("Fly : OFF", ScrollFrame)
local BtnFlyNoclip = CreateButton("Fly Noclip : OFF", ScrollFrame)
BtnFlyNoclip.Visible = false
local BtnESP = CreateButton("ESP: OFF", ScrollFrame)
local BtnGod = CreateButton("God Mode: OFF", ScrollFrame)
local BtnNoclip = CreateButton("Noclip: OFF", ScrollFrame)
local BtnAntiAFK = CreateButton("Anti-AFK: ON", ScrollFrame)
BtnAntiAFK.TextColor3 = Theme.Accent

-----------------------------------
-- Aimbot V2 (Wall Check + TriggerBot) --
-----------------------------------
local FOVGui = Instance.new("ScreenGui")
FOVGui.Name = "Zoko_AimbotFOV"
FOVGui.Parent = ScreenGui
local FOVFrame = Instance.new("Frame", FOVGui)
FOVFrame.BackgroundTransparency = 1
FOVFrame.Size = UDim2.new(0, Features.AimbotFOV * 2, 0, Features.AimbotFOV * 2)
FOVFrame.AnchorPoint = Vector2.new(0.5, 0.5)
FOVFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
Instance.new("UICorner", FOVFrame).CornerRadius = UDim.new(1, 0)
local FOVStroke = Instance.new("UIStroke", FOVFrame)
FOVStroke.Color = Theme.Accent
FOVStroke.Thickness = 1.5
FOVFrame.Visible = false

-- فحص الجدران (Raycast)
local function IsVisible(targetPart)
    local origin = workspace.CurrentCamera.CFrame.Position
    local direction = targetPart.Position - origin
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {Player.Character}
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.IgnoreWater = true

    local result = workspace:Raycast(origin, direction, rayParams)
    
    -- إذا ما صدم بشيء، أو صدم بالشخص نفسه = معناه مكشوف
    if not result or result.Instance:IsDescendantOf(targetPart.Parent) then
        return true
    end
    return false
end

-- إيجاد أقرب هدف مكشوف
local function GetClosestVisibleTarget()
    local center = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
    local closestDist = Features.AimbotFOV
    local closestTarget = nil
    
    for _, v in pairs(game.Players:GetPlayers()) do
        local isEnemy = true
        if Player.Team and v.Team and Player.Team == v.Team then
            isEnemy = false
        end

        if v ~= Player and isEnemy and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(v.Character.Head.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                if dist < closestDist then
                    -- هنا نفحص هل هو ورا جدار أو لا
                    if IsVisible(v.Character.Head) then
                        closestDist = dist
                        closestTarget = v.Character.Head
                    end
                end
            end
        end
    end
    return closestTarget
end

BtnAimbot.MouseButton1Click:Connect(function()
    Features.Aimbot = not Features.Aimbot
    BtnAimbot.Text = "Aimbot V2: " .. (Features.Aimbot and "ON" or "OFF")
    BtnAimbot.TextColor3 = Features.Aimbot and Theme.Accent or Color3.fromRGB(200, 200, 200)
    FOVFrame.Visible = Features.Aimbot
end)

local clicking = false
local AimbotLoop = RunService.RenderStepped:Connect(function()
    if Features.Aimbot then
        local targetHead = GetClosestVisibleTarget()
        if targetHead then
            -- تأييم سلس (Smooth Aim)
            local camCFrame = workspace.CurrentCamera.CFrame
            local newCFrame = CFrame.new(camCFrame.Position, targetHead.Position)
            workspace.CurrentCamera.CFrame = camCFrame:Lerp(newCFrame, 0.4) -- سرعة التوجيه
            
            -- نظام الإطلاق التلقائي (TriggerBot) أول ما يكون الإيم عليه
            if not clicking then
                clicking = true
                pcall(function()
                    if mouse1press then 
                        mouse1press() 
                        task.wait(0.02) 
                        mouse1release()
                    else 
                        VirtualUser:ClickButton1(Vector2.new()) 
                    end
                end)
                task.wait(0.08) -- سرعة الطلق (Fire Rate)
                clicking = false
            end
        end
    end
end)

-----------------------------------
-- ESP باللون الأحمر -------------
-----------------------------------
local ESPLoop = nil
BtnESP.MouseButton1Click:Connect(function()
    Features.ESP = not Features.ESP
    BtnESP.Text = string.split(BtnESP.Text, ":")[1] .. (Features.ESP and ": ON" or ": OFF")
    BtnESP.TextColor3 = Features.ESP and Theme.Accent or Color3.fromRGB(200, 200, 200)
    
    if Features.ESP then
        ESPLoop = RunService.RenderStepped:Connect(function()
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    if not p.Character:FindFirstChild("ZokoESP_Highlight") then
                        local hl = Instance.new("Highlight")
                        hl.Name = "ZokoESP_Highlight"
                        hl.FillTransparency = 0.7
                        hl.FillColor = Theme.Accent
                        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                        hl.OutlineTransparency = 0.2
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        hl.Parent = p.Character
                    end
                end
            end
        end)
    else
        if ESPLoop then ESPLoop:Disconnect() end
        for _, p in pairs(game.Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("ZokoESP_Highlight") then 
                p.Character.ZokoESP_Highlight:Destroy() 
            end
        end
    end
end)

-----------------------------------
-- أزرار إضافية وتكملة الواجهة ----
-----------------------------------
local DevBtn = Instance.new("TextButton")
DevBtn.Size = UDim2.new(1, 0, 0, 25)
DevBtn.Position = UDim2.new(0, 0, 1, -45)
DevBtn.BackgroundTransparency = 1
DevBtn.RichText = true
DevBtn.Text = [[Engineered by <font color="rgb(255, 30, 30)"><b>Zoko</b></font>]]
DevBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
DevBtn.Font = Enum.Font.GothamMedium
DevBtn.TextSize = 14
DevBtn.Parent = MainFrame

local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 45, 0, 45)
OpenBtn.Position = UDim2.new(0, 15, 0.5, 0)
OpenBtn.BackgroundColor3 = Theme.MainBg
OpenBtn.BackgroundTransparency = 0.2
OpenBtn.Text = "Z"
OpenBtn.Font = Enum.Font.GothamBlack
OpenBtn.TextSize = 22
OpenBtn.TextColor3 = Theme.Accent
OpenBtn.Parent = ScreenGui
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", OpenBtn).Color = Theme.Accent
MakeDraggable(OpenBtn)

OpenBtn.MouseButton1Click:Connect(function()
    if MainFrame.Visible then
        MainFrame:TweenSize(UDim2.new(0, 0, 0, 0), "Out", "Quart", 0.3, true)
        task.wait(0.3)
        MainFrame.Visible = false
    else
        MainFrame.Visible = true
        MainFrame:TweenSize(UDim2.new(0, 280, 0, 420), "Out", "Back", 0.5, true)
    end
end)

MainFrame:TweenSize(UDim2.new(0, 280, 0, 420), "Out", "Back", 0.6, true)
