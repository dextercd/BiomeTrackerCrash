-- Just for fun :^)
function OnWorldPreUpdate()
    local we = GameGetWorldStateEntity()
    local wc = EntityGetFirstComponent(we, "WorldStateComponent")
    ComponentSetValue2(wc, "mods_have_been_active_during_this_run", false)
end
local x, y = 3846, 5445

-- Script shows off the biome changes that don't make sense
ModTextFileSetContent("mods/BiomeTrackerCrash/biome_tracker.lua", [[
function biome_entered(new, old)
    print(old .. " -> " .. new)
    GamePrint(old .. " -> " .. new)
end
]])

function OnPlayerSpawned(player)
    EntitySetTransform(player, x, y)

    local SpawnBiomeTracker = function(x, y)
        local e = EntityCreateNew("biome-tracker")
        EntityAddComponent2(e, "BiomeTrackerComponent")
        EntityAddComponent2(e, "LuaComponent", {
            execute_every_n_frame = -1,
            script_biome_entered = "mods/BiomeTrackerCrash/biome_tracker.lua",
        })
        EntitySetTransform(e, x, y)
    end

    -- The more unique biomes are tracked, the more likely the crash becomes
    SpawnBiomeTracker(0, 600)       SpawnBiomeTracker(0, 1400)       SpawnBiomeTracker(0, 2100)
    SpawnBiomeTracker(0, 3700)      SpawnBiomeTracker(0, 5500)       SpawnBiomeTracker(0, 7300)
    SpawnBiomeTracker(0, 9300)      SpawnBiomeTracker(0, 11690)      SpawnBiomeTracker(2000, 13134)
    SpawnBiomeTracker(0, 13860)     SpawnBiomeTracker(-4855, 15142)  SpawnBiomeTracker(3850, 15611)
    SpawnBiomeTracker(-3457, 3801)  SpawnBiomeTracker(-6317, 4713)   SpawnBiomeTracker(-13946, 8622)
    SpawnBiomeTracker(9982, 4354)   SpawnBiomeTracker(15035, -3284)  SpawnBiomeTracker(14867, 14960)
    SpawnBiomeTracker(6399, 15127)  SpawnBiomeTracker(11516, 10025)  SpawnBiomeTracker(14079, 11008)
    SpawnBiomeTracker(14089, 6420)  SpawnBiomeTracker(14102, 3127)   SpawnBiomeTracker(10371, -4876)
    SpawnBiomeTracker(11531, -4864) SpawnBiomeTracker(-13902, -4744) SpawnBiomeTracker(-13057, -5363)
    SpawnBiomeTracker(259, -25847)  SpawnBiomeTracker(12536, 15161)
end

function OnWorldPostUpdate()
    -- Load biome map every second. Will crash eventually in the LuaSystem event
    -- handler for Message_EnteredBiome when copying the name of the old_biome.
    if GameGetFrameNum() % 60 == 0 then
        BiomeMapLoad_KeepPlayer("data/scripts/biome_map.lua")
    end
end
