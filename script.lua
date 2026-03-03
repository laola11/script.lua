local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local Player = Players.LocalPlayer
local ParentObj = (gethui and gethui()) or game:GetService("CoreGui")

if ParentObj:FindFirstChild("Poseria_Final") then ParentObj.Poseria_Final:Destroy() end

local Flags = { ESP = false, Desync = false, AntiLag = false }

local Gui = Instance.new("ScreenGui", ParentObj); Gui.Name = "Poseria_Final"
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 240, 0, 360); Main.Position = UDim2.new(0.5, -120, 0.5, -180)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 5)
local Stroke = Instance.new("UIStroke", Main); Stroke.Color = Color3.new(1, 1, 1); Stroke.Thickness = 1.5

local Container = Instance.new("Frame", Main); Container.Size = UDim2.new(1, -20, 1, -20); Container.Position = UDim2.new(0, 10, 0, 10); Container.BackgroundTransparency = 1
Instance.new("UIListLayout", Container).Padding = UDim.new(0, 5)

local Input = Instance.new("TextBox", Container)
Input.Size = UDim2.new(1, 0, 0, 35); Input.BackgroundColor3 = Color3.fromRGB(30, 30, 30); Input.Text = "Username..."; Input.TextColor3 = Color3.new(1,1,1); Input.Font = "SourceSansBold"; Instance.new("UICorner", Input)

local function Morph()
    if Input.Text == "" or Input.Text == "Username..." then return end
    local success, id = pcall(function() return Players:GetUserIdFromNameAsync(Input.Text) end)
    if success and Player.Character then
        local hum = Player.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ApplyDescription(Players:GetHumanoidDescriptionFromUserId(id)) end
    end
end

local MorphBtn = Instance.new("TextButton", Container); MorphBtn.Size = UDim2.new(1,0,0,35); MorphBtn.BackgroundColor3 = Color3.fromRGB(40,40,40); MorphBtn.Text = "MORPH [G]"; MorphBtn.TextColor3 = Color3.new(1,1,1); MorphBtn.Font = "SourceSansBold"; Instance.new("UICorner", MorphBtn)
MorphBtn.MouseButton1Click:Connect(Morph)

local FOVLabel = Instance.new("TextLabel", Container); FOVLabel.Size = UDim2.new(1,0,0,20); FOVLabel.BackgroundTransparency = 1; FOVLabel.Text = "FOV: 70"; FOVLabel.TextColor3 = Color3.new(1,1,1); FOVLabel.Font = "SourceSansBold"
local SliderFrame = Instance.new("Frame", Container); SliderFrame.Size = UDim2.new(1,0,0,15); SliderFrame.BackgroundColor3 = Color3.fromRGB(35,35,35); Instance.new("UICorner", SliderFrame)
local SliderFill = Instance.new("Frame", SliderFrame); SliderFill.Size = UDim2.new(0.2,0,1,0); SliderFill.BackgroundColor3 = Color3.new(1,1,1); Instance.new("UICorner", SliderFill)

local sliding = false
local function UpdateFOV(input)
    local pos = math.clamp((input.Position.X - SliderFrame.AbsolutePosition.X) / SliderFrame.AbsoluteSize.X, 0, 1)
    SliderFill.Size = UDim2.new(pos, 0, 1, 0)
    local fovVal = math.floor(70 + (pos * 50))
    Camera.FieldOfView = fovVal
    FOVLabel.Text = "FOV: " .. fovVal
end
SliderFrame.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then sliding = true; UpdateFOV(i) end end)

local Toggles = {}
local function CreateToggle(name, flag, key)
    local btn = Instance.new("TextButton", Container); btn.Size = UDim2.new(1, 0, 0, 40); btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25); btn.Text = name .. " [" .. key .. "]"; btn.TextColor3 = Color3.new(0.6,0.6,0.6); btn.Font = "SourceSansBold"; Instance.new("UICorner", btn)
    
    local function Toggle()
        Flags[flag] = not Flags[flag]
        btn.BackgroundColor3 = Flags[flag] and Color3.new(1,1,1) or Color3.fromRGB(25, 25, 25)
        btn.TextColor3 = Flags[flag] and Color3.new(0,0,0) or Color3.new(0.6,0.6,0.6)
        
        if flag == "AntiLag" then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") then v.Material = Flags.AntiLag and Enum.Material.SmoothPlastic or Enum.Material.Plastic
                elseif v:IsA("Texture") or v:IsA("Decal") then v.Transparency = Flags.AntiLag and 1 or 0 end
            end
        end
    end
    btn.MouseButton1Click:Connect(Toggle)
    Toggles[key] = Toggle
end

CreateToggle("PLAYER ESP", "ESP", "Z")
CreateToggle("CLASSIC DESYNC", "Desync", "X")
CreateToggle("ANTI-LAG", "AntiLag", "C")

RunService.Heartbeat:Connect(function()
    local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if Flags.Desync and hrp then
        local oldV = hrp.Velocity
        hrp.Velocity = Vector3.new(800, 0, 800)
        RunService.RenderStepped:Wait()
        hrp.Velocity = oldV
    end
end)

UserInputService.InputBegan:Connect(function(i, p)
    if p then return end 
    local k = i.KeyCode.Name
    if Toggles[k] then Toggles[k]() end
    if i.KeyCode == Enum.KeyCode.G then Morph() end
    if i.KeyCode == Enum.KeyCode.P then Main.Visible = not Main.Visible end
end)

UserInputService.InputChanged:Connect(function(i) if sliding and i.UserInputType == Enum.UserInputType.MouseMovement then UpdateFOV(i) end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end end)


local d, ds, sp
Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 and not sliding then d = true; ds = i.Position; sp = Main.Position end end)
UserInputService.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then
    local del = i.Position - ds; Main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + del.X, sp.Y.Scale, sp.Y.Offset + del.Y)
end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)
