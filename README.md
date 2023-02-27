[![GitHub stars](https://img.shields.io/github/stars/beauwilliams/focus.nvim.svg?style=social&label=Star)](https://GitHub.com/beauwilliams/focus.nvim/stargazers/)
[![Requires](https://img.shields.io/badge/requires-nvim%200.5%2B-9cf?logo=neovim)](https://neovim.io//)
[![GitHub contributors](https://img.shields.io/github/contributors/beauwilliams/focus.nvim.svg)](https://GitHub.com/beauwilliams/focus.nvim/graphs/contributors/)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com)
[![GitHub issues](https://img.shields.io/github/issues/beauwilliams/focus.nvim.svg)](https://GitHub.com/beauwilliams/focus.nvim/issues/)
[![GitHub issues-closed](https://img.shields.io/github/issues-closed/beauwilliams/focus.nvim.svg)](https://GitHub.com/beauwilliams/focus.nvim/issues?q=is%3Aissue+is%3Aclosed)



# Auto-Resizing Focused Splits/Windows for Neovim
# Go To Existing or Create New Split Windows by Direction
# Run Cmds/Open Files in New/Current Windows by Direction
# Useful Splits/Window Management Enhancements for Neovim

👌 Maximises current split/window automatically when cursor moves based on golden ratio

⚙️ Set Focus auto-cursorline/signcolumn/linenums & active/inactive win-highlight + disable

🙌 Compatible with NvimTree, NerdTree, CHADTree, Fern, Telescope, Snap, FZF, Diffview.nvim & QuickFix

👁️ Currently focused split/window maximised to the perfect viewing size according to golden ratio

🏃 Move to existing windows or else create new splits automatically, only a single command

📲 Also specify a file to be opened or run a custom command after moving to an existing/created window

🔌 Option to open tmux windows instead of creating new splits

🖥 Equalise splits or maximise focused splits, and toggle between the two

💾 Set custom filetypes or buftypes to be excluded from resizing

⏱ Supports lazy loading via packer

💯 Written in pure lua


# Demo

![screencast](https://i.ibb.co/0tsKww4/focusop.gif)

*note: for reference this screencast features dimensions set to 120\*40 (W\*H)*

## **[See a visual demonstration of each focus feature here](https://github.com/beauwilliams/focus.nvim/blob/master/DEMO.md)**


## Installation


#### [packer.nvim](https://github.com/wbthomason/packer.nvim)
```lua
use { "beauwilliams/focus.nvim", config = function() require("focus").setup() end }
-- Or lazy load with `module` option. See further down for info on how to lazy load when using FocusSplit commands
-- Or lazy load this plugin by creating an arbitrary command using the cmd option in packer.nvim
-- use { 'beauwilliams/focus.nvim', cmd = { "FocusSplitNicely", "FocusSplitCycle" }, module = "focus",
--     config = function()
--         require("focus").setup({hybridnumber = true})
--     end
-- }
```

#### [vim-plug](https://github.com/junegunn/vim-plug)
```vim
Plug 'beauwilliams/focus.nvim'
"You must run setup() to begin using focus
lua require("focus").setup()
```

## Vim Commands

*For more information on below commands scroll down to see them each described in more detail*
| _Command_      | _Description_ |
| -------------- | ------------- |
| `:FocusDisable` |  Disable the plugin per session. Splits will be normalised back to defaults and then spaced evenly. |
| `:FocusEnable` |  Enable the plugin per session. Splits will be resized back to your configs or defaults if not set. |
| `:FocusToggle` |  Toggle focus on and off again. |
| `:FocusSplitNicely` | Split a window based on the golden ratio rule |
| `:FocusSplitCycle` | If there are no splits, create one and move to it, else cycle focussed split. `:FocusSplitCycle reverse` for counterclockwise |
| `:FocusDisableWindow` | Disable resizing of the current window (winnr). |
| `:FocusEnableWindow` | Enable resizing of the current window (winnr). |
| `:FocusToggleWindow` | Toggle focus on and off again on a per window basis. |
| `:FocusGetDisabledWindows` | Pretty prints the list of disabled window ID's along with the current window ID. |
| `:FocusSplitLeft` | Move to existing or create a new split to the left of your current window + open file or custom command |
| `:FocusSplitDown` | Move to existing or create a new split to the bottom of your current window + open file or custom command |
| `:FocusSplitUp` | Move to existing or create a new split to the top of your current window + open file or custom command |
| `:FocusSplitRight` | Move to existing or create a new split to the right of your current window + open file or custom command |
| `:FocusEqualise` | Temporarily equalises the splits so they are all of similar width/height  |
| `:FocusMaximise` | Temporarily maximises the focussed window |
| `:FocusMaxOrEqual` | Toggles Between having the splits equalised or the focussed window maximised |


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
-- Or use lua-style keymap
--vim.api.nvim_set_keymap('n', '<c-l>', ":lua require('focus').split_nicely()<CR>", { silent = true })
```

❗ **NOTE** ❗

Additionally you can open a file or a run a custom command with the `:FocusSplitNicely` command

*Opens a file in the split created by SplitNicely command*

`:FocusSplitNicely README.md`

*Opens a terminal window in the split created by SplitNicely command by using the cmd arg to run a custom command*

`:FocusSplitNicely cmd term`



## Auto Splitting Directionally

Instead of worrying about multiple commands and shortcuts, *simply think about splits as to which direction you would like to go*.

Calling a focus split command i.e :FocusSplitRight will do one of two things, **it will attempt to move across to the window** in the specified direction.
Otherwise, **if no window exists in the specified direction** relative to the current window **then it will instead create a new blank buffer window** in the direction specified,
and then move to that window.

*Recommended commands, leverage hjkl to move and create your splits directionally with ease*
```lua
vim.api.nvim_set_keymap('n', '<leader>h', ':FocusSplitLeft<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>j', ':FocusSplitDown<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>k', ':FocusSplitUp<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>l', ':FocusSplitRight<CR>', { silent = true })
```
**If you lazy load this plugin with packer `module` option, please use lua-style keymap**
```lua
local focusmap = function(direction)
    vim.api.nvim_set_keymap('n', '<Leader>'..direction, ":lua require'focus'.split_command('"..direction.."')<CR>", { silent = true })
end
-- Use `<Leader>h` to split the screen to the left, same as command FocusSplitLeft etc
focusmap('h')
focusmap('j')
focusmap('k')
focusmap('l')
```

❗ **NOTE** ❗

Additionally you can open a file or a run a custom command with the `:FocusSplit<direction>` command

*Opens a file in a split that was either created or moved to*

`:FocusSplitRight README.md`

*Opening a terminal window by using the cmd arg to run a custom command in a split that was created or moved to*

`:FocusSplitDown cmd term`



## Configuration

**Example Configuration**
```lua
require("focus").setup({hybridnumber = true, excluded_filetypes = {"toggleterm"}})
```
### Available Options

**Enable/Disable Focus**
```lua
-- Completely disable this plugin
-- Default: true
require("focus").setup({enable = false})
```

**Enable/Disable Focus Window Autoresizing**
```lua
--The focussed window will no longer automatically resize. Other focus features are still available
-- Default: true
require("focus").setup({autoresize = false})
```


**Set Focus Excluded Filetypes or Buftypes**
```lua
-- Prevents focus automatically resizing windows based on configured excluded filetypes or buftypes
-- Query filetypes using :lua print(vim.bo.ft) or buftypes using :lua print(vim.bo.buftype)
-- Default[filetypes]: none
-- Default[buftypes]: 'nofile', 'prompt', 'popup'
require("focus").setup({excluded_filetypes = {"toggleterm"}})
require("focus").setup({excluded_buftypes = {"help"}})
-- Enable resizing for excluded filetypes using forced_filetypes
require("focus").setup({forced_filetypes = {"dan_repl"}})
```



**Set Focus Width**
```lua
-- Force width for the focused window
-- Default: Calculated based on golden ratio
require("focus").setup({width = 120})
```

**Set Focus Minimum Width**
```lua
-- Force minimum width for the unfocused window
-- Default: Calculated based on golden ratio
require("focus").setup({minwidth = 80})
```

**Set Focus Height**
```lua
-- Force height for the focused window
-- Default: Calculated based on golden ratio
require("focus").setup({height = 40})
```

**Set Focus Minimum Height**
```lua
-- Force minimum height for the unfocused window
-- Default: 0
require("focus").setup({minheight = 10})
```

**Set Focus Tree Width**
```lua
-- Sets the width of directory tree buffers such as NerdTree, NvimTree and CHADTree
-- Default: vim.g.nvim_tree_width or 30
require("focus").setup({treewidth = 20})
```
**Set Focus Quickfix Height**
```lua
-- Sets the height of quickfix panel
-- Default: 10
require("focus").setup({quickfixheight = 20})
```

**When creating a new split window, do/don't initialise it as an empty buffer**
```lua
-- True: When a :Focus.. command creates a new split window, initialise it as a new blank buffer
-- False: When a :Focus.. command creates a new split, retain a copy of the current window in the new window
-- Default: false
require("focus").setup({bufnew =  false})
```

**Set Focus Compatible File Trees**
```lua
-- Prevents focus automatically resizing windows based on configured file trees
-- Query filetypes using :lua print(vim.bo.ft)
-- Default: { 'nvimtree', 'nerdtree', 'chadtree', 'fern' }
require("focus").setup({compatible_filetrees = {"filetree"}})
```

**Set Focus Auto Cursor Line**
```lua
-- Displays a cursorline in the focussed window only
-- Not displayed in unfocussed windows
-- Default: true
require("focus").setup({cursorline = false})
```

**Set Focus Auto Sign Column**
```lua
-- Displays a sign column in the focussed window only
-- Gets the vim variable setcolumn when focus.setup() is run
-- See :h signcolumn for more options e.g :set signcolum=yes
-- Default: true, signcolumn=auto
require("focus").setup({signcolumn = false})
```

**Set Focus Auto Cursor Column**
```lua
-- Displays a cursor column in the focussed window only
-- See :h cursorcolumn for more options
-- Default: false
require("focus").setup({cursorcolumn = true})
```

**Set Focus Auto Color Column**
```lua
-- Displays a color column in the focussed window only
-- See :h colorcolumn for more options
-- Default: enable = false, width = 80
require("focus").setup({colorcolumn = {enable = true, width = 100}})
```

**Set Focus Auto Numbers**
```lua
-- Displays line numbers in the focussed window only
-- Not displayed in unfocussed windows
-- Default: true
require("focus").setup({number = false})
```

**Set Focus Auto Relative Numbers**
```lua
-- Displays relative line numbers in the focussed window only
-- Not displayed in unfocussed windows
-- See :h relativenumber
-- Default: false
require("focus").setup({relativenumber = true})
```

**Set Focus Auto Hybrid Numbers**
```lua
-- Displays hybrid line numbers in the focussed window only
-- Not displayed in unfocussed windows
-- Combination of :h relativenumber, but also displays the line number of the current line only
-- Default: false
require("focus").setup({hybridnumber = true})
```

**Set Presrve Absolute Numbers**
```lua
-- Preserve absolute numbers in the unfocussed windows
-- Works in combination with relativenumber or hybridnumber
-- Default: false
require("focus").setup({absolutenumber_unfocussed = true})
```

**Set Focus Window Highlighting**
```lua
-- Enable auto highlighting for focussed/unfocussed windows
-- Default: false
require("focus").setup({winhighlight = true})

-- By default, the highlight groups are setup as such:
--   hi default link FocusedWindow VertSplit
--   hi default link UnfocusedWindow Normal
-- To change them, you can link them to a different highlight group, see `:h hi-default` for more info.
vim.highlight.link('FocusedWindow', 'CursorLine', true)
vim.highlight.link('UnfocusedWindow', 'VisualNOS', true)
```



## Planned Improvements 😼

- [x] Refactoring
- [x] Adding more filetype support as we go
- [x] Adding Auto Line Numbers, options for relative, norelative
- [x] Adding a FocusSplitCycle command, create split if there are none, else cycle, choice between vsplit or split as default
- [x] Adding SplitCycleReverse, so we can auto-create split on left instead of right and cycle backwards
- [x] Switch back to setting height/width manually. Using vim.o.winwidth and wim.o.winminwidth was not flexible enough.

# FAQ

**I have a small display and I am finding splits are resized too much**

If for example your screen resolution is *1024x768* --> i.e on the smaller side, you may notice that focus by default can maximise a window *too much*.

That is, the window will sort of 'crush' some of your other splits due to the limited screen real estate. This is not an issue with focus,

but an issue with minimal screen real estate. In this case, you can simply reduce the width/height of focus.


**Quickfix window opens in the right split always. Is this caused by focus.lua?**

No. This is a [documented](http://vimdoc.sourceforge.net/htmldoc/quickfix.html#quickfix) design decision by core vim, this might be something that can be adjusted upstream.

In the meantime, you can open a quickfix window occupying the the full width of the window with `:botright copen`

**I tried to lazy load focus with `:FocusToggle`, but I need to toggle it again to get auto-resizing working**

Please note if you lazy load with command `:FocusToggle`, it will load focus, but will toggle it off initially. See [#34](https://github.com/beauwilliams/focus.nvim/issues/34).

This is because focus is toggled on by default when you load focus, so if you load it and then run the command `:FocusToggle`, it toggles it off again.

**My terminal window is being resized despite 'term' filetype being ignored**

This is an issue with how and when the filetype is set for a buffer. It is recommended to use [toggleterm](https://github.com/akinsho/toggleterm.nvim)

And set excluded filetypes to include toggleterm e.g.. `excluded_filetypes = { 'fterm', 'term', 'toggleterm' }`


# Developers Only

**Contributing**

Please before submitting a PR install stylua [here](https://github.com/JohnnyMorganz/StyLua)

And run `stylua .` from your shell in the root folder of `focus.nvim`

This will format the code according to the guidlines set in `stylua.toml`
