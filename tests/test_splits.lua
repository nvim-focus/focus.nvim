---
--- MIT License
--- Copyright (c) Andreas Schneider
---
--- ==============================================================================
local helpers = dofile('tests/helpers.lua')

local child = helpers.new_child_neovim()
local expect, eq = helpers.expect, helpers.expect.equality
---@diagnostic disable-next-line: undefined-global
local new_set = MiniTest.new_set

local path_sep = package.config:sub(1, 1)
local project_root = vim.fn.fnamemodify(vim.fn.getcwd(), ':p')
local testdata_dir = project_root .. 'tests/data/'

local load_module = function(config)
    child.load_module(config)
end
local unload_module = function()
    child.unload_module()
end
local reload_module = function(config)
    unload_module()
    load_module(config)
end
local make_path = function(...)
    return table.concat({ ... }, path_sep):gsub(path_sep .. path_sep, path_sep)
end
local edit = function(x)
    child.cmd('edit ' .. x)
end
local validate_win_dims = function(win_id, ref)
    eq({
        child.api.nvim_win_get_width(win_id),
        child.api.nvim_win_get_height(win_id),
    }, ref)
end
local validate_win_layout = function(ref)
    eq(child.fn.winlayout(), ref)
end

---@diagnostic disable-next-line: unused-local
local vim_print = vim.print or vim.pretty_print

-- Output test set ============================================================
T = new_set({
    hooks = {
        pre_case = function()
            child.setup()
            child.set_size(50, 180)
            load_module()
        end,
        post_once = child.stop,
    },
})

-- Unit tests =================================================================
T['focus_split'] = new_set()

local lorem_ipsum_file = make_path(testdata_dir, 'loremipsum.txt')

T['focus_split']['nicely autoresize'] = function()
    edit(lorem_ipsum_file)
    child.cmd('FocusSplitNicely')
    local resize_state = child.get_resize_state()

    -- Check if got the layout we expect
    local win_id_left = resize_state.windows[1]
    local win_id_right = resize_state.windows[2]

    validate_win_layout({
        'row',
        { { 'leaf', win_id_left }, { 'leaf', win_id_right } },
    })

    -- Check if the right window is the current window
    eq(win_id_right, child.api.nvim_get_current_win())

    -- Both windows should have the same buffer
    eq(resize_state.buffer[win_id_left], resize_state.buffer[win_id_right])

    -- Check dimensions (autoresize)
    validate_win_dims(win_id_left, { 68, 48 })
    validate_win_dims(win_id_right, { 111, 48 })

    -- Switch windows
    child.cmd('wincmd w')

    -- Check dimensions after switching windows (autoresize)
    validate_win_dims(win_id_left, { 111, 48 })
    validate_win_dims(win_id_right, { 68, 48 })
end

return T
