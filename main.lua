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
ScreenGui.Name = "Zoko_UI"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
_G.ZokoUI = ScreenGui

-----------------------------------
-- نظام حفظ النقاط (Checkpoints) --
-----------------------------------
local CP_FileName = "Zoko_Checkpoints_V1.json"
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
Title.Text = "Zoko Trainer V1.5"
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
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 1100)
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
    NDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
    NDesc.Font = Enum.Font.GothamMedium
    NDesc.TextSize = 13
    NDesc.ZIndex = 201
    NDesc.TextXAlignment = Enum.TextXAlignment.Left
    NDesc.TextWrapped = true

    NotifFrame:TweenPosition(UDim2.new(1, -260, 0.8, 0), "Out", "Back", 0.5, true)
    task.wait(3.5)
    NotifFrame:TweenPosition(UDim2.new(1, 10, 0.8, 0), "In", "Back", 0.5, true)
    task.wait(0.5)
    NotifFrame:Destroy()
end

-----------------------------------
-- مودل تأكيد الرسائل (Confirm) ---
-----------------------------------
local ConfirmFrame = Instance.new("Frame", ScreenGui)
ConfirmFrame.Size = UDim2.new(0, 240, 0, 130)
ConfirmFrame.Position = UDim2.new(0.5, -120, 0.5, -65)
ConfirmFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ConfirmFrame.Visible = false
ConfirmFrame.ZIndex = 50
Instance.new("UICorner", ConfirmFrame).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", ConfirmFrame).Color = Color3.fromRGB(255, 150, 0)

local ConfirmText = Instance.new("TextLabel", ConfirmFrame)
ConfirmText.Size = UDim2.new(1, -20, 0, 60)
ConfirmText.Position = UDim2.new(0, 10, 0, 10)
ConfirmText.BackgroundTransparency = 1
ConfirmText.Text = "هل أنت متأكد؟"
ConfirmText.TextColor3 = Color3.fromRGB(255, 255, 255)
ConfirmText.Font = Enum.Font.GothamBold
ConfirmText.TextSize = 14
ConfirmText.TextWrapped = true
ConfirmText.TextScaled = true
ConfirmText.ZIndex = 51

local BtnYes = Instance.new("TextButton", ConfirmFrame)
BtnYes.Size = UDim2.new(0.4, 0, 0, 35)
BtnYes.Position = UDim2.new(0.05, 0, 1, -45)
BtnYes.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
BtnYes.Text = "نعم (Yes)"
BtnYes.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnYes.Font = Enum.Font.GothamBold
BtnYes.TextSize = 14
BtnYes.TextScaled = true
BtnYes.ZIndex = 51
Instance.new("UICorner", BtnYes).CornerRadius = UDim.new(0, 6)

local BtnNo = Instance.new("TextButton", ConfirmFrame)
BtnNo.Size = UDim2.new(0.4, 0, 0, 35)
BtnNo.Position = UDim2.new(0.55, 0, 1, -45)
BtnNo.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
BtnNo.Text = "إلغاء (No)"
BtnNo.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnNo.Font = Enum.Font.GothamBold
BtnNo.TextSize = 14
BtnNo.TextScaled = true
BtnNo.ZIndex = 51
Instance.new("UICorner", BtnNo).CornerRadius = UDim.new(0, 6)

local ConfirmAction = nil
BtnYes.MouseButton1Click:Connect(function()
    ConfirmFrame.Visible = false
    if ConfirmAction then ConfirmAction(true) end
end)
BtnNo.MouseButton1Click:Connect(function()
    ConfirmFrame.Visible = false
    if ConfirmAction then ConfirmAction(false) end
end)

local function ShowConfirm(text, callback)
    ConfirmText.Text = text
    ConfirmAction = callback
    ConfirmFrame.Visible = true
end

-----------------------------------
-- واجهة الانتقالات (Teleports) ---
-----------------------------------
local TpFrame = Instance.new("Frame")
TpFrame.Size = UDim2.new(0, 250, 0, 350)
TpFrame.Position = UDim2.new(0.5, -300, 0.5, -150)
TpFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TpFrame.Visible = false
TpFrame.Parent = ScreenGui
Instance.new("UICorner", TpFrame).CornerRadius = UDim.new(0, 12)
local TStroke = Instance.new("UIStroke", TpFrame)
TStroke.Color = Color3.fromRGB(0, 255, 127)
TStroke.Thickness = 2
MakeDraggable(TpFrame)

local TpTitle = Instance.new("TextLabel", TpFrame)
TpTitle.Size = UDim2.new(1, 0, 0, 30)
TpTitle.BackgroundTransparency = 1
TpTitle.Text = "Checkpoints"
TpTitle.TextColor3 = Color3.fromRGB(0, 255, 127)
TpTitle.Font = Enum.Font.GothamBold
TpTitle.TextSize = 18

