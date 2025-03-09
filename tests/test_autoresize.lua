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
            child.set_size(25, 80)
            child.o.wrap = false
            load_module()
        end,
        post_once = child.stop,
    },
})

-- Unit tests =================================================================
T['autoresize'] = new_set()

local lorem_ipsum_file = make_path(testdata_dir, 'loremipsum.txt')

T['autoresize']['split'] = function()
    edit(lorem_ipsum_file)
    child.set_cursor(15, 1)
    child.cmd('split')
    local resize_state = child.get_resize_state()

    -- Check if we have a column layout
    local win_id_upper = resize_state.windows[1]
    local win_id_lower = resize_state.windows[2]

    validate_win_layout({
        'col',
        { { 'leaf', win_id_upper }, { 'leaf', win_id_lower } },
    })

    eq(win_id_upper, child.api.nvim_get_current_win())

    -- Both windows should have the same buffer
    eq(resize_state.buffer[win_id_upper], resize_state.buffer[win_id_lower])

    -- Check dimensions
    validate_win_dims(win_id_upper, { 80, 15 })
    validate_win_dims(win_id_lower, { 80, 7 })

    -- Check if the window has been centered on line 15
    eq(child.fn.line('w0', win_id_lower), 11)
    eq(child.fn.line('w$', win_id_lower), 17)

    -- Switch windows
    child.cmd('wincmd w')

    -- Check dimensions after switching windows
    validate_win_dims(win_id_upper, { 80, 7 })
    validate_win_dims(win_id_lower, { 80, 15 })

    -- Check if the window has been centered on line 15
    eq(child.fn.line('w0', win_id_upper), 11)
    eq(child.fn.line('w$', win_id_upper), 17)
end

T['autoresize']['split height'] = function()
    reload_module({ autoresize = { height = 18 } })
    edit(lorem_ipsum_file)
    child.set_cursor(15, 1)
    child.cmd('split')
    local resize_state = child.get_resize_state()

    -- Check if we have a column layout
    local win_id_upper = resize_state.windows[1]
    local win_id_lower = resize_state.windows[2]

    eq(win_id_upper, child.api.nvim_get_current_win())

    -- Check dimensions
    validate_win_dims(win_id_upper, { 80, 18 })
    validate_win_dims(win_id_lower, { 80, 4 })
end

T['autoresize']['split minheight'] = function()
    reload_module({ autoresize = { height = 20, minheight = 10 } })
    edit(lorem_ipsum_file)
    child.set_cursor(15, 1)
    child.cmd('split')
    local resize_state = child.get_resize_state()

    -- Check if we have a column layout
    local win_id_upper = resize_state.windows[1]
    local win_id_lower = resize_state.windows[2]

    eq(win_id_upper, child.api.nvim_get_current_win())

    -- Check dimensions
    validate_win_dims(win_id_upper, { 80, 12 })
    validate_win_dims(win_id_lower, { 80, 10 })
end

T['autoresize']['vsplit'] = function()
    edit(lorem_ipsum_file)
    child.set_cursor(15, 1)
    child.cmd('vsplit')
    local resize_state = child.get_resize_state()

    -- Check if we have a column layout
    local win_id_left = resize_state.windows[1]
    local win_id_right = resize_state.windows[2]

    validate_win_layout({
        'row',
        { { 'leaf', win_id_left }, { 'leaf', win_id_right } },
    })

    eq(win_id_left, child.api.nvim_get_current_win())

    -- Both windows should have the same buffer
    eq(resize_state.buffer[win_id_left], resize_state.buffer[win_id_right])

    -- Check dimensions
    validate_win_dims(win_id_left, { 49, 23 })
    validate_win_dims(win_id_right, { 30, 23 })

    eq(child.fn.line('w0', win_id_left), 1)
    eq(child.fn.line('w$', win_id_left), 23)

    eq(child.fn.line('w0', win_id_right), 1)
    eq(child.fn.line('w$', win_id_right), 23)

    -- Switch windows
    child.cmd('wincmd w')

    -- Check dimensions after switching windows
    validate_win_dims(win_id_left, { 30, 23 })
    validate_win_dims(win_id_right, { 49, 23 })
end

