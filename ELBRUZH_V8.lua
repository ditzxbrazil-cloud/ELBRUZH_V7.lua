-- [[ ELBRUZH - PRECISION REPAIR ]] --

local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- [[ 1. DATA SYSTEM ]] --
local FolderName = "ELBRUZH_Configs"
if not isfolder(FolderName) then makefolder(FolderName) end

local TeleportTable = {}
local TeleportSpeed = 1.0 
local looping = false

-- [[ 2. NOTIFICATION SYSTEM (Sesuai Video) ]] --
local function ShowNotify(msg)
    local Notify = Instance.new("Frame", ScreenGui)
    Notify.Size = UDim2.new(0, 200, 0, 40)
    Notify.Position = UDim2.new(0.5, -100, 1, -100)
    Notify.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Instance.new("UICorner", Notify)
    Instance.new("UIStroke", Notify).Color = Color3.fromRGB(0, 255, 255)
    
    local txt = Instance.new("TextLabel", Notify)
    txt.Size = UDim2.new(1, 0, 1, 0); txt.Text = msg; txt.TextColor3 = Color3.new(1,1,1)
    txt.BackgroundTransparency = 1; txt.Font = Enum.Font.Gotham
    
    task.wait(2)
    Notify:Destroy()
end

-- [[ 3. GUI BASE ]] --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "ELBRUZH_V8_Final"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 550, 0, 380) -- Frame lebih panjang sedikit
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 12, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true 
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 15)
Instance.new("UIStroke", MainFrame).Thickness = 3.5

-- [[ 4. TITLE & DIVIDER (NEW) ]] --
local Title = Instance.new("TextLabel", MainFrame)
Title.Text = "ELBRUZH - AUTO TELEPORT"; Title.Size = UDim2.new(1, 0, 0, 50)
Title.TextColor3 = Color3.fromRGB(0, 255, 255); Title.Font = Enum.Font.GothamBold
Title.TextSize = 22; Title.BackgroundTransparency = 1; Title.ZIndex = 10

local Divider = Instance.new("Frame", MainFrame)
Divider.Size = UDim2.new(0.9, 0, 0, 2)
Divider.Position = UDim2.new(0.05, 0, 0, 55)
Divider.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
Divider.BorderSizePixel = 0; Divider.ZIndex = 10

-- [[ 5. LIST & BUTTONS (TIDAK MENUMPUK) ]] --
local ListFrame = Instance.new("ScrollingFrame", MainFrame)
ListFrame.Size = UDim2.new(0, 320, 0, 230); ListFrame.Position = UDim2.new(0, 20, 0, 75)
ListFrame.BackgroundTransparency = 1; ListFrame.ScrollBarThickness = 4; ListFrame.ZIndex = 5
local UIList = Instance.new("UIListLayout", ListFrame); UIList.Padding = UDim.new(0, 8)

local function UpdateList()
    for _, c in pairs(ListFrame:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
    for i, v in pairs(TeleportTable) do
        local Row = Instance.new("Frame", ListFrame)
        Row.Size = UDim2.new(0.95, 0, 0, 40); Row.BackgroundColor3 = Color3.fromRGB(20, 25, 40)
        Row.ZIndex = 6; Instance.new("UICorner", Row)
        local Label = Instance.new("TextLabel", Row)
        Label.Text = "📍 POSISI " .. i; Label.Size = UDim2.new(0.5, 0, 1, 0); Label.TextColor3 = Color3.new(1,1,1); Label.BackgroundTransparency = 1; Label.ZIndex = 7
        local TPBtn = Instance.new("TextButton", Row)
        TPBtn.Text = "TP"; TPBtn.Size = UDim2.new(0, 45, 0, 25); TPBtn.Position = UDim2.new(0.55, 0, 0.5, -12)
        TPBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 80); Instance.new("UICorner", TPBtn); TPBtn.ZIndex = 7
        TPBtn.MouseButton1Click:Connect(function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(v.X, v.Y, v.Z) end)
        local Del = Instance.new("TextButton", Row)
        Del.Text = "🗑️"; Del.Size = UDim2.new(0, 35, 0, 25); Del.Position = UDim2.new(0.85, 0, 0.5, -12)
        Del.BackgroundColor3 = Color3.fromRGB(150, 0, 0); Instance.new("UICorner", Del); Del.ZIndex = 7
        Del.MouseButton1Click:Connect(function() table.remove(TeleportTable, i); UpdateList() end)
    end
end

-- [[ 6. POP-UP MODAL (SESUAI VIDEO) ]] --
local Modal = Instance.new("Frame", MainFrame)
Modal.Size = UDim2.new(0, 320, 0, 180); Modal.Position = UDim2.new(0.5, -160, 0.5, -90)
Modal.BackgroundColor3 = Color3.fromRGB(25, 25, 30); Modal.Visible = false; Modal.ZIndex = 100
Instance.new("UICorner", Modal)
Instance.new("UIStroke", Modal).Color = Color3.fromRGB(0, 255, 255)