local BtnCloseTp = Instance.new("TextButton", TpFrame)
BtnCloseTp.Size = UDim2.new(0, 25, 0, 25)
BtnCloseTp.Position = UDim2.new(1, -30, 0, 5)
BtnCloseTp.BackgroundTransparency = 1
BtnCloseTp.Text = "X"
BtnCloseTp.TextColor3 = Color3.fromRGB(255, 50, 50)
BtnCloseTp.Font = Enum.Font.GothamBold
BtnCloseTp.TextSize = 18
BtnCloseTp.MouseButton1Click:Connect(function() TpFrame.Visible = false end)

local BtnToggleReorder = Instance.new("ImageButton", TpFrame)
BtnToggleReorder.Size = UDim2.new(0, 20, 0, 20)
BtnToggleReorder.Position = UDim2.new(1, -60, 0, 7)
BtnToggleReorder.BackgroundTransparency = 1
BtnToggleReorder.Image = "rbxassetid://6031280882"
BtnToggleReorder.ImageColor3 = Color3.fromRGB(200, 200, 200)

local TpScroll = Instance.new("ScrollingFrame", TpFrame)
TpScroll.Size = UDim2.new(1, -10, 1, -80)
TpScroll.Position = UDim2.new(0, 5, 0, 35)
TpScroll.BackgroundTransparency = 1
TpScroll.ScrollBarThickness = 3
TpScroll.CanvasSize = UDim2.new(0, 0, 0, 0)

local TpLayout = Instance.new("UIListLayout", TpScroll)
TpLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TpLayout.Padding = UDim.new(0, 5)
TpLayout.SortOrder = Enum.SortOrder.LayoutOrder

local BtnAddNewTp = Instance.new("TextButton", TpFrame)
BtnAddNewTp.Size = UDim2.new(0.9, 0, 0, 30)
BtnAddNewTp.Position = UDim2.new(0.05, 0, 1, -40)
BtnAddNewTp.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
BtnAddNewTp.Text = "+ Add Checkpoint"
BtnAddNewTp.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnAddNewTp.Font = Enum.Font.GothamBold
BtnAddNewTp.TextSize = 14
Instance.new("UICorner", BtnAddNewTp).CornerRadius = UDim.new(0, 6)

local BtnSaveOrder = Instance.new("ImageButton", TpFrame)
BtnSaveOrder.Size = UDim2.new(0, 30, 0, 30)
BtnSaveOrder.Position = UDim2.new(0.05, 0, 1, -40)
BtnSaveOrder.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
BtnSaveOrder.Image = "rbxassetid://6031280882"
BtnSaveOrder.Visible = false
Instance.new("UICorner", BtnSaveOrder).CornerRadius = UDim.new(0, 6)

local BtnCancelOrder = Instance.new("ImageButton", TpFrame)
BtnCancelOrder.Size = UDim2.new(0, 30, 0, 30)
BtnCancelOrder.Position = UDim2.new(0.95, -30, 1, -40)
BtnCancelOrder.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
BtnCancelOrder.Image = "rbxassetid://6031094678"
BtnCancelOrder.Visible = false
Instance.new("UICorner", BtnCancelOrder).CornerRadius = UDim.new(0, 6)

local TxtOrderMode = Instance.new("TextLabel", TpFrame)
TxtOrderMode.Size = UDim2.new(0.6, 0, 0, 30)
TxtOrderMode.Position = UDim2.new(0.2, 0, 1, -40)
TxtOrderMode.BackgroundTransparency = 1
TxtOrderMode.Text = "اسحب للترتيب (Drag to Reorder)"
TxtOrderMode.TextColor3 = Color3.fromRGB(255, 150, 0)
TxtOrderMode.Font = Enum.Font.GothamBold
TxtOrderMode.TextScaled = true
TxtOrderMode.Visible = false

-- مودل إدخال/تعديل الاسم
local ModalFrame = Instance.new("Frame", ScreenGui)
ModalFrame.Size = UDim2.new(0, 220, 0, 120)
ModalFrame.Position = UDim2.new(0.5, -110, 0.5, -60)
ModalFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ModalFrame.Visible = false
ModalFrame.ZIndex = 50 
Instance.new("UICorner", ModalFrame).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", ModalFrame).Color = Color3.fromRGB(0, 212, 255)

local ModalInput = Instance.new("TextBox", ModalFrame)
ModalInput.Size = UDim2.new(0.9, 0, 0, 35)
ModalInput.Position = UDim2.new(0.05, 0, 0, 20)
ModalInput.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ModalInput.Text = ""
ModalInput.ClearTextOnFocus = false
ModalInput.PlaceholderText = "Enter Checkpoint Name..."
ModalInput.TextColor3 = Color3.fromRGB(255, 255, 255)
ModalInput.Font = Enum.Font.GothamMedium
ModalInput.TextSize = 14
ModalInput.ZIndex = 51
Instance.new("UICorner", ModalInput).CornerRadius = UDim.new(0, 6)

