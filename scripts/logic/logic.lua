saffron_access = AccessibilityLevel.None
TRAINERSANITY_LOCATIONS = {}
TABLE_DUMP = TRUE

function trainer_visible(id)
    local obj = Tracker:FindObjectForCode('opt_trn')
    if (obj.CurrentStage == 0) then
        return false
    end
    -- playernumber doesn't matter, just checking if we're connected
    if Archipelago.PlayerNumber < 1 then
        return true
    end

    local key = tonumber(id)
    local x = TRAINERSANITY_LOCATIONS[key]
    return TRAINERSANITY_LOCATIONS[key]
end

function trainersanity_init(locations)
    TRAINERSANITY_LOCATIONS = {}
    -- trainersanity checks have ids in the range 172000215-172000531
    local start_index = 172000215
    local end_index = 172000531
    for i = start_index, end_index do
        local location_exists = locations[i]
        TRAINERSANITY_LOCATIONS[i] = location_exists
    end
end	

-- ITEM COUNT CHECKS

-- returns int of # of badges
function badges_count()
    return Tracker:ProviderCountForCode('badge')
end
-- returns int of # of key items
function key_items_count()
    if Tracker:FindObjectForCode('v5_update').CurrentStage == 0 then
        return Tracker:ProviderCountForCode('keyitem')
    elseif Tracker:FindObjectForCode('v5_update').CurrentStage == 1 then
        return Tracker:ProviderCountForCode('keyitem') + Tracker:ProviderCountForCode('newkeyitem')
    end
end
-- returns int of # of pokemon caught
function pokedex_count()
    local hundreds = 0
    local tens = 0
    local ones = 0

    obj = Tracker:FindObjectForCode("dex_digit1")
    if obj then
        hundreds = obj.CurrentStage
    end
    obj = Tracker:FindObjectForCode("dex_digit2")
    if obj then
        tens = obj.CurrentStage
    end
    obj = Tracker:FindObjectForCode("dex_digit3")
    if obj then
        ones = obj.CurrentStage
    end
    return (100 * hundreds) + (10 * tens) + ones
end
-- returns whether we have enough fossils for a second check
function enough_fossils()
    local fossils = Tracker:ProviderCountForCode("fossil")
    local fossils_req = Tracker:FindObjectForCode('opt_fossilcheck').AcquiredCount
    return fossils >= fossils_req
end

-- HM CHECKS

--a table for lookups
badges = {"boulder", "cascade", "thunder", "rainbow", "soul", "marsh", "volcano", "earth"}

function cut()
    obj = Tracker:FindObjectForCode('cut')
    stage = 0
    extra = AccessibilityLevel.None
    if obj then
        stage = obj.CurrentStage
        if stage > 0 then
            extra = has(badges[stage])
        end
    end
    return access(has('cut'),max(has('cascade'),has('opt_hm_off'),extra))
end

function fly()
    obj = Tracker:FindObjectForCode('fly')
    stage = 0
    extra = AccessibilityLevel.None
    if obj then
        stage = obj.CurrentStage
        if stage > 0 then
            extra = has(badges[stage])
        end
    end

    return access(has('fly'), max(has('thunder'),has('opt_hm_off'),extra))
end

function surf()
    obj = Tracker:FindObjectForCode('surf')
    stage = 0
    extra = AccessibilityLevel.None
    if obj then
        stage = obj.CurrentStage
        if stage > 0 then
            extra = has(badges[stage])
        end
    end
    return access(has('surf'), max(has('soul'),has('opt_hm_off'),extra))
end

function strength()
    obj = Tracker:FindObjectForCode('strength')
    stage = 0
    extra = AccessibilityLevel.None
    if obj then
        stage = obj.CurrentStage
        if stage > 0 then
            extra = has(badges[stage])
        end
    end

    return access(has('strength'), max(has('rainbow'),has('opt_hm_off'),extra))
end

function flash()
    obj = Tracker:FindObjectForCode('flash')
    stage = 0
    extra = AccessibilityLevel.None
    if obj then
        stage = obj.CurrentStage
        if stage > 0 then
            extra = has(badges[stage])
        end
    end
    return access(has('flash'), max(has('boulder'),has('opt_hm_off'),extra))
end

function flyto(location)
    local map = access(has("map_fly_"..location),has('townmap'))
    return access(fly(),max(map,has("fly_"..location)))
end

-- ITEM ACCESS CHECKS
function cardkey(floor)
    return max(has('cardkey'),has('cardkey'..floor..'f'),has('cardkey_progressive', floor-1))
end

function hidden()
    return max(has('opt_itemfinder_off'),has('itemfinder'))
