-- Author: Rikj000

local config = require("./config")
local hooked = false

-- Initialize arrays for each pal type
local configAffectsSize = {
    [5] = config.AffectsXL,
    [4] = config.AffectsL,
    [3] = config.AffectsM,
    [2] = config.AffectsS,
    [1] = config.AffectsXS
}

local configScaleSize = {
    [5] = config.ScaleXL,
    [4] = config.ScaleL,
    [3] = config.ScaleM,
    [2] = config.ScaleS,
    [1] = config.ScaleXS
}

local logScaleSize = {
    [5] = "XL",
    [4] = "L",
    [3] = "M",
    [2] = "S",
    [1] = "XS"
}

-- Initialize debug logging helper functions
local logHeader = "[NoStuckPals] "
local function LogDebug(message)
    if (config.LogDebugInfo == true) then
        print(logHeader .. message .. "\n")
    end
end

local function LogScaleSize(character)
    if (config.AffectsRare == true and character.StaticCharacterParameterComponent:IsRarePal()) then
        return "Rare"
    else
        return logScaleSize[character.StaticCharacterParameterComponent.Size]
    end
end

-- Define scale helper functions
local function ShouldScalePal(character)
    if (character.StaticCharacterParameterComponent.IsPal == false) then
        return false
    elseif (config.AffectsRare == true and character.StaticCharacterParameterComponent:IsRarePal()) then
        return true
    elseif (configAffectsSize[character.StaticCharacterParameterComponent.Size] == true) then
        return true
    else
        return false
    end
end

local function ScalePal(character, scale)
    character:SetActorScale3D({ X = scale, Y = scale, Z = scale })
end

local function ScaleSize(character)
    if (config.AffectsRare == true and character.StaticCharacterParameterComponent:IsRarePal()) then
        return config.ScaleRare
    else
        return configScaleSize[character.StaticCharacterParameterComponent.Size]
    end
end

-- Register early hook - Scales to custom pal + hit-box size
RegisterHook("/Script/Engine.PlayerController:ClientRestart", function()
    if (not hooked) then
        NotifyOnNewObject("/Script/Pal.PalCharacter", function(character)
            if (ShouldScalePal(character) == true) then
                local scale = ScaleSize(character)
                local palType = LogScaleSize(character)
                ScalePal(character, scale)
                LogDebug("Scaled " .. palType .. " pal (and hit-box) to size " .. tostring(scale) .. '!')
            end
        end)
    end
    hooked = true
end)

-- Register late hook - Restores pal scale, keeps modified hit-box size, if enabled
RegisterHook("/Script/Pal.PalCharacterParameterComponent:OnInitializedCharacter", function(Context, OwnerCharacter)
    local character = OwnerCharacter:get()
    if (config.OnlyScaleHitBox == true and ShouldScalePal(character) == true) then
        local palType = LogScaleSize(character)
        ScalePal(character, 1)
        LogDebug("Scaled " .. palType .. " pal (not hit-box) to size 1!")
    end
end)
