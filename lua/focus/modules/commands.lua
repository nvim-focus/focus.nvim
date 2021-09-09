local vim = vim
local commands = {}

commands.setup = function()
	vim.cmd([[
command! -nargs=0 DisableFocus echo "Deprecated -> Use :FocusDisable"
command! -nargs=0 EnableFocus echo "Deprecated -> Use :FocusEnable"
command! -nargs=0 ToggleFocus echo "Deprecated -> Use :FocusToggle"


"Export commands so we can do :DisableFocus etc
command! -nargs=0 FocusDisable lua require('focus').focus_disable()
command! -nargs=0 FocusEnable lua require('focus').focus_enable()
command! -nargs=0 FocusToggle lua require('focus').focus_toggle()
command! -nargs=0 FocusSplitNicely lua require('focus').split_nicely()
command! -nargs=? FocusSplitLeft lua require('focus').split_command("h", <q-args>)
command! -nargs=? FocusSplitDown lua require('focus').split_command("j", <q-args>)
command! -nargs=? FocusSplitUp lua require('focus').split_command("k", <q-args>)
command! -nargs=? FocusSplitRight lua require('focus').split_command("l", <q-args>)
]])
end

return commands
