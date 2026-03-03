local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local ParentObj = (gethui and gethui()) or game:GetService("CoreGui")

if ParentObj:FindFirstChild("Poseria_V8") then ParentObj.Poseria_V8:Destroy() end

local Flags = { ESP = false, Desync = false, AntiLag = false, Morph = false }
local TargetId = 0

local Gui = Instance.new("ScreenGui", ParentObj); Gui.Name = "Poseria_V8"
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 240, 0, 300); Main.Position = UDim2.new(0.5, -120, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12); Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)
local Stroke = Instance.new("UIStroke", Main); Stroke.Color = Color3.fromRGB(255, 255, 255); Stroke.Thickness = 1

local Container = Instance.new("Frame", Main); Container.Size = UDim2.new(1, -20, 1, -20); Container.Position = UDim2.new(0, 10, 0, 10); Container.BackgroundTransparency = 1
Instance.new("UIListLayout", Container).Padding = UDim.new(0, 5)

local Input = Instance.new("TextBox", Container)
Input.Size = UDim2.new(1, 0, 0, 35); Input.BackgroundColor3 = Color3.fromRGB(30, 30, 30); Input.Text = "Username..."; Input.TextColor3 = Color3.new(1,1,1); Input.Font = "GothamBold"; Instance.new("UICorner", Input)

local function MorphLogic()
    if not Flags.Morph or not Player.Character then return end
    local hum = Player.Character:FindFirstChildOfClass("Humanoid")
    if hum and TargetId ~= 0 then
        local desc = Players:GetHumanoidDescriptionFromUserId(TargetId)
        hum:ApplyDescription(desc)
    end
end

local MorphBtn = Instance.new("TextButton", Container)
MorphBtn.Size = UDim2.new(1, 0, 0, 40); MorphBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45); MorphBtn.Text = "TOGGLE MORPH [G]"; MorphBtn.TextColor3 = Color3.new(1,1,1); MorphBtn.Font = "GothamBold"; Instance.new("UICorner", MorphBtn)
MorphBtn.MouseButton1Click:Connect(function()
    Flags.Morph = not Flags.Morph
    if Flags.Morph then
        local success, id = pcall(function() return Players:GetUserIdFromNameAsync(Input.Text) end)
        if success then TargetId = id; MorphLogic() end
    end
    MorphBtn.BackgroundColor3 = Flags.Morph and Color3.new(1,1,1) or Color3.fromRGB(45, 45, 45)
    MorphBtn.TextColor3 = Flags.Morph and Color3.new(0,0,0) or Color3.new(1,1,1)
end)

RunService.Heartbeat:Connect(function()
    local char = Player.Character
    if not char or not Flags.Desync then return end
    
    for _, v in pairs(char:GetChildren()) do
        if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
 
            v.CFrame = v.CFrame * CFrame.new(math.random(-2, 2), 0, math.random(-2, 2))
        end
    end
end)

task.spawn(function()
    while task.wait(5) do 
        if Flags.Morph then MorphLogic() end
    end
end)

local function AddToggle(n, f, key)
    local b = Instance.new("TextButton", Container); b.Size = UDim2.new(1, 0, 0, 40); b.BackgroundColor3 = Color3.fromRGB(25, 25, 25); b.Text = n .. " [" .. key .. "]"; b.TextColor3 = Color3.new(0.6, 0.6, 0.6); b.Font = "GothamBold"; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        Flags[f] = not Flags[f]
        b.BackgroundColor3 = Flags[f] and Color3.new(1, 1, 1) or Color3.fromRGB(25, 25, 25)
        b.TextColor3 = Flags[f] and Color3.new(0, 0, 0) or Color3.new(0.6, 0.6, 0.6)
    end)
end

AddToggle("PLAYER ESP", "ESP", "Z")
AddToggle("FIXED DESYNC", "Desync", "X")
AddToggle("ANTI-LAG", "AntiLag", "C")

UserInputService.InputBegan:Connect(function(i, p)
    if p then return end
    if i.KeyCode == Enum.KeyCode.G then Flags.Morph = not Flags.Morph 
    elseif i.KeyCode == Enum.KeyCode.P then Main.Visible = not Main.Visible end
end)


local d, ds, sp
Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true; ds = i.Position; sp = Main.Position end end)
UserInputService.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then
    local del = i.Position - ds; Main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + del.X, sp.Y.Scale, sp.Y.Offset + del.Y)
end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)

-- morph is bugged and if u know how to fix it please dm me :thumbsup: ill give u a good night kiss if u know how to make it
