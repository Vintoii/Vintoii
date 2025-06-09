-- Bootstrap loader script to fetch and execute full auto bid script from GitHub in Roblox (Delta Executor)

local rawScriptUrl = "https://raw.githubusercontent.com/yourusername/RobloxScripts/main/BidBattles_AutoScriptWithUI.lua"

local function fetchAndRunScript(url)
    local HttpService = game:GetService("HttpService")
    local scriptText

    -- Try Roblox HttpService:GetAsync (may be blocked in some games)
    local success, err = pcall(function()
        scriptText = HttpService:GetAsync(url)
    end)

    -- Fallback to executor-specific HTTP
    if not success then
        if syn and syn.request then
            local response = syn.request({Url = url, Method = "GET"})
            if response and response.Body then
                scriptText = response.Body
                success = true
            end
        elseif http_request then
            local response = http_request({Url = url, Method = "GET"})
            if response and response.Body then
                scriptText = response.Body
                success = true
            end
        end
    end

    if not success or not scriptText then
        warn("Failed to fetch script from URL: " .. url)
        return
    end

    local func, loadErr = loadstring(scriptText)
    if not func then
        warn("Failed to load script: " .. tostring(loadErr))
        return
    end

    local ok, execErr = pcall(func)
    if not ok then
        warn("Error running script: " .. tostring(execErr))
    end
end

fetchAndRunScript(rawScriptUrl)
