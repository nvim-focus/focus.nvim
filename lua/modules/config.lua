local globals = vim.g
local DEFAULT_WIDTH = 120
local DEFAULT_HEIGHT = 0
local DEFAULT_TREE_WIDTH = globals.nvim_tree_width or 30



local defaults = {
    enable = true,
    height_compatible = false,
    width = DEFAULT_WIDTH,
    height = DEFAULT_HEIGHT,
    treewidth = DEFAULT_TREE_WIDTH;
    cursorline = true,
    signcolumn = true,
    winhighlight = false,
}

local function verify()
    if type(defaults.width) ~= 'number' then
        defaults.width = DEFAULT_WIDTH
    end

    if type(defaults.height) ~= 'number' then
        defaults.height = DEFAULT_HEIGHT
    end
    if type(defaults.treewidth) ~= 'number' then
        defaults.treewidth = DEFAULT_TREE_WIDTH
    end
end

local function set(table, key, value)
    defaults[key] = value
end

local function get(table, key)
    return defaults[key]
end

return {
    defaults = defaults,
    get = get,
    set = set,
    verify = verify,
}