T['autoresize']['vsplit width'] = function()
    reload_module({ autoresize = { width = 50 } })
    edit(lorem_ipsum_file)
    child.set_cursor(15, 1)
    child.cmd('vsplit')
    local resize_state = child.get_resize_state()

    -- Check if we have a column layout
    local win_id_left = resize_state.windows[1]
    local win_id_right = resize_state.windows[2]

    eq(win_id_left, child.api.nvim_get_current_win())

    -- Check dimensions
    validate_win_dims(win_id_left, { 50, 23 })
    validate_win_dims(win_id_right, { 29, 23 })
end

T['autoresize']['vsplit minwidth'] = function()
    reload_module({ autoresize = { width = 70, minwidth = 30 } })
    edit(lorem_ipsum_file)
    child.set_cursor(15, 1)
    child.cmd('vsplit')
    local resize_state = child.get_resize_state()

    -- Check if we have a column layout
    local win_id_left = resize_state.windows[1]
    local win_id_right = resize_state.windows[2]

    eq(win_id_left, child.api.nvim_get_current_win())

    -- Check dimensions
    validate_win_dims(win_id_left, { 49, 23 })
    validate_win_dims(win_id_right, { 30, 23 })
end

-- focused minwidth for vertical splits
T['autoresize']['vsplit focusedwindow_minwidth'] = function()
    reload_module({ autoresize = { focusedwindow_minwidth = 55 } })
    edit(lorem_ipsum_file)
    child.set_cursor(15, 1)
    child.cmd('vsplit')
    local resize_state = child.get_resize_state()
    local win_id_left = resize_state.windows[1]
    local win_id_right = resize_state.windows[2]

    eq(win_id_left, child.api.nvim_get_current_win())

    -- Expect the left window's width to be at least 55.
    -- In the default test, the left width is 49.
    -- With forced focusedwindow_minwidth, we now expect 55.
    validate_win_dims(win_id_left, { 55, 23 })
    -- The right window should take the remaining width
    validate_win_dims(win_id_right, { 24, 23 })
end

-- focused minwidth for vertical splits inferior to the default one obtained by
-- the golden ratio
T['autoresize']['vsplit focusedwindow_minwidth < golden_ratio expected value'] = function()
    reload_module({ autoresize = { focusedwindow_minwidth = 40 } })
    edit(lorem_ipsum_file)
    child.set_cursor(15, 1)
    child.cmd('vsplit')
    local resize_state = child.get_resize_state()
    local win_id_left = resize_state.windows[1]
    local win_id_right = resize_state.windows[2]

    eq(win_id_left, child.api.nvim_get_current_win())

    -- The expected value is the golden ratio one
    validate_win_dims(win_id_left, { 49, 23 })
    -- The right window should take the remaining width
    validate_win_dims(win_id_right, { 30, 23 })
end

-- focused minheight for horizontal splits
T['autoresize']['split focusedwindow_minheight'] = function()
    reload_module({ autoresize = { focusedwindow_minheight = 17 } })
    edit(lorem_ipsum_file)
    child.set_cursor(15, 1)
    child.cmd('split')
    local resize_state = child.get_resize_state()
    local win_id_upper = resize_state.windows[1]
    local win_id_lower = resize_state.windows[2]

    -- In the default test, the upper window height is 15.
    -- With forced focusedwindow_minheight, we now expect 17.
    validate_win_dims(win_id_upper, { 80, 17 })
    -- The lower window gets the rest (assuming total height used equals 22)
    validate_win_dims(win_id_lower, { 80, 5 })
end

-- focused minheight for horizontal splits inferior to the default one obtained by
-- the golden ratio
T['autoresize']['split focusedwindow_minheight < golden_ratio expected value'] = function()
    reload_module({ autoresize = { focusedwindow_minheight = 10 } })
    edit(lorem_ipsum_file)
    child.set_cursor(15, 1)
    child.cmd('split')
    local resize_state = child.get_resize_state()
    local win_id_upper = resize_state.windows[1]
    local win_id_lower = resize_state.windows[2]

    -- The expected value is the golden ratio one
    validate_win_dims(win_id_upper, { 80, 15 })
    -- The lower window gets the rest
    validate_win_dims(win_id_lower, { 80, 7 })
end

