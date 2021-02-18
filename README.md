# Auto-resizing Focused Splits/Windows for Neovim

🔋 Batteries Included. No configuration neccessary

👌 Maximises Current Split/Window Automatically When Cursor Moves

⚙️  Set Focus Split/Window Width, Height, Cursorline & Active/Inactive Win-Highlight + Disable

🙌 Compatible with NvimTree, NerdTree, CHADTree & QuickFix (QF default to 10, rest won't resize)

# Demo

![screencast](https://i.ibb.co/0tsKww4/focusop.gif)

## Installation
#### [vim-plug](https://github.com/junegunn/vim-plug)
```vim
Plug 'beauwilliams/focus.nvim'
```
#### [packer.nvim](https://github.com/wbthomason/packer.nvim)
```lua
use 'beauwilliams/focus.nvim'
```

## Commands

| _Command_      | _Description_ |
| -------------- | ------------- |
| `DisableFocus` |  Disable the plugin entirely, but for now it has to be run before creating any splits |

## Configuration

Place some version of this in your configuration file, e.g. `init.lua`, etc.


**Set Focus Width (Default to 120 px)**
```lua
local focus = require('focus')

-- Completely disable this plugin
-- default: true
focus.enable = true

-- Width for the focused window, other windows resized accordingly
-- default: 120
focus.width = 120

**Set Focus Height (By default disabled)**
```lua
-- place me somewhere in your init.lua
local focus = require('focus')
-- Height for the focused window
-- default: 0
focus.height = 40

-- Turn on the cursorline in the focused window, turn it off in unfocused windows
-- default: true
focus.cursorline = true

-- Highlight the focused window differently than unfocused windows, see `:h winhighlight`
-- default: false
focus.winhighlight = true

-- By default, the highlight groups are setup as such:
--   hi default link FocusedWindow VertSplit
--   hi default link UnfocusedWindow Normal
-- To change them, you can link them to a different highlight group, see `:h hi-default` for more info.
vim.cmd('hi link UnfocusedWindow CursorLine')
vim.cmd('hi link FocusedWindow VisualNOS')
```
**Set Focus Auto-Cursorline (By default enabled)**
```lua
-- place me somewhere in your init.lua
local focus = require('focus')
focus.cursorline = true
```
**Set Focus Window Highlighting (By default disabled)**
```lua
-- place me somewhere in your init.lua
local focus = require('focus')
focus.winhighlight = false
```



## Planned Improvements 😼

- [ ] Refactoring
- [ ] Adding `:h filetype` support as we go
- [ ] Decide default width as per feedback (I like 120)
- [x] Perhaps some other configs, maybe height?
