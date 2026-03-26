-- [[ Zoko Hub V8 - The Controller Edition (Fly, Control Wand, Spectate) ]]

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
Title.Text = "ZOKO HUB V8"
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
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 550)
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
-- لوحة التحكم باللاعبين والمشاهدة (Spectate & Control)
-- ==========================================
local TargetPlayer = nil
local SpectateLoop = nil

-- لوحة التحكم المنبثقة
local ControlFrame = Instance.new("Frame")
ControlFrame.Size = UDim2.new(0, 250, 0, 300)
ControlFrame.Position = UDim2.new(0.5, 150, 0.5, -150)
ControlFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ControlFrame.Visible = false
ControlFrame.Parent = ScreenGui
Instance.new("UICorner", ControlFrame).CornerRadius = UDim.new(0, 12)
local CStroke = Instance.new("UIStroke", ControlFrame)
CStroke.Color = Color3.fromRGB(255, 100, 100)
CStroke.Thickness = 2
MakeDraggable(ControlFrame)

local TargetImage = Instance.new("ImageLabel", ControlFrame)
TargetImage.Size = UDim2.new(0, 80, 0, 80)
TargetImage.Position = UDim2.new(0.5, -40, 0, 15)
TargetImage.BackgroundTransparency = 1
Instance.new("UICorner", TargetImage).CornerRadius = UDim.new(1, 0)

local TargetDisplay = Instance.new("TextLabel", ControlFrame)
TargetDisplay.Size = UDim2.new(1, 0, 0, 20)
TargetDisplay.Position = UDim2.new(0, 0, 0, 100)
TargetDisplay.BackgroundTransparency = 1
TargetDisplay.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetDisplay.Font = Enum.Font.GothamBold
TargetDisplay.TextSize = 16

local TargetUser = Instance.new("TextLabel", ControlFrame)
TargetUser.Size = UDim2.new(1, 0, 0, 15)
TargetUser.Position = UDim2.new(0, 0, 0, 120)
TargetUser.BackgroundTransparency = 1
TargetUser.TextColor3 = Color3.fromRGB(150, 150, 150)
TargetUser.Font = Enum.Font.GothamMedium
TargetUser.TextSize = 12

local function CreateControlButton(text, pos, color)
    local btn = Instance.new("TextButton", ControlFrame)
    btn.Size = UDim2.new(0.8, 0, 0, 30)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = text
    btn.TextColor3 = color
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

local BtnCmdFling = CreateControlButton("Fling (تطيير)", UDim2.new(0.1, 0, 0, 145), Color3.fromRGB(255, 80, 80))
local BtnCmdTp = CreateControlButton("Teleport (انتقال)", UDim2.new(0.1, 0, 0, 180), Color3.fromRGB(80, 200, 255))
local BtnCmdBring = CreateControlButton("Bring (سحب فيزيائي)", UDim2.new(0.1, 0, 0, 215), Color3.fromRGB(255, 200, 80))
local BtnCmdSpec = CreateControlButton("Spectate (مشاهدة)", UDim2.new(0.1, 0, 0, 250), Color3.fromRGB(100, 255, 100))

local BtnCloseControl = Instance.new("TextButton", ControlFrame)
BtnCloseControl.Size = UDim2.new(0, 25, 0, 25)
BtnCloseControl.Position = UDim2.new(1, -30, 0, 5)
BtnCloseControl.BackgroundTransparency = 1
BtnCloseControl.Text = "X"
BtnCloseControl.TextColor3 = Color3.fromRGB(200, 50, 50)
BtnCloseControl.Font = Enum.Font.GothamBold
BtnCloseControl.TextSize = 18
BtnCloseControl.MouseButton1Click:Connect(function() ControlFrame.Visible = false end)

