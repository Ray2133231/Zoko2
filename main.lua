-- [[ Zoko Hub V24 - Spectate Image Fix & Smart Speed ]]

local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local Mouse = Player:GetMouse()

if _G.ZokoUI then pcall(function() _G.ZokoUI:Destroy() end) end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Zoko_UI"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
_G.ZokoUI = ScreenGui

-- ==========================================
-- نظام تنظيف العصا
-- ==========================================
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

-- ==========================================
-- الواجهة الرئيسية
-- ==========================================
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, -135, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BackgroundTransparency = 0.25
MainFrame.Visible = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(0, 212, 255)
Stroke.Thickness = 2

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "ZOKO HUB V24"
Title.TextColor3 = Color3.fromRGB(0, 212, 255)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 22
Title.Parent = MainFrame

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
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 212, 255)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 700)
ScrollFrame.Parent = MainFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Parent = ScrollFrame
ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ListLayout.Padding = UDim.new(0, 8)

local function Notify(titleText, descText, color)
    local useColor = color or Color3.fromRGB(0, 212, 255)
    local NotifFrame = Instance.new("Frame")
    NotifFrame.Size = UDim2.new(0, 250, 0, 70)
    NotifFrame.Position = UDim2.new(1, 10, 0.8, 0)
    NotifFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    NotifFrame.BackgroundTransparency = 0.2
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
end

-- ==========================================
-- لوحة التحكم باللاعبين
-- ==========================================
local SelectedTargets = {} 
local TargetCards = {}     
local ActiveTarget = nil   
local SpectatedPlayer = nil 
local SpectateLoop = nil

local ControlFrame = Instance.new("Frame")
ControlFrame.Size = UDim2.new(0, 280, 0, 350)
ControlFrame.Position = UDim2.new(0.5, 150, 0.5, -150)
ControlFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ControlFrame.Visible = false
ControlFrame.Parent = ScreenGui
Instance.new("UICorner", ControlFrame).CornerRadius = UDim.new(0, 12)
local CStroke = Instance.new("UIStroke", ControlFrame)
CStroke.Color = Color3.fromRGB(255, 100, 100)
CStroke.Thickness = 2
MakeDraggable(ControlFrame)

local TargetTitle = Instance.new("TextLabel", ControlFrame)
TargetTitle.Size = UDim2.new(1, 0, 0, 25)
TargetTitle.Position = UDim2.new(0, 0, 0, 5)
TargetTitle.BackgroundTransparency = 1
TargetTitle.Text = "Selected Targets (Max 3)"
TargetTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetTitle.Font = Enum.Font.GothamBold
TargetTitle.TextSize = 14

local TargetsContainer = Instance.new("Frame", ControlFrame)
TargetsContainer.Size = UDim2.new(1, 0, 0, 100)
TargetsContainer.Position = UDim2.new(0, 0, 0, 30)
TargetsContainer.BackgroundTransparency = 1

local TPadding = Instance.new("UIPadding", TargetsContainer)
TPadding.PaddingLeft = UDim.new(0, 8)
local TListLayout = Instance.new("UIListLayout", TargetsContainer)
TListLayout.FillDirection = Enum.FillDirection.Horizontal
TListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
TListLayout.Padding = UDim.new(0, 8)

local ControlButtonsFrame = Instance.new("Frame", ControlFrame)
ControlButtonsFrame.Size = UDim2.new(1, 0, 0, 180)
ControlButtonsFrame.Position = UDim2.new(0, 0, 0, 150)
ControlButtonsFrame.BackgroundTransparency = 1

local ControlListLayout = Instance.new("UIListLayout", ControlButtonsFrame)
ControlListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ControlListLayout.Padding = UDim.new(0, 6)