local ModalTitle = Instance.new("TextLabel", Modal)
ModalTitle.Size = UDim2.new(1, 0, 0, 40); ModalTitle.Text = "Config Name"; ModalTitle.TextColor3 = Color3.new(1,1,1)
ModalTitle.BackgroundTransparency = 1; ModalTitle.ZIndex = 101; ModalTitle.Font = Enum.Font.GothamBold

local ModalInput = Instance.new("TextBox", Modal)
ModalInput.Size = UDim2.new(0.8, 0, 0, 35); ModalInput.Position = UDim2.new(0.1, 0, 0.35, 0)
ModalInput.PlaceholderText = "Type here..."; ModalInput.BackgroundColor3 = Color3.new(0,0,0)
ModalInput.TextColor3 = Color3.new(1,1,1); ModalInput.ZIndex = 101

local ModalSave = Instance.new("TextButton", Modal)
ModalSave.Size = UDim2.new(0.4, 0, 0, 35); ModalSave.Position = UDim2.new(0.55, 0, 0.7, 0)
ModalSave.Text = "Save"; ModalSave.BackgroundColor3 = Color3.fromRGB(0, 150, 80); ModalSave.TextColor3 = Color3.new(1,1,1); ModalSave.ZIndex = 101; Instance.new("UICorner", ModalSave)

local ModalCancel = Instance.new("TextButton", Modal)
ModalCancel.Size = UDim2.new(0.4, 0, 0, 35); ModalCancel.Position = UDim2.new(0.05, 0, 0.7, 0)
ModalCancel.Text = "Cancel"; ModalCancel.BackgroundColor3 = Color3.fromRGB(150, 0, 0); ModalCancel.TextColor3 = Color3.new(1,1,1); ModalCancel.ZIndex = 101; Instance.new("UICorner", ModalCancel)
ModalCancel.MouseButton1Click:Connect(function() Modal.Visible = false end)

-- [[ 7. LOAD LIST MODAL ]] --
local LoadFrame = Instance.new("Frame", MainFrame)
LoadFrame.Size = UDim2.new(0, 320, 0, 250); LoadFrame.Position = UDim2.new(0.5, -160, 0.5, -125)
LoadFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25); LoadFrame.Visible = false; LoadFrame.ZIndex = 110
Instance.new("UICorner", LoadFrame); Instance.new("UIStroke", LoadFrame).Color = Color3.fromRGB(0, 255, 255)

local LoadTitle = Instance.new("TextLabel", LoadFrame)
LoadTitle.Text = "Select Configuration"; LoadTitle.Size = UDim2.new(1, 0, 0, 40); LoadTitle.TextColor3 = Color3.new(1,1,1); LoadTitle.BackgroundTransparency = 1; LoadTitle.ZIndex = 111

local LoadScroll = Instance.new("ScrollingFrame", LoadFrame)
LoadScroll.Size = UDim2.new(0.9, 0, 0.6, 0); LoadScroll.Position = UDim2.new(0.05, 0, 0.2, 0)
LoadScroll.BackgroundTransparency = 1; LoadScroll.ZIndex = 111; LoadScroll.ScrollBarThickness = 3
Instance.new("UIListLayout", LoadScroll).Padding = UDim.new(0, 5)

local LoadClose = Instance.new("TextButton", LoadFrame)
LoadClose.Text = "Close"; LoadClose.Size = UDim2.new(1, 0, 0, 35); LoadClose.Position = UDim2.new(0, 0, 0.85, 0)
LoadClose.BackgroundColor3 = Color3.fromRGB(50, 50, 50); LoadClose.TextColor3 = Color3.new(1,1,1); LoadClose.ZIndex = 111
LoadClose.MouseButton1Click:Connect(function() LoadFrame.Visible = false end)

-- [[ 8. MAIN BUTTONS (SESUAI POSISI SCRIPT AWAL) ]] --
local function CreateBtn(t, c, y, cb)
    local b = Instance.new("TextButton", MainFrame)
    b.Text = t; b.Size = UDim2.new(0, 180, 0, 40); b.Position = UDim2.new(0.64, 0, 0, y)
    b.BackgroundColor3 = c; b.TextColor3 = Color3.new(1,1,1); b.ZIndex = 10; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(cb)
end

CreateBtn("📍 ADD CHECKPOINT", Color3.fromRGB(0, 120, 255), 75, function()
    local p = LocalPlayer.Character.HumanoidRootPart.Position
    table.insert(TeleportTable, {X=p.X, Y=p.Y, Z=p.Z}); UpdateList()
end)

CreateBtn("▶ START LOOP", Color3.fromRGB(0, 180, 80), 125, function()
    if looping then return end
    looping = true
    task.spawn(function()
        while looping do
            if #TeleportTable == 0 then looping = false; break end
            for _, v in pairs(TeleportTable) do
                if not looping then break end
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(v.X, v.Y, v.Z)
                task.wait(TeleportSpeed)
            end
            task.wait(0.1)
        end
    end)
end)

