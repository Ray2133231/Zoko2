-- [[ Zoko Menu ]]

local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()


local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Zoko_UI"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false


local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 0, 0, 0) 
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BackgroundTransparency = 0.3 
MainFrame.Visible = false
MainFrame.Parent = ScreenGui


local Blur = Instance.new("BlurEffect")
Blur.Size = 10
Blur.Parent = game.Lighting


local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(0, 212, 255)
Stroke.Thickness = 2
Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Stroke.Parent = MainFrame

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 15)
Corner.Parent = MainFrame


local GodModeActive = false
local InfiniteJumpActive = false
local Flying = false


local DevBtn = Instance.new("TextButton")
DevBtn.Size = UDim2.new(0.9, 0, 0, 40)
DevBtn.Position = UDim2.new(0.05, 0, 0.85, 0)
DevBtn.BackgroundTransparency = 1
DevBtn.RichText = true
DevBtn.Text = [[Developed by <font color="rgb(0, 212, 255)"><b>Zoko</b></font>]]
DevBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
DevBtn.Font = Enum.Font.GothamBold
DevBtn.TextSize = 14
DevBtn.Parent = MainFrame

DevBtn.MouseButton1Click:Connect(function()
    print("Visit Zoko's Website: http://45.137.98.42:5000/")
end)


local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 55, 0, 55)
OpenBtn.Position = UDim2.new(0, 20, 0.5, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 212, 255)
OpenBtn.Text = "Z"
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 25
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.Parent = ScreenGui

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(1, 0)
BtnCorner.Parent = OpenBtn

OpenBtn.MouseButton1Click:Connect(function()
    if MainFrame.Visible then
        MainFrame:TweenSize(UDim2.new(0, 0, 0, 0), "Out", "Quart", 0.4, true)
        task.wait(0.4)
        MainFrame.Visible = false
    else
        MainFrame.Visible = true
        MainFrame:TweenSize(UDim2.new(0, 220, 0, 320), "Out", "Back", 0.5, true)
    end
end)
