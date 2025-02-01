-- Author: Rikj000
local json = require('json')
local configPath = './Mods/NoStuckPals/NoStuckPals.modconfig.json'
local configTemplatePath = './Mods/NoStuckPals/NoStuckPals.template.json'
local config

-- Define debug logging helper function
local logHeader = '[NoStuckPals] '
local function LogDebug(message)
    if (config == nil or config.LogDebugInfo.live == true) then
        print(logHeader .. message .. '\n')
    end
end

-- Define config creation helper function
local function CreateConfig()
    local configFile = io.open(configPath, 'w')
    local configTemplateFile = io.open(configTemplatePath, 'r')
    local configTemplateString = configTemplateFile:read('*all')
    configTemplateFile:close()
    configFile:write(configTemplateString)
    configFile:close()
    LogDebug('Created NoStuckPals.modconfig.json!')
end

-- Define config loading helper function
local function LoadConfig()
    if (io.open(configPath, 'r') == nil) then
        CreateConfig()
    end

    local configFile = io.open(configPath, 'r')
    local configString = configFile:read('*all')
    configFile:close()

    config = json.decode(configString)
    LogDebug('Loaded NoStuckPals.modconfig.json!')
end

-- Define scale helper function
local function ScalePal(character, scale)
    character:SetActorScale3D({ X = scale, Y = scale, Z = scale })
end

-- Register config (re)load hook + Load the initial config
LoadConfig()
RegisterHook('/Script/Engine.PlayerController:ServerAcknowledgePossession', function(_)
    LoadConfig()
end)

-- Register scaling hook
NotifyOnNewObject('/Script/Pal.PalCharacter', function(Character)
    if (Character.StaticCharacterParameterComponent.IsPal == false or config.ScaleSize.live > 1) then
        return
    end

    ScalePal(Character, config.ScaleSize.live)
    LogDebug('Early hook - Scaled pal (and collision box) to smaller size '
            .. tostring(config.ScaleSize.live) .. '!')

    ExecuteWithDelay(1, function()
        ScalePal(Character, 1)
        LogDebug('Delayed hook - Scaled pal (not collision box) back to original size 1!')
    end)
end)