local BtnSaveModal = Instance.new("TextButton", ModalFrame)
BtnSaveModal.Size = UDim2.new(0.4, 0, 0, 30)
BtnSaveModal.Position = UDim2.new(0.05, 0, 0, 70)
BtnSaveModal.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
BtnSaveModal.Text = "Save"
BtnSaveModal.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnSaveModal.Font = Enum.Font.GothamBold
BtnSaveModal.TextSize = 14
BtnSaveModal.TextScaled = true
BtnSaveModal.ZIndex = 51
Instance.new("UICorner", BtnSaveModal).CornerRadius = UDim.new(0, 6)

local BtnCancelModal = Instance.new("TextButton", ModalFrame)
BtnCancelModal.Size = UDim2.new(0.4, 0, 0, 30)
BtnCancelModal.Position = UDim2.new(0.55, 0, 0, 70)
BtnCancelModal.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
BtnCancelModal.Text = "Cancel"
BtnCancelModal.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnCancelModal.Font = Enum.Font.GothamBold
BtnCancelModal.TextSize = 14
BtnCancelModal.TextScaled = true
BtnCancelModal.ZIndex = 51
Instance.new("UICorner", BtnCancelModal).CornerRadius = UDim.new(0, 6)

local ContextMenu = Instance.new("Frame", ScreenGui)
ContextMenu.Size = UDim2.new(0, 150, 0, 105)
ContextMenu.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ContextMenu.Visible = false
ContextMenu.ZIndex = 50
Instance.new("UICorner", ContextMenu).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", ContextMenu).Color = Color3.fromRGB(100, 100, 100)

local CtxLayout = Instance.new("UIListLayout", ContextMenu)
CtxLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
CtxLayout.Padding = UDim.new(0, 4)

local BtnCtxAutoJoin = Instance.new("TextButton", ContextMenu)
BtnCtxAutoJoin.Size = UDim2.new(0.9, 0, 0, 30)
BtnCtxAutoJoin.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
BtnCtxAutoJoin.Text = "Auto Join: OFF"
BtnCtxAutoJoin.TextColor3 = Color3.fromRGB(200, 200, 200)
BtnCtxAutoJoin.Font = Enum.Font.GothamMedium
BtnCtxAutoJoin.TextSize = 12
BtnCtxAutoJoin.ZIndex = 51
Instance.new("UICorner", BtnCtxAutoJoin).CornerRadius = UDim.new(0, 4)

local BtnCtxRename = Instance.new("TextButton", ContextMenu)
BtnCtxRename.Size = UDim2.new(0.9, 0, 0, 30)
BtnCtxRename.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
BtnCtxRename.Text = "Rename"
BtnCtxRename.TextColor3 = Color3.fromRGB(255, 200, 0)
BtnCtxRename.Font = Enum.Font.GothamBold
BtnCtxRename.TextSize = 12
BtnCtxRename.ZIndex = 51
Instance.new("UICorner", BtnCtxRename).CornerRadius = UDim.new(0, 4)

local BtnCtxDelete = Instance.new("TextButton", ContextMenu)
BtnCtxDelete.Size = UDim2.new(0.9, 0, 0, 30)
BtnCtxDelete.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
BtnCtxDelete.Text = "Delete"
BtnCtxDelete.TextColor3 = Color3.fromRGB(255, 50, 50)
BtnCtxDelete.Font = Enum.Font.GothamBold
BtnCtxDelete.TextSize = 12
BtnCtxDelete.ZIndex = 51
Instance.new("UICorner", BtnCtxDelete).CornerRadius = UDim.new(0, 4)

local SelectedCpName = ""
local RenameMode = false
local IsReorderMode = false
local TempCheckpoints = {}

-----------------------------------
-- نظام السحب والإفلات (Drag & Drop)
-----------------------------------
local DragInfo = {
    IsDragging = false,
    Ghost = nil,
    Placeholder = nil,
    OffsetY = 0
}

UIS.InputChanged:Connect(function(input)
    if IsReorderMode and DragInfo.IsDragging and DragInfo.Ghost then
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local newY = input.Position.Y - DragInfo.OffsetY
            DragInfo.Ghost.Position = UDim2.new(0, DragInfo.Placeholder.AbsolutePosition.X, 0, newY)
            
            local ghostCenter = DragInfo.Ghost.AbsolutePosition.Y + (DragInfo.Ghost.AbsoluteSize.Y / 2)
            for _, otherBtn in pairs(TpScroll:GetChildren()) do
                if otherBtn:IsA("TextButton") and otherBtn ~= DragInfo.Placeholder then
                    local otherCenter = otherBtn.AbsolutePosition.Y + (otherBtn.AbsoluteSize.Y / 2)
                    if math.abs(ghostCenter - otherCenter) < (otherBtn.AbsoluteSize.Y / 2) then
                        local tempOrder = DragInfo.Placeholder.LayoutOrder
                        DragInfo.Placeholder.LayoutOrder = otherBtn.LayoutOrder
                        otherBtn.LayoutOrder = tempOrder
                    end
                end
            end
        end
    end
end)

