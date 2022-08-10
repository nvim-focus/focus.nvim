local M = {}

--RETURNS TABLE OF LOWER CASE STRINGS
--
function M.to_lower(list)
	for k, v in ipairs(list) do
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

function M.add_to_set(set, item)
	set[item] = true
	return set
end

function M.remove_from_set(set, item)
	set[item] = nil
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

-- RETURNS TRUE IF THE STRING IS IN THE SET
function M.is_buffer_filetype_excluded(config)
	local ft = vim.bo.ft:lower()
	local bt = vim.bo.buftype:lower()
	local filetrees_set = M.to_set(M.to_lower(config.compatible_filetrees))
	local excluded_ft_set = M.to_set(M.to_lower(config.excluded_filetypes))
	local excluded_bt_set = M.to_set(M.to_lower(config.excluded_buftypes))
	local forced_ft_set = M.to_set(M.to_lower(config.forced_filetypes))
	local excluded_windows_set = M.to_set(config.excluded_windows)
	local winnr = vim.api.nvim_get_current_win()
	if
		(filetrees_set[ft] or excluded_bt_set[bt] or excluded_ft_set[ft])
		or excluded_windows_set[winnr] and not forced_ft_set[ft]
	then
		return true
	else
		return false
	end
end

return M
