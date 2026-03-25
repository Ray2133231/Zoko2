-- [[ Zoko Hub V3 - Ultimate Glass Edition (Perfect Clone Outfits & Fly) ]]

local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

-- حذف الواجهة القديمة للريستارت
if _G.ZokoUI then pcall(function() _G.ZokoUI:Destroy() end) end

-- 1. إنشاء الواجهة الأساسية
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Zoko_UI"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
_G.ZokoUI = ScreenGui

-- الإطار الزجاجي (Main Frame)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, -135, 0.5, -200)
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

-- عنوان المنيو
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "ZOKO HUB"
Title.TextColor3 = Color3.fromRGB(0, 212, 255)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 22
Title.Parent = MainFrame

-- ==========================================
-- نظام السحب والتحريك (Draggable)
-- ==========================================
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

-- ==========================================
-- 2. إعداد القوائم (ScrollingFrames)
-- ==========================================
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

-- قائمة السكنات
local SkinsScroll = Instance.new("ScrollingFrame")
SkinsScroll.Size = ScrollFrame.Size
SkinsScroll.Position = ScrollFrame.Position
SkinsScroll.BackgroundTransparency = 1
SkinsScroll.ScrollBarThickness = 4
SkinsScroll.ScrollBarImageColor3 = Color3.fromRGB(0, 212, 255)
SkinsScroll.CanvasSize = UDim2.new(0, 0, 0, 600)
SkinsScroll.Visible = false
SkinsScroll.Parent = MainFrame

local SkinsLayout = Instance.new("UIListLayout")
SkinsLayout.Parent = SkinsScroll
SkinsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SkinsLayout.Padding = UDim.new(0, 8)
SkinsLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- 3. نظام الإشعارات
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
-- نظام حفظ الأطقم بالاستنساخ الشامل (Copy Paste System)
-- ==========================================
local SavedSkins = {}
local SkinToDelete = ""
local FileName = "ZokoHub_SavedSkins.json"

-- جميع الخصائص المطلوبة لنسخ الشخصية 100%
local StandardProps = {
    "HatAccessory", "HairAccessory", "FaceAccessory", "NeckAccessory", "ShouldersAccessory", "FrontAccessory", "BackAccessory", "WaistAccessory",
    "Shirt", "Pants", "GraphicTShirt", "Face", "Head", "Torso", "LeftArm", "RightArm", "LeftLeg", "RightLeg",
    "DepthScale", "HeadScale", "HeightScale", "ProportionScale", "WidthScale", "BodyTypeScale",
    "ClimbAnimation", "FallAnimation", "IdleAnimation", "JumpAnimation", "RunAnimation", "SwimAnimation", "WalkAnimation"
}
local ColorProps = {
    "HeadColor", "LeftArmColor", "LeftLegColor", "RightArmColor", "RightLegColor", "TorsoColor"
}

local function SaveDataToFile()
    if writefile then
        pcall(function() writefile(FileName, HttpService:JSONEncode(SavedSkins)) end)
    end
end

local function LoadDataFromFile()
    if readfile and isfile and isfile(FileName) then
        local s, result = pcall(function() return HttpService:JSONDecode(readfile(FileName)) end)
        if s and type(result) == "table" then
            SavedSkins = result
        end
    end
end
LoadDataFromFile()

local function GetAssetId(str)
    if type(str) == "string" then
        local id = string.match(str, "%d+")
        return id and tonumber(id) or 0
    elseif type(str) == "number" then
        return str
    end
    return 0
end

