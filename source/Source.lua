-- NotificationAPI: Um sistema moderno para notificações

local NotificationAPI = {}

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Configuração inicial
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NotificationAPI"
ScreenGui.Parent = PlayerGui

-- Logs
local function log(message, messageType)
    print(string.format("[NotificationAPI - %s]: %s", messageType or "INFO", message))
end

--[[ CONFIGURAÇÃO PADRÃO ]]
NotificationAPI.Config = {
    DefaultDuration = 5,
    DefaultPosition = "Center", -- "Left", "Right", "Center"
    DefaultColor = Color3.fromRGB(255, 255, 255),
    DefaultBackgroundColor = Color3.fromRGB(30, 30, 30),
    DefaultBorderColor = Color3.fromRGB(255, 255, 255),
    DefaultCornerRadius = UDim.new(0.1, 0),
}

--[[ FUNÇÃO PRINCIPAL DE NOTIFICAÇÃO ]]
function NotificationAPI.ShowNotification(params)
    -- Validar parâmetros
    params.title = params.title or "Sem título"
    params.description = params.description or "Sem descrição"
    params.titleColor = params.titleColor or NotificationAPI.Config.DefaultColor
    params.bgColor = params.bgColor or NotificationAPI.Config.DefaultBackgroundColor
    params.borderColor = params.borderColor or NotificationAPI.Config.DefaultBorderColor
    params.duration = params.duration or NotificationAPI.Config.DefaultDuration
    params.position = params.position or NotificationAPI.Config.DefaultPosition
    params.image = params.image or nil
    params.reaction = params.reaction or nil

    log("Criando notificação: " .. params.title, "INFO")

    -- Criar notificação
    local NotificationFrame = Instance.new("Frame")
    NotificationFrame.Size = UDim2.new(0.3, 0, 0.15, 0)
    NotificationFrame.BackgroundColor3 = params.bgColor
    NotificationFrame.BorderSizePixel = 0
    NotificationFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    NotificationFrame.Position = UDim2.new(0.5, 0, 0.2, 0)
    NotificationFrame.Parent = ScreenGui

    -- Cantos arredondados
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = NotificationAPI.Config.DefaultCornerRadius
    Corner.Parent = NotificationFrame

    -- Adicionar Título
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -20, 0.3, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 5)
    TitleLabel.Text = params.title
    TitleLabel.TextColor3 = params.titleColor
    TitleLabel.TextScaled = true
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.Gotham
    TitleLabel.Parent = NotificationFrame

    -- Adicionar Descrição
    local DescriptionLabel = Instance.new("TextLabel")
    DescriptionLabel.Size = UDim2.new(1, -20, 0.5, 0)
    DescriptionLabel.Position = UDim2.new(0, 10, 0.4, 0)
    DescriptionLabel.Text = params.description
    DescriptionLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    DescriptionLabel.TextScaled = true
    DescriptionLabel.BackgroundTransparency = 1
    DescriptionLabel.Font = Enum.Font.Gotham
    DescriptionLabel.Parent = NotificationFrame

    -- Imagem (opcional)
    if params.image then
        local ImageLabel = Instance.new("ImageLabel")
        ImageLabel.Size = UDim2.new(0.3, 0, 0.3, 0)
        ImageLabel.Position = UDim2.new(0.85, -20, 0.5, -20)
        ImageLabel.Image = params.image
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Parent = NotificationFrame
    end

    -- Botão de Reação (opcional)
    if params.reaction then
        local ReactionButton = Instance.new("TextButton")
        ReactionButton.Size = UDim2.new(0.3, 0, 0.2, 0)
        ReactionButton.Position = UDim2.new(0.5, -50, 0.85, -15)
        ReactionButton.Text = params.reaction.text or "OK"
        ReactionButton.TextColor3 = params.reaction.color or NotificationAPI.Config.DefaultColor
        ReactionButton.BackgroundColor3 = params.reaction.bgColor or NotificationAPI.Config.DefaultBorderColor
        ReactionButton.Font = Enum.Font.Gotham
        ReactionButton.TextScaled = true
        ReactionButton.Parent = NotificationFrame

        ReactionButton.MouseButton1Click:Connect(function()
            log("Botão de reação clicado", "EVENT")
            NotificationFrame:Destroy()
        end)
    end

    -- Posicionamento
    if params.position == "Left" then
        NotificationFrame.Position = UDim2.new(0.1, 0, 0.5, 0)
    elseif params.position == "Right" then
        NotificationFrame.Position = UDim2.new(0.9, 0, 0.5, 0)
    elseif params.position == "Center" then
        NotificationFrame.Position = UDim2.new(0.5, 0, 0.2, 0)
    end

    -- Destruir após o tempo
    task.delay(params.duration, function()
        NotificationFrame:Destroy()
        log("Notificação destruída", "INFO")
    end)
end

--[[ LOG DE INICIALIZAÇÃO ]]
log("API carregada com sucesso!", "STARTUP")

return NotificationAPI