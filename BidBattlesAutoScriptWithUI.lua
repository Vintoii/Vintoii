-- Bid Battles Auto Script with Elegant UI
-- Automates clicking 'Auctions', entering 'Bank Vault', auto bidding, and detects diamond/gem safes
-- For use with Roblox executor (e.g., Delta Executor)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ======= UI Setup =======
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoBidStatusGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Container Frame with light background and subtle shadow
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 360, 0, 170)
frame.Position = UDim2.new(1, -380, 0.5, -85)
frame.BackgroundColor3 = Color3.fromHex("#ffffff")
frame.BorderSizePixel = 0
frame.AnchorPoint = Vector2.new(0, 0.5)
frame.Name = "StatusFrame"
frame.Parent = screenGui
frame.ClipsDescendants = true

-- Rounded corners subtle shadow container
local shadow = Instance.new("Frame")
shadow.Name = "Shadow"
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.9
shadow.BorderSizePixel = 0
shadow.ZIndex = frame.ZIndex - 1
shadow.Position = frame.Position + UDim2.new(0, 5, 0, 5)
shadow.Size = frame.Size + UDim2.new(0, 10, 0, 10)
shadow.AnchorPoint = frame.AnchorPoint
shadow.Parent = screenGui

local frameUICorner = Instance.new("UICorner")
frameUICorner.CornerRadius = UDim.new(0, 12)
frameUICorner.Parent = frame

local shadowUICorner = Instance.new("UICorner")
shadowUICorner.CornerRadius = UDim.new(0, 12)
shadowUICorner.Parent = shadow

-- Title label - bold, elegant typography
local titleLabel = Instance.new("TextLabel")
titleLabel.Text = "Bid Battles AutoScript"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 28
titleLabel.TextColor3 = Color3.fromHex("#1f2937") -- dark gray
titleLabel.BackgroundTransparency = 1
titleLabel.Size = UDim2.new(1, -40, 0, 38)
titleLabel.Position = UDim2.new(0, 20, 0, 12)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = frame

-- Status Label - neutral gray, readable body text
local statusLabel = Instance.new("TextLabel")
statusLabel.Text = "Status: Initializing..."
statusLabel.Font = Enum.Font.GothamMedium
statusLabel.TextSize = 18
statusLabel.TextColor3 = Color3.fromHex("#6b7280")
statusLabel.BackgroundTransparency = 1
statusLabel.Size = UDim2.new(1, -40, 0, 30)
statusLabel.Position = UDim2.new(0, 20, 0, 60)
statusLabel.TextWrapped = true
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = frame

-- Safes detection label
local safesLabel = Instance.new("TextLabel")
safesLabel.Text = "Detected Safes: None"
safesLabel.Font = Enum.Font.GothamMedium
safesLabel.TextSize = 18
safesLabel.TextColor3 = Color3.fromHex("#6b7280")
safesLabel.BackgroundTransparency = 1
safesLabel.Size = UDim2.new(1, -40, 0, 30)
safesLabel.Position = UDim2.new(0, 20, 0, 95)
safesLabel.TextXAlignment = Enum.TextXAlignment.Left
safesLabel.Parent = frame

-- Auto Bid label with subtle green accent
local autoBidLabel = Instance.new("TextLabel")
autoBidLabel.Text = "Auto Bidding: ON"
autoBidLabel.Font = Enum.Font.GothamMedium
autoBidLabel.TextSize = 18
autoBidLabel.TextColor3 = Color3.fromHex("#22c55e") -- green
autoBidLabel.BackgroundTransparency = 1
autoBidLabel.Size = UDim2.new(1, -40, 0, 30)
autoBidLabel.Position = UDim2.new(0, 20, 0, 130)
autoBidLabel.TextXAlignment = Enum.TextXAlignment.Left
autoBidLabel.Parent = frame

-- Helper function: find descendant TextButton or TextLabel by exact text (case insensitive)
local function findGuiObjectByText(root, targetText)
    targetText = targetText:lower()
    local function searchChildren(parent)
        for _, child in ipairs(parent:GetChildren()) do
            if (child:IsA("TextButton") or child:IsA("TextLabel")) and child.Text and child.Text:lower() == targetText then
                return child
            end
            local found = searchChildren(child)
            if found then return found end
        end
        return nil
    end
    return searchChildren(root)
end