local function CreateBaseButton(text, parent, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.BackgroundTransparency = 0.4
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.LayoutOrder = order or 10
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    return btn
end

local BtnBackToMenu = CreateBaseButton("العودة للقائمة", SkinsScroll, 1)
BtnBackToMenu.TextColor3 = Color3.fromRGB(255, 100, 100)
local BtnAddOutfit = CreateBaseButton("اضافة طقم", SkinsScroll, 2)
BtnAddOutfit.TextColor3 = Color3.fromRGB(0, 255, 127)

-- نوافذ السكنات (Modals)
local ModalAdd = Instance.new("Frame", MainFrame)
ModalAdd.Size = UDim2.new(1, 0, 1, 0)
ModalAdd.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
ModalAdd.BackgroundTransparency = 0.1
ModalAdd.ZIndex = 10
ModalAdd.Visible = false

local OutfitNameInput = Instance.new("TextBox", ModalAdd)
OutfitNameInput.Size = UDim2.new(0.8, 0, 0, 40)
OutfitNameInput.Position = UDim2.new(0.1, 0, 0.3, 0)
OutfitNameInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
OutfitNameInput.TextColor3 = Color3.fromRGB(255, 255, 255)
OutfitNameInput.PlaceholderText = "اكتب اسم الطقم هنا..."
OutfitNameInput.Font = Enum.Font.GothamBold
OutfitNameInput.TextSize = 14
OutfitNameInput.ZIndex = 11
Instance.new("UICorner", OutfitNameInput)

local BtnSaveOutfit = CreateBaseButton("حفظ الطقم", ModalAdd)
BtnSaveOutfit.Size = UDim2.new(0.35, 0, 0, 35)
BtnSaveOutfit.Position = UDim2.new(0.1, 0, 0.5, 0)
BtnSaveOutfit.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
BtnSaveOutfit.ZIndex = 11

local BtnCancelOutfit = CreateBaseButton("الغاء", ModalAdd)
BtnCancelOutfit.Size = UDim2.new(0.35, 0, 0, 35)
BtnCancelOutfit.Position = UDim2.new(0.55, 0, 0.5, 0)
BtnCancelOutfit.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
BtnCancelOutfit.ZIndex = 11

local ModalDel = Instance.new("Frame", MainFrame)
ModalDel.Size = UDim2.new(1, 0, 1, 0)
ModalDel.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
ModalDel.BackgroundTransparency = 0.1
ModalDel.ZIndex = 10
ModalDel.Visible = false

local DelText = Instance.new("TextLabel", ModalDel)
DelText.Size = UDim2.new(1, 0, 0, 40)
DelText.Position = UDim2.new(0, 0, 0.3, 0)
DelText.BackgroundTransparency = 1
DelText.Text = "هل انت متاكد من الحذف؟"
DelText.TextColor3 = Color3.fromRGB(255, 50, 50)
DelText.Font = Enum.Font.GothamBold
DelText.TextSize = 18
DelText.ZIndex = 11

local BtnConfirmDel = CreateBaseButton("نعم", ModalDel)
BtnConfirmDel.Size = UDim2.new(0.35, 0, 0, 35)
BtnConfirmDel.Position = UDim2.new(0.1, 0, 0.5, 0)
BtnConfirmDel.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
BtnConfirmDel.ZIndex = 11

local BtnCancelDel = CreateBaseButton("الغاء", ModalDel)
BtnCancelDel.Size = UDim2.new(0.35, 0, 0, 35)
BtnCancelDel.Position = UDim2.new(0.55, 0, 0.5, 0)
BtnCancelDel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
BtnCancelDel.ZIndex = 11

local function RefreshSkinsUI()
    for _, child in pairs(SkinsScroll:GetChildren()) do
        if child:IsA("TextButton") and child.LayoutOrder > 2 then child:Destroy() end
    end
    
    for skinName, skinProps in pairs(SavedSkins) do
        local btn = CreateBaseButton(skinName, SkinsScroll, 10)
        local isApplying = false
        
        -- كلك يسار = تطبيق السكن
        btn.MouseButton1Click:Connect(function()
            if isApplying then return end
            isApplying = true
            local char = Player.Character
            if char and char:FindFirstChild("Humanoid") then
                
                -- بناء شخصيتك المستنسخة
                local newDesc = Instance.new("HumanoidDescription")
                
                for k, v in pairs(skinProps) do
                    pcall(function()
                        if type(v) == "table" and v.R and v.G and v.B then
                            newDesc[k] = Color3.new(v.R, v.G, v.B) -- إرجاع الألوان
                        else
                            newDesc[k] = v -- إرجاع المقاسات والأيدي
                        end
                    end)
                end
                
                -- تطبيق الطقم الشامل
                pcall(function() char.Humanoid:ApplyDescription(newDesc) end)
                
                -- التركيب الإجباري للملابس والفيس كاحتياط
                pcall(function()
                    if skinProps.Shirt and skinProps.Shirt ~= 0 then
                        local shirt = char:FindFirstChildOfClass("Shirt") or Instance.new("Shirt", char)
                        shirt.ShirtTemplate = "rbxassetid://" .. skinProps.Shirt
                    end
                    if skinProps.Pants and skinProps.Pants ~= 0 then
                        local pants = char:FindFirstChildOfClass("Pants") or Instance.new("Pants", char)
                        pants.PantsTemplate = "rbxassetid://" .. skinProps.Pants
                    end
                    if skinProps.GraphicTShirt and skinProps.GraphicTShirt ~= 0 then
                        local tshirt = char:FindFirstChildOfClass("ShirtGraphic") or Instance.new("ShirtGraphic", char)
                        tshirt.Graphic = "rbxassetid://" .. skinProps.GraphicTShirt
                    end
                    if skinProps.Face and skinProps.Face ~= 0 then
                        local head = char:FindFirstChild("Head")
                        if head then
                            local face = head:FindFirstChildOfClass("Decal") or Instance.new("Decal", head)
                            face.Texture = "rbxassetid://" .. skinProps.Face
                        end
                    end
                end)
                
                Notify("Zoko Skins", "تم تطبيق الطقم: " .. skinName, Color3.fromRGB(0, 255, 127))
            end
            task.wait(0.5)
            isApplying = false
        end)
        
        -- كلك يمين = حذف السكن
        btn.MouseButton2Click:Connect(function()
            SkinToDelete = skinName
            ModalDel.Visible = true
        end)
    end
end
RefreshSkinsUI()

BtnAddOutfit.MouseButton1Click:Connect(function() ModalAdd.Visible = true OutfitNameInput.Text = "" end)
BtnCancelOutfit.MouseButton1Click:Connect(function() ModalAdd.Visible = false end)

BtnSaveOutfit.MouseButton1Click:Connect(function()
    local name = OutfitNameInput.Text
    local char = Player.Character
    if name ~= "" and char and char:FindFirstChild("Humanoid") then
        local currentDesc = char.Humanoid:GetAppliedDescription()
        local data = {}
        
        -- 1. حفظ جميع الخصائص العادية والمقاسات والأجزاء
        for _, prop in ipairs(StandardProps) do
            pcall(function() data[prop] = currentDesc[prop] end)
        end
        
        -- 2. حفظ ألوان البشرة كأرقام لأن الحفظ بملف ما يدعم ألوان مباشرة
        for _, prop in ipairs(ColorProps) do
            pcall(function()
                local c = currentDesc[prop]
                data[prop] = {R = c.R, G = c.G, B = c.B}
            end)
        end
        
        -- 3. سحب الملابس مباشرة من الشخصية لضمان عدم وجود أخطاء من الماب
        local cShirt = char:FindFirstChildOfClass("Shirt")
        local cPants = char:FindFirstChildOfClass("Pants")
        local cTShirt = char:FindFirstChildOfClass("ShirtGraphic")
        local head = char:FindFirstChild("Head")
        local cFace = head and head:FindFirstChildOfClass("Decal")
        
        data.Shirt = cShirt and GetAssetId(cShirt.ShirtTemplate) or data.Shirt
        data.Pants = cPants and GetAssetId(cPants.PantsTemplate) or data.Pants
        data.GraphicTShirt = cTShirt and GetAssetId(cTShirt.Graphic) or data.GraphicTShirt
        data.Face = cFace and GetAssetId(cFace.Texture) or data.Face
        
        SavedSkins[name] = data
        SaveDataToFile()
        RefreshSkinsUI()
        ModalAdd.Visible = false
        Notify("Zoko Skins", "تم حفظ الطقم المستنسخ بنجاح!", Color3.fromRGB(0, 255, 127))
    end
end)

BtnConfirmDel.MouseButton1Click:Connect(function()
    SavedSkins[SkinToDelete] = nil
    SaveDataToFile()
    RefreshSkinsUI()
    ModalDel.Visible = false
    Notify("Zoko Skins", "تم حذف الطقم!", Color3.fromRGB(255, 50, 50))
end)
BtnCancelDel.MouseButton1Click:Connect(function() ModalDel.Visible = false end)

BtnBackToMenu.MouseButton1Click:Connect(function()
    SkinsScroll.Visible = false
    ScrollFrame.Visible = true
end)

-- 4. المتغيرات والخصائص
local Features = {
    GodMode = false, Fly = false, Invisible = false, InfJump = false,
    Ghost = false, FakeMe = false, CustomSpeed = false, SpeedValue = 50, CustomJump = false, JumpValue = 100
}
local FakeClone = nil

-- 5. صنع الأزرار
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

-- إضافة الأزرار للواجهة
local BtnGod = CreateButton("God Mode & Anti-Ragdoll: OFF", ScrollFrame)
local BtnFly = CreateButton("Fly: OFF", ScrollFrame)
local BtnInvis = CreateButton("Sub: Invisible: OFF", ScrollFrame)
BtnInvis.Visible = false 
BtnInvis.Size = UDim2.new(0.8, 0, 0, 30)
BtnInvis.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

local BtnInfJump = CreateButton("Infinite Jump: OFF", ScrollFrame)
local BtnGhost = CreateButton("Ghost Mode: OFF", ScrollFrame)
local BtnFakeMe = CreateButton("Fake Me (Desync): OFF", ScrollFrame)

local BtnSpeed, BoxSpeed = CreateInputRow("Walk Speed: OFF", 50, ScrollFrame)
local BtnJump, BoxJump = CreateInputRow("Jump Power: OFF", 100, ScrollFrame)

-- منيو السكنات
local BtnSkinsMenu = CreateButton("منيو السكنات", ScrollFrame)
BtnSkinsMenu.TextColor3 = Color3.fromRGB(0, 212, 255)
BtnSkinsMenu.MouseButton1Click:Connect(function()
    ScrollFrame.Visible = false
    SkinsScroll.Visible = true
end)

-- 6. برمجة المزايا والتفعيل
local RenderLoop = RunService.RenderStepped:Connect(function()
    local char = Player.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end

    if Features.GodMode then
        pcall(function()
            hum.Health = hum.MaxHealth
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        end)
    end

    if Features.Ghost then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then
                if v.Name ~= "HumanoidRootPart" then 
                    v.Transparency = 1 
                    v.LocalTransparencyModifier = 1
                end
            elseif v:IsA("BillboardGui") or v:IsA("SurfaceGui") then
                v.Enabled = false
            end
        end
    end

    if Features.CustomSpeed then hum.WalkSpeed = Features.SpeedValue end
    if Features.CustomJump then hum.UseJumpPower = true hum.JumpPower = Features.JumpValue end
end)

BtnGod.MouseButton1Click:Connect(function()
    Features.GodMode = not Features.GodMode
    BtnGod.Text = Features.GodMode and "God Mode & Anti-Ragdoll: ON" or "God Mode & Anti-Ragdoll: OFF"
    BtnGod.TextColor3 = Features.GodMode and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(200, 200, 200)
end)

local FlyLoop
BtnFly.MouseButton1Click:Connect(function()
    Features.Fly = not Features.Fly
    BtnFly.Text = Features.Fly and "Fly: ON" or "Fly: OFF"
    BtnFly.TextColor3 = Features.Fly and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(200, 200, 200)
    
    BtnInvis.Visible = Features.Fly
    
    if not Features.Fly and Features.Invisible then
        Features.Invisible = false
        BtnInvis.Text = "Sub: Invisible: OFF"
        BtnInvis.TextColor3 = Color3.fromRGB(200, 200, 200)
        local char = Player.Character
        if char then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") or v:IsA("Decal") then
                    if v.Name ~= "HumanoidRootPart" then v.Transparency = 0 end
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
            local speed = 2.0 
            
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then speed = 8.0 end 
            
            if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Q) then move = move + Vector3.new(0,1,0) end 
            if UIS:IsKeyDown(Enum.KeyCode.Z) then move = move - Vector3.new(0,1,0) end 
            
            hrp.Velocity = Vector3.new(0,0,0)
            hrp.CFrame = hrp.CFrame + (move * speed)
        end)
    else
        char.Humanoid.PlatformStand = false
        if FlyLoop then FlyLoop:Disconnect() end
    end