CreateBtn("⏹ STOP LOOP", Color3.fromRGB(200, 40, 40), 175, function() looping = false end)

CreateBtn("💾 SAVE CONFIG", Color3.fromRGB(150, 50, 255), 225, function()
    Modal.Visible = true; ModalInput.Text = ""
end)

ModalSave.MouseButton1Click:Connect(function()
    if ModalInput.Text ~= "" then
        local path = FolderName.."/"..ModalInput.Text..".json"
        writefile(path, HttpService:JSONEncode({Pos = TeleportTable, Speed = TeleportSpeed}))
        Modal.Visible = false
        task.spawn(function() ShowNotify("Saved: "..ModalInput.Text) end)
    end
end)

CreateBtn("📂 LOAD CONFIG", Color3.fromRGB(100, 100, 100), 275, function()
    LoadFrame.Visible = true
    for _, c in pairs(LoadScroll:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
    for _, file in pairs(listfiles(FolderName)) do
        local name = file:gsub(FolderName.."/", ""):gsub(".json", "")
        local Row = Instance.new("Frame", LoadScroll)
        Row.Size = UDim2.new(1, -5, 0, 35); Row.BackgroundTransparency = 1; Row.ZIndex = 112
        
        local btn = Instance.new("TextButton", Row)
        btn.Size = UDim2.new(0.8, 0, 1, 0); btn.Text = name; btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        btn.TextColor3 = Color3.new(1,1,1); btn.ZIndex = 113; Instance.new("UICorner", btn)
        
        local del = Instance.new("TextButton", Row)
        del.Size = UDim2.new(0.15, 0, 1, 0); del.Position = UDim2.new(0.85, 0, 0, 0)
        del.Text = "🗑️"; del.BackgroundColor3 = Color3.fromRGB(150, 0, 0); del.ZIndex = 113; Instance.new("UICorner", del)
        
        btn.MouseButton1Click:Connect(function()
            local data = HttpService:JSONDecode(readfile(file))
            TeleportTable = data.Pos or {}; TeleportSpeed = data.Speed or 1.0
            UpdateList(); LoadFrame.Visible = false
            task.spawn(function() ShowNotify("Loaded: "..name) end)
        end)
        
        del.MouseButton1Click:Connect(function() delfile(file); Row:Destroy() end)
    end
end)

-- [[ 9. SPEED SYSTEM ]] --
local SLabel = Instance.new("TextLabel", MainFrame)
SLabel.Text = "SPEED: "..string.format("%.1f", TeleportSpeed).."s"
SLabel.Position = UDim2.new(0.64, 0, 0, 315); SLabel.Size = UDim2.new(0, 180, 0, 20)
SLabel.TextColor3 = Color3.new(1,1,1); SLabel.BackgroundTransparency = 1; SLabel.ZIndex = 10

local function CreateSpeedBtn(txt, x, delta)
    local b = Instance.new("TextButton", MainFrame)
    b.Text = txt; b.Size = UDim2.new(0, 45, 0, 35); b.Position = UDim2.new(0.64, x, 0, 335)
    b.BackgroundColor3 = Color3.fromRGB(255, 230, 0); b.TextColor3 = Color3.new(0,0,0)
    b.Font = Enum.Font.GothamBold; b.TextSize = 25; b.ZIndex = 10; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        TeleportSpeed = math.max(0.1, TeleportSpeed + delta)
        SLabel.Text = "SPEED: "..string.format("%.1f", TeleportSpeed).."s"
    end)
end
CreateSpeedBtn("-", 0, -0.1); CreateSpeedBtn("+", 135, 0.1)

-- [[ 10. MINIMIZE & CLOSE ]] --
local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Text = "X"; CloseBtn.Size = UDim2.new(0, 35, 0, 35); CloseBtn.Position = UDim2.new(1, -45, 0, 10)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0); CloseBtn.ZIndex = 20; Instance.new("UICorner", CloseBtn)

local MinIcon = Instance.new("ImageButton", ScreenGui)
MinIcon.Size = UDim2.new(0, 55, 0, 55); MinIcon.Position = UDim2.new(1, -60, 0, 15)
MinIcon.Image = "rbxassetid://6031094678"; MinIcon.Visible = false; MinIcon.ZIndex = 100
Instance.new("UICorner", MinIcon).CornerRadius = UDim.new(1, 0)

CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; MinIcon.Visible = true end)
MinIcon.MouseButton1Click:Connect(function() MainFrame.Visible = true; MinIcon.Visible = false end)

-- [[ 11. DRAG FIX ]] --
local dragToggle, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragToggle = true; dragStart = input.Position; startPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function() dragToggle = false end)

UpdateList()
