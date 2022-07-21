# tidy.nvim 🧹

An [autocommand](https://neovim.io/doc/user/autocmd.html) that removes all

    - trailing whitespace
    - empty lines at the end of the buffer

on every `BufWritePre`.


![tidy](https://user-images.githubusercontent.com/59481467/170846833-40ab4e8c-ebdf-42c4-b1f1-a4d874f27ea8.gif)


## About
I originally wrote this as a wrapper around a couple of vim regex commands used for formatting files before I began using formatters. These commands are not mine, please see the `Credits` section below for sources. Even with real formatters in my setup now, I still like and use this because I like these specific formats to be applied to every buffer and don't want to have a formatting tool installed for them.


## Installation
- [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use({
    "mcauley-penney/tidy.nvim",
    config = function()
        require("tidy").setup()
    end
})
```

## Configuration
Tidy will work on all buffers using only the basic installation shown above. No configuration options are required. The options displayed below are simply examples.

```lua
require("tidy").setup({
    filetype_exclude = { "markdown", "diff" },
})
```


## Credits
- [Vim Tips Wiki entry for removing unwanted spaces](https://vim.fandom.com/wiki/Remove_unwanted_spaces#Automatically_removing_all_trailing_whitespace)

- `ib.`, the author of [this Stack Overflow answer](https://stackoverflow.com/a/7501902)

- [This line](https://github.com/gpanders/editorconfig.nvim/blob/ae3586771996b2fb1662eb0c17f5d1f4f5759bb7/lua/editorconfig.lua#L180)
in [gpanders/editorconfig.nvim](https://github.com/gpanders/editorconfig.nvim) for exposing me to the `keepjumps`
and `keeppatterns` modifiers
