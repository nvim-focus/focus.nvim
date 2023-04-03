-- Add project root as full path to runtime path (in order to be able to
-- `require()`) modules from this module
local cwd = vim.fn.getcwd()

vim.opt.runtimepath:prepend(string.format('%s/tests/mini.test,%s', cwd, cwd))