local function CreateControlButton(text, color)
    local btn = Instance.new("TextButton", ControlButtonsFrame)
    btn.Size = UDim2.new(0.85, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = text
    btn.TextColor3 = color
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

local BtnCmdFling = CreateControlButton("Fling (تطيير): OFF", Color3.fromRGB(200, 200, 200))
local BtnCmdTp = CreateControlButton("Teleport (انتقال)", Color3.fromRGB(80, 200, 255))
local BtnCmdBring = CreateControlButton("Bring (سحب)", Color3.fromRGB(255, 200, 80))
local BtnCmdSpec = CreateControlButton("Spectate (مشاهدة)", Color3.fromRGB(100, 255, 100))
local BtnCmdScare = CreateControlButton("Scare (تخويف): OFF", Color3.fromRGB(200, 200, 200))

local isScaring = false
local isFlinging = false
local FlingLoop = nil

-- التحديد المضمون للألوان بالكروت
local function SetActiveTarget(plr)
    ActiveTarget = plr
    for userId, card in pairs(TargetCards) do
        local stroke = card:FindFirstChild("CardStroke")
        if plr and userId == plr.UserId then
            if stroke then stroke.Color = Color3.fromRGB(0, 255, 127) stroke.Thickness = 2 end
            card.BackgroundColor3 = Color3.fromRGB(20, 60, 30)
        else
            if stroke then stroke.Color = Color3.fromRGB(100, 100, 100) stroke.Thickness = 1 end
            card.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        end
    end
end

local SpecFrame = Instance.new("Frame")
local function StopSpectating()
    if SpectateLoop then SpectateLoop:Disconnect() SpectateLoop = nil end
    SpectatedPlayer = nil
    task.wait(0.1)
    local char = Player.Character
    if char and char:FindFirstChild("Humanoid") then
        workspace.CurrentCamera.CameraSubject = char.Humanoid
        workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
    end
    SpecFrame.Visible = false
    MainFrame.Visible = true
    ControlFrame.Visible = true
end

local function RemoveTarget(plr)
    if SelectedTargets[plr.UserId] then
        SelectedTargets[plr.UserId] = nil
        if TargetCards[plr.UserId] then
            TargetCards[plr.UserId]:Destroy()
            TargetCards[plr.UserId] = nil
        end
    end
    if SpectatedPlayer == plr then StopSpectating() end
    if ActiveTarget == plr then
        local nextTarget = nil
        for _, p in pairs(SelectedTargets) do nextTarget = p break end
        SetActiveTarget(nextTarget)
    end
    local count = 0
    for _ in pairs(SelectedTargets) do count = count + 1 end
    if count == 0 then ControlFrame.Visible = false end
end

local function AddTarget(plr)
    if SelectedTargets[plr.UserId] then RemoveTarget(plr) return end
    local count = 0
    for _ in pairs(SelectedTargets) do count = count + 1 end
    if count >= 3 then Notify("تنبيه", "الحد 3 أشخاص!", Color3.fromRGB(255, 50, 50)) return end

    SelectedTargets[plr.UserId] = plr
    ControlFrame.Visible = true

    local Card = Instance.new("TextButton", TargetsContainer)
    Card.Size = UDim2.new(0, 80, 0, 100)
    Card.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Card.Text = "" 
    Card.AutoButtonColor = false
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 8)
    
    local CStroke = Instance.new("UIStroke", Card)
    CStroke.Name = "CardStroke"
    CStroke.Color = Color3.fromRGB(100, 100, 100)
    CStroke.Thickness = 1

    TargetCards[plr.UserId] = Card
    Card.MouseButton1Click:Connect(function() SetActiveTarget(plr) end)

    local Img = Instance.new("ImageLabel", Card)
    Img.Size = UDim2.new(0, 60, 0, 60)
    Img.Position = UDim2.new(0.5, -30, 0, 10)
    Img.BackgroundTransparency = 1
    Img.Active = false
    Instance.new("UICorner", Img).CornerRadius = UDim.new(1, 0)
    
    -- جلب الصورة بشكل آمن للكروت
    pcall(function() 
        local imgContent, isReady = game.Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size150x150)
        Img.Image = imgContent 
    end)

    local NameLbl = Instance.new("TextLabel", Card)
    NameLbl.Size = UDim2.new(1, -4, 0, 20)
    NameLbl.Position = UDim2.new(0, 2, 0, 75)
    NameLbl.BackgroundTransparency = 1
    NameLbl.Text = plr.Name
    NameLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    NameLbl.Font = Enum.Font.GothamMedium
    NameLbl.TextSize = 10
    NameLbl.TextScaled = true
    NameLbl.Active = false

    local XBtn = Instance.new("TextButton", Card)
    XBtn.Size = UDim2.new(0, 20, 0, 20)
    XBtn.Position = UDim2.new(1, -20, 0, 0)
    XBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    XBtn.Text = "X"
    XBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    XBtn.Font = Enum.Font.GothamBold
    XBtn.ZIndex = 10 
    Instance.new("UICorner", XBtn).CornerRadius = UDim.new(0, 6)
    XBtn.MouseButton1Click:Connect(function() RemoveTarget(plr) end)
    
    SetActiveTarget(plr)
end

local BtnCloseControl = Instance.new("TextButton", ControlFrame)
BtnCloseControl.Size = UDim2.new(0, 25, 0, 25)
BtnCloseControl.Position = UDim2.new(1, -30, 0, 5)
BtnCloseControl.BackgroundTransparency = 1
BtnCloseControl.Text = "X"
BtnCloseControl.TextColor3 = Color3.fromRGB(200, 50, 50)
BtnCloseControl.Font = Enum.Font.GothamBold
BtnCloseControl.TextSize = 18
BtnCloseControl.MouseButton1Click:Connect(function()
    for _, plr in pairs(SelectedTargets) do RemoveTarget(plr) end
    ControlFrame.Visible = false 
end)

