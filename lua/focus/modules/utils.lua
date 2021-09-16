local M = {}

function M.to_set(list)
	local set = {}
	for _, l in ipairs(list) do
		set[l] = true
	end
	return set
end

function M.split(s, delimiter)
	local result = {}
	for match in (s .. delimiter):gmatch('(.-)' .. delimiter) do
		table.insert(result, match)
	end
	return result
end

return M