-- لوحة المشاهدة (Spectate UI) - تحت في النص
local SpecFrame = Instance.new("Frame")
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
SpecClose.BackgroundColor3 = Color3.fromRGB(100, 100, 100) -- رصاصي
SpecClose.Text = "X"
SpecClose.TextColor3 = Color3.fromRGB(255, 255, 255)
SpecClose.Font = Enum.Font.GothamBold
SpecClose.TextSize = 16
Instance.new("UICorner", SpecClose).CornerRadius = UDim.new(0, 6)

-- أنيميشن زر الإغلاق في المشاهدة
SpecClose.MouseEnter:Connect(function()
    TweenService:Create(SpecClose, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 50, 50), Size = UDim2.new(0, 34, 0, 34), Position = UDim2.new(1, -42, 0.5, -17)}):Play()
end)
SpecClose.MouseLeave:Connect(function()
    TweenService:Create(SpecClose, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100, 100, 100), Size = UDim2.new(0, 30, 0, 30), Position = UDim2.new(1, -40, 0.5, -15)}):Play()
end)

local function StopSpectating()
    if SpectateLoop then SpectateLoop:Disconnect() SpectateLoop = nil end
    workspace.CurrentCamera.CameraSubject = Player.Character:WaitForChild("Humanoid")
    SpecFrame.Visible = false
    MainFrame.Visible = true
    ControlFrame.Visible = true
end
SpecClose.MouseButton1Click:Connect(StopSpectating)

local function OpenControlPanel(plr)
    TargetPlayer = plr
    TargetDisplay.Text = plr.DisplayName
    TargetUser.Text = "@" .. plr.Name
    pcall(function()
        TargetImage.Image = game.Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.AvatarHeadShot, Enum.ThumbnailSize.Size150x150)
        SpecImage.Image = TargetImage.Image
    end)
    SpecName.Text = plr.DisplayName
    ControlFrame.Visible = true
end

-- أوامر لوحة التحكم
BtnCmdTp.MouseButton1Click:Connect(function()
    if TargetPlayer and TargetPlayer.Character and TargetPlayer.Character:FindFirstChild("HumanoidRootPart") and Player.Character then
        Player.Character.HumanoidRootPart.CFrame = TargetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
        Notify("Teleport", "تم الانتقال إلى " .. TargetPlayer.DisplayName)
    end
end)

BtnCmdFling.MouseButton1Click:Connect(function()
    if TargetPlayer and TargetPlayer.Character and TargetPlayer.Character:FindFirstChild("HumanoidRootPart") and Player.Character then
        local targetHRP = TargetPlayer.Character.HumanoidRootPart
        local myHRP = Player.Character:FindFirstChild("HumanoidRootPart")
        if myHRP then
            local startPos = myHRP.CFrame
            local spinLoop
            Notify("Fling", "جاري تطيير " .. TargetPlayer.DisplayName .. "...", Color3.fromRGB(255, 50, 50))
            
            spinLoop = RunService.Heartbeat:Connect(function()
                myHRP.CFrame = targetHRP.CFrame
                myHRP.Velocity = Vector3.new(0, 50, 0)
                myHRP.RotVelocity = Vector3.new(10000, 10000, 10000) -- دوران خارق لضربه
            end)
            
            task.wait(1.5) -- يطيره لمدة ثانية ونص
            if spinLoop then spinLoop:Disconnect() end
            myHRP.Velocity = Vector3.new(0,0,0)
            myHRP.RotVelocity = Vector3.new(0,0,0)
            myHRP.CFrame = startPos -- يرجعك لمكانك
        end
    end
end)

