local AntiCheatBypass = loadstring(game:HttpGet('https://raw.githubusercontent.com/DarkFadow/Zen-s-Anti-Cheat-Bypass/refs/heads/main/ZenAntiCheatBypasser.lua'))()
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local MainWindow = Rayfield:CreateWindow({
   Name = "💫ZenScriptHub✨",
   Icon = 0,
   LoadingTitle = "💫ZenScriptHub✨",
   LoadingSubtitle = "by DarkFadow",
   ShowText = "Rayfield",
   Theme = "Default",
   ToggleUIKeybind = "K",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,
   ConfigurationSaving = { Enabled = false },

   Discord = {
      Enabled = true,
      Invite = "cG3w8V2NYq",
      RememberJoins = true
   },

   KeySystem = false,
   KeySettings = {
      Title = "💫ZenScriptHub✨ | Key",
      Subtitle = "Join the discord and go to the key channel",
      Note = "Join the discord for more scripts !",
      FileName = "ZenKey",
      SaveKey = true,
      GrabKeyFromSite = true,
      Key = {"https://pastebin.com/raw/uZJ6ELkG"}
   }
})

local MainTab = MainWindow:CreateTab("Player🙍‍♂️", nil)
local MainSection = MainTab:CreateSection("Main")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- helper clamp
local function clamp(v, lo, hi) if v < lo then return lo elseif v > hi then return hi else return v end end

-- Infinite Jump
local InfiniteJumpEnabled = false
MainTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Flag = "InfiniteJumpToggle",
   Callback = function(Value)
      InfiniteJumpEnabled = Value
   end,
})
UserInputService.JumpRequest:Connect(function()
   if InfiniteJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
      LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
   end
end)

-- WalkSpeed
local speedValue = 16
MainTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {0,300},
   Increment = 1,
   Suffix = "WS",
   CurrentValue = 16,
   Flag = "SpeedSlider",
   Callback = function(v)
      speedValue = v
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
         LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = speedValue
      end
   end
})

-- JumpPower
local jumpValue = 50
MainTab:CreateSlider({
   Name = "JumpPower",
   Range = {0,300},
   Increment = 1,
   Suffix = "JP",
   CurrentValue = 50,
   Flag = "JumpSlider",
   Callback = function(v)
      jumpValue = v
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
         LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = jumpValue
      end
   end
})

-- Noclip
local noclipEnabled = false
MainTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Flag = "NoclipToggle",
   Callback = function(v) noclipEnabled = v end,
})
RunService.Stepped:Connect(function()
   if noclipEnabled and LocalPlayer.Character then
      for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
         if part:IsA("BasePart") then
            part.CanCollide = false
         end
      end
   end
end)

--- Fly (Version Corrigée)
local FlyEnabled = false
local FlySpeed = 50
local BodyVelocity
local FlyConnection

-- Slider pour la vitesse du Fly
MainTab:CreateSlider({
    Name = "Fly Speed",
    Range = {1, 300},
    Increment = 1,
    Suffix = "speed",
    CurrentValue = 50,
    Flag = "FlySpeedSlider",
    Callback = function(v)
        FlySpeed = v
    end
})

MainTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(Value)
        FlyEnabled = Value
        
        if FlyEnabled then
            -- Activation du fly
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.PlatformStand = true
                    
                    -- Créer le BodyVelocity
                    BodyVelocity = Instance.new("BodyVelocity")
                    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
                    BodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
                    BodyVelocity.Parent = character.HumanoidRootPart
                    
                    -- Démarrer la boucle de mouvement
                    FlyConnection = RunService.Heartbeat:Connect(function()
                        if not FlyEnabled or not BodyVelocity or not character or not character.HumanoidRootPart then
                            if FlyConnection then
                                FlyConnection:Disconnect()
                            end
                            return
                        end
                        
                        local rootPart = character.HumanoidRootPart
                        local camera = workspace.CurrentCamera
                        local moveDirection = Vector3.new(0, 0, 0)
                        
                        -- Avancer (Z)
                        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                            moveDirection = moveDirection + camera.CFrame.LookVector
                        end
                        
                        -- Reculer (Z)
                        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                            moveDirection = moveDirection - camera.CFrame.LookVector
                        end
                        
                        -- Gauche (X)
                        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                            moveDirection = moveDirection - camera.CFrame.RightVector
                        end
                        
                        -- Droite (X)
                        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                            moveDirection = moveDirection + camera.CFrame.RightVector
                        end
                        
                        -- Monter (Y)
                        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                            moveDirection = moveDirection + Vector3.new(0, 1, 0)
                        end
                        
                        -- Descendre (Y)
                        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                            moveDirection = moveDirection - Vector3.new(0, 1, 0)
                        end
                        
                        -- Normaliser la direction si on se déplace
                        if moveDirection.Magnitude > 0 then
                            moveDirection = moveDirection.Unit
                        end
                        
                        -- Appliquer la vélocité
                        BodyVelocity.Velocity = moveDirection * FlySpeed
                    end)
                end
            end
        else
            -- Désactivation du fly
            if FlyConnection then
                FlyConnection:Disconnect()
                FlyConnection = nil
            end
            
            local character = LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.PlatformStand = false
                end
                
                if BodyVelocity then
                    BodyVelocity:Destroy()
                    BodyVelocity = nil
                end
            end
        end
    end,
})

-- Speed Boost
MainTab:CreateButton({
   Name = "Speed Boost (3s)",
   Callback = function()
      local char = LocalPlayer.Character
      if char and char:FindFirstChildOfClass("Humanoid") then
         local hum = char:FindFirstChildOfClass("Humanoid")
         local old = hum.WalkSpeed
         hum.WalkSpeed = math.max(100, old + 80)
         task.delay(3, function()
            if hum and hum.Parent then
               hum.WalkSpeed = old
            end
         end)
      end
   end
})

-- Invincible (God Mode)
local invincibleEnabled = false
local originalHealth
local humanoidConnection

MainTab:CreateToggle({
    Name = "Invincible",
    CurrentValue = false,
    Flag = "InvincibleToggle",
    Callback = function(value)
        invincibleEnabled = value
        local character = LocalPlayer.Character
        
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            
            if humanoid then
                if invincibleEnabled then
                    -- Save original health
                    originalHealth = humanoid.Health
                    
                    -- Make character invincible
                    humanoid.MaxHealth = math.huge
                    humanoid.Health = math.huge
                    
                    -- Prevent health changes
                    if humanoidConnection then
                        humanoidConnection:Disconnect()
                    end
                    
                    humanoidConnection = humanoid.HealthChanged:Connect(function()
                        if humanoid.Health < math.huge then
                            humanoid.Health = math.huge
                        end
                    end)
                    
                    -- Prevent death
                    humanoid.BreakJointsOnDeath = false
                    
                    print("✅ Invincible: Enabled")
                    Rayfield:Notify({
                        Title = "Invincible",
                        Content = "God mode activated!",
                        Duration = 3.0,
                        Image = 4483362458
                    })
                else
                    -- Restore original health settings
                    if humanoidConnection then
                        humanoidConnection:Disconnect()
                        humanoidConnection = nil
                    end
                    
                    humanoid.MaxHealth = 100
                    humanoid.Health = math.min(originalHealth or 100, 100)
                    humanoid.BreakJointsOnDeath = true
                    
                    print("❌ Invincible: Disabled")
                    Rayfield:Notify({
                        Title = "Invincible",
                        Content = "God mode deactivated!",
                        Duration = 3.0,
                        Image = 4483362458
                    })
                end
            end
        end
    end
})

-- Invisible (Fixed - keeps hair and accessories)
local invisibleEnabled = false
local originalProperties = {}