end)

BtnInvis.MouseButton1Click:Connect(function()
    Features.Invisible = not Features.Invisible
    BtnInvis.Text = Features.Invisible and "Sub: Invisible: ON" or "Sub: Invisible: OFF"
    BtnInvis.TextColor3 = Features.Invisible and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(200, 200, 200)
    local char = Player.Character
    if char then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then
                if v.Name ~= "HumanoidRootPart" then v.Transparency = Features.Invisible and 1 or 0 end
            end
        end
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

BtnGhost.MouseButton1Click:Connect(function()
    Features.Ghost = not Features.Ghost
    BtnGhost.Text = Features.Ghost and "Ghost Mode: ON" or "Ghost Mode: OFF"
    BtnGhost.TextColor3 = Features.Ghost and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(200, 200, 200)
    if not Features.Ghost and Player.Character then
        for _, v in pairs(Player.Character:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then
                if v.Name ~= "HumanoidRootPart" then v.Transparency = 0 end
            end
        end
    end
end)

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

-- 7. زر الحقوق (Developed by Zoko) 
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
        Notify("Zoko Link Copied!", "تم نسخ الرابط!")
    else
        Notify("Zoko Site", "الرابط: " .. site)
    end
end)

-- زر الريستارت الجديد (RESTART) 
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
    if FlyLoop then FlyLoop:Disconnect() end
    if JumpLoop then JumpLoop:Disconnect() end
    ScreenGui:Destroy()
    
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Ray2133231/Zoko2/main/main.lua"))()
    end)
end)

-- 8. زر الفتح والقفل الدائري
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

-- تشغيل أنميشن الفتح
MainFrame:TweenSize(UDim2.new(0, 270, 0, 400), "Out", "Back", 0.6, true)
