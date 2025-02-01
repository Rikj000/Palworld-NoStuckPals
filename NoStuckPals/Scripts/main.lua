-- Author: Rikj000

local config = require("./config")

-- Define debug logging helper function
local logHeader = "[NoStuckPals] "
local function LogDebug(message)
    if (config.LogDebugInfo == true) then
        print(logHeader .. message .. "\n")
    end
end

-- Define scale helper function
local function ScalePal(character, scale)
    character:SetActorScale3D({ X = scale, Y = scale, Z = scale })
end

-- Register early hook
NotifyOnNewObject("/Script/Pal.PalCharacter", function(Character)
    if (Character.StaticCharacterParameterComponent.IsPal == false or config.ScaleSize > 1) then
        return
    end

    ScalePal(Character, config.ScaleSize)
    LogDebug("Early hook - Scaled pal (and collision capsule) to smaller size " .. tostring(config.ScaleSize) .. '!')

    ExecuteWithDelay(1, function()
        ScalePal(Character, 1)
        LogDebug('Delayed hook - Scaled pal (not collision capsule) back to original size 1!')
    end)
end)
