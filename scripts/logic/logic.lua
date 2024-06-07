-- ITEM COUNT CHECKS

-- returns int of # of badges
function badges_count()
    return Tracker:ProviderCountForCode('badge')
end
-- returns int of # of key items
function key_items_count()
    local count = 0
    -- accounting for the purchasable evo stones
    --TODO: I guess this should account for sequencebreak so it can bubble up
    -- if celadon() == AccessibilityLevel.Normal and has('opt_stonesanity_on') ~= AccessibilityLevel.Normal then
    if has('opt_stonesanity_on') == AccessibilityLevel.Normal then
        count = 4
    end
    print('key items' .. count  + Tracker:ProviderCountForCode('keyitem'))
    return count  + Tracker:ProviderCountForCode('keyitem')
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
-- returns int of # of fossiles
function fossil_count()
    local fossils = Tracker:ProviderCountForCode("fossil")
    return fossils
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
    -- if access(has('cut'),max(has('cascade'),has('opt_hm_off'),extra)) then
    --     return AccessibilityLevel.Normal
    -- end
    -- return AccessibilityLevel.None
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
    -- if has('fly') and (has('thunder') or has('opt_hm_off') or extra) then
    --     return AccessibilityLevel.Normal
    -- end
    -- return AccessibilityLevel.None
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
    return access(fly(),has("fly_"..location))
end

-- ITEM ACCESS CHECKS
function cardkey(floor)
    -- print("cardkey floor:" .. floor)
    -- print("has cardkey: " .. has('cardkey'))
    -- print("has cardkey " .. floor .. "F: " .. has('cardkey'..floor..'f'))
    -- print('cardkey_prog: ' .. Tracker:ProviderCountForCode('cardkey_progressive'))
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
    -- if flash() or has('opt_dark_rock_tunnel_on') then
    --     return AccessibilityLevel.Normal
    -- elseif has('opt_dark_rock_tunnel_off') then
    --     return AccessibilityLevel.SequenceBreak
    -- else
    --     return AccessibilityLevel.None
    -- end
end

function officer()
    print('bill: '..has('bill'))
    print('officer_off: '..has('opt_officer_off'))
    return max(has('bill'),has("opt_officer_off"))
end

-- LOCATION ACCESS CHECKS
function pewter()
    return max(old_man(),cut(),flyto('pewter'), access(cerulean(),surf()))
end

function rt3()
    local open = has('opt_rt3open')
    local boulder = access(has('opt_rt3boulder'),has('boulder'))
    local any_badge = access(has('opt_rt3badge'),has('badge'))
    local brock = access(has('opt_rt3brock'),has('brock_beaten'))
    local any_gym = access(has('opt_rt3gym'),has('gym_beaten'))
    return max(open, boulder, any_badge, brock, any_gym)
    -- return max(has('opt_rt3open'),access(has('opt_rt3boulder'),has('boulder')), access(has('opt_rt3badge'),has('badge')))
end

function cerulean()
    local flight =  flyto('cerulean')
    local underground = max(cut(), flyto('vermilion'))
    local underground_via_boardwalk = access(has('pokeflute'),extra_boulders(), max(access(surf(), strength()), flyto('fuchsia')))
    local gate = max(access(has('tea'),max(flyto('saffron'),celadon())),access(has('opt_tea_off'),celadon()))
    local rt3_passable = access(rt3(),max(old_man(),cut(),flyto('pewter')))
    -- local rocktunnel = access(cut(),lavender()) --this skips checking for flash, which we'll do in accessrules i think?
    -- if flight or underground or rt3_passable or gate then
    --     return AccessibilityLevel.Regular
    -- elseif gate then
    --     return AccessibilityLevel.SequenceBreak
    -- else
    --     return AccessibilityLevel.None
    -- end
    return max(flight, underground, gate, rt3_passable, underground_via_boardwalk)
    -- return AccessibilityLevel.None
    -- return flight or vermilion() or rt3_passable
end

function vermilion()
    --flight
    local flight =  flyto('vermilion')
    -- local underground = flyto('vermilion') or (has('pokeflute') and surf() and (strength() or extra_boulders()))
    local gate = max(access(has('tea'),max(flyto('saffron'),celadon())),access(has('opt_tea_off'),celadon()))
    -- local underground = max(cut(),officer()) and ((rt3() and max(old_man(),cut(),flyto('pewter'))) or flyto('cerulean')) --TODO: Fix this
    local underground = access(officer(), max(flyto('cerulean'), access(rt3(), max(old_man(), flyto('pewter')))))
    -- local rocktunnel = access(cut(),lavender(),rock_tunnel())
    local snorlax = access(has('pokeflute'),extra_boulders(),max(lavender(),flyto('fuchsia'), access(surf(), strength())))--through eastern boardwalk
    local diglett = cut() --through diglett cave

    -- if flight or underground or rt3_passable or gate then
    --     return AccessibilityLevel.Regular
    -- elseif gate then
    --     return AccessibilityLevel.SequenceBreak
    -- else
    --     return AccessibilityLevel.None
    -- end
    return max(flight,gate,underground, snorlax, diglett)
    -- return flight or underground or rocktunnel or gate or diglett
end

function lavender()
    return celadon()
end

function celadon()
    local flute = has('pokeflute')
    local boulders = extra_boulders()
    local cerulean = max(flyto('cerulean'),flyto('vermilion'),access(rt3(),max(old_man(),cut(),flyto('pewter'))))
    local rocktunnel = access(cerulean, rock_tunnel(), cut())
    local flight = max(flyto('celadon'),flyto('lavender'))
    local gate = access(fly('saffron'),has('tea'))
    local reverse_lavender = access(surf(),strength())
    local via_fuchsia = access(flyto('fuchsia'),flute,max(boulders,cyclingroad()))
    local via_vermilion = access(max(flyto('cerulean'), flyto('vermilion')),max(has('tea'),access(flute,boulders)))
    return max(flight,gate,reverse_lavender,via_fuchsia,via_vermilion, rocktunnel)
    -- return flight or gate or reverse_lavender or via_fuchsia or via_vermilion
end

function saffron()
    local gate = access(max(has('tea'), access(celadon(),has('opt_tea_off'))),max(lavender(),cerulean()))
    return max(flyto('saffron'), gate)
end

function fuchsia()
    local flight = flyto('fuchsia')
    local via_cinnabar = access(surf(),strength())
    local flute = has('pokeflute')
    local cycling_road = access(cyclingroad(),cerulean(),flute)
    local boulders = extra_boulders()
    local via_vermilion = access(cerulean(),flute,boulders)
    local via_lavender = access(lavender(),max(surf(),access(flute,boulders)))
    -- return flight or via_cinnabar or cycling_road or via_vermilion or via_lavender
    return max(flight, via_cinnabar, cycling_road, via_vermilion, via_lavender)
end

function cinnabar()
    local surf = access(surf())
    local flight = access(flyto('cinnabar'))
    -- return surf() or flyto('cinnabar')
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
    -- local badges = badges()
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
    -- local key_items = key_items()
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


    if ((badges_count() >= badges_required) and (key_items_count() >= key_items_required) and (pokedex >= pokedex_required)) then
        return AccessibilityLevel.Normal
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
    -- local badges = badges()
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
    -- local badges = badges()
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