MainTab:CreateToggle({
    Name = "Invisible",
    CurrentValue = false,
    Flag = "InvisibleToggle",
    Callback = function(value)
        invisibleEnabled = value
        local character = LocalPlayer.Character
        
        if character then
            if invisibleEnabled then
                -- Save original properties and make only body parts invisible
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        -- Only make body parts invisible, not accessories
                        if part.Name == "Head" or part.Name == "Torso" or part.Name == "LeftArm" or 
                           part.Name == "RightArm" or part.Name == "LeftLeg" or part.Name == "RightLeg" then
                            
                            originalProperties[part] = {
                                Transparency = part.Transparency,
                                CanCollide = part.CanCollide
                            }
                            
                            part.Transparency = 1
                            part.CanCollide = false
                        end
                    end
                end
                
                print("✅ Invisible: Enabled")
                Rayfield:Notify({
                    Title = "Invisible",
                    Content = "You are now invisible!",
                    Duration = 3.0,
                    Image = 4483362458
                })
            else
                -- Restore original properties only for body parts
                for part, properties in pairs(originalProperties) do
                    if part and part.Parent then
                        part.Transparency = properties.Transparency
                        part.CanCollide = properties.CanCollide
                    end
                end
                
                -- Clear table
                originalProperties = {}
                
                print("❌ Invisible: Disabled")
                Rayfield:Notify({
                    Title = "Invisible",
                    Content = "You are now visible!",
                    Duration = 3.0,
                    Image = 4483362458
                })
            end
        end
    end
})

-- Tab Exploits
local ExploitsTab = MainWindow:CreateTab("Exploits🛠️", nil)
local ExploitsSection = ExploitsTab:CreateSection("Exploits")

-- Spoof
ExploitsTab:CreateButton({
    Name = "Spoof Game",
    Callback = function()
        -- Spoof basique du jeu
        pcall(function()
            if hookfunction then
                -- Spoof du PlayerId
                if game.Players.LocalPlayer then
                    local originalGetPlayerId = game.Players.LocalPlayer.GetPlayerId
                    hookfunction(game.Players.LocalPlayer.GetPlayerId, function(self)
                        return math.random(1000000, 9999999)
                    end)
                end
                
                -- Spoof du UserId
                if game.Players.LocalPlayer then
                    local originalUserId = game.Players.LocalPlayer.UserId
                    hookfunction(game.Players.LocalPlayer.GetUserId, function(self)
                        return math.random(1000000, 9999999)
                    end)
                end
                
                -- Spoof du AccountAge
                if game.Players.LocalPlayer then
                    hookfunction(game.Players.LocalPlayer.GetAccountAge, function(self)
                        return math.random(100, 1000)
                    end)
                end
            end
        end)
    end
})

-- Autres boutons exploits (ajoutez selon besoin)
ExploitsTab:CreateButton({
    Name = "Anti-AFK",
    Callback = function()
        local VirtualUser = game:GetService("VirtualUser")
        game:GetService("Players").LocalPlayer.Idled:connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
})

-- Shooter tab (ESP + Aimbot)
local ShooterTab = MainWindow:CreateTab("Shooter 🔫", nil)
local ShooterSection = ShooterTab:CreateSection("OP but a bit broken")

-- =============================
-- Rainbow ESP (Improved Version)
-- =============================
local baseEspEnabled = false
local baseEspTable = {}

-- Rainbow color generator
local function getRainbowColor()
    local hue = tick() % 5 / 5
    return Color3.fromHSV(hue, 1, 1)
end

