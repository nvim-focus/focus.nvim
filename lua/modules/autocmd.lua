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

function autocmd.setup(width,height)
  local definitions = {
    autocmds = {
      { 'BufEnter', '*', 'lua require \'modules.resizer\'.split_resizer('..width..','..height..')'},
      { 'BufEnter', '*', 'setlocal cursorline'},
      { 'BufEnter', '*', 'setlocal signcolumn=no'},
      { 'BufLeave', '*', 'setlocal nocursorline'},
  };
  }

  nvim_create_augroups(definitions)
end


return autocmd