local function EndDrag()
    if DragInfo.IsDragging then
        DragInfo.IsDragging = false
        if DragInfo.Ghost then DragInfo.Ghost:Destroy() end
        if DragInfo.Placeholder then
            DragInfo.Placeholder.BackgroundTransparency = 0
            DragInfo.Placeholder.TextTransparency = 0
            local icn = DragInfo.Placeholder:FindFirstChild("DragIcon")
            if icn then icn.ImageTransparency = 0 end
        end
        
        -- حفظ الترتيب الجديد في TempCheckpoints
        local btns = {}
        for _, btn in pairs(TpScroll:GetChildren()) do
            if btn:IsA("TextButton") and btn:FindFirstChild("DataName") then
                table.insert(btns, {Name = btn.DataName.Value, LOrder = btn.LayoutOrder})
            end
        end
        table.sort(btns, function(a, b) return a.LOrder < b.LOrder end)
        
        -- التحقق هل المستخدم بدل شيء فعلياً؟
        local hasChanged = false
        for i, b in ipairs(btns) do
            if TempCheckpoints[b.Name] then
                if TempCheckpoints[b.Name].Order ~= i then hasChanged = true end
                TempCheckpoints[b.Name].Order = i
            end
        end
        
        -- إذا تم التبديل الفعلي، نظهر أزرار الحفظ والإلغاء
        if hasChanged then
            BtnSaveOrder.Visible = true
            BtnCancelOrder.Visible = true
            TxtOrderMode.Text = "تأكيد التعديلات؟"
        end
    end
end

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        EndDrag()
    end
end)

local function RefreshTpList()
    for _, v in pairs(TpScroll:GetChildren()) do
        if v:IsA("Frame") or v:IsA("TextButton") then v:Destroy() end
    end
    
    local sortedList = {}
    local dataSrc = IsReorderMode and TempCheckpoints or SavedCheckpoints[CurrentPlaceId]
    for name, data in pairs(dataSrc) do
        table.insert(sortedList, {Name = name, Data = data})
    end
    table.sort(sortedList, function(a, b) return a.Data.Order < b.Data.Order end)
    
    local ySize = 0
    for i, item in ipairs(sortedList) do
        local btn = Instance.new("TextButton", TpScroll)
        btn.Size = UDim2.new(0.95, 0, 0, 30)
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        btn.LayoutOrder = item.Data.Order 
        
        local dn = Instance.new("StringValue", btn)
        dn.Name = "DataName"
        dn.Value = item.Name

        local displayTxt = item.Name
        if item.Data.AutoJoin then
            displayTxt = "[★] " .. item.Name
            btn.TextColor3 = Color3.fromRGB(0, 255, 127)
        else
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        
        btn.Text = displayTxt
        btn.Font = Enum.Font.GothamMedium
        btn.TextSize = 13
        btn.TextXAlignment = Enum.TextXAlignment.Left
        local pad = Instance.new("UIPadding", btn) pad.PaddingLeft = UDim.new(0, 10)
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        
        if IsReorderMode then
            local DragIcon = Instance.new("ImageLabel", btn)
            DragIcon.Name = "DragIcon"
            DragIcon.Size = UDim2.new(0, 20, 0, 20)
            DragIcon.Position = UDim2.new(1, -25, 0.5, -10)
            DragIcon.BackgroundTransparency = 1
            DragIcon.Image = "rbxassetid://3926305904" 
            DragIcon.ImageRectOffset = Vector2.new(36, 36)
            DragIcon.ImageRectSize = Vector2.new(36, 36)
            DragIcon.ImageColor3 = Color3.fromRGB(150, 150, 150)

            btn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    DragInfo.IsDragging = true
                    DragInfo.Placeholder = btn
                    DragInfo.OffsetY = input.Position.Y - btn.AbsolutePosition.Y
                    
                    DragInfo.Ghost = btn:Clone()
                    DragInfo.Ghost.Parent = ScreenGui
                    DragInfo.Ghost.Size = UDim2.new(0, btn.AbsoluteSize.X, 0, btn.AbsoluteSize.Y)
                    DragInfo.Ghost.Position = UDim2.new(0, btn.AbsolutePosition.X, 0, btn.AbsolutePosition.Y)
                    DragInfo.Ghost.BackgroundTransparency = 0.2
                    DragInfo.Ghost.ZIndex = 100
                    
                    btn.BackgroundTransparency = 0.8
                    btn.TextTransparency = 0.8
                    DragIcon.ImageTransparency = 0.8
                end
            end)
        else
            btn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                        Player.Character.HumanoidRootPart.CFrame = CFrame.new(item.Data.X, item.Data.Y, item.Data.Z)
                        Notify("Teleport", "تم الانتقال إلى: " .. item.Name, Color3.fromRGB(0, 255, 127))
                    end
                    ContextMenu.Visible = false
                elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                    SelectedCpName = item.Name
                    BtnCtxAutoJoin.Text = item.Data.AutoJoin and "Auto Join: ON" or "Auto Join: OFF"
                    BtnCtxAutoJoin.TextColor3 = item.Data.AutoJoin and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(200, 200, 200)
                    ContextMenu.Position = UDim2.new(0, Mouse.X, 0, Mouse.Y)
                    ContextMenu.Visible = true
                end
            end)
        end
        ySize = ySize + 35
    end
    TpScroll.CanvasSize = UDim2.new(0, 0, 0, ySize)
