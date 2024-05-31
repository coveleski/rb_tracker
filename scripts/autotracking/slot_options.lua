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
		Tracker:FindObjectForCode('opt_extra_key_items').CurrentStage = slot_data["extra_key_items"]
	end

    if slot_data["extra_strength_boulders"] then
		Tracker:FindObjectForCode('opt_extra_boulders').CurrentStage = slot_data["extra_strength_boulders"]
	end

    if slot_data["tea"] then
		--TODO
		Tracker:FindObjectForCode('opt_extra_key_items').CurrentStage = slot_data["extra_key_items"]
	end

    if slot_data["old_man"] then
		Tracker:FindObjectForCode('opt_old_man').CurrentStage = slot_data["old_man"]
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
		-- TODO
	end

    if slot_data["robbed_house_officer"] then
		opt = slot_data["robbed_house_officer"]
		if opt ~= 0 then
			Tracker:FindObjectForCode('opt_officer').Active = true
		else
			Tracker:FindObjectForCode('opt_officer').Active = false
		end
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

    if slot_data["town_map_free_fly"] then
		Tracker:FindObjectForCode('tm_free_fly').CurrentStage = slot_data["town_map_free_fly"]
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
					print(stages[badge])
					obj.CurrentStage = stages[badge]
					print(obj)
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
		Tracker:FindObjectForCode('opt_trn').CurrentStage = slot_data["trainersanity"]
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

    if slot_data["split_card_key"] then
		local obj = Tracker:FindObjectForCode("op_cardkey")
		if obj then
			tmp = slot_data["split_card_key"]
			if tmp == 2 then
				tmp = 1
			elseif tmp == 1 then
				tmp = 2
				obj.CurrentStage = tmp
			end
		end
	end
end

function dexsanity_init()
    missing = Archipelago.MissingLocations
	locations = Archipelago.CheckedLocations
	dex_checks = {}
    --loop through all checked and unchecked locations
	for _, v in pairs(missing) do
		dex_checks[v] = true
	end
	for _, v in pairs(locations) do
		dex_checks[v] = true
	end

	for i = 0, 150 do
        --check to see if the dexsanity location exists in the list of all checks
		index = i + 172000549
		check_exists = dex_checks[index]
		--if it doesn't, set it to the disabled stage
        --otherwise leave at default
		if not check_exists then
			loc = LOCATION_MAPPING[index]
			obj = Tracker:FindObjectForCode(loc[1])
			if obj then
				obj.CurrentStage = 2
			end
		end
	end
end
