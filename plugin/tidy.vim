
augroup Tidy
    au!
    au BufWritePre * lua require( "aucmd.functions" ).clear_spaces()
augroup END
