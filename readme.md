## tidy.nvim 🧹

A function and autocommand pair that removes all

    - trailing whitespace
    - empty lines at the end of the buffer

on every `BufWritePre`.


https://user-images.githubusercontent.com/59481467/138811091-05031eb1-96fc-4915-a349-e41d87c921ea.mp4


Credits:
1. [Vim Tips Wiki entry for removing unwanted spaces](https://vim.fandom.com/wiki/Remove_unwanted_spaces#Automatically_removing_all_trailing_whitespace)
2. ib., the author of [this stack overflow answer](https://stackoverflow.com/a/7501902)
3. [This line](https://github.com/gpanders/editorconfig.nvim/blob/ae3586771996b2fb1662eb0c17f5d1f4f5759bb7/lua/editorconfig.lua#L180)
in [gpanders/editorconfig.nvim](https://github.com/gpanders/editorconfig.nvim) for exposing me to the `keepjumps`
and `keeppatterns` modifiers
