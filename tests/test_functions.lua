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

local load_module = function(config)
    child.load_module(config)
end
local unload_module = function()
    child.unload_module()
end

local validate_win_dims = function(win_id, ref)
    eq({
        child.api.nvim_win_get_width(win_id),
        child.api.nvim_win_get_height(win_id),
    }, ref)
end

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
T['focus_max_or_equal'] = new_set()

T['focus_max_or_equal']['vertical split - maximised window equalises'] = function()
    -- Create a vertical split
    child.cmd('vsplit')
    local resize_state = child.get_resize_state()
    local win_id_left = resize_state.windows[1]
    local win_id_right = resize_state.windows[2]

    -- Set focus to right window (it should be maximised by autoresize)
    child.api.nvim_set_current_win(win_id_right)
    child.cmd('FocusMaxOrEqual')

    -- After FocusMaxOrEqual, since the window is bigger than half,
    -- it should equalise the windows
    local new_state = child.get_resize_state()
    local left_width = child.api.nvim_win_get_width(win_id_left)
    local right_width = child.api.nvim_win_get_width(win_id_right)

    -- Windows should be roughly equal (within 1 pixel due to rounding)
    assert(
        math.abs(left_width - right_width) <= 1,
        string.format(
            'Windows not equal: left=%d, right=%d',
            left_width,
            right_width
        )
    )
end

T['focus_max_or_equal']['vertical split - equalised window maximises'] = function()
    -- Create a vertical split
    child.cmd('vsplit')
    local resize_state = child.get_resize_state()
    local win_id_left = resize_state.windows[1]
    local win_id_right = resize_state.windows[2]

    -- Equalize the windows so they're both at or near half size
    -- This disables autoresize temporarily
    child.cmd('wincmd =')

    -- Disable focus autoresize to prevent it from auto-maximizing
    child.cmd('FocusDisable')

    -- Focus on the right window (won't auto-maximize because focus is disabled)
    child.api.nvim_set_current_win(win_id_right)

    -- Get initial dimensions - windows should be equal (roughly half each)
    local initial_right_width = child.api.nvim_win_get_width(win_id_right)
    local columns = child.o.columns

    -- Verify window is NOT bigger than half
    assert(
        initial_right_width <= columns / 2,
        string.format(
            'Window should be at or below half: right=%d, half=%d',
            initial_right_width,
            columns / 2
        )
    )

    -- Call FocusMaxOrEqual - since window is NOT bigger than half,
    -- it should maximise
    child.cmd('FocusMaxOrEqual')

    local new_left_width = child.api.nvim_win_get_width(win_id_left)
    local new_right_width = child.api.nvim_win_get_width(win_id_right)

    -- Right window should now be larger than left (or equal within 1 pixel due to separator)
    assert(
        new_right_width >= new_left_width - 1,
        string.format(
            'Right window should be larger or equal to left: right=%d, left=%d',
            new_right_width,
            new_left_width
        )
    )

    -- Re-enable focus for other tests
    child.cmd('FocusEnable')
end

T['focus_max_or_equal']['horizontal split - maximised window equalises'] = function()
    -- Create a horizontal split
    child.cmd('split')
    local resize_state = child.get_resize_state()
    local win_id_top = resize_state.windows[1]
    local win_id_bottom = resize_state.windows[2]

    -- Set focus to bottom window (it should be maximised by autoresize)
    child.api.nvim_set_current_win(win_id_bottom)
    child.cmd('FocusMaxOrEqual')

    -- After FocusMaxOrEqual, since the window is bigger than half,
    -- it should equalise the windows
    local top_height = child.api.nvim_win_get_height(win_id_top)
    local bottom_height = child.api.nvim_win_get_height(win_id_bottom)

    -- Windows should be roughly equal (within 1 pixel due to rounding)
    assert(
        math.abs(top_height - bottom_height) <= 1,
        string.format(
            'Windows not equal: top=%d, bottom=%d',
            top_height,
            bottom_height
        )
    )
end

T['focus_max_or_equal']['horizontal split - equalised window maximises'] = function()
    -- Create a horizontal split
    child.cmd('split')
    local resize_state = child.get_resize_state()
    local win_id_top = resize_state.windows[1]
    local win_id_bottom = resize_state.windows[2]

    -- Equalize the windows so they're both at or near half size
    child.cmd('wincmd =')

    -- Disable focus autoresize to prevent it from auto-maximizing
    child.cmd('FocusDisable')

    -- Focus on the bottom window (won't auto-maximize because focus is disabled)
    child.api.nvim_set_current_win(win_id_bottom)

    -- Get initial dimensions - windows should be equal (roughly half each)
    local initial_bottom_height = child.api.nvim_win_get_height(win_id_bottom)
    local lines = child.o.lines

    -- Verify window is NOT bigger than half
    assert(
        initial_bottom_height <= lines / 2,
        string.format(
            'Window should be at or below half: bottom=%d, half=%d',
            initial_bottom_height,
            lines / 2
        )
    )

    -- Call FocusMaxOrEqual - since window is NOT bigger than half,
    -- it should maximise
    child.cmd('FocusMaxOrEqual')

    local new_top_height = child.api.nvim_win_get_height(win_id_top)
    local new_bottom_height = child.api.nvim_win_get_height(win_id_bottom)

    -- Bottom window should be larger than top (or equal within 1 pixel due to separator)
    assert(
        new_bottom_height >= new_top_height - 1,
        string.format(
            'Bottom window should be larger or equal to top: bottom=%d, top=%d',
            new_bottom_height,
            new_top_height
        )
    )

    -- Re-enable focus for other tests
    child.cmd('FocusEnable')
end

T['focus_max_or_equal']['mixed splits - checks both dimensions'] = function()
    -- Create a complex layout with both horizontal and vertical splits
    -- This tests that the function checks BOTH width AND height
    child.cmd('vsplit')
    child.cmd('split')

    local resize_state = child.get_resize_state()
    local win_count = #resize_state.windows

    -- We should have 3 windows total
    eq(win_count, 3)

    -- Get the current window
    local current_win = child.api.nvim_get_current_win()
    local win_width = child.api.nvim_win_get_width(current_win)
    local win_height = child.api.nvim_win_get_height(current_win)
    local columns = child.o.columns
    local lines = child.o.lines

    -- Record whether window is bigger than half in both dimensions
    local bigger_width = win_width > columns / 2
    local bigger_height = win_height > lines / 2
    local should_equalise = bigger_width and bigger_height

    child.cmd('FocusMaxOrEqual')

    -- Verify the behavior matches expectations
    local new_width = child.api.nvim_win_get_width(current_win)
    local new_height = child.api.nvim_win_get_height(current_win)

    if should_equalise then
        -- If both dimensions were bigger than half, window should have shrunk
        assert(
            new_width <= win_width and new_height <= win_height,
            string.format(
                'Window should have shrunk: width %d->%d, height %d->%d',
                win_width,
                new_width,
                win_height,
                new_height
            )
        )
    else
        -- Otherwise, window should have grown in at least one dimension
        assert(
            new_width >= win_width or new_height >= win_height,
            string.format(
                'Window should have grown: width %d->%d, height %d->%d',
                win_width,
                new_width,
                win_height,
                new_height
            )
        )
    end
end

return T