-- ==========================================
-- إعدادات واجهة السبكتيت
-- ==========================================
SpecFrame.Size = UDim2.new(0, 200, 0, 70)
SpecFrame.Position = UDim2.new(0.5, -100, 0.9, -80)
SpecFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
SpecFrame.BackgroundTransparency = 0.3
SpecFrame.Visible = false
SpecFrame.Parent = ScreenGui
Instance.new("UICorner", SpecFrame).CornerRadius = UDim.new(0, 10)

local SpecImage = Instance.new("ImageLabel", SpecFrame)
SpecImage.Size = UDim2.new(0, 50, 0, 50)
SpecImage.Position = UDim2.new(0, 10, 0.5, -25)
SpecImage.BackgroundTransparency = 1
Instance.new("UICorner", SpecImage).CornerRadius = UDim.new(1, 0)

local SpecName = Instance.new("TextLabel", SpecFrame)
SpecName.Size = UDim2.new(0, 100, 1, 0)
SpecName.Position = UDim2.new(0, 70, 0, 0)
SpecName.BackgroundTransparency = 1
SpecName.TextColor3 = Color3.fromRGB(255, 255, 255)
SpecName.Font = Enum.Font.GothamBold
SpecName.TextSize = 14
SpecName.TextXAlignment = Enum.TextXAlignment.Left

local SpecClose = Instance.new("TextButton", SpecFrame)
SpecClose.Size = UDim2.new(0, 30, 0, 30)
SpecClose.Position = UDim2.new(1, -40, 0.5, -15)
SpecClose.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
SpecClose.Text = "X"
SpecClose.TextColor3 = Color3.fromRGB(255, 255, 255)
SpecClose.Font = Enum.Font.GothamBold
SpecClose.TextSize = 16
Instance.new("UICorner", SpecClose).CornerRadius = UDim.new(0, 6)
SpecClose.MouseButton1Click:Connect(StopSpectating)

-- ==========================================
-- أوامر لوحة التحكم
-- ==========================================
BtnCmdTp.MouseButton1Click:Connect(function()
    local tPlayer = ActiveTarget
    if tPlayer and tPlayer.Character and tPlayer.Character:FindFirstChild("HumanoidRootPart") and Player.Character then
        Player.Character.HumanoidRootPart.CFrame = tPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
        Notify("Teleport", "تم الانتقال إلى " .. tPlayer.DisplayName)
    end
end)

BtnCmdBring.MouseButton1Click:Connect(function()
    local tPlayer = ActiveTarget
    if tPlayer and tPlayer.Character and tPlayer.Character:FindFirstChild("HumanoidRootPart") and Player.Character then
        local targetHRP = tPlayer.Character.HumanoidRootPart
        local myHRP = Player.Character:FindFirstChild("HumanoidRootPart")
        if myHRP then
            local myPos = myHRP.CFrame
            Notify("Bring", "سحب " .. tPlayer.DisplayName, Color3.fromRGB(255, 200, 80))
            local spinLoop = RunService.Heartbeat:Connect(function()
                myHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 1)
                myHRP.Velocity = (myPos.Position - targetHRP.Position).Unit * 100
            end)
            task.wait(1.5)
            if spinLoop then spinLoop:Disconnect() end
            myHRP.Velocity = Vector3.new(0,0,0)
            myHRP.CFrame = myPos
        end
    end
end)

BtnCmdSpec.MouseButton1Click:Connect(function()
    local tPlayer = ActiveTarget
    if tPlayer and tPlayer.Character and tPlayer.Character:FindFirstChild("Humanoid") then
        SpectatedPlayer = tPlayer
        workspace.CurrentCamera.CameraSubject = tPlayer.Character.Humanoid
        MainFrame.Visible = false
        ControlFrame.Visible = false
        SpecFrame.Visible = true
        SpecName.Text = tPlayer.DisplayName
        
        -- التصليح هنا: سحب الصورة بنفس طريقة الكروت عشان تضمن إنها تطلع 100٪
        pcall(function() 
            local imgContent, isReady = game.Players:GetUserThumbnailAsync(tPlayer.UserId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size150x150)
            SpecImage.Image = imgContent
        end)
        
        if SpectateLoop then SpectateLoop:Disconnect() end
        SpectateLoop = RunService.RenderStepped:Connect(function()
            if tPlayer and tPlayer.Character and tPlayer.Character:FindFirstChild("Humanoid") then
                workspace.CurrentCamera.CameraSubject = tPlayer.Character.Humanoid
            else
                StopSpectating()
            end
        end)
    end
end)

