-- 1AZROBLOXCHAT FIXED VERSION

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local chatUI = nil

local CHAT_COLORS = {
    Background = Color3.fromRGB(25,5,8),
    OwnerName = Color3.fromRGB(255,100,150),
    NormalName = Color3.fromRGB(200,120,150),
    Message = Color3.fromRGB(240,200,210),
    Border = Color3.fromRGB(80,20,40)
}

local OWNER_USERIDS = {
    5224146556
}

local function isOwner(id)
    for _,v in pairs(OWNER_USERIDS) do
        if v == id then
            return true
        end
    end
    return false
end

function createUI()

    local gui = Instance.new("ScreenGui")
    gui.Name = "1AZROBLOXCHAT_UI"
    gui.ResetOnSpawn = false

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0,450,0,350)
    main.Position = UDim2.new(0,20,1,-370)
    main.BackgroundColor3 = CHAT_COLORS.Background
    main.BorderColor3 = CHAT_COLORS.Border
    main.Parent = gui

    local chatFrame = Instance.new("ScrollingFrame")
    chatFrame.Size = UDim2.new(1,-20,1,-120)
    chatFrame.Position = UDim2.new(0,10,0,10)
    chatFrame.BackgroundTransparency = 1
    chatFrame.Parent = main

    local layout = Instance.new("UIListLayout")
    layout.Parent = chatFrame

    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(1,-20,0,35)
    textBox.Position = UDim2.new(0,10,1,-40)
    textBox.PlaceholderText = "Mesaj yaz..."
    textBox.TextColor3 = CHAT_COLORS.Message
    textBox.BackgroundColor3 = CHAT_COLORS.Border
    textBox.ClearTextOnFocus = false
    textBox.Parent = main

    gui.Parent = player:WaitForChild("PlayerGui")

    chatUI = {
        Gui = gui,
        ChatFrame = chatFrame,
        TextBox = textBox
    }

end


function addMessage(name,msg,isowner)

    if not chatUI then return end

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,0,0,25)
    frame.BackgroundTransparency = 1

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0,120,1,0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = (isowner and "[OWNER] " or "")..name
    nameLabel.TextColor3 = isowner and CHAT_COLORS.OwnerName or CHAT_COLORS.NormalName
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = frame

    local msgLabel = Instance.new("TextLabel")
    msgLabel.Size = UDim2.new(1,-120,1,0)
    msgLabel.Position = UDim2.new(0,120,0,0)
    msgLabel.BackgroundTransparency = 1
    msgLabel.Text = msg
    msgLabel.TextColor3 = CHAT_COLORS.Message
    msgLabel.TextXAlignment = Enum.TextXAlignment.Left
    msgLabel.Parent = frame

    frame.Parent = chatUI.ChatFrame
end


function startChat()

    createUI()

    addMessage("1AZROBLOXCHAT","Sistem başlatıldı",true)

    chatUI.TextBox.FocusLost:Connect(function(enter)

        if enter then

            local msg = chatUI.TextBox.Text

            if msg ~= "" then
                addMessage(player.Name,msg,isOwner(player.UserId))
                chatUI.TextBox.Text = ""
            end

        end

    end)

end


if player then

    player.CharacterAdded:Connect(function()
        task.wait(1)
        startChat()
    end)

    if player.Character then
        startChat()
    end

end


getgenv().AZChat = {}

function AZChat.ToggleChat()

    local gui = player.PlayerGui:FindFirstChild("1AZROBLOXCHAT_UI")

    if gui then
        gui.Enabled = not gui.Enabled
    end

end
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TouchInputService = game:GetService("TouchInputService")

local privateChats = {}
local isMobile = false
local mainChatEnabled = true

local CHAT_COLORS = {
    Background = Color3.fromRGB(25,5,8),
    OwnerName = Color3.fromRGB(255,100,150),
    NormalName = Color3.fromRGB(200,120,150),
    Message = Color3.fromRGB(240,200,210),
    Border = Color3.fromRGB(80,20,40),
    PrivateChat = Color3.fromRGB(150, 50, 100),
    MobileButton = Color3.fromRGB(220, 100, 140),
    ToggleButton = Color3.fromRGB(100, 180, 220)
}

if TouchInputService.TouchEnabled then
    isMobile = true
end