end

BtnToggleReorder.MouseButton1Click:Connect(function()
    IsReorderMode = not IsReorderMode
    if IsReorderMode then
        TempCheckpoints = HttpService:JSONDecode(HttpService:JSONEncode(SavedCheckpoints[CurrentPlaceId]))
        BtnToggleReorder.ImageColor3 = Color3.fromRGB(255, 150, 0)
        BtnAddNewTp.Visible = false
        -- الأزرار مخفية في البداية الين تسحب وتبدل فعلياً
        BtnSaveOrder.Visible = false
        BtnCancelOrder.Visible = false
        TxtOrderMode.Text = "اسحب للترتيب (Drag to Reorder)"
        TxtOrderMode.Visible = true
    else
        BtnToggleReorder.ImageColor3 = Color3.fromRGB(200, 200, 200)
        BtnAddNewTp.Visible = true
        BtnSaveOrder.Visible = false
        BtnCancelOrder.Visible = false
        TxtOrderMode.Visible = false
    end
    RefreshTpList()
end)

BtnSaveOrder.MouseButton1Click:Connect(function()
    ShowConfirm("هل متأكد أنك تريد تبديل الترتيب وحفظه؟", function(yes)
        if yes then
            SavedCheckpoints[CurrentPlaceId] = TempCheckpoints
            SaveCheckpoints()
            Notify("Saved", "تم حفظ الترتيب الجديد بنجاح!", Color3.fromRGB(0, 255, 127))
            
            TpScroll.Position = UDim2.new(0, -20, 0, 35)
            TpScroll:TweenPosition(UDim2.new(0, 5, 0, 35), "Out", "Back", 0.3, true)
            
            BtnToggleReorder.ImageColor3 = Color3.fromRGB(200, 200, 200)
            IsReorderMode = false
            BtnAddNewTp.Visible = true
            BtnSaveOrder.Visible = false
            BtnCancelOrder.Visible = false
            TxtOrderMode.Visible = false
            RefreshTpList()
        end
    end)
end)

BtnCancelOrder.MouseButton1Click:Connect(function()
    ShowConfirm("هل متأكد أنك تريد إلغاء الترتيب؟", function(yes)
        if yes then
            Notify("Cancelled", "تم إلغاء التبديلات ورجوع الترتيب القديم.", Color3.fromRGB(255, 50, 50))
            BtnToggleReorder.ImageColor3 = Color3.fromRGB(200, 200, 200)
            IsReorderMode = false
            BtnAddNewTp.Visible = true
            BtnSaveOrder.Visible = false
            BtnCancelOrder.Visible = false
            TxtOrderMode.Visible = false
            RefreshTpList()
        end
    end)
end)

UIS.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        if ContextMenu.Visible then
            local pos = ContextMenu.AbsolutePosition
            local size = ContextMenu.AbsoluteSize
            if Mouse.X < pos.X or Mouse.X > pos.X + size.X or Mouse.Y < pos.Y or Mouse.Y > pos.Y + size.Y then
                ContextMenu.Visible = false
            end
        end
    end
end)

BtnAddNewTp.MouseButton1Click:Connect(function()
    RenameMode = false
    ModalInput.Text = ""
    ModalFrame.Visible = true
end)

BtnCancelModal.MouseButton1Click:Connect(function()
    ModalFrame.Visible = false
end)

BtnSaveModal.MouseButton1Click:Connect(function()
    local name = ModalInput.Text
    if name ~= "" then
        if RenameMode and SelectedCpName ~= "" then
            local data = SavedCheckpoints[CurrentPlaceId][SelectedCpName]
            if data then
                SavedCheckpoints[CurrentPlaceId][name] = {
                    X = data.X, Y = data.Y, Z = data.Z, 
                    AutoJoin = data.AutoJoin, Order = data.Order
                }
                if name ~= SelectedCpName then
                    SavedCheckpoints[CurrentPlaceId][SelectedCpName] = nil
                end
                Notify("Rename", "تم تغيير الاسم إلى: " .. name, Color3.fromRGB(0, 255, 127))
            end
        elseif Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local pos = Player.Character.HumanoidRootPart.Position
            local maxOrder = 0
            for _, d in pairs(SavedCheckpoints[CurrentPlaceId]) do
                if d.Order and d.Order > maxOrder then maxOrder = d.Order end
            end
            SavedCheckpoints[CurrentPlaceId][name] = {
                X = pos.X, Y = pos.Y, Z = pos.Z, AutoJoin = false, Order = maxOrder + 1
            }
            Notify("Checkpoint", "تم حفظ النقطة بنجاح!", Color3.fromRGB(0, 255, 127))
        end
        SaveCheckpoints()
        RefreshTpList()
        ModalInput.Text = ""
        ModalFrame.Visible = false
    end
end)

