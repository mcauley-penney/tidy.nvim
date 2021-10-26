
augroup Tidy
    au!
    au BufWritePre * lua require( "tidy.init" ).clear_spaces()
augroup END
