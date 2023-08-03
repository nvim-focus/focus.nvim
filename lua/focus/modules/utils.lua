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

M.is_disabled = function()
    return vim.g.focus_disable == true or vim.b.focus_disable == true
end

return M
