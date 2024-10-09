-- TRAINERSANITY_LOCATIONS = {}
function get_slot_options(slot_data)

    if slot_data["second_fossil_check_condition"] then
		Tracker:FindObjectForCode('opt_fossilcheck').AcquiredCount = slot_data["second_fossil_check_condition"]
	end

    if slot_data["require_item_finder"] then
		Tracker:FindObjectForCode('opt_itemfinder').CurrentStage = slot_data["require_item_finder"]
	end

    if slot_data["randomize_hidden_items"] then
		Tracker:FindObjectForCode('opt_hidden_items').CurrentStage = slot_data["randomize_hidden_items"]
	end

	if slot_data["badges_needed_for_hm_moves"] then
		local obj = Tracker:FindObjectForCode("opt_hm")
		local stage = slot_data["badges_needed_for_hm_moves"]
		if stage >= 2 then
			stage = 2
		end
		if obj then
			obj.CurrentStage = stage
		end
	end

    if slot_data["oaks_aide_rt_2"] then
		Tracker:FindObjectForCode('opt_aide_2').AcquiredCount = slot_data["oaks_aide_rt_2"]
	end

    if slot_data["oaks_aide_rt_11"] then
		Tracker:FindObjectForCode('opt_aide_11').AcquiredCount = slot_data["oaks_aide_rt_11"]
	end

    if slot_data["oaks_aide_rt_15"] then
		Tracker:FindObjectForCode('opt_aide_15').AcquiredCount = slot_data["oaks_aide_rt_15"]
	end

    if slot_data["extra_key_items"] then
		--we need to force an item-code change
		local current = Tracker:FindObjectForCode('opt_extra_key_items').CurrentStage
		local sd_value = slot_data["extra_key_items"]
		if current == sd_value then
			toggle_extra_key_items()
		else
			Tracker:FindObjectForCode('opt_extra_key_items').CurrentStage = sd_value
		end
	end

    if slot_data["extra_strength_boulders"] then
		Tracker:FindObjectForCode('opt_extra_boulders').CurrentStage = slot_data["extra_strength_boulders"]
	end

    if slot_data["tea"] then
		local current = Tracker:FindObjectForCode('opt_tea').CurrentStage
		local sd_value = slot_data["tea"]
		if current == sd_value then
			toggle_tea()
		else
			Tracker:FindObjectForCode('opt_tea').CurrentStage = sd_value
		end
	end

    if slot_data["old_man"] then
		local obj = Tracker:FindObjectForCode('opt_old_man')
		local setting = slot_data["old_man"]
		if setting == 2 then
			obj.CurrentStage = 1
		else
			obj.CurrentStage = 0
		end
	end

    if slot_data["elite_four_badges_condition"] then
		local obj = Tracker:FindObjectForCode("e4b_digit")
		obj.CurrentStage = slot_data["elite_four_badges_condition"]
	end
    
    if slot_data["elite_four_key_items_condition"] then
		local tens = Tracker:FindObjectForCode("e4k_digit1")
		local ones = Tracker:FindObjectForCode("e4k_digit2")
		local val = slot_data["elite_four_key_items_condition"]
		if tens and ones then
			tens.CurrentStage = val // 10
			ones.CurrentStage = val % 10
		end
	end

    if slot_data["elite_four_pokedex_condition"] then
		local hunds = Tracker:FindObjectForCode("e4p_digit1")
		local tens = Tracker:FindObjectForCode("e4p_digit2")
		local ones = Tracker:FindObjectForCode("e4p_digit3")
		local val = slot_data["elite_four_pokedex_condition"]
		if hunds and tens and ones then
			hunds.CurrentStage = val // 100
			tens.CurrentStage = val % 100 // 10
			ones.CurrentStage = val % 10
		end
	end

    if slot_data["victory_road_condition"] then
		local obj = Tracker:FindObjectForCode("vr_digit")
		if obj then
			obj.CurrentStage = slot_data["victory_road_condition"]
		end
	end

    if slot_data["route_22_gate_condition"] then
		local obj = Tracker:FindObjectForCode("rt22_digit")
		if obj then
			obj.CurrentStage = slot_data["route_22_gate_condition"]
		end	
	end

    if slot_data["route_3_condition"] then
		local obj = Tracker:FindObjectForCode("opt_rt3")
		local stage = slot_data["route_3_condition"]
		if stage >= 5 then
			stage = 5
		end
		if obj then
			obj.CurrentStage = stage
		end
	end

    if slot_data["robbed_house_officer"] then
		Tracker:FindObjectForCode('opt_officer').CurrentStage = slot_data["robbed_house_officer"]
	end

    if slot_data["viridian_gym_condition"] then
		local obj = Tracker:FindObjectForCode("vg_digit")
		if obj then
			obj.CurrentStage = slot_data["viridian_gym_condition"]
		end
	end

    if slot_data["cerulean_cave_badges_condition"] then
		local obj = Tracker:FindObjectForCode("ccaveB_digit")
		obj.CurrentStage = slot_data["cerulean_cave_badges_condition"]
	end

    if slot_data["cerulean_cave_key_items_condition"] then
		local tens = Tracker:FindObjectForCode("ccaveK_digit1")
		local ones = Tracker:FindObjectForCode("ccaveK_digit2")
		local val = slot_data["cerulean_cave_key_items_condition"]
		if tens and ones then
			tens.CurrentStage = val // 10
			ones.CurrentStage = val % 10
		end
	end

    if slot_data["free_fly_map"] then
		Tracker:FindObjectForCode('free_fly').CurrentStage = slot_data["free_fly_map"]
	end

    if slot_data["town_map_fly_map"] then
		Tracker:FindObjectForCode('tm_free_fly').CurrentStage = slot_data["town_map_fly_map"]
	end

    if slot_data["extra_badges"] then

		hm_list = {"Cut", "Fly", "Surf", "Strength", "Flash"}
		stages = { boulder=1, cascade=2, thunder=3, rainbow=4, soul=5, marsh=6, volcano=7, earth=8}
		for i=1,5 do
			hm = hm_list[i]
			badge = slot_data["extra_badges"][hm]
			if  badge then
				badge = string.lower(badge)
				badge = string.gsub(badge, " badge", "")
				
				obj = Tracker:FindObjectForCode(string.lower(hm).."_"..badge)
				if obj then
					obj.CurrentStage = stages[badge]
				end

			end
		end


		badge = "boulder"
		hm = "fly"
	end

    if slot_data["randomize_pokedex"] then
		Tracker:FindObjectForCode('opt_dex').CurrentStage = slot_data["randomize_pokedex"]
	end

    if slot_data["trainersanity"] then
		local value = slot_data['trainersanity']
		local stage = 0
		if value > 0 then
			stage = 1
		end
		Tracker:FindObjectForCode('opt_trn').CurrentStage = stage
		print('slot data: '.. slot_data['trainersanity'])
		print('stage' .. stage)
		print(value > 0)
		print('setting trn stage to '.. stage)
	end

    if slot_data["prizesanity"] then
		Tracker:FindObjectForCode('opt_prizesanity').CurrentStage = slot_data["prizesanity"]
	end

    if slot_data["key_items_only"] then
		Tracker:FindObjectForCode('opt_keyonly').CurrentStage = slot_data["key_items_only"]
	end

    if slot_data["poke_doll_skip"] then
		Tracker:FindObjectForCode('opt_pokedoll_skip').CurrentStage = slot_data["poke_doll_skip"]
	end

    if slot_data["bicycle_gate_skips"] then
		Tracker:FindObjectForCode('opt_bike_skips').CurrentStage = slot_data["bicycle_gate_skips"]
	end

    if slot_data["stonesanity"] then
		Tracker:FindObjectForCode('opt_stonesanity').CurrentStage = slot_data["stonesanity"]
	end

    if slot_data["dark_rock_tunnel_logic"] then
		Tracker:FindObjectForCode('opt_dark_rock_tunnel').CurrentStage = slot_data["dark_rock_tunnel_logic"]
	end

	if slot_data["require_pokedex"] then
		Tracker:FindObjectForCode('opt_dex_required').CurrentStage = slot_data["require_pokedex"]
	end

	if slot_data["blind_trainers"] then
		local sd_value = slot_data["blind_trainers"]
		if sd_value == 100 then
			Tracker:FindObjectForCode('opt_blind_trainers').CurrentStage = 1
		else
			Tracker:FindObjectForCode('opt_blind_trainers').CurrentStage = 0
		end
	end

	if slot_data["area_1_to_1_mapping"] then
		local obj = Tracker:FindObjectForCode('opt_encounter') 
		obj.CurrentStage = slot_data["area_1_to_1_mapping"] + 1 -- 0 is the disabled stage
	end

    if slot_data["split_card_key"] then
		local obj = Tracker:FindObjectForCode("opt_cardkey")
		if obj then
			local current = obj.CurrentStage
			local sd_value  = slot_data["split_card_key"]
			if sd_value == 2 then
				sd_value = 1
			elseif sd_value == 1 then
				sd_value = 2
			end
			if current == sd_value then
				split_key()
			else
				obj.CurrentStage = sd_value
			end
		end
	end
end

function dexsanity_init(locations)
    local count = 0
	for i = 0, 150 do
		local index = i + 172000549
		local check_exists = locations[index]
		if check_exists then
			count = count + 1
		end
	end
end

function trainersanity_init(locations)
    -- trainersanity checks have ids in the range 172000215-172000531
    local start_index = 172000215
    local end_index = 172000531
    for i = start_index, end_index do
        local location_exists = locations[i]
        TRAINERSANITY_LOCATIONS[i] = location_exists
		print(i .. ': ' .. tostring(TRAINERSANITY_LOCATIONS[i]))
    end
end	