-- نظام التطيير
BtnCmdFling.MouseButton1Click:Connect(function()
    isFlinging = not isFlinging
    if isFlinging then
        BtnCmdFling.Text = "Fling (تطيير): ON"
        BtnCmdFling.TextColor3 = Color3.fromRGB(0, 255, 127)
        Notify("Fling", "تم تشغيل وضع الخلاط (الطيارة)!", Color3.fromRGB(0, 255, 127))
        
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local myHRP = Player.Character.HumanoidRootPart
            FlingLoop = RunService.Heartbeat:Connect(function()
                local tPlayer = ActiveTarget
                if tPlayer and tPlayer.Character and tPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local targetHRP = tPlayer.Character.HumanoidRootPart
                    local angle = tick() * 35 
                    local radius = 1.2
                    myHRP.CFrame = targetHRP.CFrame * CFrame.Angles(0, angle, 0) * CFrame.new(0, 0, -radius)
                    myHRP.Velocity = Vector3.new(5000, 5000, 5000)
                    myHRP.RotVelocity = Vector3.new(5000, 5000, 5000)
                end
            end)
        end
    else
        BtnCmdFling.Text = "Fling (تطيير): OFF"
        BtnCmdFling.TextColor3 = Color3.fromRGB(200, 200, 200)
        Notify("Fling", "تم إيقاف التطيير.", Color3.fromRGB(200, 200, 200))
        
        if FlingLoop then FlingLoop:Disconnect() FlingLoop = nil end
        
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local myHRP = Player.Character.HumanoidRootPart
            myHRP.Velocity = Vector3.new(0,0,0)
            myHRP.RotVelocity = Vector3.new(0,0,0)
        end
    end
end)

-- نظام التخويف السينمائي
BtnCmdScare.MouseButton1Click:Connect(function()
    isScaring = not isScaring
    if isScaring then
        BtnCmdScare.Text = "Scare (تخويف): ON"
        BtnCmdScare.TextColor3 = Color3.fromRGB(0, 255, 127)
        Notify("Scare", "بدأ سيناريو التخويف!", Color3.fromRGB(0, 255, 127))
        
        task.spawn(function()
            while isScaring do
                local tPlayer = ActiveTarget
                if tPlayer and tPlayer.Character and tPlayer.Character:FindFirstChild("HumanoidRootPart") and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                    local myHRP = Player.Character.HumanoidRootPart
                    local targetHRP = tPlayer.Character.HumanoidRootPart
                    
                    myHRP.Anchored = true 
                    
                    if not isScaring then break end
                    myHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, -2.5) * CFrame.Angles(0, math.pi, 0)
                    task.wait(2)
                    
                    if not isScaring then break end
                    myHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 200, 0)
                    task.wait(0.5)
                    
                    if not isScaring then break end
                    myHRP.CFrame = targetHRP.CFrame * CFrame.new(1.5, 0.5, 2) * CFrame.Angles(0, 0, 0)
                    task.wait(1.5)
                    
                    local randomDuration = math.random(6, 8)
                    local endTime = tick() + randomDuration
                    while tick() < endTime and isScaring do
                        if not (tPlayer.Character and tPlayer.Character:FindFirstChild("HumanoidRootPart")) then break end
                        local rx = math.random(-4, 4)
                        local rz = math.random(-4, 4)
                        myHRP.CFrame = targetHRP.CFrame * CFrame.new(rx, 0, rz)
                        task.wait(0.4)
                    end
                    
                    if not isScaring then break end
                    myHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, -2) * CFrame.Angles(0, math.pi, 0)
                    task.wait(1.5)
                else
                    task.wait(0.1)
                end
            end
            
            if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                Player.Character.HumanoidRootPart.Anchored = false
            end
        end)
    else
        BtnCmdScare.Text = "Scare (تخويف): OFF"
        BtnCmdScare.TextColor3 = Color3.fromRGB(200, 200, 200)
        Notify("Scare", "تم إيقاف التخويف.", Color3.fromRGB(200, 200, 200))
    end
end)

-- ==========================================
-- الأزرار الرئيسية وإعدادات السرعة الذكية
-- ==========================================
local Features = {
    Fly = false, FlyNoclip = false, GodMode = false, InfJump = false, Noclip = false, 
    InstantPrompt = false, SuperHit = false, AntiAFK = true, ControlWand = false, ESP = false,
    CustomSpeed = false, WalkSpeed = 100, CarSpeed = 100, FlySpeed = 100, CarFlySpeed = 100, 
    CustomJump = false, JumpValue = 100
}
local CurrentSpeedState = "Walk"

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

local BtnWand = CreateButton("Control Wand (أداة التحكم): OFF", ScrollFrame)
local BtnFly = CreateButton("Fly (Shift/Q/Z): OFF", ScrollFrame)
local BtnFlyNoclip = CreateButton("Fly Noclip (اختراق): OFF", ScrollFrame)
BtnFlyNoclip.Visible = false
local BtnESP = CreateButton("ESP (X-Ray - كشف): OFF", ScrollFrame)
local BtnGod = CreateButton("God Mode & No Ragdoll: OFF", ScrollFrame)
local BtnNoclip = CreateButton("Noclip (Anti-Rubberband): OFF", ScrollFrame)
local BtnInstant = CreateButton("Instant Interact (No Hold): OFF", ScrollFrame)
local BtnSuperHit = CreateButton("Super Hero Hit (Fling): OFF", ScrollFrame)
local BtnInfJump = CreateButton("Infinite Jump: OFF", ScrollFrame)
local BtnAntiAFK = CreateButton("Anti-AFK: ON", ScrollFrame)
BtnAntiAFK.TextColor3 = Color3.fromRGB(0, 255, 127)

