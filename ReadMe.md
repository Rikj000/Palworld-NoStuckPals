# Palworld - No Stuck Pals

<p align="left">
    <a href="https://www.nexusmods.com/palworld/mods/2161">
        <img src="https://img.shields.io/badge/NexusMods_Page-NoStuckPals-orange" alt="Nexus Mods - NoStuckPals">
    </a> <a href="https://github.com/Rikj000/Palworld-NoStuckPals/blob/development/LICENSE">
        <img src="https://img.shields.io/github/license/Rikj000/Palworld-NoStuckPals?label=License&logo=gnu" alt="GNU General Public License">
    </a> <a href="https://github.com/Rikj000/Palworld-NoStuckPals/releases">
        <img src="https://img.shields.io/github/downloads/Rikj000/Palworld-NoStuckPals/total?label=Total%20Downloads&logo=github" alt="Total Releases Downloaded from GitHub">
    </a> <a href="https://github.com/Rikj000/Palworld-NoStuckPals/releases/latest">
        <img src="https://img.shields.io/github/v/release/Rikj000/Palworld-NoStuckPals?include_prereleases&label=Latest%20Release&logo=github" alt="Latest Official Release on GitHub">
    </a> <a href="https://www.iconomi.com/register?ref=zQQPK">
        <img src="https://img.shields.io/badge/ICONOMI-Join-blue?logo=bitcoin&logoColor=white" alt="ICONOMI - The world’s largest crypto strategy provider">
    </a> <a href="https://www.buymeacoffee.com/Rikj000">
        <img src="https://img.shields.io/badge/-Buy%20me%20a%20Coffee!-FFDD00?logo=buy-me-a-coffee&logoColor=black" alt="Buy me a Coffee as a way to sponsor this project!"> 
    </a>
</p>

A simple single player [Palworld](https://www.pocketpair.jp/palworld) mod to prevent pals getting stuck in the base. Written in [Lua](https://www.lua.org/) using [UE4SS](https://github.com/UE4SS-RE/RE-UE4SS).

## Requirements
- [UE4SS](https://github.com/UE4SS-RE/RE-UE4SS)
- [ModConfigMenu](https://www.nexusmods.com/palworld/mods/577) (Optional)

## Installation
1. Extract the release `.zip` file into the `Palworld\Pal\Binaries\Win64\Mods` directory
2. Launch the game (generates `Palworld\Pal\Binaries\Win64\Mods\NoStuckPals\NoStuckPals.modconfig.json`)

**Servers are not supported!**   
This mod was developed on/for single player.   
Installing this mod on servers will lead to issues!

## Configuration
Either use [ModConfigMenu](https://www.nexusmods.com/palworld/mods/577) in the game's menu   
or directly edit `Palworld\Pal\Binaries\Win64\Mods\NoStuckPals\NoStuckPals.modconfig.json` with your favorite text editor.

## Motivation

I grew tired of pals getting stuck in my base,      
unable to complete their tasks due to pathing issues.   
So I've decided to write this simple mod!

## Logic Description
This mod scales down pals early, before full initialization of the Unreal Engine Character object,     
which also appears to alter their collision box.

After a delay of 1ms (not notice-able to humans), it scales the Character object back to it's original size,   
but not their collision box (that's not possible anymore at that point), so that remains smaller.

Which successfully resolved pals getting stuck in my base (with a 2 high roof),   
without undesired side effects on pals in the wild (been testing the mod a week or so before releasing).
