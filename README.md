# tidy.nvim 🧹

A function and autocommand pair that removes all

    - trailing whitespace
    - empty lines at the end of the buffer

on every `BufWritePre`.


![tidy](https://user-images.githubusercontent.com/59481467/170846833-40ab4e8c-ebdf-42c4-b1f1-a4d874f27ea8.gif)


## About
I originally wrote this as a wrapper around a couple of vim regex commands used for formatting files before I began using formatters. These commands are not mine, please see the `Credits` section below for sources. My contribution is a basic conditional which ensures that the user's cursor doesn't migrate during the cleaning operations conducted on the buffer's contents unless the cursor is in the removed white space. Even with real formatters in my setup now, I still like and use this because I like these specific formats to be applied to every buffer and don't want to have a formatting tool installed for them. There really isn't a reason to have this in a plugin other than wanting to disseminate it for new users or people who didn't know you could do this. You could (should) instead just yank and put the code right in your configuration.


## Installation
- Packer

```lua
use({
    "mcauley-penney/tidy.nvim",
    config = function()
        require("tidy").setup()
    end
})
```

## Credits
- [Vim Tips Wiki entry for removing unwanted spaces](https://vim.fandom.com/wiki/Remove_unwanted_spaces#Automatically_removing_all_trailing_whitespace)

- `ib.`, the author of [this Stack Overflow answer](https://stackoverflow.com/a/7501902)

- [This line](https://github.com/gpanders/editorconfig.nvim/blob/ae3586771996b2fb1662eb0c17f5d1f4f5759bb7/lua/editorconfig.lua#L180)
in [gpanders/editorconfig.nvim](https://github.com/gpanders/editorconfig.nvim) for exposing me to the `keepjumps`
and `keeppatterns` modifiers
