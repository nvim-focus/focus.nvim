local api = vim.api
local cmd = api.nvim_command
local autocmd = {}

local function nvim_create_augroups(definitions)
  for group_name, definition in pairs(definitions) do
    cmd('augroup '..group_name)
    cmd('autocmd!')
    for _, def in ipairs(definition) do
      local command = table.concat(vim.tbl_flatten{'autocmd', def}, ' ')
      cmd(command)
    end
    cmd('augroup END')
  end
end

function autocmd.setup(width)
  local definitions = {
    autocmds = {
      { 'WinEnter', '*', 'lua require \'modules.resizer\'.split_resizer('..width..')'},
      { 'WinEnter', '*', 'setlocal cursorline'},
      { 'WinEnter', '*', 'setlocal signcolumn=no'},
      { 'WinLeave', '*', 'setlocal nocursorline'},
  };
  }

  nvim_create_augroups(definitions)
end


return autocmd