-- focused minwidth for vertical splits with minwidth + focusedwindow_minwidth >
-- maxwidth.
T['autoresize']['vsplit minwidth focusedwindow_minwidth'] = function()
    reload_module({
        autoresize = { minwidth = 20, focusedwindow_minwidth = 80 },
    })
    edit(lorem_ipsum_file)
    child.set_cursor(15, 1)
    child.cmd('vsplit')
    local resize_state = child.get_resize_state()
    local win_id_left = resize_state.windows[1]
    local win_id_right = resize_state.windows[2]

    eq(win_id_left, child.api.nvim_get_current_win())

    -- Expect the left window's width to be at least the maxwidth (80) minus 21,
    -- 20 from the right window as the minimum width possible and 1 from the
    -- separator.
    -- With forced focusedwindow_minwidth, we now expect 59.
    validate_win_dims(win_id_left, { 78, 23 })
    -- The right window should have the minwidth.
    validate_win_dims(win_id_right, { 1, 23 })

    child.api.nvim_set_current_win(win_id_right)

    validate_win_dims(win_id_left, { 1, 23 })
    -- The right window should have the minwidth.
    validate_win_dims(win_id_right, { 78, 23 })
end

-- focused minheight for horizontal splits with minheight as 0
T['autoresize']['split minheight focusedwindow_minheight'] = function()
    reload_module({
        autoresize = { minheight = 10, focusedwindow_minheight = 25 },
    })
    edit(lorem_ipsum_file)
    child.set_cursor(15, 1)
    child.cmd('split')
    local resize_state = child.get_resize_state()
    local win_id_upper = resize_state.windows[1]
    local win_id_lower = resize_state.windows[2]

    -- Expect the upper window's height to be at least the maxheight (23) minus 2,
    -- 1 from the lower window as the minimum height and 1 from the separator.
    -- With forced focusedwindow_minheight, we now expect 21.
    validate_win_dims(win_id_upper, { 80, 21 })
    -- The lower window should have the minimum height.
    validate_win_dims(win_id_lower, { 80, 1 })
end

T['autoresize']['quickfix'] = function()
    reload_module({ autoresize = { height_quickfix = 10 } })
    child.cmd('vimgrep /ipsum/' .. lorem_ipsum_file)
    child.cmd('copen')

    local resize_state = child.get_resize_state()
    local win_id_upper = resize_state.windows[1]
    local win_id_lower = resize_state.windows[2]

    -- We should be in the quickfix window
    eq(win_id_lower, child.api.nvim_get_current_win())

    -- Check dimensions
    validate_win_dims(win_id_upper, { 80, 12 })
    validate_win_dims(win_id_lower, { 80, 10 })
end

T['autoresize']['terminal'] = function()
    -- create a new term split
    child.cmd('split')
    child.cmd('terminal')
    -- enter terminal insert mode
    child.cmd('startinsert!')

    -- Switch to the upper window
    -- Without pcall, this throws an error because `normal!` doesn't
    -- work from terminal mode.
    child.cmd('wincmd w')
end

T['autoresize']['maximize'] = function()
    reload_module({ autoresize = {} })
    child.cmd('vsplit')
    child.cmd('FocusMaximise')

    local resize_state = child.get_resize_state()
    local win_id_left = resize_state.windows[1]
    local win_id_right = resize_state.windows[2]

    -- we should be in the left win
    eq(win_id_left, child.api.nvim_get_current_win())

    -- let should take up the entire width, other than the winseparator (1 col)
    -- and numbercolumn (1 col)
    validate_win_dims(win_id_left, { 78, 23 })
    validate_win_dims(win_id_right, { 1, 23 })
end

T['autoresize']['maximize_minwidth'] = function()
    reload_module({ autoresize = {
        minwidth = 12,
    } })
    child.cmd('vsplit')
    child.cmd('FocusMaximise')

    local resize_state = child.get_resize_state()
    local win_id_left = resize_state.windows[1]
    local win_id_right = resize_state.windows[2]

    -- we should be in the left win
    eq(win_id_left, child.api.nvim_get_current_win())

    -- let should take up the entire width, other than the winseparator (1 col)
    -- and numbercolumn (1 col)
    validate_win_dims(win_id_left, { 67, 23 })
    validate_win_dims(win_id_right, { 12, 23 })
end

