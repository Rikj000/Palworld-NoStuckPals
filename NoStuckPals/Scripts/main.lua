local palUtility = nil
local hooked = false

local config = require("./config")

local logDebugInfo = config["LogDebugInfo"]
local logHeader = "[CustomPalSizeIndividual] "

local function Log(message)
    print(logHeader .. message .. "\n")
end

local function LogDebug(message)
    if (logDebugInfo == true) then
        Log(message)
    end
end


---@return UPalUtility
local function GetPalUtility()
    if (palUtility == nil or not palUtility:IsValid()) then
        palUtility = StaticFindObject("/Script/Pal.Default__PalUtility")
    end

    return palUtility
end

local function ShouldScalePal(character)
    return character.StaticCharacterParameterComponent.IsPal == true
end

function ScalePal(character, scale)
    character:SetActorScale3D({ X = scale, Y = scale, Z = scale })
end

RegisterHook("/Script/Engine.PlayerController:ClientRestart", function()
    if not hooked then
        NotifyOnNewObject("/Script/Pal.PalCharacter", function(character)
            if (ShouldScalePal(character) == true) then
                ScalePal(character, 0.2)
                LogDebug("Hook: /Script/Pal.PalCharacter - Scaled pal to 0.2")
            end
        end)
    end
    hooked = true
end)

RegisterHook("/Script/Pal.PalCharacterParameterComponent:OnInitializedCharacter", function(Context, OwnerCharacter)
    local character = OwnerCharacter:get()
    if (ShouldScalePal(character) == true) then
        ScalePal(character, 1)
        LogDebug("Hook: /Script/Pal.PalCharacterParameterComponent:OnInitializedCharacter - Re-scaled pal to 1")
    end
end)
