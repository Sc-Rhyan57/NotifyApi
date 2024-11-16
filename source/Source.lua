-- NotificationAPI - Super Moderno e Animado
-- Autor: Lua Programming GOD

local NotificationAPI = {}

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- GUI Principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NotificationAPI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Configurações padrão
NotificationAPI.Config = {
    DefaultDuration = 5,
    DefaultPosition = "Right", -- "Left", "Right", "Center"
    DefaultBackgroundColor = Color3.fromRGB(30, 30, 30),
    DefaultBorderColor = Color3.fromRGB(255, 255, 255),
    DefaultCornerRadius = UDim.new(0.1, 0),
    AnimationSpeed = 0.5,
    DefaultSoundId = nil, -- Som padrão ou nil
    EasingStyle = Enum.EasingStyle.Quad,
    EasingDirection = Enum.EasingDirection.Out
}

-- Logs
local function log(message, messageType)
    print(string.format("[NotificationAPI - %s]: %s", messageType or "INFO", message))
end

log("API inicializada com sucesso!", "STARTUP")

-- Função de animação genérica
local function animate(instance, properties, duration, easingStyle, easingDirection)
    local tween = TweenService:Create(
        instance,
        TweenInfo.new(duration, easingStyle or NotificationAPI.Config.EasingStyle, easingDirection or NotificationAPI.Config.EasingDirection),
        properties
    )
    tween:Play()
    return tween
end

-- Função para criar uma borda animada
local function createBorder(parent, borderColor)
    local Border = Instance.new("Frame")
    Border.Size = UDim2.new(1, 6, 1, 6)
    Border.Position = UDim2.new(-0.03, 0, -0.03, 0)
    Border.BackgroundColor3 = borderColor
    Border.BorderSizePixel = 0
    Border.ZIndex = parent.ZIndex - 1
    Border.Parent = parent

    -- Cantos arredondados para a borda
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = NotificationAPI.Config.DefaultCornerRadius
    Corner.Parent = Border

    -- Animação de cor
    animate(Border, {BackgroundColor3 = Color3.fromRGB(255, 0, 0)}, 1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut):Play()
    return Border
end

-- Função para criar notificações
function NotificationAPI.ShowNotification(params)
    -- Validar parâmetros
    params.title = params.title or "Título Padrão"
    params.description = params.description or "Descrição Padrão"
    params.bgColor = params.bgColor or NotificationAPI.Config.DefaultBackgroundColor
    params.borderColor = params.borderColor or NotificationAPI.Config.DefaultBorderColor
    params.duration = params.duration or NotificationAPI.Config.DefaultDuration
    params.position = params.position or NotificationAPI.Config.DefaultPosition
    params.soundId = params.soundId or NotificationAPI.Config.DefaultSoundId
    params.image = params.image or nil
    params.reaction = params.reaction or nil

    log("Criando notificação: " .. params.title, "INFO")

    -- Criar a notificação
    local NotificationFrame = Instance.new("Frame")
    NotificationFrame.Size = UDim2.new(0.3, 0, 0.15, 0)
    NotificationFrame.BackgroundColor3 = params.bgColor
    NotificationFrame.BorderSizePixel = 0
    NotificationFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    NotificationFrame.Position = UDim2.new(1.5, 0, 0.5, 0) -- Fora da tela (para animação)
    NotificationFrame.Parent = ScreenGui

    -- Cantos arredondados
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = NotificationAPI.Config.DefaultCornerRadius
    Corner.Parent = NotificationFrame

    -- Adicionar a borda animada
    createBorder(NotificationFrame, params.borderColor)

    -- Adicionar título
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -20, 0.3, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 5)
    TitleLabel.Text = params.title
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextScaled = true
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.Gotham
    TitleLabel.Parent = NotificationFrame

    -- Adicionar descrição
    local DescriptionLabel = Instance.new("TextLabel")
    DescriptionLabel.Size = UDim2.new(1, -20, 0.5, 0)
    DescriptionLabel.Position = UDim2.new(0, 10, 0.4, 0)
    DescriptionLabel.Text = params.description
    DescriptionLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    DescriptionLabel.TextScaled = true
    DescriptionLabel.BackgroundTransparency = 1
    DescriptionLabel.Font = Enum.Font.Gotham
    DescriptionLabel.Parent = NotificationFrame

    -- Adicionar imagem (opcional)
    if params.image then
        local ImageLabel = Instance.new("ImageLabel")
        ImageLabel.Size = UDim2.new(0.3, 0, 0.3, 0)
        ImageLabel.Position = UDim2.new(0.85, -20, 0.5, -20)
        ImageLabel.Image = params.image
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Parent = NotificationFrame
    end

    -- Adicionar som (opcional)
    if params.soundId then
        local Sound = Instance.new("Sound")
        Sound.SoundId = "rbxassetid://" .. tostring(params.soundId)
        Sound.Volume = 1
        Sound.Parent = NotificationFrame
        Sound:Play()

        Sound.Ended:Connect(function()
            Sound:Destroy()
        end)
    end

    -- Animação de entrada
    local finalPosition = params.position == "Right" and UDim2.new(0.9, 0, 0.5, 0)
        or params.position == "Left" and UDim2.new(0.1, 0, 0.5, 0)
        or UDim2.new(0.5, 0, 0.2, 0)

    animate(NotificationFrame, {Position = finalPosition}, NotificationAPI.Config.AnimationSpeed)

    -- Auto-destruir após o tempo
    task.delay(params.duration, function()
        animate(NotificationFrame, {Position = UDim2.new(1.5, 0, 0.5, 0)}, NotificationAPI.Config.AnimationSpeed)
        task.wait(NotificationAPI.Config.AnimationSpeed)
        NotificationFrame:Destroy()
        log("Notificação destruída", "INFO")
    end)
end

return NotificationAPI
