-- [ Services ] --
local Services = setmetatable({}, {__index = function(Self, Index)
    local NewService = game:GetService(Index)
    if NewService then
        Self[Index] = NewService
    end
    return NewService
end})

-- [ LocalPlayer ] --
local LocalPlayer = Services.Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [ Weapon Names ] --
local WeaponNames = {
    Knife = {
        Index = "Murderer",
        Color = Color3.fromRGB(255, 0, 0)
    },
    Gun = {
        Index = "Sheriff",
        Color = Color3.fromRGB(0, 0, 255)
    }
}

local AttackAnimations = {
    "rbxassetid://2467567750",
    "rbxassetid://1957618848",
    "rbxassetid://2470501967",
    "rbxassetid://2467577524"
}

-- // Variables \\ --
-- [ Roles ] --
local Roles = {
    Murderer = nil,
    Sheriff = nil,
    Closest = nil
}

local ESPInstances = {}
local ESPToggle = true
local SilentAIMEnabled = true

-- [ Character ] --
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
LocalPlayer.CharacterAdded:Connect(function(Character)
    Character = Character
    Humanoid = Character:WaitForChild("Humanoid")
end)

-- [ Raycast Parameters ] --
local RaycastParameters = RaycastParams.new()
RaycastParameters.IgnoreWater = true
RaycastParameters.FilterType = Enum.RaycastFilterType.Blacklist
RaycastParameters.FilterDescendantsInstances = {LocalPlayer.Character}

-- // Functions \\ --
-- [ Main ] --
local Functions = {}

function Functions.SetText()
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Parent = Services.StarterGui
    TextLabel.Position = UDim2.new(0, 20, 0.9, 0)
    TextLabel.Size = UDim2.new(0, 150, 0, 30)
    TextLabel.Text = "Porno"
    TextLabel.TextSize = 20
    TextLabel.TextColor3 = Color3.new(1, 1, 1)
    TextLabel.BackgroundTransparency = 1
end

-- [ Run Functions ] --
Functions.SetText()

local ButtonScreenGui = Instance.new("ScreenGui")
ButtonScreenGui.Name = "ButtonScreenGui"
ButtonScreenGui.Parent = Services.CoreGui

local ButtonScreenGui = Instance.new("ScreenGui")
ButtonScreenGui.Name = "ButtonScreenGui"
ButtonScreenGui.Parent = Services.CoreGui

local function CreateUIButton(name, buttonText, position, clickFunction)
    local Button = Instance.new("TextButton")

    Button.Name = name .. "Button"
    Button.Size = UDim2.new(0, 100, 0, 25)  -- Smaller size
    Button.Position = position  -- Position
    Button.BackgroundColor3 = Color3.fromRGB(64, 64, 64)  -- Dark gray color
    Button.BackgroundTransparency = 0.3  -- Slight opacity
    Button.TextColor3 = Color3.fromRGB(0, 0, 0)
    Button.TextSize = 14  -- Smaller text size
    Button.Text = buttonText

    -- Adding rounded corners
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)  -- Adjust the corner radius as needed
    UICorner.Parent = Button

    -- Click Function
    Button.MouseButton1Click:Connect(clickFunction)
    Button.Parent = ButtonScreenGui
end

-- Toggle Buttons Visibility Function
local ButtonsVisible = true
local function ToggleButtonsVisibility()
    ButtonsVisible = not ButtonsVisible
    for _, button in pairs(ButtonScreenGui:GetChildren()) do
        if button:IsA("TextButton") and button.Name ~= "ToggleButtonsButton" then
            button.Visible = ButtonsVisible
        end
    end
end




-- Teleport Button Function
local function TeleportToGun()
    local gunDrop = workspace:FindFirstChild("GunDrop")
    if gunDrop then
        local originalPosition = LocalPlayer.Character.PrimaryPart.Position
        LocalPlayer.Character:SetPrimaryPartCFrame(gunDrop.CFrame)
        wait(0.3)  -- sure
        LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(originalPosition))
    else
        Services.StarterGui:SetCore("SendNotification", {
            Title = "Gun Not Found",
            Text = "GunDrop not found!",
            Duration = 3,
            Icon = "rbxassetid://18151246593"
        })
        warn("GunDrop not found!")
    end
