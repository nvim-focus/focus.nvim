local M = {}

--RETURNS TABLE OF LOWER CASE STRINGS
--
function M.to_lower(list)
    for k,v in ipairs(list) do
    list[k] = v:lower()
    end
    return list
end


--RETURNS SET FROM A TABLE FOR FAST LOOKUPS
function M.to_set(list)
	local set = {}
	for _, l in ipairs(list) do
		set[l] = true
	end
	return set
end

-- SPLITS A STRING BY SPACE FOR : COMMAND PARSING
function M.split(s, delimiter)
	local result = {}
	for match in (s .. delimiter):gmatch('(.-)' .. delimiter) do
		table.insert(result, match)
	end
	return result
end

return M
