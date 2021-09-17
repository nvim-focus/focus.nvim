local vim = vim
local M = {}

M.setup = function()
	vim.cmd([[
command! -nargs=0 FocusDisable lua require('focus').focus_disable()
command! -nargs=0 FocusEnable lua require('focus').focus_enable()
command! -nargs=0 FocusToggle lua require('focus').focus_toggle()
command! -nargs=0 FocusEqualise lua require('focus').focus_equalise()
command! -nargs=0 FocusMaximise lua require('focus').focus_maximise()
command! -nargs=0 FocusMaxOrEqual lua require('focus').focus_max_or_equal()
command! -nargs=? FocusSplitNicely lua require('focus').split_nicely(<q-args>)
command! -nargs=? FocusSplitCycle lua require('focus').split_cycle(<q-args>)
command! -nargs=? FocusSplitLeft lua require('focus').split_command("h", <q-args>)
command! -nargs=? FocusSplitDown lua require('focus').split_command("j", <q-args>)
command! -nargs=? FocusSplitUp lua require('focus').split_command("k", <q-args>)
command! -nargs=? FocusSplitRight lua require('focus').split_command("l", <q-args>)
]])
end

return M