end

-- ESP
local function ToggleESP()
    ESPToggle = not ESPToggle
    for i, v in ipairs(ESPInstances) do
        v.Visible = ESPToggle
        if v.Parent == nil then
            table.remove(ESPInstances, i)
        end
    end
    Services.StarterGui:SetCore("SendNotification", {
        Title = "ESP",
        Text = "ESP " .. (ESPToggle and "Enabled" or "Disabled"),
        Duration = 3,
        Icon = "rbxassetid://18151246593"
    })
end

-- Silent AIM 
local function ToggleSilentAIM()
    SilentAIMEnabled = not SilentAIMEnabled
    Services.StarterGui:SetCore("SendNotification", {
        Title = "Silent Aim",
        Text = "Silent Aim " .. (SilentAIMEnabled and "Enabled" or "Disabled"),
        Duration = 3,
        Icon = "rbxassetid://18151246593"
    })
end

-- Coin Farm Function ( oyundan kickliyor kaldırdım )
local function coinFarm()
    local CoinContainer = workspace:FindFirstChild("CoinContainer", true)
    if CoinContainer and Roles[LocalPlayer.Name] ~= "Unknown" then
        for _, coin in ipairs(CoinContainer:GetChildren()) do
            if coin.Name == "Coin_Server" then
                local originalPosition = LocalPlayer.Character.PrimaryPart.Position
                LocalPlayer.Character:SetPrimaryPartCFrame(coin.CFrame)
                wait(1)  -- bekleme süresi
                LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(originalPosition))
                wait(1)  -- 0.5 saniye bekleme
            end
        end
    else
        Services.StarterGui:SetCore("SendNotification", {
            Title = "Coin Not Found",
            Text = "No coins found!",
            Duration = 3
        })
        warn("No coins found!")
    end
end

-- Stabb All Function
local function StabbAll()
    if Roles.Murderer ~= LocalPlayer then
        Services.StarterGui:SetCore("SendNotification", {
            Title = "Stabb All",
            Text = "Only the Murderer can perform this action!",
            Duration = 3,
            Icon = "rbxassetid://18151246593"
        })
        return
    end
    
    for _, player in pairs(Services.Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
            local AHRP = player.Character:FindFirstChild("HumanoidRootPart")
            if AHRP then
                local originalPosition = LocalPlayer.Character.PrimaryPart.Position
                LocalPlayer.Character:SetPrimaryPartCFrame(AHRP.CFrame)
                wait(0.5)  -- Small delay to ensure the kill is registered
                LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(originalPosition))
            end
        end
    end
end
CreateUIButton("ToggleButtons", "Toggle UI", UDim2.new(0, 10, 0, 10), ToggleButtonsVisibility)
CreateUIButton("Teleport", "GunDrop", UDim2.new(0, 10, 0, 40), TeleportToGun)
CreateUIButton("ESP", " ESP", UDim2.new(0, 10, 0, 70), ToggleESP)
CreateUIButton("SilentAIM", "Silent Aim", UDim2.new(0, 10, 0, 100), ToggleSilentAIM)
CreateUIButton("StabbAll", "Stabb All", UDim2.new(0, 10, 0, 130), StabbAll)

-- ESP --
function Functions.ESP(Part, Color)
    if Part:FindFirstChildOfClass('BoxHandleAdornment') then
        return Part:FindFirstChildOfClass('BoxHandleAdornment')
    end

    local Box = Instance.new("BoxHandleAdornment")
    Box.Size = Part.Size + Vector3.new(0.1, 0.1, 0.1)
    Box.Name = "Mesh"
    Box.Visible = ESPToggle
    Box.Adornee = Part
    Box.Color3 = Color or Color3.fromRGB(0, 255, 0)  -- Varsayılan renk yeşil
    Box.AlwaysOnTop = true
    Box.ZIndex = 5
    Box.Transparency = 0.5
    Box.Parent = Part

    table.insert(ESPInstances, Box)

    return Box
