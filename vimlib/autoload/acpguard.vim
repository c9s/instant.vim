

" Autocomplpop Conflict Guard

let acpguard#class = { }
let acpguard#class.warning_pres_t = '500m'

fun! acpguard#class.check()

  " check for autocomplpop.vim
  " we can not check loaded_autocomplpop variable , because we might load
  " window.vim before we load autocomplpop.
  if ( exists('g:AutoComplPop_Behavior') || exists('g:loaded_acp') ) 
      \ && exists("#CursorMovedI")
    " then we should disable it , because the autocmd CursorMoveI conflicts
    
    if ! self.warning_show
      call s:echo("AutoComplPop Disabled: the cursor moved event of autocomplpop conflicts with me.")
      exec 'sleep ' .  self.warning_pres_t
      let  self.warning_show = 1
    endif
    AutoComplPopDisable
    let self.reveal_autocomplpop = 1
  endif

endf

fun! acpguard#class.reveal()

  if exists('g:AutoComplPop_Behavior') && exists('reveal_autocomplpop')
    call s:echo("AutoComplPop Enabled.")
    AutoComplPopEnable
    unlet self.reveal_autocomplpop 
  endif

endf