BtnCtxRename.MouseButton1Click:Connect(function()
    if SelectedCpName ~= "" then
        RenameMode = true
        ModalInput.Text = SelectedCpName
        ModalFrame.Visible = true
        ContextMenu.Visible = false
    end
end)

BtnCtxDelete.MouseButton1Click:Connect(function()
    if SelectedCpName ~= "" then
        SavedCheckpoints[CurrentPlaceId][SelectedCpName] = nil
        SaveCheckpoints()
        RefreshTpList()
        ContextMenu.Visible = false
        Notify("Deleted", "تم حذف النقطة.", Color3.fromRGB(255, 50, 50))
    end
end)

BtnCtxAutoJoin.MouseButton1Click:Connect(function()
    if SelectedCpName ~= "" then
        local currentState = SavedCheckpoints[CurrentPlaceId][SelectedCpName].AutoJoin
        for n, d in pairs(SavedCheckpoints[CurrentPlaceId]) do d.AutoJoin = false end
        SavedCheckpoints[CurrentPlaceId][SelectedCpName].AutoJoin = not currentState
        SaveCheckpoints()
        RefreshTpList()
        ContextMenu.Visible = false
        if not currentState then
            Notify("Auto Join", "تم التفعيل! سيتم نقلك هنا عند دخول الماب.", Color3.fromRGB(0, 255, 127))
        else
            Notify("Auto Join", "تم الإيقاف.", Color3.fromRGB(200, 200, 200))
        end
    end
end)

-----------------------------------
-- باقي الأكواد والميزات (Aimbot, Fly, ESP...) --
-----------------------------------
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
local TPadding = Instance.new("UIPadding", TargetsContainer) TPadding.PaddingLeft = UDim.new(0, 8)
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

local BtnCmdFling = CreateControlButton("Fling: OFF", Color3.fromRGB(200, 200, 200))
local BtnCmdTp = CreateControlButton("Teleport", Color3.fromRGB(80, 200, 255))
local BtnCmdBring = CreateControlButton("Bring", Color3.fromRGB(255, 200, 80))
local BtnCmdSpec = CreateControlButton("Spectate", Color3.fromRGB(100, 255, 100))
local BtnCmdScare = CreateControlButton("Scare: OFF", Color3.fromRGB(200, 200, 200))

local isScaring = false
local isFlinging = false
local FlingLoop = nil

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
        pcall(function() 
            local imgContent, isReady = game.Players:GetUserThumbnailAsync(tPlayer.UserId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size150x150)
            SpecImage.Image = imgContent
        end)
        if SpectateLoop then SpectateLoop:Disconnect() end
        SpectateLoop = RunService.RenderStepped:Connect(function()
            if tPlayer and tPlayer.Character and tPlayer.Character:FindFirstChild("Humanoid") then
                workspace.CurrentCamera.CameraSubject = tPlayer.Character.Humanoid
            else StopSpectating() end
        end)
    end
end)

BtnCmdFling.MouseButton1Click:Connect(function()
    isFlinging = not isFlinging
    if isFlinging then
        BtnCmdFling.Text = string.split(BtnCmdFling.Text, ":")[1] .. ": ON"
        BtnCmdFling.TextColor3 = Color3.fromRGB(0, 255, 127)
        Notify("Fling", "تم تشغيل وضع التطير!", Color3.fromRGB(0, 255, 127))
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
        BtnCmdFling.Text = string.split(BtnCmdFling.Text, ":")[1] .. ": OFF"
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

BtnCmdScare.MouseButton1Click:Connect(function()
    isScaring = not isScaring
    if isScaring then
        BtnCmdScare.Text = string.split(BtnCmdScare.Text, ":")[1] .. ": ON"
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
                else task.wait(0.1) end
            end
            if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                Player.Character.HumanoidRootPart.Anchored = false
            end
        end)
    else
        BtnCmdScare.Text = string.split(BtnCmdScare.Text, ":")[1] .. ": OFF"
        BtnCmdScare.TextColor3 = Color3.fromRGB(200, 200, 200)
        Notify("Scare", "تم إيقاف التخويف.", Color3.fromRGB(200, 200, 200))
    end
end)