-- Click 'Auctions' button on left sidebar
local function clickAuctionsButton()
    local btn = findGuiObjectByText(playerGui, "auctions")
    if btn and btn.Visible and btn.Enabled then
        if btn.Activate then
            btn:Activate()
        elseif btn.FireServer then
            btn:FireServer()
        end
        statusLabel.Text = "Status: Clicked 'Auctions'"
        return true
    elseif btn then
        statusLabel.Text = "'Auctions' button found but not clickable"
        return false
    else
        statusLabel.Text = "'Auctions' button not found"
        return false
    end
end

-- Enter specified auction map (exact match)
local function enterAuctionMap(auctionName)
    local btn = findGuiObjectByText(playerGui, auctionName)
    if btn and btn.Visible and btn.Enabled then
        if btn.Activate then
            btn:Activate()
        elseif btn.FireServer then
            btn:FireServer()
        end
        statusLabel.Text = "Status: Entered auction '".. auctionName .."'"
        return true
    elseif btn then
        statusLabel.Text = "'" .. auctionName .. "' found but not clickable"
        return false
    else
        statusLabel.Text = "'" .. auctionName .. "' not found"
        return false
    end
end

-- Auto place bid by clicking 'Place Bid'
local function autoPlaceBid()
    local btn = findGuiObjectByText(playerGui, "place bid")
    if btn and btn.Visible and btn.Enabled then
        if btn.Activate then
            btn:Activate()
        elseif btn.FireServer then
            btn:FireServer()
        end
        statusLabel.Text = "Status: Placed bid"
        return true
    elseif btn then
        statusLabel.Text = "'Place Bid' found but not clickable"
        return false
    end
    statusLabel.Text = "'Place Bid' not found"
    return false
end

-- Detect diamond and gem safes in workspace or GUI
local function detectSafes()
    local safesFound = {}

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") then
            local lname = obj.Name:lower()
            if lname:find("diamond safe") or lname:find("diamond_safe") or lname:find("diamond-safe") then
                safesFound["Diamond Safe"] = true
            elseif lname:find("gem safe") or lname:find("gem_safe") or lname:find("gem-safe") then
                safesFound["Gem Safe"] = true
            end
        end
    end

    for _, guiObj in pairs(playerGui:GetDescendants()) do
        if guiObj:IsA("GuiObject") then
            local lname = guiObj.Name:lower()
            if lname:find("diamond safe") or lname:find("diamond_safe") or lname:find("diamond-safe") then
                safesFound["Diamond Safe (GUI)"] = true
            elseif lname:find("gem safe") or lname:find("gem_safe") or lname:find("gem-safe") then
                safesFound["Gem Safe (GUI)"] = true
            end
        end
    end

    local safeList = {}
    for safeName in pairs(safesFound) do
        table.insert(safeList, safeName)
    end

    if #safeList == 0 then
        safesLabel.Text = "Detected Safes: None"
    else
        safesLabel.Text = "Detected Safes: " .. table.concat(safeList, ", ")
    end
end

-- Main auto script variables
local auctionMapName = "Bank Vault"
local autoBidEnabled = true
local lastEnterAttempt = 0
local lastBidAttempt = 0
local lastSafeDetect = 0
local enterCooldown = 12
local bidCooldown = 3
local safeDetectInterval = 5
local auctionsClicked = false
local mapEntered = false

RunService.Heartbeat:Connect(function()
    local now = tick()

    -- Click 'Auctions' button once per cooldown until clicked
    if not auctionsClicked and (now - lastEnterAttempt) >= enterCooldown then
        local clicked = clickAuctionsButton()
        if clicked then
            auctionsClicked = true
            mapEntered = false
        end
        lastEnterAttempt = now
    end

    -- Enter auction map after clicking auctions
    if auctionsClicked and not mapEntered and (now - lastEnterAttempt) >= 1 then
        local entered = enterAuctionMap(auctionMapName)
        if entered then
            mapEntered = true
        end
        lastEnterAttempt = now
    end

    -- Auto place bid if auction map entered
    if autoBidEnabled and mapEntered and (now - lastBidAttempt) >= bidCooldown then
        local bidPlaced = autoPlaceBid()
        if bidPlaced then
            lastBidAttempt = now
        end
    end

    -- Detect safes periodically
    if (now - lastSafeDetect) >= safeDetectInterval then
        detectSafes()
        lastSafeDetect = now
    end
end)

statusLabel.Text = "Status: AutoScript active | Waiting to enter auction"

