local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local Player = Players.LocalPlayer
local Flags = { ESP = false, Desync = false, AntiLag = false }
local Toggles = {}

local ParentObj = (gethui and gethui()) or game:GetService("CoreGui")
if ParentObj:FindFirstChild("Poseria_Public") then ParentObj.Poseria_Public:Destroy() end

local Gui = Instance.new("ScreenGui", ParentObj); Gui.Name = "Poseria_Public"
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 240, 0, 420); Main.Position = UDim2.new(0.5, -120, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10); Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", Main).Color = Color3.new(1, 1, 1)

local Container = Instance.new("Frame", Main); Container.Size = UDim2.new(1, -20, 1, -20); Container.Position = UDim2.new(0, 10, 0, 10); Container.BackgroundTransparency = 1
Instance.new("UIListLayout", Container).Padding = UDim.new(0, 5)


local Credits = Instance.new("TextLabel", Container)
Credits.Size = UDim2.new(1, 0, 0, 30); Credits.BackgroundTransparency = 1
Credits.Text = "POSERIA VBL • BY NOTANAGEPLAYER"; Credits.TextColor3 = Color3.new(0.7, 0.7, 0.7)
Credits.Font = "SourceSansBold"; Credits.TextSize = 13


local function Morph(input)
    local targetId = nil
    

    if tonumber(input) then
        targetId = tonumber(input)
    else
        local success, id = pcall(function() return Players:GetUserIdFromNameAsync(input) end)
        if success then targetId = id end
    end
    
    if targetId and Player.Character then
        local char = Player.Character
        local hum = char:FindFirstChildOfClass("Humanoid")
        
        if hum then
     
            for _, v in pairs(char:GetChildren()) do
                if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("CharacterMesh") or v:IsA("BodyColors") then
                    v:Destroy()
                end
            end
            
    
            local description = Players:GetHumanoidDescriptionFromUserId(targetId)
            hum:ApplyDescription(description)
        end
    end
end


local Input = Instance.new("TextBox", Container)
Input.Size = UDim2.new(1, 0, 0, 35); Input.BackgroundColor3 = Color3.fromRGB(25, 25, 25); Input.PlaceholderText = "Username or ID..."; Input.Text = ""; Input.TextColor3 = Color3.new(1,1,1); Input.Font = "SourceSansBold"; Instance.new("UICorner", Input)

local MBtn = Instance.new("TextButton", Container); MBtn.Size = UDim2.new(1,0,0,35); MBtn.Text = "MORPH [G]"; MBtn.BackgroundColor3 = Color3.fromRGB(40,40,40); MBtn.TextColor3 = Color3.new(1,1,1); MBtn.Font = "SourceSansBold"; Instance.new("UICorner", MBtn)
MBtn.MouseButton1Click:Connect(function() Morph(Input.Text) end)

local function CreateToggle(name, flag, key)
    local btn = Instance.new("TextButton", Container); btn.Size = UDim2.new(1, 0, 0, 40); btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20); btn.Text = name .. " [" .. key .. "]"; btn.TextColor3 = Color3.new(0.6,0.6,0.6); btn.Font = "SourceSansBold"; Instance.new("UICorner", btn)
    local function Toggle()
        Flags[flag] = not Flags[flag]
        btn.BackgroundColor3 = Flags[flag] and Color3.new(1,1,1) or Color3.fromRGB(20, 20, 20)
        btn.TextColor3 = Flags[flag] and Color3.new(0,0,0) or Color3.new(0.6,0.6,0.6)
        
        if flag == "AntiLag" then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") then v.Material = Flags.AntiLag and Enum.Material.SmoothPlastic or Enum.Material.Plastic end
            end
        end
    end
    btn.MouseButton1Click:Connect(Toggle); Toggles[key] = Toggle
end

CreateToggle("PLAYER ESP", "ESP", "Z")
CreateToggle("CLASSIC DESYNC", "Desync", "X")
CreateToggle("ANTI-LAG", "AntiLag", "C")


RunService.Heartbeat:Connect(function()

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Player and p.Character then
            local highlight = p.Character:FindFirstChild("Poseria_ESP")
            if Flags.ESP then
                if not highlight then
                    highlight = Instance.new("Highlight", p.Character); highlight.Name = "Poseria_ESP"
                    highlight.FillColor = Color3.new(1,1,1); highlight.FillAlpha = 0.5
                end
            elseif highlight then highlight:Destroy() end
        end
    end

    local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if Flags.Desync and hrp then
        local oldV = hrp.Velocity; hrp.Velocity = Vector3.new(800, 0, 800)
        RunService.RenderStepped:Wait(); hrp.Velocity = oldV
    end
end)

UserInputService.InputBegan:Connect(function(i, p)
    if p then return end
    if Toggles[i.KeyCode.Name] then Toggles[i.KeyCode.Name]() end
    if i.KeyCode == Enum.KeyCode.G then Morph(Input.Text) end
    if i.KeyCode == Enum.KeyCode.P then Main.Visible = not Main.Visible end
end)

local d, ds, sp
Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true; ds = i.Position; sp = Main.Position end end)
UserInputService.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then
    local del = i.Position - ds; Main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + del.X, sp.Y.Scale, sp.Y.Offset + del.Y)
end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)