local Features = {
    Fly = false, FlyNoclip = false, GodMode = false, InfJump = false, Noclip = false, 
    InstantPrompt = false, SuperHit = false, AntiAFK = true, ControlWand = false, ESP = false,
    CustomSpeed = false, WalkSpeed = 100, CarSpeed = 100, FlySpeed = 100, CarFlySpeed = 100, 
    CustomJump = false, JumpValue = 100, Aimbot = false, AimbotFOV = 150
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

local BtnOpenTeleports = CreateButton("Checkpoints", ScrollFrame)
BtnOpenTeleports.MouseButton1Click:Connect(function()
    TpFrame.Visible = not TpFrame.Visible
    if TpFrame.Visible then
        -- إغلاق وضع التعديل (الترتيب) أوامر تفتح القائمة الجديدة عشان تطلع لك بشكلها الأساسي
        IsReorderMode = false
        BtnToggleReorder.ImageColor3 = Color3.fromRGB(200, 200, 200)
        BtnAddNewTp.Visible = true
        BtnSaveOrder.Visible = false
        BtnCancelOrder.Visible = false
        TxtOrderMode.Visible = false
        ContextMenu.Visible = false
        ModalFrame.Visible = false
        RefreshTpList()
    end
end)

local BtnAimbot = CreateButton("Aimbot A: OFF", ScrollFrame)
local BtnWand = CreateButton("Control Wand : OFF", ScrollFrame)
local BtnFly = CreateButton("Fly : OFF", ScrollFrame)
local BtnFlyNoclip = CreateButton("Fly Noclip : OFF", ScrollFrame)
BtnFlyNoclip.Visible = false
local BtnESP = CreateButton("ESP: OFF", ScrollFrame)
local BtnGod = CreateButton("God Mode: OFF", ScrollFrame)
local BtnRevive = CreateButton("Revive", ScrollFrame)
local BtnNoclip = CreateButton("Noclip: OFF", ScrollFrame)
local BtnInstant = CreateButton("Instant Interact: OFF", ScrollFrame)
local BtnSuperHit = CreateButton("Super Hero Hit : OFF", ScrollFrame)
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

-----------------------------------
-- Aimbot A System (Smooth + TriggerBot)
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
FOVStroke.Color = Color3.fromRGB(255, 0, 0)
FOVStroke.Thickness = 1.5
FOVFrame.Visible = false

local function GetClosestToCenter()
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
                    closestDist = dist
                    closestTarget = v.Character.Head
                end
            end
        end
    end
    return closestTarget
end

BtnAimbot.MouseButton1Click:Connect(function()
    Features.Aimbot = not Features.Aimbot
    BtnAimbot.Text = "Aimbot A: " .. (Features.Aimbot and "ON" or "OFF")
    BtnAimbot.TextColor3 = Features.Aimbot and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(200, 200, 200)
    FOVFrame.Visible = Features.Aimbot
end)

local clicking = false
local AimbotLoop = RunService.RenderStepped:Connect(function()
    if Features.Aimbot then
        local targetHead = GetClosestToCenter()
        if targetHead then
            local camCFrame = workspace.CurrentCamera.CFrame
            local newCFrame = CFrame.new(camCFrame.Position, targetHead.Position)
            workspace.CurrentCamera.CFrame = camCFrame:Lerp(newCFrame, 0.25)
            
            if not clicking then
                clicking = true
                pcall(function()
                    if mouse1press then mouse1press() task.wait(0.05) mouse1release()
                    else VirtualUser:ClickButton1(Vector2.new()) end
                end)
                task.wait(0.1)
                clicking = false
            end
        end
        
        local tool = Player.Character and Player.Character:FindFirstChildOfClass("Tool")
        if tool then
            for _, v in pairs(tool:GetDescendants()) do
                if v:IsA("ValueBase") and type(v.Value) == "number" then
                    local nameLow = string.lower(v.Name)
                    if string.find(nameLow, "ammo") or string.find(nameLow, "clip") or string.find(nameLow, "mag") then
                        v.Value = 999
                    end
                end
            end
        end
    end
end)

local ESPLoop = nil
BtnESP.MouseButton1Click:Connect(function()
    Features.ESP = not Features.ESP
    BtnESP.Text = string.split(BtnESP.Text, ":")[1] .. (Features.ESP and ": ON" or ": OFF")
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
    BtnWand.Text = string.split(BtnWand.Text, ":")[1] .. (Features.ControlWand and ": ON" or ": OFF")
    BtnWand.TextColor3 = Features.ControlWand and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(200, 200, 200)
    
    CleanupWands() 
    if Features.ControlWand then
        local currentWand = Instance.new("Tool")
        currentWand.RequiresHandle = false
        currentWand.CanBeDropped = false
        currentWand.Name = "Zoko Control"
        currentWand.ToolTip = "اضغط على لاعب لإضافته"
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
    BtnFly.Text = string.split(BtnFly.Text, ":")[1] .. (Features.Fly and ": ON" or ": OFF")
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
            BtnFlyNoclip.Text = string.split(BtnFlyNoclip.Text, ":")[1] .. ": OFF"
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
    BtnFlyNoclip.Text = string.split(BtnFlyNoclip.Text, ":")[1] .. (Features.FlyNoclip and ": ON" or ": OFF")
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
    else lastNoclipPos = nil end
end)

local RenderLoop = RunService.RenderStepped:Connect(function()
    local char = Player.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum then return end

    if Features.GodMode then
        pcall(function()
            hum.MaxHealth = math.huge
            hum.Health = math.huge
            hum.BreakJointsOnDeath = false 
            hum.RequiresNeck = false 
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false) 
            local currentState = hum:GetState()
            if currentState == Enum.HumanoidStateType.Ragdoll or currentState == Enum.HumanoidStateType.FallingDown or currentState == Enum.HumanoidStateType.Dead or currentState == Enum.HumanoidStateType.Physics then
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
            if hrp then hrp.CustomPhysicalProperties = PhysicalProperties.new(100000, 0.3, 0.5, 1, 1) end
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("Motor6D") and not v.Enabled then v.Enabled = true end
            end
        end)
    else 
        pcall(function() 
            if hrp then hrp.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0.5, 1, 1) end 
            hum.RequiresNeck = true
        end) 
    end

    local isVehicle = hum.SeatPart ~= nil
    local newState = "Walk"
    if Features.Fly then newState = isVehicle and "CarFly" or "Fly"
    else newState = isVehicle and "Car" or "Walk" end
    
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
        elseif newState == "Walk" then hum.WalkSpeed = Features.WalkSpeed end
    else BtnSpeed.TextColor3 = Color3.fromRGB(200, 200, 200) end
    
    if Features.CustomJump then hum.UseJumpPower = true hum.JumpPower = Features.JumpValue end
