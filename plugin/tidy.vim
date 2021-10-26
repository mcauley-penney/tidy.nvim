
augroup Tidy
    au!
    au BufWritePre * lua require( "tidy.init" ).tidy_up()
augroup END
