---
--- MIT License
--- Copyright (c) Andreas Schneider
---
--- ==============================================================================
local helpers = dofile('tests/helpers.lua')

local child = helpers.new_child_neovim()
local expect, eq, neq =
    helpers.expect, helpers.expect.equality, helpers.expect.no_equality
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

T['focus_split']['nicely config bufnew'] = function()
    reload_module({ bufnew = true })
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

    -- The right buffer should have a different winid
    neq(resize_state.buffer[win_id_left], resize_state.buffer[win_id_right])

    -- The first line should be empty of the new buf
    eq(child.get_lines(1, 1), {})
end

T['focus_split']['nicely 2x'] = function()
    edit(lorem_ipsum_file)
    child.cmd('FocusSplitNicely')
    child.cmd('FocusSplitNicely')
    local resize_state = child.get_resize_state()

    -- Check if got the layout we expect
    local win_id_left = resize_state.windows[1]
    local win_id_right_upper = resize_state.windows[2]
    local win_id_right_lower = resize_state.windows[3]

    validate_win_layout({
        'row',
        {
            { 'leaf', win_id_left },
            {
                'col',
                {
                    { 'leaf', win_id_right_upper },
                    { 'leaf', win_id_right_lower },
                },
            },
        },
    })

    -- Check if the right window is the current window
    eq(win_id_right_lower, child.api.nvim_get_current_win())

    -- All windows should have the same buffer
    eq(
        resize_state.buffer[win_id_left],
        resize_state.buffer[win_id_right_upper]
    )
    eq(
        resize_state.buffer[win_id_left],
        resize_state.buffer[win_id_right_lower]
    )
end

T['focus_split']['nicely 3x'] = function()
    edit(lorem_ipsum_file)
    child.cmd('FocusSplitNicely')
    child.cmd('FocusSplitNicely')
    child.cmd('FocusSplitNicely')
    local resize_state = child.get_resize_state()

    -- Check if got the layout we expect
    local win_id_left = resize_state.windows[1]
    local win_id_right_upper = resize_state.windows[2]
    local win_id_right_middle = resize_state.windows[3]
    local win_id_right_lower = resize_state.windows[4]

    validate_win_layout({
        'row',
        {
            { 'leaf', win_id_left },
            {
                'col',
                {
                    { 'leaf', win_id_right_upper },
                    { 'leaf', win_id_right_middle },
                    { 'leaf', win_id_right_lower },
                },
            },
        },
    })

    -- Check if the right window is the current window
    eq(win_id_right_lower, child.api.nvim_get_current_win())

    -- All windows should have the same buffer
    eq(
        resize_state.buffer[win_id_left],
        resize_state.buffer[win_id_right_upper]
    )
    eq(
        resize_state.buffer[win_id_left],
        resize_state.buffer[win_id_right_middle]
    )
    eq(
        resize_state.buffer[win_id_left],
        resize_state.buffer[win_id_right_lower]
    )
end

T['focus_split']['nicely 4x'] = function()
    edit(lorem_ipsum_file)
    child.cmd('FocusSplitNicely')
    child.cmd('FocusSplitNicely')
    child.cmd('FocusSplitNicely')
    child.cmd('FocusSplitNicely')
    local resize_state = child.get_resize_state()

    -- Check if got the layout we expect
    local win_id_left_upper = resize_state.windows[1]
    local win_id_left_lower = resize_state.windows[2]
    local win_id_right_upper = resize_state.windows[3]
    local win_id_right_middle = resize_state.windows[4]
    local win_id_right_lower = resize_state.windows[5]

    validate_win_layout({
        'row',
        {
            { 'col', { { 'leaf', win_id_left_upper }, { 'leaf', win_id_left_lower } } },
            { 'col', { { 'leaf', win_id_right_upper }, { 'leaf', win_id_right_middle }, { 'leaf', win_id_right_lower } } },
        },
    })

    -- Check if the right window is the current window
    eq(win_id_left_lower, child.api.nvim_get_current_win())

    -- All windows should have the same buffer
    eq(
        resize_state.buffer[win_id_left_upper],
        resize_state.buffer[win_id_left_lower]
    )
    eq(
        resize_state.buffer[win_id_left_upper],
        resize_state.buffer[win_id_right_upper]
    )
    eq(
        resize_state.buffer[win_id_right_upper],
        resize_state.buffer[win_id_right_middle]
    )
    eq(
        resize_state.buffer[win_id_right_middle],
        resize_state.buffer[win_id_right_lower]
    )
end

return T