end)

BtnGod.MouseButton1Click:Connect(function()
    Features.GodMode = not Features.GodMode
    BtnGod.Text = string.split(BtnGod.Text, ":")[1] .. (Features.GodMode and ": ON" or ": OFF")
    BtnGod.TextColor3 = Features.GodMode and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(200, 200, 200)
    if Features.GodMode and Player.Character then
        local hum = Player.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.HealthChanged:Connect(function(newHealth)
                if Features.GodMode and newHealth < hum.MaxHealth then hum.Health = hum.MaxHealth end
            end)
        end
        pcall(function()
            if getconnections then
                for _, v in pairs(Player.Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        for _, conn in pairs(getconnections(v.Touched)) do conn:Disable() end
                    end
                end
                Notify("God Mode", "تم تفعيل وضع الشبح المنيع (ضد لمس الكوارث)!", Color3.fromRGB(0, 255, 127))
            end
        end)
    end
end)

BtnRevive.MouseButton1Click:Connect(function()
    local char = Player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            pcall(function()
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                hum.Health = hum.MaxHealth
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("Motor6D") then v.Enabled = true end
                end
            end)
            Notify("Force Revive", "تم الإنعاش مع الحفاظ على الانفنتوري!", Color3.fromRGB(0, 255, 127))
        end
    end
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
    BtnInstant.Text = string.split(BtnInstant.Text, ":")[1] .. (Features.InstantInteract and ": ON" or ": OFF")
    BtnInstant.TextColor3 = Features.InstantInteract and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(200, 200, 200)
    if Features.InstantInteract then
        InstantInteractLoop = RunService.Heartbeat:Connect(function()
            for _, obj in pairs(workspace:GetDescendants()) do if obj:IsA("ProximityPrompt") then obj.HoldDuration = 0 end end
        end)
    else if InstantInteractLoop then InstantInteractLoop:Disconnect() InstantInteractLoop = nil end end
end)

BtnNoclip.MouseButton1Click:Connect(function()
    Features.Noclip = not Features.Noclip
    BtnNoclip.Text = string.split(BtnNoclip.Text, ":")[1] .. (Features.Noclip and ": ON" or ": OFF")
    BtnNoclip.TextColor3 = Features.Noclip and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(200, 200, 200)
    if not Features.Noclip and Player.Character then
        for _, part in pairs(Player.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = true end end
    end
end)

BtnSuperHit.MouseButton1Click:Connect(function()
    Features.SuperHit = not Features.SuperHit
    BtnSuperHit.Text = string.split(BtnSuperHit.Text, ":")[1] .. (Features.SuperHit and ": ON" or ": OFF")
    BtnSuperHit.TextColor3 = Features.SuperHit and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(200, 200, 200)
end)

BtnInfJump.MouseButton1Click:Connect(function()
    Features.InfJump = not Features.InfJump
    BtnInfJump.Text = string.split(BtnInfJump.Text, ":")[1] .. (Features.InfJump and ": ON" or ": OFF")
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
    BtnAntiAFK.Text = string.split(BtnAntiAFK.Text, ":")[1] .. (Features.AntiAFK and ": ON" or ": OFF")
    BtnAntiAFK.TextColor3 = Features.AntiAFK and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(200, 200, 200)
end)

BtnJump.MouseButton1Click:Connect(function()
    Features.CustomJump = not Features.CustomJump
    BtnJump.Text = string.split(BtnJump.Text, ":")[1] .. (Features.CustomJump and ": ON" or ": OFF")
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
    if AimbotLoop then AimbotLoop:Disconnect() end
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

-----------------------------------
-- تنفيذ الانتقال عند الدخول ------
-----------------------------------
task.spawn(function()
    local autoJoinTarget = nil
    for name, data in pairs(SavedCheckpoints[CurrentPlaceId] or {}) do
        if data.AutoJoin then autoJoinTarget = data break end
    end
    
    if autoJoinTarget then
        local char = Player.Character or Player.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart", 5)
        if hrp then
            task.wait(1)
            hrp.CFrame = CFrame.new(autoJoinTarget.X, autoJoinTarget.Y, autoJoinTarget.Z)
            Notify("Auto Join", "تم نقلك لنقطة الحفظ التلقائية!", Color3.fromRGB(0, 255, 127))
        end
    end
end)
