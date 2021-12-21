# tidy.nvim 🧹

A function and autocommand pair that removes all

    - trailing whitespace
    - empty lines at the end of the buffer

on every `BufWritePre`.

![tidy](https://user-images.githubusercontent.com/59481467/142785684-96559135-88e7-4c50-a848-56f2c65262ef.gif)

## install
- Packer with default configuration and lazy-loading

```lua
use{
    "mcauley-penney/tidy.nvim",
     config = function()
        require "tidy".setup{}
    end,
    event  = "BufWritePre"
}
```

## Configuration

### default

Tidy comes with the below default configuration:

```lua
local M = {
    config = {
        eof_quant = -1,  -- the amount of empty lines to leave at the end of
                         -- the file; -1 = no lines, 0 = 1 line, no limit;
                         -- only applies if "eof" given to "fmts"

        fmts = {         -- the types of formattings to apply
            "eof",       -- removes lines at end of file
            "multi",     -- condenses multiple newlines into one
            "sof",       -- removes lines at start of file
            "ws"         -- removes trailing whitespace
        }
    }
}
```

### how to customize

To customize which formattings will apply, give a list to the `setup` function:

```lua
use{
    "mcauley-penney/tidy.nvim",
    config = function()
        require "tidy".setup{
            fmts = {
                "eof",
                "ws"
            }
       }
   end,
   event  = "BufWritePre"
}
```

### formatting styles

- `eof`: remove a variable amount of newlines at end of file

![eof](https://user-images.githubusercontent.com/59481467/146851029-d1c47cfa-a25f-4ea0-b33e-faac6153b5f6.gif)

- `multi`: condenses multiple newlines into one

![condense](https://user-images.githubusercontent.com/59481467/146851295-aa77bcb0-d5b3-4c0a-9857-5eb1043e48c9.gif)

- `sof`: removes lines at start of file

![sof](https://user-images.githubusercontent.com/59481467/146851203-d7d7c3dd-8c2f-4267-bb71-fde1f95fc88f.gif)

- `ws`: remove whitespace

![whitespace](https://user-images.githubusercontent.com/59481467/146851131-c39e9ba8-851f-4a12-9eb5-609f8f7b29ab.gif)

## Credits:
- [Vim Tips Wiki entry](https://vim.fandom.com/wiki/Remove_unwanted_spaces#Automatically_removing_all_trailing_whitespace)
for removing unwanted spaces
- ib., the author of [this stack overflow answer](https://stackoverflow.com/a/7501902), for how to remove empty lines at the
end of the buffer
    - @blackboardd for how to choose how many lines will be kept
- [This line](https://github.com/gpanders/editorconfig.nvim/blob/ae3586771996b2fb1662eb0c17f5d1f4f5759bb7/lua/editorconfig.lua#L180)
in [gpanders/editorconfig.nvim](https://github.com/gpanders/editorconfig.nvim) for exposing me to the `keepjumps`
and `keeppatterns` modifiers
- [Vim Tips Wiki entry](https://vim.fandom.com/wiki/Remove_unwanted_empty_lines) for condensing multiple empty lines