function createToggleButton()
    local toggleGui = Instance.new("ScreenGui")
    toggleGui.Name = "1AZ_ToggleButton"
    toggleGui.ResetOnSpawn = false
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 50, 0, 50)
    toggleBtn.Position = UDim2.new(1, -60, 1, -60)
    toggleBtn.Text = "CHAT"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.BackgroundColor3 = CHAT_COLORS.ToggleButton
    toggleBtn.Font = Enum.Font.SourceSansBold
    toggleBtn.TextSize = 14
    toggleBtn.BorderSizePixel = 2
    toggleBtn.BorderColor3 = CHAT_COLORS.Border
    
    toggleBtn.MouseButton1Click:Connect(function()
        AZChat.ToggleChat()
    end)
    
    if isMobile then
        toggleBtn.TouchTap:Connect(function()
            AZChat.ToggleChat()
        end)
    end
    
    toggleBtn.Parent = toggleGui
    toggleGui.Parent = player:WaitForChild("PlayerGui")
    
    return toggleBtn
end

function createPrivateChat(playerName)
    if privateChats[playerName] then
        if privateChats[playerName].Gui then
            privateChats[playerName].Gui.Enabled = true
        end
        return privateChats[playerName]
    end
    
    local privateGui = Instance.new("ScreenGui")
    privateGui.Name = "PrivateChat_" .. playerName
    privateGui.ResetOnSpawn = false
    
    local main = Instance.new("Frame")
    main.Size = isMobile and UDim2.new(0, 300, 0, 200) or UDim2.new(0, 400, 0, 300)
    main.Position = isMobile and UDim2.new(0.5, -150, 0.5, -100) or UDim2.new(0, 450, 1, -370)
    main.BackgroundColor3 = CHAT_COLORS.PrivateChat
    main.BackgroundTransparency = 0.1
    main.BorderColor3 = CHAT_COLORS.Border
    main.BorderSizePixel = 2
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, isMobile and 25 or 30)
    title.Text = "ÖZEL: " .. playerName
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundColor3 = CHAT_COLORS.Border
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = isMobile and 14 or 16
    title.Parent = main
    
    local chatFrame = Instance.new("ScrollingFrame")
    chatFrame.Size = UDim2.new(1, -20, 1, -80)
    chatFrame.Position = UDim2.new(0, 10, 0, isMobile and 30 or 40)
    chatFrame.BackgroundTransparency = 1
    chatFrame.ScrollBarThickness = 5
    chatFrame.ScrollBarImageColor3 = CHAT_COLORS.OwnerName
    chatFrame.Parent = main
    
    local layout = Instance.new("UIListLayout")
    layout.Parent = chatFrame
    
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(1, -20, 0, isMobile and 25 or 35)
    textBox.Position = UDim2.new(0, 10, 1, -40)
    textBox.PlaceholderText = playerName .. " ile mesaj..."
    textBox.TextColor3 = CHAT_COLORS.Message
    textBox.BackgroundColor3 = CHAT_COLORS.Border
    textBox.ClearTextOnFocus = false
    textBox.Font = Enum.Font.SourceSans
    textBox.TextSize = isMobile and 12 or 14
    textBox.Parent = main
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, isMobile and 20 or 30, 0, isMobile and 20 or 30)
    closeBtn.Position = UDim2.new(1, -25, 0, 5)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.Font = Enum.Font.SourceSansBold
    closeBtn.TextSize = isMobile and 12 or 14
    closeBtn.Parent = main
    
    closeBtn.MouseButton1Click:Connect(function()
        privateGui:Destroy()
        privateChats[playerName] = nil
    end)
    
    if isMobile then
        closeBtn.TouchTap:Connect(function()
            privateGui:Destroy()
            privateChats[playerName] = nil
        end)
    end
    
    main.Parent = privateGui
    privateGui.Parent = player:WaitForChild("PlayerGui")
    
    local function addPrivateMessage(sender, message)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, isMobile and 20 or 25)
        frame.BackgroundTransparency = 1
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(0, 80, 1, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = sender
        nameLabel.TextColor3 = CHAT_COLORS.OwnerName
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.Font = Enum.Font.SourceSans
        nameLabel.TextSize = isMobile and 10 or 12
        nameLabel.Parent = frame
        
        local msgLabel = Instance.new("TextLabel")
        msgLabel.Size = UDim2.new(1, -80, 1, 0)
        msgLabel.Position = UDim2.new(0, 80, 0, 0)
        msgLabel.BackgroundTransparency = 1
        msgLabel.Text = message
        msgLabel.TextColor3 = CHAT_COLORS.Message
        msgLabel.TextXAlignment = Enum.TextXAlignment.Left
        msgLabel.Font = Enum.Font.SourceSans
        msgLabel.TextSize = isMobile and 10 or 12
        msgLabel.Parent = frame
        
        frame.Parent = chatFrame
        
        chatFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
        chatFrame.CanvasPosition = Vector2.new(0, chatFrame.CanvasSize.Y.Offset)
    end
    
    textBox.FocusLost:Connect(function(enterPressed)
        if enterPressed and textBox.Text ~= "" then
            addPrivateMessage(player.Name, textBox.Text)
            textBox.Text = ""
        end
    end)
    
    privateChats[playerName] = {
        Gui = privateGui,
        AddMessage = addPrivateMessage,
        PlayerName = playerName
    }
    
    addPrivateMessage("Sistem", "Özel chat başlatıldı: " .. playerName)
    
    return privateChats[playerName]
end

function startSystem()
    createToggleButton()
    
    print("1AZROBLOXCHAT - Özel Chat & Buton sistemi başlatıldı")
end

getgenv().AZChat = {
    PrivateChats = privateChats,
    IsMobile = isMobile
}

function AZChat.ToggleChat()
    local mainChatGui = player.PlayerGui:FindFirstChild("1AZROBLOXCHAT_UI")
    if mainChatGui then
        mainChatEnabled = not mainChatEnabled
        mainChatGui.Enabled = mainChatEnabled
        
        local toggleBtn = player.PlayerGui:FindFirstChild("1AZ_ToggleButton")
        if toggleBtn then
            local btn = toggleBtn:FindFirstChildWhichIsA("TextButton")
            if btn then
                btn.Text = mainChatEnabled and "CHAT" or "CHAT"
                btn.BackgroundColor3 = mainChatEnabled and CHAT_COLORS.ToggleButton or Color3.fromRGB(100, 100, 100)
            end
        end
        
        print("Ana chat: " .. (mainChatEnabled and "AÇIK" or "KAPALI"))
        return mainChatEnabled
    end
end

function AZChat.CreatePrivateChat(playerName)
    if type(playerName) == "string" and playerName ~= "" then
        local chatData = createPrivateChat(playerName)
        if chatData then
            print("Özel chat başlatıldı: " .. playerName)
            return chatData
        end
    else
        print("Geçersiz oyuncu adı!")
    end
    return nil
end

function AZChat.CloseAllPrivateChats()
    local count = 0
    for name, data in pairs(privateChats) do
        if data.Gui then
            data.Gui:Destroy()
            count = count + 1
        end
    end
    privateChats = {}
    print(count .. " özel chat kapatıldı")
end

if not isMobile then
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed then
            if input.KeyCode == Enum.KeyCode.F1 then
                AZChat.ToggleChat()
            elseif input.KeyCode == Enum.KeyCode.F2 then
                local executorInput = ""
                if getgenv().ExecutorInput then
                    executorInput = getgenv().ExecutorInput("Özel chat için oyuncu adı:")
                end
                
                if executorInput and executorInput ~= "" then
                    AZChat.CreatePrivateChat(executorInput)
                else
                    print("Executor input bulunamadı!")                    
                end
            end
        end
    end)
end

if getgenv().Executor then
    print("1AZROBLOXCHAT - Executor uyumlu")
    
    getgenv().ExecutorShortcuts = {
        ToggleChat = AZChat.ToggleChat,
        PrivateChat = function(name)
            return AZChat.CreatePrivateChat(name)
        end,
        ClosePrivate = AZChat.CloseAllPrivateChats,
        ListPrivateChats = function()
            local list = {}
            for name in pairs(privateChats) do
                table.insert(list, name)
            end
            return list
        end
    }
end

if player then
    player.CharacterAdded:Connect(function()
        task.wait(1)
        startSystem()
    end)

    if player.Character then
        startSystem()
    end
end

print("=====================================")
print("1AZROBLOXCHAT - ÖZEL CHAT & BUTON SİSTEMİ") 
print("Platform: " .. (isMobile and "MOBİL" or "PC"))
print("Komutlar: AZChat.ToggleChat()") 
print("          AZChat.CreatePrivateChat('isim')")
print("          AZChat.CloseAllPrivateChats()")
print("=====================================")