-- Function to create rainbow ESP
local function createRainbowESP(plr)
    if not plr.Character or not plr.Character:FindFirstChild("Head") or not plr.Character:FindFirstChild("HumanoidRootPart") then return end
    if baseEspTable[plr] then return end

    local head = plr.Character.Head
    local hrp = plr.Character.HumanoidRootPart
    local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")

    -- Main Billboard GUI for name
    local bill = Instance.new("BillboardGui")
    bill.Name = "MSH_RainbowESP"
    bill.Adornee = head
    bill.Size = UDim2.new(0, 200, 0, 50)
    bill.StudsOffset = Vector3.new(0, 3, 0)
    bill.AlwaysOnTop = true
    bill.ResetOnSpawn = false

    -- Container
    local container = Instance.new("Frame", bill)
    container.Name = "Container"
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1

    -- Name Label
    local nameLabel = Instance.new("TextLabel", container)
    nameLabel.Name = "Name"
    nameLabel.AnchorPoint = Vector2.new(0.5, 0)
    nameLabel.Position = UDim2.new(0.5, 0, 0, 0)
    nameLabel.Size = UDim2.new(1, 0, 0, 20)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = plr.Name
    nameLabel.TextColor3 = Color3.new(1, 1, 1)
    nameLabel.TextScaled = false
    nameLabel.TextSize = 14
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    nameLabel.ZIndex = 2

    -- Distance Label
    local distanceLabel = Instance.new("TextLabel", container)
    distanceLabel.Name = "Distance"
    distanceLabel.AnchorPoint = Vector2.new(0.5, 0)
    distanceLabel.Position = UDim2.new(0.5, 0, 0, 18)
    distanceLabel.Size = UDim2.new(1, 0, 0, 16)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Text = "0 studs"
    distanceLabel.TextColor3 = Color3.new(1, 1, 1)
    distanceLabel.TextSize = 12
    distanceLabel.Font = Enum.Font.SourceSans
    distanceLabel.TextStrokeTransparency = 0
    distanceLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    distanceLabel.ZIndex = 2

    -- Health Label
    local healthLabel = Instance.new("TextLabel", container)
    healthLabel.Name = "Health"
    healthLabel.AnchorPoint = Vector2.new(0.5, 0)
    healthLabel.Position = UDim2.new(0.5, 0, 0, 32)
    healthLabel.Size = UDim2.new(1, 0, 0, 16)
    healthLabel.BackgroundTransparency = 1
    healthLabel.Text = "100 HP"
    healthLabel.TextColor3 = Color3.new(0, 1, 0)
    healthLabel.TextSize = 12
    healthLabel.Font = Enum.Font.SourceSans
    healthLabel.TextStrokeTransparency = 0
    healthLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    healthLabel.ZIndex = 2

    -- Create box around player using Adornee
    local boxHandle = Instance.new("Part")
    boxHandle.Name = "RainbowBoxHandle"
    boxHandle.Size = Vector3.new(4, 6, 2)
    boxHandle.Transparency = 1
    boxHandle.CanCollide = false
    boxHandle.Anchored = true
    boxHandle.Parent = workspace

    local boxAdorn = Instance.new("BoxHandleAdornment")
    boxAdorn.Name = "RainbowBox"
    boxAdorn.Adornee = boxHandle
    boxAdorn.AlwaysOnTop = true
    boxAdorn.ZIndex = 1
    boxAdorn.Size = Vector3.new(4, 6, 2)
    boxAdorn.Transparency = 0.3
    boxAdorn.Color3 = getRainbowColor()
    boxAdorn.Parent = boxHandle

    -- Create outline around player
    local outlineAdorn = Instance.new("BoxHandleAdornment")
    outlineAdorn.Name = "RainbowOutline"
    outlineAdorn.Adornee = boxHandle
    outlineAdorn.AlwaysOnTop = true
    outlineAdorn.ZIndex = 0
    outlineAdorn.Size = Vector3.new(4.2, 6.2, 2.2)
    outlineAdorn.Transparency = 0.1
    outlineAdorn.Color3 = Color3.new(1, 1, 1)
    outlineAdorn.Parent = boxHandle

    bill.Parent = game.CoreGui
    
    baseEspTable[plr] = {
        gui = bill,
        nameLabel = nameLabel,
        distanceLabel = distanceLabel,
        healthLabel = healthLabel,
        boxHandle = boxHandle,
        boxAdorn = boxAdorn,
        outlineAdorn = outlineAdorn,
        lastUpdate = tick()
    }
end

-- Function to remove ESP
local function removeRainbowESP(plr)
    if baseEspTable[plr] then
        if baseEspTable[plr].gui and baseEspTable[plr].gui.Parent then
            baseEspTable[plr].gui:Destroy()
        end
        if baseEspTable[plr].boxHandle and baseEspTable[plr].boxHandle.Parent then
            baseEspTable[plr].boxHandle:Destroy()
        end
        baseEspTable[plr] = nil
    end
end

-- Toggle for Rainbow ESP
ShooterTab:CreateToggle({
    Name = "Rainbow ESP",
    CurrentValue = false,
    Flag = "RainbowESPToggle",
    Callback = function(v)
        baseEspEnabled = v
        if not v then
            for p, _ in pairs(baseEspTable) do
                removeRainbowESP(p)
            end
        end
    end
})

