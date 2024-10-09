-- from https://stackoverflow.com/questions/9168058/how-to-dump-a-table-to-console
-- dumps a table in a readable string
function dump_table(o, depth)
    if depth == nil then
        depth = 0
    end
    if type(o) == 'table' then
        local tabs = ('\t'):rep(depth)
        local tabs2 = ('\t'):rep(depth + 1)
        local s = '{\n'
        for k, v in pairs(o) do
            if type(k) ~= 'number' then
                k = '"' .. k .. '"'
            end
            s = s .. tabs2 .. '[' .. k .. '] = ' .. dump_table(v, depth + 1) .. ',\n'
        end
        return s .. tabs .. '}'
    else
        return tostring(o)
    end
end

function has(item, amount)
	local count = Tracker:ProviderCountForCode(item)
	local amount = tonumber(amount)
	if not amount then
        if count > 0 then
            return AccessibilityLevel.Normal
        end
	elseif count >= amount then
        return AccessibilityLevel.Normal
	end
    return AccessibilityLevel.None
end

function has_location(loc)
    if loc.AvailableChestCount == 0 then
        return AccessibilityLevel.Normal
    else 
        return AccessibilityLevel.None
    end
end


function progCount(code)
	return Tracker:FindObjectForCode(code).CurrentStage
end
--returns whether we can access all given arguments
function access(...)
    local access = AccessibilityLevel.Normal
    local args = {...}
    for i,v in ipairs(args) do
        --break early if we hit min accessibility
        if v == AccessibilityLevel.None then
            return AccessibilityLevel.None
        end

        if access > v then
            access = v
        end
    end

    return access
end
--returns the maximum accessibility of the given arguments
function max(...)
    local maximum = AccessibilityLevel.None
    local args = {...}

    for i,v in ipairs(args) do
        if v == AccessibilityLevel.Normal then
            return AccessibilityLevel.Normal
        end

        if maximum < v then
            maximum = v
        end
    end
    return maximum
end

function scoutable()
    return AccessibilityLevel.Inspect
end

function toggle_extra_key_items()
    local codes = {'safaripass', 'hideoutkey', 'plantkey', 'mansionkey'}
    local stage = Tracker:FindObjectForCode('opt_extra_key_items').CurrentStage

    for i, item in ipairs(codes) do
        local obj = Tracker:FindObjectForCode(item)
        if obj then
            obj.CurrentStage = stage
        end
    end
end

function toggle_tea()
    local stage = Tracker:FindObjectForCode('opt_tea').CurrentStage
    local obj = Tracker:FindObjectForCode('tea')
    if obj then
        obj.CurrentStage = stage
    end
end

function toggle_item(code)
  local active = Tracker:FindObjectForCode(code).Active
  code = code.."_hosted"
  local object = Tracker:FindObjectForCode(code)
  if object then
    object.Active = active
  else
    if ENABLE_DEBUG_LOG then
      print(string.format("toggle_item: could not find object for code %s", code))
    end
  end
end

function toggle_hosted_item(code)
  local active = Tracker:FindObjectForCode(code).Active
  code = code:gsub("_hosted", "")
  local object = Tracker:FindObjectForCode(code)
  if object then
    object.Active = active
  else
    if ENABLE_DEBUG_LOG then
      print(string.format("toggle_hosted_item: could not find object for code %s", code))
    end
  end
end

function get_ap_locations()
    local missing = Archipelago.MissingLocations
	local locations = Archipelago.CheckedLocations
	local existing_locations = {}
    --loop through all checked and unchecked locations
	for _, v in pairs(missing) do
		existing_locations[v] = true
	end
	for _, v in pairs(locations) do
		existing_locations[v] = true
	end
    return existing_locations
end