end

function aide(route)
    local code = 'opt_aide_' .. route
    local required = Tracker:FindObjectForCode(code).AcquiredCount
    local caught = pokedex_count()
    return required <= caught and max(has('pokedex'),has('opt_dex_required_off'))

end

function rt25_item()
    local blind = AccessibilityLevel.SequenceBreak
    if has('opt_blind_trainers_on') == AccessibilityLevel.Normal then
        blind = AccessibilityLevel.None
    end
    return max(cut(), blind)
end

-- ROADBLOCK CHECKS
function old_man()
    return max(has('opt_old_man_on'), has('parcel'))
end

function extra_boulders()
    return max(strength(),has('opt_extra_boulders_off'))
end

function cyclingroad()
    return max(has('bicycle'), has('opt_bike_skips_on'))
end

function rock_tunnel()

    local in_logic = max(flash(), has('opt_dark_rock_tunnel_on'))
    local out_of_logic = AccessibilityLevel.SequenceBreak
    return max(in_logic, out_of_logic)
end

function officer()
    return max(has('bill'),has("opt_officer_off"))
end

-- LOCATION ACCESS CHECKS
function pewter()
    return max(old_man(),cut(),flyto('pewter'), access(cerulean(),surf()))
end

function rt3()
    local brock = access(has('opt_rt3brock'), has('brock_beaten'))
    local any_gym = access(has('opt_rt3gym'),has('gym_beaten'))
    local open = has('opt_rt3open')
    local boulder = access(has('opt_rt3boulder'),has('boulder'))
    local any_badge = access(has('opt_rt3badge'),has('badge'))

    
    return max(open, boulder, any_badge, brock, any_gym)
end

function cerulean()
    local flight =  flyto('cerulean')
    local underground = max(cut(), flyto('vermilion'))
    -- local underground_via_fuchsia = access(has('pokeflute'), max(access(surf(), extra_boulders()), flyto('fuchsia')))
    local underground_via_fuchsia = access(has('pokeflute'), flyto('fuchsia'), max(surf(), extra_boulders()))
    local underground_via_lavender = access(has('pokeflute'),lavender())
    local gate = max(access(has('tea'),max(flyto('saffron'),celadon())),access(has('opt_tea_off'),celadon()))
    local rt3_passable = access(rt3(),max(old_man(),cut(),flyto('pewter')))
    return max(flight, underground, gate, rt3_passable, underground_via_fuchsia, underground_via_lavender)
end

function vermilion()
    local flight =  flyto('vermilion') -- flight
    local gate = max(access(has('tea'),max(flyto('saffron'),celadon())),access(has('opt_tea_off'),celadon())) --through saffron gates
    local underground = access(officer(), max(flyto('cerulean'), access(rt3(), max(old_man(), flyto('pewter'))))) --through underground
    local pokeflute_via_fuchsia = access(has('pokeflute'),extra_boulders(),max(lavender(),flyto('fuchsia'), max(surf(), strength())))--through eastern boardwalk from fuchsia
    local pokeflute_via_lavender = access(has('pokeflute'),lavender()) --through eastern boardwalk from lavender
    local diglett = cut() --through diglett cave
    return max(flight,gate,underground, pokeflute_via_lavender, pokeflute_via_fuchsia, diglett)
end

function lavender()
    return celadon()
end

function celadon()
    local flute = has('pokeflute')
    local boulders = extra_boulders()

    local cerulean = max(flyto('cerulean'),flyto('vermilion'),cut(),access(rt3(),max(old_man(),cut(),flyto('pewter'))))
    local rocktunnel = access(cerulean, rock_tunnel(), cut())

    local flight = max(flyto('celadon'),flyto('lavender'))
    local gate = access(saffron_access,has('tea'))
    local reverse_lavender = access(surf(),strength())
    local via_fuchsia = access(flyto('fuchsia'),max(surf(),cyclingroad(),access(flute,boulders)))
    local via_vermilion = access(cerulean,max(has('tea'),access(flute,boulders)))
    return max(flight,gate,reverse_lavender,via_fuchsia,via_vermilion, rocktunnel)
end

function saffron()
    local buy_drinks = access(celadon(), has('opt_tea_off'))
    local tea = access(has('tea'),has('opt_tea_on'))
    local gate = access(tea, max(lavender(),cerulean()))
    --TODO: CLEAM THIS UP
    saffron_access = max(flyto('saffron'), gate, buy_drinks)
    return saffron_access
end