BtnCmdBring.MouseButton1Click:Connect(function()
    -- السحب الفيزيائي (يطيره لجهتك بقوة)
    if TargetPlayer and TargetPlayer.Character and TargetPlayer.Character:FindFirstChild("HumanoidRootPart") and Player.Character then
        local targetHRP = TargetPlayer.Character.HumanoidRootPart
        local myHRP = Player.Character:FindFirstChild("HumanoidRootPart")
        if myHRP then
            local myPos = myHRP.CFrame
            local spinLoop
            Notify("Bring", "محاولة سحب " .. TargetPlayer.DisplayName .. " لك...", Color3.fromRGB(255, 200, 80))
            
            spinLoop = RunService.Heartbeat:Connect(function()
                myHRP.CFrame = targetHRP.CFrame * CFrame.new(0, -1, 0)
                myHRP.Velocity = (myPos.Position - targetHRP.Position).Unit * 150 + Vector3.new(0, 50, 0)
            end)
            
            task.wait(1) 
            if spinLoop then spinLoop:Disconnect() end
            myHRP.Velocity = Vector3.new(0,0,0)
            myHRP.CFrame = myPos
        end
    end
end)

BtnCmdSpec.MouseButton1Click:Connect(function()
    if TargetPlayer and TargetPlayer.Character and TargetPlayer.Character:FindFirstChild("Humanoid") then
        workspace.CurrentCamera.CameraSubject = TargetPlayer.Character.Humanoid
        MainFrame.Visible = false
        ControlFrame.Visible = false
        SpecFrame.Visible = true
        Notify("Spectate", "أنت الآن تشاهد " .. TargetPlayer.DisplayName)
        
        -- تأكد أنه يكمل مشاهدة لو الشخص رسبن
        if SpectateLoop then SpectateLoop:Disconnect() end
        SpectateLoop = RunService.RenderStepped:Connect(function()
            if TargetPlayer and TargetPlayer.Character and TargetPlayer.Character:FindFirstChild("Humanoid") then
                workspace.CurrentCamera.CameraSubject = TargetPlayer.Character.Humanoid
            else
                StopSpectating()
                Notify("Spectate", "اللاعب مات أو طلع من اللعبة.", Color3.fromRGB(255, 50, 50))
            end
        end)
    end
end)


-- ==========================================
-- الأزرار الرئيسية والميزات الأساسية
-- ==========================================
local Features = {
    Fly = false, GodMode = false, InfJump = false, Noclip = false, 
    InstantPrompt = false, SuperHit = false, AntiAFK = true, ControlWand = false,
    CustomSpeed = false, SpeedValue = 50, CustomJump = false, JumpValue = 100
}

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
local BtnGod = CreateButton("God Mode & No Ragdoll: OFF", ScrollFrame)
local BtnNoclip = CreateButton("Noclip (Anti-Rubberband): OFF", ScrollFrame)
local BtnInstant = CreateButton("Instant Interact (No Hold): OFF", ScrollFrame)
local BtnSuperHit = CreateButton("Super Hero Hit (Fling): OFF", ScrollFrame)
local BtnInfJump = CreateButton("Infinite Jump: OFF", ScrollFrame)
local BtnAntiAFK = CreateButton("Anti-AFK: ON", ScrollFrame)
BtnAntiAFK.TextColor3 = Color3.fromRGB(0, 255, 127)

local BtnSpeed, BoxSpeed = CreateInputRow("Walk Speed: OFF", 50, ScrollFrame)
local BtnJump, BoxJump = CreateInputRow("Jump Power: OFF", 100, ScrollFrame)

-- ==========================================
-- الأنظمة (Loops)
-- ==========================================

-- نظام عصا التحكم (Control Wand)
local currentWand = nil
BtnWand.MouseButton1Click:Connect(function()
    Features.ControlWand = not Features.ControlWand
    BtnWand.Text = Features.ControlWand and "Control Wand (أداة التحكم): ON" or "Control Wand (أداة التحكم): OFF"
    BtnWand.TextColor3 = Features.ControlWand and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(200, 200, 200)
    
    if Features.ControlWand then
        currentWand = Instance.new("Tool")
        currentWand.RequiresHandle = false
        currentWand.Name = "Zoko Control"
        currentWand.ToolTip = "اضغط على لاعب لفتح لوحة التحكم"
        currentWand.TextureId = "rbxassetid://100414902" -- أيقونة علم/صولجان
        currentWand.Parent = Player.Backpack
        
        currentWand.Activated:Connect(function()
            local target = Mouse.Target
            if target and target.Parent then
                local model = target.Parent
                if not model:FindFirstChild("Humanoid") then model = model.Parent end
                
                if model and model:FindFirstChild("Humanoid") then
                    local plr = game.Players:GetPlayerFromCharacter(model)
                    if plr and plr ~= Player then
                        OpenControlPanel(plr)
                    end
                end
            end
        end)
    else
        if currentWand then currentWand:Destroy() currentWand = nil end
        ControlFrame.Visible = false
    end
end)

