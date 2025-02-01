-- Author: Rikj000

local config = require("./config")
local hooked = false

-- Initialize debug logging helper functions
local logHeader = "[NoStuckPals] "
local function LogDebug(message)
    if (config.LogDebugInfo == true) then
        print(logHeader .. message .. "\n")
    end
end

-- Define scale helper functions
local function ShouldScalePal(character)
    return character.StaticCharacterParameterComponent.IsPal == true
end

local function ScalePal(character, scale)
    character:SetActorScale3D({ X = scale, Y = scale, Z = scale })
end

-- Register early hook - Scales to custom pal + hit-box size
RegisterHook("/Script/Engine.PlayerController:ClientRestart", function()
    if (not hooked) then
        NotifyOnNewObject("/Script/Pal.PalCharacter", function(character)
            if (ShouldScalePal(character) == true) then
                ScalePal(character, config.ScaleSize)
                LogDebug("Early hook - Scaled pal (and hit-box) to size " .. tostring(config.ScaleSize) .. '!')
            end
        end)
    end
    hooked = true
end)

-- Register late hook - Restores pal scale, keeps modified hit-box size, if enabled
RegisterHook("/Script/Pal.PalCharacterParameterComponent:OnInitializedCharacter", function(Context, OwnerCharacter)
    local character = OwnerCharacter:get()
    if (config.ScaleHitBoxOnly == true and ShouldScalePal(character) == true) then
        ScalePal(character, 1)
        LogDebug("Late hook - Scaled pal (not hit-box) to size 1!")
    end
end)