-- Update ESP in real-time
RunService.RenderStepped:Connect(function()
    if baseEspEnabled then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") and 
               plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChildOfClass("Humanoid") then
                local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
                
                if humanoid.Health > 0 then
                    if not baseEspTable[plr] then
                        createRainbowESP(plr)
                    end
                    
                    -- Update ESP data
                    local data = baseEspTable[plr]
                    if data and tick() - data.lastUpdate > 0.05 then -- Update every 0.05 seconds for performance
                        data.lastUpdate = tick()
                        
                        local headPos = plr.Character.Head.Position
                        local hrpPos = plr.Character.HumanoidRootPart.Position
                        local localHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        
                        -- Update rainbow colors
                        local rainbowColor = getRainbowColor()
                        data.boxAdorn.Color3 = rainbowColor
                        data.nameLabel.TextColor3 = rainbowColor
                        
                        -- Update box position and size based on character
                        if data.boxHandle then
                            data.boxHandle.CFrame = CFrame.new(hrpPos)
                            
                            -- Adjust box size based on character scale
                            local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
                            if humanoid then
                                local scale = humanoid.HipHeight / 2
                                data.boxAdorn.Size = Vector3.new(3 + scale, 5 + scale, 1.5 + scale)
                                data.outlineAdorn.Size = Vector3.new(3.2 + scale, 5.2 + scale, 1.7 + scale)
                            end
                        end
                        
                        -- Update distance
                        if localHrp then
                            local distance = (localHrp.Position - hrpPos).Magnitude
                            data.distanceLabel.Text = math.floor(distance) .. " studs"
                            
                            -- Change distance color based on proximity
                            if distance < 20 then
                                data.distanceLabel.TextColor3 = Color3.new(1, 0, 0) -- Red
                            elseif distance < 50 then
                                data.distanceLabel.TextColor3 = Color3.new(1, 1, 0) -- Yellow
                            else
                                data.distanceLabel.TextColor3 = Color3.new(1, 1, 1) -- White
                            end
                        end
                        
                        -- Update health
                        data.healthLabel.Text = math.floor(humanoid.Health) .. " HP"
                        
                        -- Change health color based on health percentage
                        local healthPercent = humanoid.Health / humanoid.MaxHealth
                        if healthPercent > 0.7 then
                            data.healthLabel.TextColor3 = Color3.new(0, 1, 0) -- Green
                        elseif healthPercent > 0.3 then
                            data.healthLabel.TextColor3 = Color3.new(1, 1, 0) -- Yellow
                        else
                            data.healthLabel.TextColor3 = Color3.new(1, 0, 0) -- Red
                        end
                        
                        -- Update GUI position based on character movement
                        local screenHead, onHead = Camera:WorldToViewportPoint(headPos)
                        if onHead then
                            data.gui.StudsOffset = Vector3.new(0, 3 + (math.sin(tick() * 3) * 0.1), 0) -- Subtle floating animation
                        end
                    end
                else
                    removeRainbowESP(plr)
                end
            else
                removeRainbowESP(plr)
            end
        end
    end
end)

-- Cleanup when players leave
Players.PlayerRemoving:Connect(function(plr)
    removeRainbowESP(plr)
end)

-- Cleanup when script stops
game:GetService("Players").PlayerRemoving:Connect(function(leavingPlayer)
    if leavingPlayer == LocalPlayer then
        for p, _ in pairs(baseEspTable) do
            removeRainbowESP(p)
        end
    end
end)

-- =============================
-- Aimbot
-- =============================
local aimbotEnabled = false
local aimHold = false
local aimFOV = 150
local showFOV = true
local aimSmooth = 0.55
local aimMaxDistance = 1000

local haveDrawing, drawNew = pcall(function() return Drawing.new end)
local aimCircle = nil
local hue = 0 -- 0..1 for HSV
if haveDrawing then
    local ok, c = pcall(function() return Drawing.new("Circle") end)
    if ok and c then
        aimCircle = c
        aimCircle.Thickness = 2
        aimCircle.NumSides = 100
        aimCircle.Filled = false
        aimCircle.Visible = false
        aimCircle.Radius = aimFOV
        aimCircle.Color = Color3.fromHSV(hue, 1, 1)
    else
        aimCircle = nil
    end
end

ShooterTab:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Flag = "AimbotToggle",
    Callback = function(v)
        aimbotEnabled = v
        if not v then aimHold = false end
        if aimCircle then aimCircle.Visible = false end
    end,
})