local BtnSpeed, BoxSpeed = CreateInputRow("Walk Speed: OFF", 100, ScrollFrame)
local BtnJump, BoxJump = CreateInputRow("Jump Power: OFF", 100, ScrollFrame)

local function UpdateSpeedDisplay()
    local prefix = ""
    local val = 50
    if CurrentSpeedState == "Walk" then
        prefix = "Walk Speed"
        val = Features.WalkSpeed
    elseif CurrentSpeedState == "Car" then
        prefix = "Car Speed"
        val = Features.CarSpeed
    elseif CurrentSpeedState == "Fly" then
        prefix = "Fly Speed"
        val = Features.FlySpeed
    elseif CurrentSpeedState == "CarFly" then
        prefix = "Car Fly Speed"
        val = Features.CarFlySpeed
    end
    
    BtnSpeed.Text = prefix .. (Features.CustomSpeed and ": ON" or ": OFF")
    BoxSpeed.Text = tostring(val)
end

-- ==========================================
-- الأنظمة (Loops & Functions)
-- ==========================================

local ESPLoop = nil
BtnESP.MouseButton1Click:Connect(function()
    Features.ESP = not Features.ESP
    BtnESP.Text = Features.ESP and "ESP (X-Ray - كشف): ON" or "ESP (X-Ray - كشف): OFF"
    BtnESP.TextColor3 = Features.ESP and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(200, 200, 200)
    
    if Features.ESP then
        ESPLoop = RunService.RenderStepped:Connect(function()
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    if not p.Character:FindFirstChild("ZokoESP_Highlight") then
                        local hl = Instance.new("Highlight")
                        hl.Name = "ZokoESP_Highlight"
                        hl.FillTransparency = 0.8
                        hl.FillColor = Color3.fromRGB(255, 0, 0)
                        hl.OutlineColor = Color3.fromRGB(255, 0, 0)
                        hl.OutlineTransparency = 0
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        hl.Parent = p.Character
                    end
                    if not p.Character:FindFirstChild("ZokoESP_Name") then
                        local bg = Instance.new("BillboardGui")
                        bg.Name = "ZokoESP_Name"
                        bg.Size = UDim2.new(0, 200, 0, 50)
                        bg.StudsOffset = Vector3.new(0, 3.5, 0)
                        bg.AlwaysOnTop = true
                        local txt = Instance.new("TextLabel")
                        txt.Size = UDim2.new(1, 0, 1, 0)
                        txt.BackgroundTransparency = 1
                        txt.Text = p.Name
                        txt.TextColor3 = Color3.fromRGB(255, 255, 255)
                        txt.TextStrokeTransparency = 0
                        txt.TextStrokeColor3 = Color3.fromRGB(255, 0, 0)
                        txt.Font = Enum.Font.GothamBlack
                        txt.TextSize = 14
                        txt.Parent = bg
                        bg.Parent = p.Character
                    end
                end
            end
        end)
    else
        if ESPLoop then ESPLoop:Disconnect() end
        for _, p in pairs(game.Players:GetPlayers()) do
            if p.Character then
                if p.Character:FindFirstChild("ZokoESP_Highlight") then p.Character.ZokoESP_Highlight:Destroy() end
                if p.Character:FindFirstChild("ZokoESP_Name") then p.Character.ZokoESP_Name:Destroy() end
            end
        end
    end
end)

local function GetTopVehicle(seatPart)
    local topModel = seatPart
    local current = seatPart
    while current and current.Parent and current.Parent ~= workspace do
        current = current.Parent
        if current:IsA("Model") then topModel = current end
    end
    return topModel
end

BtnWand.MouseButton1Click:Connect(function()
    Features.ControlWand = not Features.ControlWand
    BtnWand.Text = Features.ControlWand and "Control Wand (أداة التحكم): ON" or "Control Wand (أداة التحكم): OFF"
    BtnWand.TextColor3 = Features.ControlWand and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(200, 200, 200)
    
    CleanupWands() 
    
    if Features.ControlWand then
        local currentWand = Instance.new("Tool")
        currentWand.RequiresHandle = false
        currentWand.CanBeDropped = false
        currentWand.Name = "Zoko Control"
        currentWand.ToolTip = "اضغط على لاعب لإضافته/حذفه (الحد 3)"
        currentWand.TextureId = "rbxassetid://100414902"
        currentWand.Parent = Player.Backpack
        currentWand.Activated:Connect(function()
            local target = Mouse.Target
            if target and target.Parent then
                local model = target.Parent
                if not model:FindFirstChild("Humanoid") then model = model.Parent end
                if model and model:FindFirstChild("Humanoid") then
                    local plr = game.Players:GetPlayerFromCharacter(model)
                    if plr and plr ~= Player then AddTarget(plr) end
                end
            end
        end)
        local count = 0
        for _ in pairs(SelectedTargets) do count = count + 1 end
        if count > 0 then ControlFrame.Visible = true end
    else
        ControlFrame.Visible = false
    end
end)