-- نظام الطيران (Fly)
local FlyLoop
BtnFly.MouseButton1Click:Connect(function()
    Features.Fly = not Features.Fly
    BtnFly.Text = Features.Fly and "Fly (Shift/Q/Z): ON" or "Fly (Shift/Q/Z): OFF"
    BtnFly.TextColor3 = Features.Fly and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(200, 200, 200)
    
    local char = Player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if Features.Fly then
        char.Humanoid.PlatformStand = true
        FlyLoop = RunService.RenderStepped:Connect(function()
            local cam = workspace.CurrentCamera
            local move = Vector3.new(0,0,0)
            local speed = 2.0 
            
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then speed = 8.0 end 
            
            if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Q) then move = move + Vector3.new(0,1,0) end -- Q فوق
            if UIS:IsKeyDown(Enum.KeyCode.Z) then move = move - Vector3.new(0,1,0) end -- Z تحت
            
            hrp.Velocity = Vector3.new(0,0,0)
            hrp.CFrame = hrp.CFrame + (move * speed)
        end)
    else
        char.Humanoid.PlatformStand = false
        if FlyLoop then FlyLoop:Disconnect() end
    end
end)

-- نظام Noclip المضاد للإرجاع
local lastNoclipPos = nil
local NoclipLoop = RunService.Stepped:Connect(function()
    if Features.Noclip and Player.Character then
        local hrp = Player.Character:FindFirstChild("HumanoidRootPart")
        local hum = Player.Character:FindFirstChild("Humanoid")
        for _, part in pairs(Player.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
        end
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

-- نظام Super Hit (Fling)
local FlingConnections = {}
local function EnableFlingOnTool(tool)
    if not tool or not tool:FindFirstChild("Handle") then return end
    local handle = tool.Handle
    local conn = handle.Touched:Connect(function(hit)
        if Features.SuperHit and hit.Parent and hit.Parent:FindFirstChild("Humanoid") and hit.Parent.Name ~= Player.Name then
            local enemyHRP = hit.Parent:FindFirstChild("HumanoidRootPart")
            if enemyHRP then
                enemyHRP.Velocity = Vector3.new(0, 500, 0) + (enemyHRP.Position - handle.Position).Unit * 5000
                enemyHRP.RotVelocity = Vector3.new(9999, 9999, 9999)
            end
        end
    end)
    table.insert(FlingConnections, conn)
end

Player.CharacterAdded:Connect(function(char)
    char.ChildAdded:Connect(function(child)
        if child:IsA("Tool") and Features.SuperHit then EnableFlingOnTool(child) end
    end)
end)

local SuperHitLoop = RunService.Heartbeat:Connect(function()
    if Features.SuperHit and Player.Character then
        local tool = Player.Character:FindFirstChildOfClass("Tool")
        if tool and #FlingConnections == 0 then
            EnableFlingOnTool(tool)
        elseif not tool and #FlingConnections > 0 then
             for _, conn in pairs(FlingConnections) do conn:Disconnect() end
             FlingConnections = {}
        end
    end
end)

-- نظام القود مود المضاد للطيحة (Anti-Ragdoll Force Stand)
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
    else
        pcall(function() if hrp then hrp.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0.5, 1, 1) end end)
    end

    if Features.CustomSpeed then hum.WalkSpeed = Features.SpeedValue end
    if Features.CustomJump then hum.UseJumpPower = true hum.JumpPower = Features.JumpValue end
end)

