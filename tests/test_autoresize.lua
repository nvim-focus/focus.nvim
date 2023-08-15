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
    eq(child.fn.line('w0', win_id_lower), 12)
    eq(child.fn.line('w$', win_id_lower), 18)

    -- Switch windows
    child.cmd('wincmd w')

    -- Check dimensions after switching windows
    validate_win_dims(win_id_upper, { 80, 7 })
    validate_win_dims(win_id_lower, { 80, 15 })

    -- Check if the window has been centered on line 15
    eq(child.fn.line('w0', win_id_upper), 12)
    eq(child.fn.line('w$', win_id_upper), 18)
end

T['autoresize']['disabled'] = function()
    reload_module({ autoresize = { enable = false } })

    eq(child.lua_get('_G.Focus.config.autoresize.enable'), false)

    edit(lorem_ipsum_file)
    child.cmd('split')
    local resize_state = child.get_resize_state()

    -- Check if we have a column layout
    local win_id_upper = resize_state.windows[1]
    local win_id_lower = resize_state.windows[2]

    validate_win_layout({
        'col',
        { { 'leaf', win_id_upper }, { 'leaf', win_id_lower } },
    })

    -- Check if dimensions are equal
    validate_win_dims(win_id_upper, { 80, 11 })
    validate_win_dims(win_id_lower, { 80, 11 })
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

return T
