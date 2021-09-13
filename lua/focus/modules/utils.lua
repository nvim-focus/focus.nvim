local M = {}

function M.to_set(list)
	local set = {}
	for _, l in ipairs(list) do
		set[l] = true
	end
	return set
end

return M