-- نظام Instant Interact
local InstantInteractLoop
local function ToggleInstantInteract()
    if Features.InstantInteract then
        InstantInteractLoop = RunService.Heartbeat:Connect(function()
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("ProximityPrompt") then obj.HoldDuration = 0 end
            end
        end)
    else
        if InstantInteractLoop then InstantInteractLoop:Disconnect() InstantInteractLoop = nil end
    end
end

BtnInstant.MouseButton1Click:Connect(function()
    Features.InstantInteract = not Features.InstantInteract
    BtnInstant.Text = Features.InstantInteract and "Instant Interact (No Hold): ON" or "Instant Interact (No Hold): OFF"
    BtnInstant.TextColor3 = Features.InstantInteract and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(200, 200, 200)
    ToggleInstantInteract()
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
end)

BtnSuperHit.MouseButton1Click:Connect(function()
    Features.SuperHit = not Features.SuperHit
    BtnSuperHit.Text = Features.SuperHit and "Super Hero Hit (Fling): ON" or "Super Hero Hit (Fling): OFF"
    BtnSuperHit.TextColor3 = Features.SuperHit and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(200, 200, 200)
    if Features.SuperHit then Notify("Super Hit Activated", "امسك أي سلاح واضرب اللاعبين عشان يطيرون!", Color3.fromRGB(255, 100, 100)) end
end)

BtnInfJump.MouseButton1Click:Connect(function()
    Features.InfJump = not Features.InfJump
    BtnInfJump.Text = Features.InfJump and "Infinite Jump: ON" or "Infinite Jump: OFF"
    BtnInfJump.TextColor3 = Features.InfJump and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(200, 200, 200)
end)

local JumpLoop = UIS.JumpRequest:Connect(function()
    if Features.InfJump and Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
        Player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- نظام مضاد الـ AFK
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

BtnSpeed.MouseButton1Click:Connect(function()
    Features.CustomSpeed = not Features.CustomSpeed
    BtnSpeed.Text = Features.CustomSpeed and "Walk Speed: ON" or "Walk Speed: OFF"
    BtnSpeed.TextColor3 = Features.CustomSpeed and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(200, 200, 200)
    if not Features.CustomSpeed and Player.Character then Player.Character.Humanoid.WalkSpeed = 16 end
end)
BoxSpeed.FocusLost:Connect(function() Features.SpeedValue = tonumber(BoxSpeed.Text) or 50 end)

BtnJump.MouseButton1Click:Connect(function()
    Features.CustomJump = not Features.CustomJump
    BtnJump.Text = Features.CustomJump and "Jump Power: ON" or "Jump Power: OFF"
    BtnJump.TextColor3 = Features.CustomJump and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(200, 200, 200)
    if not Features.CustomJump and Player.Character then Player.Character.Humanoid.UseJumpPower = false end
end)
BoxJump.FocusLost:Connect(function() Features.JumpValue = tonumber(BoxJump.Text) or 100 end)

-- ==========================================
-- أزرار الواجهة السفلية (Dev & Restart)
-- ==========================================
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
        setclipboard(site)
        Notify("Zoko Link Copied!", "تم نسخ الرابط بنجاح!")
    else
        Notify("Zoko Site", "الرابط: " .. site)
    end
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
    if RenderLoop then RenderLoop:Disconnect() end
    if NoclipLoop then NoclipLoop:Disconnect() end
    if SuperHitLoop then SuperHitLoop:Disconnect() end
    if InstantInteractLoop then InstantInteractLoop:Disconnect() end
    if JumpLoop then JumpLoop:Disconnect() end
    if SpectateLoop then SpectateLoop:Disconnect() end
    if FlyLoop then FlyLoop:Disconnect() end
    workspace.CurrentCamera.CameraSubject = Player.Character:WaitForChild("Humanoid")
    ScreenGui:Destroy()
    
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Ray2133231/Zoko2/main/main.lua"))()
    end)
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
