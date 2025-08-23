-- VERSÃO COMPLETA RED BLACK HUB-FORSAKEN
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/Kiwilegazin/Orion-mobile-v2/refs/heads/main/README.md')))()

local Window = OrionLib:MakeWindow({
    Name = "🎩RED BLACK HUB-FORSAKEN🎩",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "OrionTest",
    IntroEnabled = false
})

-- =====================
-- TAB ESP
-- =====================
local TabESP = Window:MakeTab({
    Name = "ESP",
    Icon = "rbxassetid://87117402316439",
    PremiumOnly = false
})

-- Funções ESP
local function getTopModel(inst)
    if inst:IsA("Model") then return inst end
    return inst:FindFirstAncestorOfClass("Model")
end

local function getAdorneePart(target)
    if target:IsA("BasePart") then return target end
    if target:IsA("Model") then
        if target.PrimaryPart then return target.PrimaryPart end
        for _,d in ipairs(target:GetDescendants()) do
            if d:IsA("BasePart") then return d end
        end
    end
    return nil
end

local function hasKeywordAncestor(inst, keyword)
    keyword = keyword:lower()
    local cur = inst
    while cur and cur ~= workspace do
        if cur.Name and string.find(cur.Name:lower(), keyword, 1, true) then
            return cur
        end
        cur = cur.Parent
    end
    return nil
end

local function attachESP(target, color, labelText)
    local model = getTopModel(target) or target
    if not model then return end
    if model:FindFirstChild("RBH_ESP") then return end
    if game.Players:GetPlayerFromCharacter(model) then return end
    if model:IsDescendantOf(workspace.Terrain) then return end

    local folder = Instance.new("Folder")
    folder.Name = "RBH_ESP"
    folder.Parent = model

    local hl = Instance.new("Highlight")
    hl.Name = "RBH_Highlight"
    hl.FillColor = color
    hl.OutlineColor = Color3.new(1,1,1)
    hl.FillTransparency = 0.5
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = folder

    local part = getAdorneePart(model)
    if part then
        hl.Adornee = part

        local bb = Instance.new("BillboardGui")
        bb.Name = "RBH_Label"
        bb.Size = UDim2.new(0, 140, 0, 24)
        bb.AlwaysOnTop = true
        bb.StudsOffsetWorldSpace = Vector3.new(0, 3, 0)
        bb.Parent = folder
        bb.Adornee = part

        local tl = Instance.new("TextLabel")
        tl.BackgroundTransparency = 1
        tl.TextScaled = true
        tl.Font = Enum.Font.SourceSansBold
        tl.TextColor3 = color
        tl.Text = labelText
        tl.Size = UDim2.new(1,0,1,0)
        tl.Parent = bb
    end
end

local function scanNow(keywords, color, labelText)
    for _,inst in ipairs(workspace:GetDescendants()) do
        if not game.Players:GetPlayerFromCharacter(inst) then
            for _,kw in ipairs(keywords) do
                if inst.Name and string.find(inst.Name:lower(), kw, 1, true) then
                    attachESP(inst, color, labelText)
                    break
                end
                local anc = hasKeywordAncestor(inst, kw)
                if anc then
                    attachESP(anc, color, labelText)
                    break
                end
            end
        end
    end
end

local activeConnections = {}
local function startWatcher(id, keywords, color, labelText)
    if activeConnections[id] then
        print(id .. " já está ativo.")
        return
    end
    scanNow(keywords, color, labelText)
    activeConnections[id] = workspace.DescendantAdded:Connect(function(inst)
        if not game.Players:GetPlayerFromCharacter(inst) then
            for _,kw in ipairs(keywords) do
                if (inst.Name and string.find(inst.Name:lower(), kw, 1, true)) or hasKeywordAncestor(inst, kw) then
                    attachESP(inst, color, labelText)
                    break
                end
            end
        end
    end)
    print(id .. " ligado.")
end

-- Botões ESP
TabESP:AddButton({
    Name = "ESP GENERATOR",
    Callback = function()
        startWatcher("ESP_GENERATOR", {"generator", "gerador"}, Color3.fromRGB(255, 0, 0), "GENERATOR")
    end
})

