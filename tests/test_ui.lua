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
T['focus_ui'] = new_set()

local lorem_ipsum_file = make_path(testdata_dir, 'loremipsum.txt')

T['focus_ui']['number'] = function()
    reload_module({ ui = { number = true } })
    edit(lorem_ipsum_file)

    child.expect_screenshot()
end

T['focus_ui']['number with split'] = function()
    reload_module({ ui = { number = true } })
    edit(lorem_ipsum_file)
    child.set_cursor(15, 0)
    child.cmd('vsplit')

    local resize_state = child.get_resize_state()
    local win_id_left = resize_state.windows[1]
    local win_id_right = resize_state.windows[2]

    eq(win_id_left, child.api.nvim_get_current_win())
    eq(child.wo.number, true)
    eq(child.wo.relativenumber, false)

    child.lua([[_G.win_get_number = function(winid)
        local win_number = false

        vim.api.nvim_win_call(winid, function()
           win_number = vim.wo.number
        end)

        return win_number
    end]])

    eq(
        child.lua_get(string.format('_G.win_get_number(%d)', win_id_right)),
        false
    )
end

T['focus_ui']['relativenumber'] = function()
    reload_module({ ui = { relativenumber = true } })
    edit(lorem_ipsum_file)
    child.set_cursor(15, 0)

    child.expect_screenshot()
end

T['focus_ui']['relativenumber with split'] = function()
    reload_module({ ui = { relativenumber = true } })
    edit(lorem_ipsum_file)
    child.set_cursor(15, 0)
    child.cmd('vsplit')

    local resize_state = child.get_resize_state()
    local win_id_left = resize_state.windows[1]
    local win_id_right = resize_state.windows[2]

    eq(win_id_left, child.api.nvim_get_current_win())
    eq(child.wo.number, false)
    eq(child.wo.relativenumber, true)

    child.lua([[_G.win_get_relativenumber = function(winid)
        local win_relativenumber = false

        vim.api.nvim_win_call(winid, function()
           win_relativenumber = vim.wo.relativenumber
        end)

        return win_relativenumber
    end]])

    eq(
        child.lua_get(
            string.format('_G.win_get_relativenumber(%d)', win_id_right)
        ),
        false
    )
end

T['focus_ui']['relativenumber and absolutenumber_unfocussed with split'] = function(
)
    reload_module({
        ui = { relativenumber = true, absolutenumber_unfocussed = true },
    })
    edit(lorem_ipsum_file)
    child.set_cursor(15, 0)
    child.cmd('vsplit')

    local resize_state = child.get_resize_state()
    local win_id_left = resize_state.windows[1]
    local win_id_right = resize_state.windows[2]

    eq(win_id_left, child.api.nvim_get_current_win())
    eq(child.wo.number, false)
    eq(child.wo.relativenumber, true)

    child.lua([[_G.win_get_relativenumber = function(winid)
        local win_relativenumber = false

        vim.api.nvim_win_call(winid, function()
           win_relativenumber = vim.wo.relativenumber
        end)

        return win_relativenumber
    end]])

    eq(
        child.lua_get(
            string.format('_G.win_get_relativenumber(%d)', win_id_right)
        ),
        false
    )

    child.lua([[_G.win_get_number = function(winid)
        local win_number = false

        vim.api.nvim_win_call(winid, function()
           win_number = vim.wo.number
        end)

        return win_number
    end]])

    eq(
        child.lua_get(string.format('_G.win_get_number(%d)', win_id_right)),
        true
    )
end

T['focus_ui']['hybridnumber'] = function()
    reload_module({ ui = { hybridnumber = true } })
    edit(lorem_ipsum_file)
    child.set_cursor(15, 0)

    child.expect_screenshot()
end

T['focus_ui']['hybridnumber with split'] = function()
    reload_module({ ui = { hybridnumber = true } })
    edit(lorem_ipsum_file)
    child.set_cursor(15, 0)
    child.cmd('vsplit')

    local resize_state = child.get_resize_state()
    local win_id_left = resize_state.windows[1]
    local win_id_right = resize_state.windows[2]

    eq(win_id_left, child.api.nvim_get_current_win())
    eq(child.wo.number, true)
    eq(child.wo.relativenumber, true)

    child.lua([[_G.win_get_number = function(winid)
        local win_number = false

        vim.api.nvim_win_call(winid, function()
           win_number = vim.wo.number
        end)

        return win_number
    end]])

    eq(
        child.lua_get(string.format('_G.win_get_number(%d)', win_id_right)),
        false
    )
    child.lua([[_G.win_get_relativenumber = function(winid)
        local win_relativenumber = false

        vim.api.nvim_win_call(winid, function()
           win_relativenumber = vim.wo.relativenumber
        end)

        return win_relativenumber
    end]])

    eq(
        child.lua_get(
            string.format('_G.win_get_relativenumber(%d)', win_id_right)
        ),
        false
    )
end