ShooterTab:CreateToggle({
    Name = "Show FOV",
    CurrentValue = true,
    Flag = "ShowFOVToggle",
    Callback = function(v)
        showFOV = v
        if aimCircle then aimCircle.Visible = (v and aimbotEnabled and aimHold) end
    end,
})

ShooterTab:CreateSlider({
    Name = "Aim FOV",
    Range = {50, 500},
    Increment = 1,
    Suffix = "px",
    CurrentValue = aimFOV,
    Flag = "AimFOVSlider",
    Callback = function(v)
        aimFOV = v
        if aimCircle then aimCircle.Radius = v end
    end,
})

ShooterTab:CreateSlider({
    Name = "Smooth",
    Range = {0,100},
    Increment = 1,
    Suffix = "%",
    CurrentValue = math.floor(aimSmooth * 100),
    Flag = "AimSmoothSlider",
    Callback = function(v)
        aimSmooth = clamp(v / 100, 0, 1)
    end,
})

ShooterTab:CreateSlider({
    Name = "Max Distance",
    Range = {50,2000},
    Increment = 10,
    Suffix = "studs",
    CurrentValue = aimMaxDistance,
    Flag = "AimMaxDistSlider",
    Callback = function(v)
        aimMaxDistance = v
    end,
})

local function getClosestInRange()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return nil end
    local localPos = LocalPlayer.Character.HumanoidRootPart.Position
    local closest, cd = nil, math.huge
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Head") then
            if not plr.Team or plr.Team ~= LocalPlayer.Team then
                local dist = (localPos - plr.Character.HumanoidRootPart.Position).Magnitude
                if dist <= aimMaxDistance then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(plr.Character.Head.Position)
                    if onScreen then
                        local mag = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                        if mag < cd and mag <= aimFOV then
                            cd = mag
                            closest = plr
                        end
                    end
                end
            end
        end
    end
    return closest
end

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 and aimbotEnabled then
        aimHold = true
        if aimCircle then aimCircle.Visible = showFOV and true end
    end
end)

UserInputService.InputEnded:Connect(function(input, gpe)
    if gpe then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        aimHold = false
        if aimCircle then aimCircle.Visible = false end
    end
end)

RunService.RenderStepped:Connect(function(dt)
    -- animate rainbow hue (adjust speed multiplier to taste)
    if aimCircle then
        hue = (hue + dt * 0.18) % 1
        aimCircle.Color = Color3.fromHSV(hue, 1, 1)
        aimCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        aimCircle.Radius = aimFOV
        aimCircle.Visible = (showFOV and aimbotEnabled and aimHold)
    end

    if aimbotEnabled and aimHold then
        local target = getClosestInRange()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            local cam = workspace.CurrentCamera
            local targetCf = CFrame.new(cam.CFrame.Position, target.Character.Head.Position)
            if aimSmooth and aimSmooth > 0 then
                local alpha = clamp(1 - math.exp(-aimSmooth * 60 * dt), 0, 1)
                cam.CFrame = cam.CFrame:Lerp(targetCf, alpha)
            else
                cam.CFrame = targetCf
            end
        end
    end
end)

local function cleanup()
    for p,_ in pairs(baseEspTable) do
        removeBaseESP(p)
    end
    if aimCircle then
        pcall(function() aimCircle.Visible = false end)
    end
    if Sense then
        pcall(function()
            if Sense.SetEnabled then
                Sense:SetEnabled(false)
            else
                if Sense.Unload then Sense.Unload() end
            end
        end)
    end
end

-- =============================
-- Sense ESP (Updated with Sirius Documentation)
-- =============================
local Sense = loadstring(game:HttpGet("https://sirius.menu/sense"))()
local senseEnabled = false