end

-- Notify Roles --
function Functions.NotifyRoles()
    if Roles.Murderer then
        -- Murderer --
        local Image, Ready = Services.Players:GetUserThumbnailAsync(Roles.Murderer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
        Services.StarterGui:SetCore("SendNotification", {
            Title = 'Murderer',
            Text = Roles.Murderer.Name,
            Icon = Image,
            Duration = 5
        })
    end

    if Roles.Sheriff then
        -- Sheriff --
        local Image, Ready = Services.Players:GetUserThumbnailAsync(Roles.Sheriff.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
        Services.StarterGui:SetCore("SendNotification", {
            Title = 'Sheriff',
            Text = Roles.Sheriff.Name,
            Icon = Image,
            Duration = 5
        })
    end
end

-- GetClosestPlayer --
function Functions.GetClosestPlayer(MaxDistance)
    local ClosestPlayer = nil
    local FarthestDistance = MaxDistance or math.huge

    for i, v in ipairs(Services.Players:GetPlayers()) do
        if v ~= LocalPlayer then
            pcall(function()
                local DistanceFromPlayer = (LocalPlayer.Character.PrimaryPart.Position - v.Character.PrimaryPart.Position).Magnitude
                if DistanceFromPlayer < FarthestDistance then
                    FarthestDistance = DistanceFromPlayer
                    ClosestPlayer = v
                end
            end)
        end
    end

    return ClosestPlayer
end

-- [ Event ] --
local EventFunctions = {}

function EventFunctions.Initialize(Player)
    local function CharacterAdded(Character)
        Player:WaitForChild("Backpack").ChildAdded:Connect(function(Child)
            local Role = WeaponNames[Child.Name]
            if Role then
                Roles[Role.Index] = Player

                local Cham = Functions.ESP(Player.Character.HumanoidRootPart, Role.Color)

                local Animator = Player.Character:FindFirstChildWhichIsA("Humanoid"):WaitForChild("Animator")
                Animator.AnimationPlayed:Connect(function(AnimationTrack)
                    if (AnimationTrack and AnimationTrack.Animation) == nil then
                        return
                    end

                    if table.find(AttackAnimations, AnimationTrack.Animation.AnimationId) then
                        Cham.Color3 = Color3.fromRGB(255, 0, 255)

                        while true do
                            Services.RunService.Heartbeat:Wait(0.01)
                            local PlayingAnimations = Animator:GetPlayingAnimationTracks()
                            local StillAttacking = false
                            for i, v in ipairs(PlayingAnimations) do
                                if table.find(AttackAnimations, v.Animation.AnimationId) then
                                    StillAttacking = true
                                end
                            end
                            if StillAttacking == false then
                                break
                            end
                        end

                        Cham.Color3 = Role.Color
                    end
                end)
            end
        end)
    end

    CharacterAdded(Player.Character or Player.CharacterAdded:Wait())
    Player.CharacterAdded:Connect(CharacterAdded)
end

function EventFunctions.GunAdded(Child)
    if Child.Name == "GunDrop" then
        Functions.ESP(Child, Color3.fromRGB(255, 255, 255))
    end
end

function EventFunctions.ContextActionService_C(actionName, InputState, inputObject)
    if InputState == Enum.UserInputState.End then
        return
    end

    Functions.NotifyRoles()
end

function EventFunctions.ContextActionService_V(actionName, InputState, inputObject)
    if InputState == Enum.UserInputState.End then
        return
    end

    if Humanoid.WalkSpeed == 16.5 or Humanoid.WalkSpeed == 16 then
        Humanoid.WalkSpeed = 20
    else
        Humanoid.WalkSpeed = 18.5
    end

    Services.StarterGui:SetCore("SendNotification", {
        Title = 'Speed Change',
        Text = tostring(Humanoid.WalkSpeed),
        Duration = 3
    })
end

function EventFunctions.ContextActionService_B(actionName, InputState, inputObject)
    if InputState == Enum.UserInputState.End then
        return
    end

    ESPToggle = not ESPToggle
    for i, v in ipairs(ESPInstances) do
        v.Visible = ESPToggle
        if v.Parent == nil then
            table.remove(ESPInstances, i)
        end
    end

    Services.StarterGui:SetCore("SendNotification", {
        Title = 'ESP',
        Text = "ESP " .. (ESPToggle and "Enabled" or "Disabled"),
        Duration = 3,
        Icon = "rbxassetid://18151246593"
    })
end

function EventFunctions.ContextActionService_G(actionName, InputState, inputObject)
    if InputState == Enum.UserInputState.End then
        return
    end

    SilentAIMEnabled = not SilentAIMEnabled
    Services.StarterGui:SetCore("SendNotification", {
        Title = 'Silent Aim',
        Text = "Enabled: " .. tostring(SilentAIMEnabled),
        Duration = 3,
        Icon = "rbxassetid://18151246593"
    })
end

-- // Metatable \\ --
local RawMetatable = getrawmetatable(game)
local OldNameCall = RawMetatable.__namecall
setreadonly(RawMetatable, false)

RawMetatable.__namecall = newcclosure(function(Object, ...)
    local NamecallMethod = getnamecallmethod()
    local Arguments = {...}

    if SilentAIMEnabled == true then
        RaycastParameters.FilterDescendantsInstances = {LocalPlayer.Character}
        if NamecallMethod == "FireServer" and tostring(Object) == "Throw" then
            local Success, Error = pcall(function()
                local Closest = Functions.GetClosestPlayer()
                local PrimaryPart = Closest.Character.PrimaryPart
                local Velocity = PrimaryPart.AssemblyLinearVelocity * Vector3.new(1, 0, 1)
                local Magnitude = (PrimaryPart.Position - LocalPlayer.Character.PrimaryPart.Position).Magnitude
                local Prediction = Velocity * 0.5 * Magnitude / 100
                local Result = workspace:Raycast(LocalPlayer.Character.PrimaryPart.Position, (PrimaryPart.Position - (LocalPlayer.Character.PrimaryPart.Position + Prediction)).Unit * 200, RaycastParameters)
                Arguments[2] = Result.Position
            end)
            if not Success then
                warn(Error)
            end
        elseif NamecallMethod == "InvokeServer" and tostring(Object) == "ShootGun" and Roles.Murderer then
            local Success, Error = pcall(function()
                local PrimaryPart = Roles.Murderer.Character.PrimaryPart
                local Prediction = PrimaryPart.AssemblyLinearVelocity / 40
                if math.abs(PrimaryPart.AssemblyLinearVelocity.Y) < 10 then
                    Arguments[2] = PrimaryPart.Position + Prediction
                else
                    return "Nullify Remote"
                end
            end)
            if not Success then
                warn(Error)
            elseif Success == "Nullify Remote" then
                warn("Null")
                return
            end
        end
    end

    return OldNameCall(Object, unpack(Arguments))
end)

setreadonly(RawMetatable, true)

-- // Event Listeners \\ --
for i, v in ipairs(Services.Players:GetPlayers()) do
    EventFunctions.Initialize(v)
end
Services.Players.PlayerAdded:Connect(EventFunctions.Initialize)

workspace.ChildAdded:Connect(EventFunctions.GunAdded)

-- [ Binds ] --
Services.ContextActionService:BindAction('SprintBind', EventFunctions.ContextActionService_V, false, Enum.KeyCode.V)
Services.ContextActionService:BindAction('NotifyBind', EventFunctions.ContextActionService_C, false, Enum.KeyCode.C)
Services.ContextActionService:BindAction('ESPBind', EventFunctions.ContextActionService_B, false, Enum.KeyCode.B)
Services.ContextActionService:BindAction('AIMBind', EventFunctions.ContextActionService_G, false, Enum.KeyCode.G)

-- // Actions \\ --