T['focus_ui']['hybridnumber and absolutenumber_unfocussed with split'] = function(
)
    reload_module({
        ui = { hybridnumber = true, absolutenumber_unfocussed = true },
    })
    edit(lorem_ipsum_file)
    child.set_cursor(15, 0)
    child.cmd('vsplit')

    local resize_state = child.get_resize_state()
    local win_id_left = resize_state.windows[1]
    local win_id_right = resize_state.windows[2]

    eq(win_id_left, child.api.nvim_get_current_win())
    eq(child.wo.number, true)
    eq(child.wo.relativenumber, true)

    child.lua([[_G.win_get_number = function(winid)
        local win_number = false

        vim.api.nvim_win_call(winid, function()
           win_number = vim.wo.number
        end)

        return win_number
    end]])

    eq(
        child.lua_get(string.format('_G.win_get_number(%d)', win_id_right)),
        true
    )
    child.lua([[_G.win_get_relativenumber = function(winid)
        local win_relativenumber = false

        vim.api.nvim_win_call(winid, function()
           win_relativenumber = vim.wo.relativenumber
        end)

        return win_relativenumber
    end]])

    eq(
        child.lua_get(
            string.format('_G.win_get_relativenumber(%d)', win_id_right)
        ),
        false
    )
end

T['focus_ui']['signcolumn with split'] = function()
    reload_module({ ui = { signcolumn = true } })
    edit(lorem_ipsum_file)
    child.set_cursor(15, 0)
    child.cmd('vsplit')

    local resize_state = child.get_resize_state()
    local win_id_left = resize_state.windows[1]
    local win_id_right = resize_state.windows[2]

    eq(win_id_left, child.api.nvim_get_current_win())
    eq(child.wo.signcolumn, 'auto')

    child.lua([[_G.win_get_signcolumn = function(winid)
        local win_signcolumn = ''

        vim.api.nvim_win_call(winid, function()
           win_signcolumn = vim.wo.signcolumn
        end)

        return win_signcolumn
    end]])

    eq(
        child.lua_get(string.format('_G.win_get_signcolumn(%d)', win_id_right)),
        'no'
    )
end

T['focus_ui']['cursorcolumn with split'] = function()
    reload_module({ ui = { cursorcolumn = true } })
    edit(lorem_ipsum_file)
    child.set_cursor(15, 0)
    child.cmd('vsplit')

    local resize_state = child.get_resize_state()
    local win_id_left = resize_state.windows[1]
    local win_id_right = resize_state.windows[2]

    eq(win_id_left, child.api.nvim_get_current_win())
    eq(child.wo.cursorcolumn, true)

    child.lua([[_G.win_get_cursorcolumn = function(winid)
        local win_cursorcolumn = {}

        vim.api.nvim_win_call(winid, function()
           win_cursorcolumn = vim.wo.cursorcolumn
        end)

        return win_cursorcolumn
    end]])

    eq(
        child.lua_get(
            string.format('_G.win_get_cursorcolumn(%d)', win_id_right)
        ),
        false
    )
end

T['focus_ui']['colorcolumn with split'] = function()
    reload_module({ ui = { colorcolumn = { enable = true } } })
    edit(lorem_ipsum_file)
    child.set_cursor(15, 0)
    child.cmd('vsplit')

    local resize_state = child.get_resize_state()
    local win_id_left = resize_state.windows[1]
    local win_id_right = resize_state.windows[2]

    eq(win_id_left, child.api.nvim_get_current_win())
    eq(child.wo.colorcolumn, '+1')

    child.lua([[_G.win_get_colorcolumn = function(winid)
        local win_colorcolumn = ''

        vim.api.nvim_win_call(winid, function()
           win_colorcolumn = vim.wo.colorcolumn
        end)

        return win_colorcolumn
    end]])

    eq(
        child.lua_get(string.format('_G.win_get_colorcolumn(%d)', win_id_right)),
        ''
    )
end

-- TODO: The test here works but testing it with real neovim doesn't do
-- anything.
T['focus_ui']['winhighlight with split'] = function()
    reload_module({ ui = { winhighlight = true } })
    edit(lorem_ipsum_file)
    child.set_cursor(15, 0)
    child.cmd('vsplit')

    local resize_state = child.get_resize_state()
    local win_id_left = resize_state.windows[1]
    local win_id_right = resize_state.windows[2]

    eq(win_id_left, child.api.nvim_get_current_win())
    eq(child.wo.winhighlight, 'Normal:FocusedWindow,NormalNC:UnfocusedWindow')

    child.lua([[_G.win_get_colorcolumn = function(winid)
        local win_colorcolumn = ''

        vim.api.nvim_win_call(winid, function()
           win_colorcolumn = vim.wo.colorcolumn
        end)

        return win_colorcolumn
    end]])

    eq(
        child.lua_get(string.format('_G.win_get_colorcolumn(%d)', win_id_right)),
        ''
    )
end

return T
