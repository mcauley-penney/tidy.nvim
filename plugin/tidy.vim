augroup Tidy
    au!
    au BufWritePre * lua require( "tidy" ).tidy_up()
augroup END
