# tidy.nvim 🧹

An [autocommand](https://neovim.io/doc/user/autocmd.html) that removes all trailing white spaces and empty lines at the end of the buffer on every `BufWritePre`.

![tidy-demo](https://github.com/mcauley-penney/tidy.nvim/assets/59481467/f3807c69-2b36-4a14-b83a-dd0f2829e096)


## Installation
- [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
    "mcauley-penney/tidy.nvim",
    config = true,
} 
```


## Configuration
Tidy will work on all buffers using only the basic installation shown above. No configuration options are required, but please see the documentation for configuration options. An example configuration for lazy.nvim is

```lua
{
    "mcauley-penney/tidy.nvim",
    config = { filetype_exclude = { "markdown", "diff" } },
    init = function()
        vim.keymap.set('n', "<leader>te", require("tidy").toggle, {})
    end
} 
```


## About and Credits
I originally wrote this as a wrapper around a couple of vim regex commands used for formatting files before I began using formatters. These commands are not mine, please see the sources below. Even with real formatters in my setup now, I still like and use this because I like these specific formats to be applied to every buffer and don't want to have a formatting tool installed for them.

- [Vim Tips Wiki entry for removing unwanted spaces](https://vim.fandom.com/wiki/Remove_unwanted_spaces#Automatically_removing_all_trailing_whitespace)

- `ib.`, the author of [this Stack Overflow answer](https://stackoverflow.com/a/7501902)

- [This line](https://github.com/gpanders/editorconfig.nvim/blob/ae3586771996b2fb1662eb0c17f5d1f4f5759bb7/lua/editorconfig.lua#L180)
in [gpanders/editorconfig.nvim](https://github.com/gpanders/editorconfig.nvim) for exposing me to the `keepjumps`
and `keeppatterns` modifiers