-- Function to setup Sense ESP
local function setupSenseESP()
    -- Configure Sense settings
    Sense.teamSettings = {
        enemy = {
            enabled = true,
            color = Color3.fromRGB(255, 0, 0),
            outlineColor = Color3.fromRGB(255, 255, 255),
            textColor = Color3.fromRGB(255, 255, 255),
            textSize = 13,
            textFont = 2,
            showDistance = true,
            showHealth = true,
            showName = true,
            showBox = true,
            showTracers = true
        },
        friendly = {
            enabled = false, -- Disable friendly ESP
            color = Color3.fromRGB(0, 255, 0),
            outlineColor = Color3.fromRGB(255, 255, 255),
            textColor = Color3.fromRGB(255, 255, 255),
            textSize = 13,
            textFont = 2,
            showDistance = false,
            showHealth = false,
            showName = false,
            showBox = false,
            showTracers = false
        }
    }
    
    -- Configure box settings
    Sense.boxSettings = {
        enabled = true,
        color = Color3.fromRGB(255, 255, 255),
        outlineColor = Color3.fromRGB(0, 0, 0),
        transparency = 1,
        outlineTransparency = 0
    }
    
    -- Configure tracer settings
    Sense.tracerSettings = {
        enabled = true,
        color = Color3.fromRGB(255, 255, 255),
        transparency = 1,
        origin = 1 -- 1 = Bottom, 2 = Top, 3 = Mouse
    }
    
    -- Configure name settings
    Sense.nameSettings = {
        enabled = true,
        color = Color3.fromRGB(255, 255, 255),
        transparency = 1,
        outline = true,
        outlineColor = Color3.fromRGB(0, 0, 0),
        displayDistance = true,
        displayHealth = true
    }
    
    -- Configure health bar settings
    Sense.healthBarSettings = {
        enabled = true,
        color = Color3.fromRGB(0, 255, 0),
        backgroundColor = Color3.fromRGB(255, 0, 0),
        transparency = 1,
        outline = true,
        outlineColor = Color3.fromRGB(0, 0, 0)
    }
    
    -- Configure distance settings
    Sense.distanceSettings = {
        enabled = true,
        color = Color3.fromRGB(255, 255, 255),
        transparency = 1,
        outline = true,
        outlineColor = Color3.fromRGB(0, 0, 0)
    }
end

-- Initialize Sense ESP
setupSenseESP()

-- Create the toggle for Sense ESP
ShooterTab:CreateToggle({
    Name = "Sense ESP",
    CurrentValue = false,
    Flag = "SenseESP",
    Callback = function(value)
        senseEnabled = value
        
        if senseEnabled then
            -- Enable Sense ESP
            pcall(function()
                Sense:SetEnabled(true)
                print("✅ Sense ESP: Enabled")
            end)
        else
            -- Disable Sense ESP
            pcall(function()
                Sense:SetEnabled(false)
                print("❌ Sense ESP: Disabled")
            end)
        end
    end
})

-- Additional Sense configuration options
local SenseSection = ShooterTab:CreateSection("Sense Settings")

-- Toggle for Team Check
ShooterTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = true,
    Flag = "SenseTeamCheck",
    Callback = function(value)
        pcall(function()
            Sense.teamCheck = value
        end)
    end
})

-- Toggle for Box ESP
ShooterTab:CreateToggle({
    Name = "Box ESP",
    CurrentValue = true,
    Flag = "SenseBoxESP",
    Callback = function(value)
        pcall(function()
            Sense.boxSettings.enabled = value
        end)
    end
})

-- Toggle for Tracers
ShooterTab:CreateToggle({
    Name = "Tracers",
    CurrentValue = true,
    Flag = "SenseTracers",
    Callback = function(value)
        pcall(function()
            Sense.tracerSettings.enabled = value
        end)
    end
})

-- Toggle for Names
ShooterTab:CreateToggle({
    Name = "Show Names",
    CurrentValue = true,
    Flag = "SenseNames",
    Callback = function(value)
        pcall(function()
            Sense.nameSettings.enabled = value
        end)
    end
})

-- Toggle for Health Bars
ShooterTab:CreateToggle({
    Name = "Health Bars",
    CurrentValue = true,
    Flag = "SenseHealthBars",
    Callback = function(value)
        pcall(function()
            Sense.healthBarSettings.enabled = value
        end)
    end
})

-- Toggle for Distance
ShooterTab:CreateToggle({
    Name = "Show Distance",
    CurrentValue = true,
    Flag = "SenseDistance",
    Callback = function(value)
        pcall(function()
            Sense.distanceSettings.enabled = value
        end)
    end
})