local FlyLoop, bg, bv, FlyNoclipLoop
BtnFly.MouseButton1Click:Connect(function()
    Features.Fly = not Features.Fly
    BtnFly.Text = Features.Fly and "Fly (Shift/Q/Z): ON" or "Fly (Shift/Q/Z): OFF"
    BtnFly.TextColor3 = Features.Fly and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(200, 200, 200)
    local char = Player.Character
    if not char then return end

    BtnFlyNoclip.Visible = Features.Fly
    local targetPart = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChild("Humanoid")
    local isVehicle = false
    
    if humanoid and humanoid.SeatPart then
        isVehicle = true
        local topVehicle = GetTopVehicle(humanoid.SeatPart)
        targetPart = topVehicle.PrimaryPart or humanoid.SeatPart
    end
    if not targetPart then return end

    if Features.Fly then
        if not isVehicle then char.Humanoid.PlatformStand = true end
        bg = Instance.new("BodyGyro", targetPart)
        bg.P = 9e5 bg.D = 2000 bg.maxTorque = Vector3.new(math.huge, math.huge, math.huge) bg.cframe = targetPart.CFrame
        bv = Instance.new("BodyVelocity", targetPart)
        bv.velocity = Vector3.new(0, 0, 0) bv.maxForce = Vector3.new(math.huge, math.huge, math.huge)

        FlyLoop = RunService.RenderStepped:Connect(function()
            local cam = workspace.CurrentCamera
            local move = Vector3.new(0,0,0)
            
            local speed = isVehicle and Features.CarFlySpeed or Features.FlySpeed
            
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then speed = speed * 3 end 
            if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Q) then move = move + Vector3.new(0, 1, 0) end 
            if UIS:IsKeyDown(Enum.KeyCode.Z) then move = move - Vector3.new(0, 1, 0) end 
            
            if isVehicle then
                local rx, ry, rz = cam.CFrame:ToOrientation()
                bg.cframe = CFrame.new(targetPart.Position) * CFrame.Angles(rx, ry, 0)
            else bg.cframe = cam.CFrame end
            
            if move.Magnitude > 0 then bv.velocity = move.Unit * speed else bv.velocity = Vector3.new(0, 0, 0) end
        end)
    else
        if not isVehicle then char.Humanoid.PlatformStand = false end
        if bg then bg:Destroy() end if bv then bv:Destroy() end
        if FlyLoop then FlyLoop:Disconnect() end
        
        if Features.FlyNoclip then
            Features.FlyNoclip = false
            BtnFlyNoclip.Text = "Fly Noclip (اختراق): OFF"
            BtnFlyNoclip.TextColor3 = Color3.fromRGB(200, 200, 200)
            if FlyNoclipLoop then FlyNoclipLoop:Disconnect() end
            
            if Player.Character then
                for _, part in pairs(Player.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = true end end
                local hum = Player.Character:FindFirstChild("Humanoid")
                if hum and hum.SeatPart then
                    local fullVehicle = GetTopVehicle(hum.SeatPart)
                    if fullVehicle then for _, part in pairs(fullVehicle:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = true end end end
                end
            end
        end
    end
end)

BtnFlyNoclip.MouseButton1Click:Connect(function()
    if not Features.Fly then return end
    Features.FlyNoclip = not Features.FlyNoclip
    BtnFlyNoclip.Text = Features.FlyNoclip and "Fly Noclip (اختراق): ON" or "Fly Noclip (اختراق): OFF"
    BtnFlyNoclip.TextColor3 = Features.FlyNoclip and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(200, 200, 200)
    
    if Features.FlyNoclip then
        FlyNoclipLoop = RunService.Stepped:Connect(function()
            if Features.Fly and Player.Character then
                for _, part in pairs(Player.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end
                local hum = Player.Character:FindFirstChild("Humanoid")
                if hum and hum.SeatPart then
                    local fullVehicle = GetTopVehicle(hum.SeatPart)
                    if fullVehicle then for _, part in pairs(fullVehicle:GetDescendants()) do if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end end end
                end
            end
        end)
    else
        if FlyNoclipLoop then FlyNoclipLoop:Disconnect() end
        if Player.Character then
            for _, part in pairs(Player.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = true end end
            local hum = Player.Character:FindFirstChild("Humanoid")
            if hum and hum.SeatPart then
                local fullVehicle = GetTopVehicle(hum.SeatPart)
                if fullVehicle then for _, part in pairs(fullVehicle:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = true end end end
            end
        end
    end
end)

local lastNoclipPos = nil
local NoclipLoop = RunService.Stepped:Connect(function()
    if Features.Noclip and not Features.Fly and Player.Character then
        local hrp = Player.Character:FindFirstChild("HumanoidRootPart")
        local hum = Player.Character:FindFirstChild("Humanoid")
        for _, part in pairs(Player.Character:GetDescendants()) do if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end end
        if hrp and hum and hum.Health > 0 then
            if lastNoclipPos then
                local dist = (hrp.Position - lastNoclipPos).Magnitude
                if dist > 10 and dist < 80 then hrp.CFrame = CFrame.new(lastNoclipPos) end
            end
            lastNoclipPos = hrp.Position
            hum:ChangeState(11) 
        end
    else 
        lastNoclipPos = nil 
    end
end)

local RenderLoop = RunService.RenderStepped:Connect(function()
    local char = Player.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum then return end

    if Features.GodMode then
        pcall(function()
            hum.Health = hum.MaxHealth
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            local currentState = hum:GetState()
            if currentState == Enum.HumanoidStateType.Ragdoll or currentState == Enum.HumanoidStateType.FallingDown then
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
            if hrp then hrp.CustomPhysicalProperties = PhysicalProperties.new(100, 0.3, 0.5, 1, 1) end
        end)
    else pcall(function() if hrp then hrp.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0.5, 1, 1) end end) end

    local isVehicle = hum.SeatPart ~= nil
    
    local newState = "Walk"
    if Features.Fly then
        newState = isVehicle and "CarFly" or "Fly"
    else
        newState = isVehicle and "Car" or "Walk"
    end
    
    if CurrentSpeedState ~= newState then
        CurrentSpeedState = newState
        UpdateSpeedDisplay()
    end

    if Features.CustomSpeed then
        BtnSpeed.TextColor3 = Color3.fromRGB(0, 255, 127)
        if newState == "Car" then
            local seat = hum.SeatPart
            if seat and seat:IsA("VehicleSeat") then
                seat.MaxSpeed = Features.CarSpeed
                local vel = seat.AssemblyLinearVelocity
                if UIS:IsKeyDown(Enum.KeyCode.W) then
                    local dir = seat.CFrame.LookVector * Features.CarSpeed
                    seat.AssemblyLinearVelocity = Vector3.new(dir.X, vel.Y, dir.Z)
                elseif UIS:IsKeyDown(Enum.KeyCode.S) then
                    local dir = seat.CFrame.LookVector * -Features.CarSpeed
                    seat.AssemblyLinearVelocity = Vector3.new(dir.X, vel.Y, dir.Z)
                end
            end
        elseif newState == "Walk" then
            hum.WalkSpeed = Features.WalkSpeed
        end
    else
        BtnSpeed.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
    
    if Features.CustomJump then hum.UseJumpPower = true hum.JumpPower = Features.JumpValue end
end)

BtnSpeed.MouseButton1Click:Connect(function()
    Features.CustomSpeed = not Features.CustomSpeed
    UpdateSpeedDisplay()
    
    if not Features.CustomSpeed and Player.Character and Player.Character:FindFirstChild("Humanoid") then 
        Player.Character.Humanoid.WalkSpeed = 16 
    end
end)

BoxSpeed.FocusLost:Connect(function() 
    local val = tonumber(BoxSpeed.Text) or 50
    if CurrentSpeedState == "Walk" then Features.WalkSpeed = val
    elseif CurrentSpeedState == "Car" then Features.CarSpeed = val
    elseif CurrentSpeedState == "Fly" then Features.FlySpeed = val
    elseif CurrentSpeedState == "CarFly" then Features.CarFlySpeed = val
    end
    UpdateSpeedDisplay()
end)

local InstantInteractLoop
BtnInstant.MouseButton1Click:Connect(function()
    Features.InstantInteract = not Features.InstantInteract
    BtnInstant.Text = Features.InstantInteract and "Instant Interact (No Hold): ON" or "Instant Interact (No Hold): OFF"
    BtnInstant.TextColor3 = Features.InstantInteract and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(200, 200, 200)
    if Features.InstantInteract then
        InstantInteractLoop = RunService.Heartbeat:Connect(function()
            for _, obj in pairs(workspace:GetDescendants()) do if obj:IsA("ProximityPrompt") then obj.HoldDuration = 0 end end
        end)
    else if InstantInteractLoop then InstantInteractLoop:Disconnect() InstantInteractLoop = nil end end
end)

BtnGod.MouseButton1Click:Connect(function()
    Features.GodMode = not Features.GodMode
    BtnGod.Text = Features.GodMode and "God Mode & No Ragdoll: ON" or "God Mode & No Ragdoll: OFF"
    BtnGod.TextColor3 = Features.GodMode and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(200, 200, 200)
end)

BtnNoclip.MouseButton1Click:Connect(function()
    Features.Noclip = not Features.Noclip
    BtnNoclip.Text = Features.Noclip and "Noclip (Anti-Rubberband): ON" or "Noclip (Anti-Rubberband): OFF"
    BtnNoclip.TextColor3 = Features.Noclip and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(200, 200, 200)
    
    if not Features.Noclip and Player.Character then
        for _, part in pairs(Player.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = true end end
    end
end)

BtnSuperHit.MouseButton1Click:Connect(function()
    Features.SuperHit = not Features.SuperHit
    BtnSuperHit.Text = Features.SuperHit and "Super Hero Hit (Fling): ON" or "Super Hero Hit (Fling): OFF"
    BtnSuperHit.TextColor3 = Features.SuperHit and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(200, 200, 200)
end)

BtnInfJump.MouseButton1Click:Connect(function()
    Features.InfJump = not Features.InfJump
    BtnInfJump.Text = Features.InfJump and "Infinite Jump: ON" or "Infinite Jump: OFF"
    BtnInfJump.TextColor3 = Features.InfJump and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(200, 200, 200)
end)

local JumpLoop = UIS.JumpRequest:Connect(function()
    if Features.InfJump and Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
        Player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    elseif Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
        local floor = Player.Character:FindFirstChildOfClass("Humanoid").FloorMaterial
        if floor ~= Enum.Material.Air then Player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

Player.Idled:Connect(function()
    if Features.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            Notify("Anti-AFK", "تم منع طردك من اللعبة وجعلك تقفز!", Color3.fromRGB(0, 255, 127))
        end
    end
end)

BtnAntiAFK.MouseButton1Click:Connect(function()
    Features.AntiAFK = not Features.AntiAFK
    BtnAntiAFK.Text = Features.AntiAFK and "Anti-AFK: ON" or "Anti-AFK: OFF"
    BtnAntiAFK.TextColor3 = Features.AntiAFK and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(200, 200, 200)
end)

BtnJump.MouseButton1Click:Connect(function()
    Features.CustomJump = not Features.CustomJump
    BtnJump.Text = Features.CustomJump and "Jump Power: ON" or "Jump Power: OFF"
    BtnJump.TextColor3 = Features.CustomJump and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(200, 200, 200)
    if not Features.CustomJump and Player.Character then Player.Character.Humanoid.UseJumpPower = false end
end)
BoxJump.FocusLost:Connect(function() Features.JumpValue = tonumber(BoxJump.Text) or 100 end)

local DevBtn = Instance.new("TextButton")
DevBtn.Size = UDim2.new(1, 0, 0, 25)
DevBtn.Position = UDim2.new(0, 0, 1, -45)
DevBtn.BackgroundTransparency = 1
DevBtn.RichText = true
DevBtn.Text = [[Developed by <font color="rgb(0, 212, 255)"><b>Zoko</b></font>]]
DevBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
DevBtn.Font = Enum.Font.GothamMedium
DevBtn.TextSize = 14
DevBtn.Parent = MainFrame

DevBtn.MouseButton1Click:Connect(function()
    local site = "http://45.137.98.42:5000/"
    if setclipboard then
        setclipboard(site) Notify("Zoko Link Copied!", "تم نسخ الرابط بنجاح!")
    else Notify("Zoko Site", "الرابط: " .. site) end
end)

local RestartBtn = Instance.new("TextButton")
RestartBtn.Size = UDim2.new(1, 0, 0, 20)
RestartBtn.Position = UDim2.new(0, 0, 1, -22)
RestartBtn.BackgroundTransparency = 1
RestartBtn.Text = "RESTART"
RestartBtn.TextColor3 = Color3.fromRGB(0, 212, 255)
RestartBtn.Font = Enum.Font.GothamBlack
RestartBtn.TextSize = 16
RestartBtn.Parent = MainFrame

local RestartGlow = Instance.new("UIStroke")
RestartGlow.Color = Color3.fromRGB(0, 212, 255)
RestartGlow.Transparency = 0.5
RestartGlow.Thickness = 0.6
RestartGlow.Parent = RestartBtn

RestartBtn.MouseButton1Click:Connect(function()
    CleanupWands()
    if RenderLoop then RenderLoop:Disconnect() end
    if NoclipLoop then NoclipLoop:Disconnect() end
    if InstantInteractLoop then InstantInteractLoop:Disconnect() end
    if JumpLoop then JumpLoop:Disconnect() end
    if SpectateLoop then SpectateLoop:Disconnect() end
    if FlyLoop then FlyLoop:Disconnect() end
    if FlyNoclipLoop then FlyNoclipLoop:Disconnect() end
    if ESPLoop then ESPLoop:Disconnect() end
    if bg then bg:Destroy() end
    if bv then bv:Destroy() end
    
    workspace.CurrentCamera.CameraSubject = Player.Character:WaitForChild("Humanoid")
    ScreenGui:Destroy()
    
    pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Ray2133231/Zoko2/main/main.lua"))() end)
end)

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
MakeDraggable(OpenBtn)

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

MainFrame:TweenSize(UDim2.new(0, 270, 0, 400), "Out", "Back", 0.6, true)
