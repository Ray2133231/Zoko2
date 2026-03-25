-- [[ Zoko Hub ]]

local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Zoko_UI"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false


local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -175)
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

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "ZOKO HUB"
Title.TextColor3 = Color3.fromRGB(0, 212, 255)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 22
Title.Parent = MainFrame

local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, 0, 1, -90)
Container.Position = UDim2.new(0, 0, 0, 45)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Parent = Container
ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ListLayout.Padding = UDim.new(0, 8)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local Features = {GodMode = false, Fly = false, Invisible = false, InfJump = false}
local FlyLoop

local function CreateButton(text, parent, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.BackgroundTransparency = 0.4
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.LayoutOrder = order
    btn.Parent = parent

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    return btn
end

local BtnGod = CreateButton("God Mode: OFF", Container, 1)
local BtnFly = CreateButton("Fly: OFF", Container, 2)
local BtnInvis = CreateButton("Invisible: OFF", Container, 3)
local BtnJump = CreateButton("Inf Jump: OFF", Container, 4)

BtnInvis.Visible = false 
BtnInvis.Size = UDim2.new(0.8, 0, 0, 30) 
BtnInvis.BackgroundColor3 = Color3.fromRGB(25, 25, 25)


BtnGod.MouseButton1Click:Connect(function()
    Features.GodMode = not Features.GodMode
    BtnGod.Text = Features.GodMode and "God Mode: ON" or "God Mode: OFF"
    BtnGod.TextColor3 = Features.GodMode and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(200, 200, 200)
    
    local char = Player.Character
    if char and char:FindFirstChild("Humanoid") then
        if Features.GodMode then
            char.Humanoid.MaxHealth = math.huge
            char.Humanoid.Health = math.huge
            char.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            char.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        else
            char.Humanoid.MaxHealth = 100
            char.Humanoid.Health = 100
            char.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
            char.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        end
    end
end)

BtnFly.MouseButton1Click:Connect(function()
    Features.Fly = not Features.Fly
    BtnFly.Text = Features.Fly and "Fly: ON" or "Fly: OFF"
    BtnFly.TextColor3 = Features.Fly and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(200, 200, 200)
    
    BtnInvis.Visible = Features.Fly
    if not Features.Fly and Features.Invisible then
        Features.Invisible = false
        BtnInvis.Text = "Invisible: OFF"
        BtnInvis.TextColor3 = Color3.fromRGB(200, 200, 200)
        for _, v in pairs(Player.Character:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then v.Transparency = 0 end
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
            hrp.CFrame = hrp.CFrame + (move * 1.5)
        end)
    else
        char.Humanoid.PlatformStand = false
        if FlyLoop then FlyLoop:Disconnect() end
    end
end)

BtnInvis.MouseButton1Click:Connect(function()
    Features.Invisible = not Features.Invisible
    BtnInvis.Text = Features.Invisible and "Invisible: ON" or "Invisible: OFF"
    BtnInvis.TextColor3 = Features.Invisible and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(200, 200, 200)
    
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


BtnJump.MouseButton1Click:Connect(function()
    Features.InfJump = not Features.InfJump
    BtnJump.Text = Features.InfJump and "Inf Jump: ON" or "Inf Jump: OFF"
    BtnJump.TextColor3 = Features.InfJump and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(200, 200, 200)
end)

UIS.JumpRequest:Connect(function()
    if Features.InfJump and Player.Character then
        Player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

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
    print("Welcome to Zoko's World: http://45.137.98.42:5000/")
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

local BtnCorner2 = Instance.new("UICorner")
BtnCorner2.CornerRadius = UDim.new(1, 0)
BtnCorner2.Parent = OpenBtn

OpenBtn.MouseButton1Click:Connect(function()
    if MainFrame.Visible then
        MainFrame:TweenSize(UDim2.new(0, 0, 0, 0), "Out", "Quart", 0.3, true)
        task.wait(0.3)
        MainFrame.Visible = false
    else
        MainFrame.Visible = true
        MainFrame:TweenSize(UDim2.new(0, 250, 0, 350), "Out", "Back", 0.5, true)
    end
end)

MainFrame:TweenSize(UDim2.new(0, 250, 0, 350), "Out", "Back", 0.6, true)