TabESP:AddButton({
    Name = "ESP RED BLACK",
    Callback = function()
        loadstring(game:HttpGet('https://rawscripts.net/raw/Universal-Script-ESP-VERIFICADOR-DE-PLAYERS-V5-27937'))()
    end
})

-- =====================
-- TAB SCRIPTS
-- =====================
local TabScripts = Window:MakeTab({
    Name = "SCRIPTS",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

TabScripts:AddButton({
    Name = "FLY RED BLACK",
    Callback = function()
        loadstring("\108\111\97\100\115\116\114\105\110\103\40\103\97\109\101\58\72\116\116\112\71\101\116\40\34\104\116\116\112\115\58\47\47\114\97\119\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\107\105\119\105\57\57\57\45\98\108\105\112\47\77\114\47\114\101\102\115\47\104\101\97\100\115\47\109\97\105\110\47\82\69\65\68\77\69\46\109\100\34\41\41\40\41")()
    end
})

TabScripts:AddParagraph("⚡ SOBRE O FLY RED BLACK ⚡",
"Durante a partida o Fly GUI só vai te dar mais velocidade.\n\n⚠️ Velocidade recomendada: 1")

TabScripts:AddButton({
    Name = "INFINITE YIELD",
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Infinite-Yield_500"))()
    end
})

-- =====================
-- TAB TROLL
-- =====================
local TabTroll = Window:MakeTab({
    Name = "TROLL",
    Icon = "rbxassetid://6023426915",
    PremiumOnly = false
})

-- Variáveis de controle do TP
local autoTPActive = false
local playerName = ""

TabTroll:AddTextbox({
    Name = "Player para TP",
    Default = "",
    TextDisappear = false,
    Callback = function(text)
        playerName = text
    end
})

TabTroll:AddButton({
    Name = "AUTO TP",
    Callback = function()
        if playerName == "" then
            warn("Digite o nome de um player primeiro!")
            return
        end
        if autoTPActive then
            warn("AUTO TP já está ativo!")
            return
        end
        autoTPActive = true
        spawn(function()
            while autoTPActive do
                local targetPlayer = nil
                for _,p in ipairs(game.Players:GetPlayers()) do
                    if string.find(p.Name:lower(), playerName:lower()) then
                        targetPlayer = p
                        break
                    end
                end
                if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
                    end
                end
                wait(0.5)
            end
        end)
    end
})

TabTroll:AddButton({
    Name = "UN AUTO TP",
    Callback = function()
        if autoTPActive then
            autoTPActive = false
            print("AUTO TP desligado.")
        else
            warn("AUTO TP não estava ativo.")
        end
    end
})

-- ✅ ANTI KICK COMPLETO
TabTroll:AddButton({
    Name = "ANTI KICK",
    Callback = function()
        local mt = getrawmetatable(game)
        local oldNamecall = mt.__namecall
        setreadonly(mt, false)

        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if method and typeof(method) == "string" then
                method = method:lower()
                if method == "kick" or method == "disconnect" then
                    warn("[ANTI KICK] Tentativa de kick bloqueada via namecall.")
                    return nil
                end
            end
            return oldNamecall(self, ...)
        end)

        local lp = game:GetService("Players").LocalPlayer
        lp.Kick = function(...) warn("[ANTI KICK] Kick bloqueado!") end
        lp.Destroy = function(...) warn("[ANTI KICK] Destroy bloqueado!") end

        for _,v in pairs(game:GetDescendants()) do
            if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                v.OnClientEvent:Connect(function(...)
                    for _,a in pairs({...}) do
                        if type(a) == "string" and string.find(a:lower(), "kick") then
                            warn("[ANTI KICK] RemoteEvent suspeito bloqueado!")
                            return nil
                        end
                    end
                end)
            end
        end

        setreadonly(mt, true)

        OrionLib:MakeNotification({
            Name = "ANTI KICK ATIVADO",
            Content = "Proteção contra Kick ativada com sucesso!",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    end

})