T['autoresize']['resize when switching resize goal (vsplit)'] = function()
    edit(lorem_ipsum_file)

    child.cmd('vsplit')
    child.cmd('FocusMaximise')

    local resize_state = child.get_resize_state()
    local win_id_left = resize_state.windows[1]
    local win_id_right = resize_state.windows[2]

    eq(win_id_left, child.api.nvim_get_current_win())

    -- validate maximized dimensions
    validate_win_dims(win_id_left, { 78, 23 })
    validate_win_dims(win_id_right, { 1, 23 })

    child.cmd('FocusAutoresize')

    -- we should still be in the left win
    eq(win_id_left, child.api.nvim_get_current_win())

    -- validate golden ratio dimensions
    validate_win_dims(win_id_left, { 49, 23 })
    validate_win_dims(win_id_right, { 30, 23 })

    child.api.nvim_win_close(win_id_right, true)

    child.cmd('split')
    child.cmd('FocusMaximise')
end

T['autoresize']['resize when switching resize goal (hsplit)'] = function()
    child.cmd('split')
    child.cmd('FocusMaximise')

    local resize_state = child.get_resize_state()
    local win_id_upper = resize_state.windows[1]
    local win_id_lower = resize_state.windows[2]

    validate_win_layout({
        'col',
        { { 'leaf', win_id_upper }, { 'leaf', win_id_lower } },
    })

    eq(win_id_upper, child.api.nvim_get_current_win())

    -- Both windows should have the same buffer
    eq(resize_state.buffer[win_id_upper], resize_state.buffer[win_id_lower])

    -- Check dimensions
    validate_win_dims(win_id_upper, { 80, 21 })
    validate_win_dims(win_id_lower, { 80, 1 })

    child.cmd('FocusAutoresize')

    -- we should still be in the left win
    eq(win_id_upper, child.api.nvim_get_current_win())

    -- Check dimensions after switching windows
    validate_win_dims(win_id_lower, { 80, 7 })
    validate_win_dims(win_id_upper, { 80, 15 })
end

T['autoresize']['golden ratio sizes (complex)'] = function()
    child.cmd('split')
    child.cmd('vsplit')
    child.cmd('FocusMaximise')

    local resize_state = child.get_resize_state()
    local win_id_upper_left = resize_state.windows[1]
    local win_id_upper_right = resize_state.windows[2]
    local win_id_lower = resize_state.windows[3]

    validate_win_layout({
        'col',
        {
            {
                'row',
                {
                    { 'leaf', win_id_upper_left },
                    { 'leaf', win_id_upper_right },
                },
            },
            { 'leaf', win_id_lower },
        },
    })

    eq(win_id_upper_left, child.api.nvim_get_current_win())

    -- validate maximized dimensions
    validate_win_dims(win_id_upper_left, { 78, 21 })
    validate_win_dims(win_id_upper_right, { 1, 21 })
    validate_win_dims(win_id_lower, { 80, 1 })

    child.cmd('FocusAutoresize')

    -- should still be in the upper left win
    eq(win_id_upper_left, child.api.nvim_get_current_win())

    -- the windows should be resized based on golden ratio
    validate_win_dims(win_id_upper_left, { 49, 15 })
    validate_win_dims(win_id_upper_right, { 30, 15 })
    validate_win_dims(win_id_lower, { 80, 7 })
end

T['autoresize']['does not modify cmdheight'] = function()
    child.o.cmdheight = 1

    child.cmd('FocusMaximise')

    child.cmd('vsplit')

    child.cmd('FocusAutoresize')

    eq(child.o.cmdheight, 1)
end

T['autoresize']['does not resize floating windows'] = function()
    local win_id = child.api.nvim_open_win(0, false, {
        relative = 'editor',
        row = 1,
        col = 1,
        width = 10,
        height = 10,
        style = 'minimal',
    })

    child.api.nvim_set_current_win(win_id)

    eq(child.api.nvim_win_get_width(win_id), 10)
    eq(child.api.nvim_win_get_height(win_id), 10)

    child.cmd('FocusAutoresize')

    eq(child.api.nvim_win_get_width(win_id), 10)
    eq(child.api.nvim_win_get_height(win_id), 10)

    child.cmd('FocusMaximise')

    eq(child.api.nvim_win_get_width(win_id), 10)
    eq(child.api.nvim_win_get_height(win_id), 10)
end

return T