-- Max Distance Slider
ShooterTab:CreateSlider({
    Name = "Max Distance",
    Range = {0, 1000},
    Increment = 10,
    Suffix = "studs",
    CurrentValue = 500,
    Flag = "SenseMaxDistance",
    Callback = function(value)
        pcall(function()
            Sense.maxDistance = value
        end)
    end
})

-- Auto cleanup when player leaves
Players.PlayerRemoving:Connect(function(leavingPlayer)
    if leavingPlayer == LocalPlayer then
        pcall(function()
            Sense:SetEnabled(false)
        end)
    end
end)

print("✅ Sense ESP loaded and configured")


-- Tab Misc
local MiscTab = MainWindow:CreateTab("Misc📦", nil)
local MiscSection = MiscTab:CreateSection("Information")

-- Job ID avec protection anti-nil
local jobId = game.JobId
local jobIdSafe = jobId or "No Job ID"

MiscTab:CreateLabel("Job ID: " .. jobIdSafe)

-- Copy Job ID
MiscTab:CreateButton({
    Name = "Copy Job ID",
    Callback = function()
        if setclipboard then
            setclipboard(jobIdSafe)
        end
    end
})

-- Private Server
MiscTab:CreateButton({
    Name = "Generate Private Server", 
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local Players = game:GetService("Players")
        local HttpService = game:GetService("HttpService")
        
        -- Function to find empty or low population public server
        local function findEmptyPublicServer()
            print("🔍 Searching for empty public server...")
            
            local gameId = game.PlaceId
            local currentServerId = game.JobId
            
            local success, result = pcall(function()
                local response = game:HttpGet("https://games.roblox.com/v1/games/" .. gameId .. "/servers/Public?sortOrder=Asc&limit=100")
                return HttpService:JSONDecode(response)
            end)
            
            if success and result and result.data then
                -- Look for servers with 0-1 players
                local emptyServers = {}
                
                for _, server in ipairs(result.data) do
                    if server.playing <= 1 and server.id ~= currentServerId then
                        table.insert(emptyServers, server)
                    end
                end
                
                if #emptyServers > 0 then
                    -- Find the most empty server
                    local bestServer = emptyServers[1]
                    for _, server in ipairs(emptyServers) do
                        if server.playing < bestServer.playing then
                            bestServer = server
                        end
                    end
                    
                    print("✅ Found empty server with " .. bestServer.playing .. " players")
                    return bestServer.id
                else
                    -- If no empty servers, create new instance
                    print("⚠️ No empty servers found, creating new instance")
                    return nil
                end
            end
            
            return nil
        end
        
        -- Function to create/join empty server
        local function joinEmptyServer()
            local emptyServerId = findEmptyPublicServer()
            
            if emptyServerId then
                -- Join existing empty server
                Rayfield:Notify({
                    Title = "Private Server",
                    Content = "Joining empty public server (" .. emptyServerId .. ")",
                    Duration = 5.0,
                    Image = 4483362458
                })
                
                TeleportService:TeleportToPlaceInstance(game.PlaceId, emptyServerId, Players.LocalPlayer)
            else
                -- Create new server instance
                Rayfield:Notify({
                    Title = "Private Server",
                    Content = "Creating new server instance...",
                    Duration = 5.0,
                    Image = 4483362458
                })
                
                TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
            end
        end
        
        -- Execute the function
        joinEmptyServer()
    end
})

MiscTab:CreateButton({
    Name = "Server Hop",
    Callback = function()
        -- Code pour changer de serveur
        loadstring(game:HttpGet("https://raw.githubusercontent.com/DarkFadow/ZenScriptHub/refs/heads/main/ServerHop.lua", true))()
    end
})


-- Rejoin Server
MiscTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
    end
})

-- Server Info
MiscTab:CreateLabel("Players: " .. #game.Players:GetPlayers() .. "/" .. game.Players.MaxPlayers)

-- FPS Counter
local fpsLabel = MiscTab:CreateLabel("FPS: Calculating...")
local fps = 0
RunService.RenderStepped:Connect(function()
    fps = math.floor(1/RunService.RenderStepped:Wait())
    fpsLabel:Set("FPS: " .. fps)
end)


-- ✅ Version safe pour le cleanup
Players.PlayerRemoving:Connect(function(leavingPlayer)
    if leavingPlayer == LocalPlayer then
        cleanup()
    end
end)