-- [[ Zoko Hub V7.3 - Anti-Rubberband Noclip & Perfect Anti-Ragdoll ]]

local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")

if _G.ZokoUI then pcall(function() _G.ZokoUI:Destroy() end) end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Zoko_UI"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
_G.ZokoUI = ScreenGui

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
Title.Text = "ZOKO HUB V7.3"
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
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 450)
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
-- الأزرار الرئيسية والميزات
-- ==========================================
local Features = {
    GodMode = false, InfJump = false, Noclip = false, 
    InstantPrompt = false, SuperHit = false, AntiAFK = true,
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
-- الأنظمة الأساسية (Loops)
-- ==========================================

-- نظام Noclip المضاد للإرجاع (Anti-Rubberband Bypass)
local lastNoclipPos = nil
local NoclipLoop = RunService.Stepped:Connect(function()
    if Features.Noclip and Player.Character then
        local hrp = Player.Character:FindFirstChild("HumanoidRootPart")
        local hum = Player.Character:FindFirstChild("Humanoid")
        
        for _, part in pairs(Player.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end

        -- منع السيرفر من إرجاعك للخلف إذا كنت تخترق جدار
        if hrp and hum and hum.Health > 0 then
            if lastNoclipPos then
                local dist = (hrp.Position - lastNoclipPos).Magnitude
                -- إذا المسافة بين الفريم الماضي والحالي أكبر من 10 (يعني السيرفر سحبك لورا) وأقل من 80 (مو ريسباون)
                if dist > 10 and dist < 80 then
                    -- كسر أمر السيرفر وإرجاعك لمكان الاختراق بقوة!
                    hrp.CFrame = CFrame.new(lastNoclipPos)
                end
            end
            lastNoclipPos = hrp.Position
            -- تغيير حالة اللاعب للمشي الوهمي لزيادة كسر حماية السيرفر
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
        if child:IsA("Tool") and Features.SuperHit then
            EnableFlingOnTool(child)
        end
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
            
            -- كسر أمر الريقدول (لو السيرفر طيحك، توقف فوراً غصب)
            local currentState = hum:GetState()
            if currentState == Enum.HumanoidStateType.Ragdoll or currentState == Enum.HumanoidStateType.FallingDown then
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end

            -- زيادة الوزن لمنع الدفع
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
                if obj:IsA("ProximityPrompt") then
                    obj.HoldDuration = 0
                end
            end
        end)
    else
        if InstantInteractLoop then
            InstantInteractLoop:Disconnect()
            InstantInteractLoop = nil
        end
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
    if Features.SuperHit then
        Notify("Super Hit Activated", "امسك أي سلاح واضرب اللاعبين عشان يطيرون!", Color3.fromRGB(255, 100, 100))
    end
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

-- تفعيل زر زوكو عشان ينسخ الرابط
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

-- تفعيل زر الريستارت
RestartBtn.MouseButton1Click:Connect(function()
    if RenderLoop then RenderLoop:Disconnect() end
    if NoclipLoop then NoclipLoop:Disconnect() end
    if SuperHitLoop then SuperHitLoop:Disconnect() end
    if InstantInteractLoop then InstantInteractLoop:Disconnect() end
    if JumpLoop then JumpLoop:Disconnect() end
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
