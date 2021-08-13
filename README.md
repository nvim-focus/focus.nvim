[![GitHub stars](https://img.shields.io/github/stars/beauwilliams/focus.nvim.svg?style=social&label=Star&maxAge=2592000)](https://GitHub.com/beauwilliams/focus.nvim/stargazers/)
[![Requires](https://img.shields.io/badge/requires-nvim%200.5%2B-9cf?logo=neovim)](https://neovim.io//)
[![GitHub contributors](https://img.shields.io/github/contributors/beauwilliams/focus.nvim.svg)](https://GitHub.com/beauwilliams/focus.nvim/graphs/contributors/)
[![GitHub issues](https://img.shields.io/github/issues/beauwilliams/focus.nvim.svg)](https://GitHub.com/beauwilliams/focus.nvim/issues/)
[![GitHub issues-closed](https://img.shields.io/github/issues-closed/beauwilliams/focus.nvim.svg)](https://GitHub.com/beauwilliams/focus.nvim/issues?q=is%3Aissue+is%3Aclosed)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com)



# Auto-resizing Focused Splits/Windows for Neovim

🔋 Batteries Included. No configuration neccessary

👌 Maximises Current Split/Window Automatically When Cursor Moves Based On Golden Ratio

⚙️  Set Focus Auto-Cursorline/SignColumn/LineNums & Active/Inactive Win-Highlight + Disable

🙌 Compatible with NvimTree, NerdTree, CHADTree, Telescope, FZF & QuickFix (QF default to 10, rest won't resize)

👁️  Currently focussed split/window automagically maximised to the perfect viewing size according to golden ratio

🏃 Move to existing or else create new splits based on direction with only a single command for each direction

# Demo

![screencast](https://i.ibb.co/0tsKww4/focusop.gif)

*note: for reference this screencast features dimensions set to 120\*40 (W\*H)*

[See a visual demonstration of each focus feature here](https://github.com/beauwilliams/focus.nvim/blob/master/demo.md)


## Installation
#### [vim-plug](https://github.com/junegunn/vim-plug)
```vim
Plug 'beauwilliams/focus.nvim'
```
#### [packer.nvim](https://github.com/wbthomason/packer.nvim)
```lua
use 'beauwilliams/focus.nvim'
```

## Vim Commands

*For more information on below commands scroll down to see them each described in more detail*
| _Command_      | _Description_ |
| -------------- | ------------- |
| `:FocusDisable` |  Disable the plugin per session. Splits will be normalised back to defaults and then spaced evenly. |
| `:FocusEnable` |  Enable the plugin per session. Splits will be resized back to your configs or defaults if not set. |
| `:FocusToggle` |  Toggle focus on and off again. |
| `:FocusSplitNicely` | Split a window based on the golden ratio rule |
| `:FocusSplitLeft` | Move to existing or create a new split to the left of your current window |
| `:FocusSplitDown` | Move to existing or create a new split to the bottom of your current window |
| `:FocusSplitUp` | Move to existing or create a new split to the top of your current window |
| `:FocusSplitRight` | Move to existing or create a new split to the right of your current window |

## Splitting Nicely

Focus allows you to split windows to tiled windows nicely and sized according to the golden ratio

```
+----------------+------------+
|                |    S1      |
|                |            |
|                +------------+
|                |            |
|   MAIN PANE    |    S2      |
|                |            |
|                |            |
|                |            |
+----------------+------------+
```

To get this view you would press the key combination 2 times.

**Split nicely with `<C-L>`**

```lua
vim.api.nvim_set_keymap('n', '<c-l>', ':FocusSplitNicely<CR>', { silent = true })
```

## Auto Splitting Directionally

Instead of worrying about multiple commands and shortcuts, simply think about splits as to which direction you would like to go

Calling a focus split command i.e :FocusSplitRight will do one of two things, firstly it will attempt to move across to the window in the specified direction.
Otherwise, if no window exists in the specified direction relative to the current window then it will instead create a new blank buffer window in the direction specified,
and then move to that window.

*Recommended commands, leverage hjkl to move and create your splits directionally with ease*
```lua
vim.api.nvim_set_keymap('n', '<leader>h', ':FocusSplitLeft<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>j', ':FocusSplitDown<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>k', ':FocusSplitUp<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>l', ':FocusSplitRight<CR>', { silent = true })
```




## Configuration

Place some version of this in your configuration file, e.g. `init.lua`, etc.

**NOTE:** If for example your screen resolution is *1024x768* --> i.e on the smaller side, you may notice that focus by default can maximise a window *too much*.
That is, the window will sort of 'crush' some of your other splits due to the limited screen real estate. This is not an issue with focus,
but an issue with minimal screen real estate. In this case, you can simply reduce the width/height of focus by following the below instructions to set them.


**Enable/Disable Focus**
```lua
local focus = require('focus')
-- Completely disable this plugin
-- Default: true
focus.enable = false
```

**Set Focus Width**
```lua
local focus = require('focus')
-- Force width for the focused window
-- Default: Calculated based on golden ratio
focus.width = 120
```

**Set Focus Height**
```lua
local focus = require('focus')
-- Force height for the focused window
-- Default: Calculated based on golden ratio
focus.height = 40
```

**Set Focus Tree Width**
```lua
local focus = require('focus')
-- Sets the width of directory tree buffers such as NerdTree, NvimTree and CHADTree
-- Default: vim.g.nvim_tree_width or 30
focus.treewidth = 20
```

**Set Focus Auto Cursorline**
```lua
local focus = require('focus')
-- Displays a cursorline in the focussed window only
-- Not displayed in unfocussed windows
-- Default: true
focus.cursorline = false
```

**Set Focus Auto Sign Column**
```lua
local focus = require('focus')
-- Displays a sign column in the focussed window only
-- Not displayed in unfocussed windows
-- Default: true
focus.signcolumn = false
```

**Set Focus Auto Numbers**
```lua
local focus = require('focus')
-- Displays line numbers in the focussed window only
-- Not displayed in unfocussed windows
-- Default: true
focus.number = false
```

**Set Focus Auto Relative Numbers**
```lua
local focus = require('focus')
-- Displays relative line numbers in the focussed window only
-- Not displayed in unfocussed windows
-- See :h relativenumber
-- Default: false
focus.relativenumber = true
```

**Set Focus Auto Hybrid Numbers**
```lua
local focus = require('focus')
-- Displays hybrid line numbers in the focussed window only
-- Not displayed in unfocussed windows
-- Combination of :h relativenumber, but also displays the line number of the current line only
-- Default: false
focus.hybridnumber = true
```

**Set Focus Window Highlighting**
```lua
local focus = require('focus')
-- Enable auto highlighting for focussed/unfocussed windows
-- Default: false
focus.winhighlight = true

-- By default, the highlight groups are setup as such:
--   hi default link FocusedWindow VertSplit
--   hi default link UnfocusedWindow Normal
-- To change them, you can link them to a different highlight group, see `:h hi-default` for more info.
vim.cmd('hi link UnfocusedWindow CursorLine')
vim.cmd('hi link FocusedWindow VisualNOS')
```


## Planned Improvements 😼

- [ ] Refactoring
- [ ] Adding `:h filetype` support as we go
- [x] Adding Auto Line Numbers, options for relative,norelative