function fuchsia()
    local flight = flyto('fuchsia')
    local via_cinnabar = access(surf(),strength())
    local flute = has('pokeflute')
    local cycling_road = access(cyclingroad(),celadon(),flute)
    local boulders = extra_boulders()
    local via_vermilion = access(vermilion(),flute,boulders)
    local via_lavender = access(lavender(),max(surf(),access(flute,boulders)))
    return max(flight, via_cinnabar, cycling_road, via_vermilion, via_lavender)
end

function cinnabar()
    local surf = access(surf())
    local flight = access(flyto('cinnabar'))
    return max(surf,flight)
end

function indigo()
    local fly = access(flyto('indigo'))
    local vanilla = access(rt23(),victoryroad(),surf(),strength())
    return max(fly, vanilla)
end



function elite4()
    local obj = Tracker:FindObjectForCode("e4b_digit")
    local badges_required = obj.CurrentStage
    local hundreds = 0
    local tens = 0
    local ones = 0

    obj = Tracker:FindObjectForCode("e4k_digit1")
    if obj then
        tens = obj.CurrentStage
    end
    obj = Tracker:FindObjectForCode("e4k_digit2")
    if obj then
        ones = obj.CurrentStage
    end
    local key_items_required = (10 * tens) + ones
    obj = Tracker:FindObjectForCode("e4p_digit1")
    if obj then
        hundreds = obj.CurrentStage
    end
    obj = Tracker:FindObjectForCode("e4p_digit2")
    if obj then
        tens = obj.CurrentStage
    end
    obj = Tracker:FindObjectForCode("e4p_digit3")
    if obj then
        ones = obj.CurrentStage
    end
    local pokedex_required = (100 * hundreds) + (10 * tens) + ones
    local pokedex = pokedex_count()


    local enough_badges = badges_count() >= badges_required
    local enough_items = key_items_count() >= key_items_required
    local enough_dex = pokedex >= pokedex_required

    if enough_badges and enough_items and enough_dex then
        return AccessibilityLevel.Normal
    elseif enough_badges and enough_items then
        return AccessibilityLevel.SequenceBreak
    elseif indigo() == AccessibilityLevel.Normal then
        return scoutable()
    end
    return AccessibilityLevel.None
end

function victoryroad()
    local obj = Tracker:FindObjectForCode("vr_digit")
    if obj then
        local count = obj.CurrentStage
        if (badges_count() >= count) then
            return AccessibilityLevel.Normal
        end
    end
    return AccessibilityLevel.None
end

function rt23()
    local obj = Tracker:FindObjectForCode("rt22_digit")
    local req = obj.CurrentStage
    if badges_count() >= req then
        return AccessibilityLevel.Normal
    end
    return AccessibilityLevel.None
end

function viridiangym()
    local obj = Tracker:FindObjectForCode("vg_digit")
    if obj then
        local count = obj.CurrentStage
        if (badges_count() >= count) then
            return AccessibilityLevel.Normal
        end
    end
    return AccessibilityLevel.None
end

function ceruleancave()
    local obj = Tracker:FindObjectForCode("ccaveB_digit")
    local badge_req = 0
    local tens = 0
    local ones = 0
    if obj then
        badge_req = obj.CurrentStage
    end
    obj = Tracker:FindObjectForCode("ccaveK_digit1")
    if obj then
        tens = obj.CurrentStage
    end
    obj = Tracker:FindObjectForCode("ccaveK_digit2")
    if obj then
        ones = obj.CurrentStage
    end
    local key_item_req = (10 * tens) + ones
    if (key_items_count() >= key_item_req) and (badges_count() >= badge_req) then
        return AccessibilityLevel.Normal
    end
    return AccessibilityLevel.None
end

function powerplant()
    local unlocked = max(has('plantkey'), has('opt_extra_key_items_off'))
    local via_cerulean = access(cerulean(), cut(), surf())
    local via_lavender = access(lavender(), surf(), rock_tunnel())
    return access(unlocked, max(via_lavender, via_cerulean))
end

function hideout()
    return max(has('opt_extra_key_items_off'), has('hideoutkey'))
end

function safari_zone()
    return max(has('opt_extra_key_items_off'), has('safaripass'))
end

function mansion()
    return max(has('opt_extra_key_items_off'), has('mansionkey'))
end

function fossils()
    local mt_moon = max(access(pewter(),rt3()),access(surf(),cerulean()))
    if mt_moon == AccessibilityLevel.Normal then
        if access(mt_moon, cinnabar()) == AccessibilityLevel.Normal and enough_fossils() then
            return AccessibilityLevel.Normal
        end
        return AccessibilityLevel.SequenceBreak
    end
    return AccessibilityLevel.None
end
