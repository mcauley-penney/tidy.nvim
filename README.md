
# tidy.nvim 🧹

A function and autocommand pair that removes all

    - trailing whitespace
    - empty lines at the end of the buffer

on every `BufWritePre`.

![tidy](https://user-images.githubusercontent.com/59481467/148654417-73a2eaeb-272e-4cb8-910b-870f2f46fa0a.gif)


**Note**: See the `cfg` branch for increased functionality and configuration.


## Installation
- Packer

```lua
use "McAuleyPenney/tidy.nvim"
```

or with lazy-loading

```lua
use{ "McAuleyPenney/tidy.nvim", event = "BufWritePre" }
```

## Todo
- [ ] preserve undotree


## Credits
- [Vim Tips Wiki entry for removing unwanted spaces](https://vim.fandom.com/wiki/Remove_unwanted_spaces#Automatically_removing_all_trailing_whitespace)

- ib., the author of [this stack overflow answer](https://stackoverflow.com/a/7501902)

- [This line](https://github.com/gpanders/editorconfig.nvim/blob/ae3586771996b2fb1662eb0c17f5d1f4f5759bb7/lua/editorconfig.lua#L180)
in [gpanders/editorconfig.nvim](https://github.com/gpanders/editorconfig.nvim) for exposing me to the `keepjumps`
and `keeppatterns` modifiers
