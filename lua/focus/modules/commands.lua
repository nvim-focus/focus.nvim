local M = {}

M.commands = {
    FocusDisable = {
        function()
            require('focus').focus_disable()
        end,
        { nargs = 0 },
    },
    FocusEnable = {
        function()
            require('focus').focus_enable()
        end,
        { nargs = 0 },
    },
    FocusToggle = {
        function()
            require('focus').focus_toggle()
        end,
        { nargs = 0 },
    },
    FocusDisableWindow = {
        function()
            require('focus').focus_disable_window()
        end,
        { nargs = 0 },
    },
    FocusEnableWindow = {
        function()
            require('focus').focus_enable_window()
        end,
        { nargs = 0 },
    },
    FocusToggleWindow = {
        function()
            require('focus').focus_toggle_window()
        end,
        { nargs = 0 },
    },
    FocusEqualise = {
        function()
            require('focus').focus_equalise()
        end,
        { nargs = 0 },
    },
    FocusMaximise = {
        function()
            require('focus').focus_maximise()
        end,
        { nargs = 0 },
    },
    FocusMaxOrEqual = {
        function()
            require('focus').focus_max_or_equal()
        end,
        { nargs = 0 },
    },
    FocusAutoresize = {
        function()
            require('focus').focus_autoresize()
        end,
        { nargs = 0 },
    },
    FocusSplitNicely = {
        function(obj)
            require('focus').split_nicely(obj.args)
        end,
        { nargs = '?', complete = 'file' },
    },
    FocusSplitCycle = {
        function(obj)
            require('focus').split_cycle(obj.args)
        end,
        { nargs = '?' },
    },
    FocusSplitLeft = {
        function(obj)
            require('focus').split_command('h', obj.args)
        end,
        { nargs = '?', complete = 'file' },
    },
    FocusSplitDown = {
        function(obj)
            require('focus').split_command('j', obj.args)
        end,
        { nargs = '?', complete = 'file' },
    },
    FocusSplitUp = {
        function(obj)
            require('focus').split_command('k', obj.args)
        end,
        { nargs = '?', complete = 'file' },
    },
    FocusSplitRight = {
        function(obj)
            require('focus').split_command('l', obj.args)
        end,
        { nargs = '?', complete = 'file' },
    },
}

M.setup = function()
    for name, def in pairs(M.commands) do
        vim.api.nvim_create_user_command(name, def[1], def[2])
    end
end

return M
