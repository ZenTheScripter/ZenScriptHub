h-- ZenScriptHub Server Hop
-- Load me with: loadstring(game:HttpGet("https://raw.githubusercontent.com/ZenTheScripter/ZenScriptHub/main/ServerHop.lua"))()

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

-- Main Server Hop Function
local function ServerHop()
    local gameId = game.PlaceId
    local currentServerId = game.JobId
    
    print("🔄 Server Hop: Searching for available servers...")
    
    -- Get server list from Roblox API
    local success, result = pcall(function()
        local response = game:HttpGet("https://games.roblox.com/v1/games/" .. gameId .. "/servers/Public?sortOrder=Desc&limit=100")
        return HttpService:JSONDecode(response)
    end)
    
    if success and result and result.data then
        local availableServers = {}
        
        -- Filter servers with available slots
        for _, server in ipairs(result.data) do
            if server.playing < server.maxPlayers and server.id ~= currentServerId then
                table.insert(availableServers, server)
            end
        end
        
        if #availableServers > 0 then
            -- Select random server
            local randomServer = availableServers[math.random(1, #availableServers)]
            print("✅ Server Hop: Joining server with " .. randomServer.playing .. "/" .. randomServer.maxPlayers .. " players")
            
            -- Teleport to selected server
            TeleportService:TeleportToPlaceInstance(gameId, randomServer.id, Players.LocalPlayer)
        else
            print("❌ Server Hop: No available servers found, using fallback method")
            -- Fallback: teleport to same game
            TeleportService:Teleport(gameId, Players.LocalPlayer)
        end
    else
        print("❌ Server Hop: Failed to fetch server list, using fallback method")
        -- Fallback: teleport to same game
        TeleportService:Teleport(gameId, Players.LocalPlayer)
    end
end

-- Low Population Server Hop
local function LowPopulationHop()
    local gameId = game.PlaceId
    local currentServerId = game.JobId
    
    print("🔄 Low Population Hop: Searching for empty servers...")
    
    local success, result = pcall(function()
        local response = game:HttpGet("https://games.roblox.com/v1/games/" .. gameId .. "/servers/Public?sortOrder=Asc&limit=100")
        return HttpService:JSONDecode(response)
    end)
    
    if success and result and result.data then
        local emptyServers = {}
        
        -- Find servers with very few players
        for _, server in ipairs(result.data) do
            if server.playing <= 5 and server.id ~= currentServerId then
                table.insert(emptyServers, server)
            end
        end
        
        if #emptyServers > 0 then
            -- Find the server with the least players
            local bestServer = emptyServers[1]
            for _, server in ipairs(emptyServers) do
                if server.playing < bestServer.playing then
                    bestServer = server
                end
            end
            
            print("✅ Low Population Hop: Joining server with " .. bestServer.playing .. "/" .. bestServer.maxPlayers .. " players")
            TeleportService:TeleportToPlaceInstance(gameId, bestServer.id, Players.LocalPlayer)
        else
            print("❌ Low Population Hop: No empty servers found, using normal hop")
            ServerHop()
        end
    else
        print("❌ Low Population Hop: Failed to fetch server list, using normal hop")
        ServerHop()
    end
end

-- Execute Server Hop
ServerHop()

return {
    ServerHop = ServerHop,
    LowPopulationHop = LowPopulationHop

}
