[![GitHub stars](https://img.shields.io/github/stars/beauwilliams/focus.nvim.svg?style=social&label=Star)](https://GitHub.com/beauwilliams/focus.nvim/stargazers/)
[![Requires](https://img.shields.io/badge/requires-nvim%200.5%2B-9cf?logo=neovim)](https://neovim.io//)
[![GitHub contributors](https://img.shields.io/github/contributors/beauwilliams/focus.nvim.svg)](https://GitHub.com/beauwilliams/focus.nvim/graphs/contributors/)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com)
[![GitHub issues](https://img.shields.io/github/issues/beauwilliams/focus.nvim.svg)](https://GitHub.com/beauwilliams/focus.nvim/issues/)
[![GitHub issues-closed](https://img.shields.io/github/issues-closed/beauwilliams/focus.nvim.svg)](https://GitHub.com/beauwilliams/focus.nvim/issues?q=is%3Aissue+is%3Aclosed)


# Breaking Change

You must now run the `setup()` function to begin using focus.

Details below and code snippets are in the readme to get you started.

# Auto-Resizing Focused Splits/Windows for Neovim

👌 Maximises current split/window automatically when cursor moves based on golden ratio

⚙️  Set Focus auto-cursorline/signcolumn/linenums & active/inactive win-highlight + disable

🙌 Compatible with NvimTree, NerdTree, CHADTree, Fern, Telescope, FZF & QuickFix

👁️ Currently focussed split/window maximised to the perfect viewing size according to golden ratio

🏃 Move to existing windows or else create new splits automatically, only a single command + can specify a file to open

🔌 Option to open tmux windows instead of creating new splits

🖥 Equalise splits or maximise focussed splits, and toggle between the two

💾 Set custom filetypes or buftypes to be excluded from resizing

⏱ Supports lazy loading via packer

💯 Written in pure lua


# Demo

![screencast](https://i.ibb.co/0tsKww4/focusop.gif)

*note: for reference this screencast features dimensions set to 120\*40 (W\*H)*

**[See a visual demonstration of each focus feature here](https://github.com/beauwilliams/focus.nvim/blob/master/DEMO.md)**


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
| `:FocusSplitCycle` | If there are no splits, create one and move to it, else cycle between them |
| `:FocusSplitLeft` | Move to existing or create a new split to the left of your current window |
| `:FocusSplitDown` | Move to existing or create a new split to the bottom of your current window |
| `:FocusSplitUp` | Move to existing or create a new split to the top of your current window |
| `:FocusSplitRight` | Move to existing or create a new split to the right of your current window |
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

## Opening a file in a new split directionally

*This feature allows you to open a file in a split specifying which position you want it to be located*

For example `:FocusSplitRight somefile.lua` will open `somefile.lua ` to the right of your current window.

You can also specify a mapping, or perhaps a function to even add lazy loading.


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

**Set Focus Excluded Filetypes or Buftypes**
```lua
-- Prevents focus automatically resizing windows based on configured excluded filetypes or buftypes
-- Query filetypes using :lua print(vim.bo.ft) or buftypes using :lua print(vim.bo.buftype)
-- Default[filetypes]: none
-- Default[buftypes]: 'nofile', 'prompt', 'help'
require("focus").setup({excluded_filetypes = {"toggleterm"}})
require("focus").setup({excluded_buftypes = {"help"}})
```

**Set Focus Width**
```lua
-- Force width for the focused window
-- Default: Calculated based on golden ratio
require("focus").setup({width = 120})
```

**Set Focus Height**
```lua
-- Force height for the focused window
-- Default: Calculated based on golden ratio
require("focus").setup({height = 40})
```

**Set Focus Tree Width**
```lua
-- Sets the width of directory tree buffers such as NerdTree, NvimTree and CHADTree
-- Default: vim.g.nvim_tree_width or 30
require("focus").setup({treewidth = 20})
```

**Set Focus Compatible File Trees**
```lua
-- Prevents focus automatically resizing windows based on configured file trees
-- Query filetypes using :lua print(vim.bo.ft)
-- Default: { 'nvimtree', 'nerdtree', 'chadtree', 'fern' }
require("focus").setup({compatible_filetrees = {"filetree"}})
```

**Set Focus Auto Cursorline**
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

**Set Focus Window Highlighting**
```lua
-- Enable auto highlighting for focussed/unfocussed windows
-- Default: false
require("focus").setup({winhighlight = true})

-- By default, the highlight groups are setup as such:
--   hi default link FocusedWindow VertSplit
--   hi default link UnfocusedWindow Normal
-- To change them, you can link them to a different highlight group, see `:h hi-default` for more info.
vim.cmd('hi link UnfocusedWindow CursorLine')
vim.cmd('hi link FocusedWindow VisualNOS')
```



## Planned Improvements 😼

- [x] Refactoring
- [x] Adding more filetype support as we go
- [x] Adding Auto Line Numbers, options for relative, norelative
- [ ] Adding a FocusSplitCycle command, create split if there are none, else cycle, choice between vsplit or split as default

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


# Developers Only

**Contributing**

Please before submitting a PR install stylua [here](https://github.com/JohnnyMorganz/StyLua)

And run `stylua .` from your shell in the root folder of `focus.nvim`

This will format the code according to the guidlines set in `stylua.toml`
