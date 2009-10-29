



" ==== Search Window Class =========================================== {{{

" Autocomplpop Conflict Guard
let g:acpguard_class = { }
let g:acpguard_class.warning_pres_t = '500m'

fun! g:acpguard_class.check()

  " check for autocomplpop.vim
  " we can not check loaded_autocomplpop variable , because we might load
  " window.vim before we load autocomplpop.
  if ( exists('g:AutoComplPop_Behavior') || exists('g:loaded_acp') ) 
      \ && exists("#CursorMovedI")
    " then we should disable it , because the autocmd CursorMoveI conflicts
    
    if ! exists( 'self.warning_show' )
      call s:echo("AutoComplPop Disabled: the cursor moved event of autocomplpop conflicts with me.")
      exec 'sleep ' . self.warning_pres_t
      let  self.warning_show = 1
    endif
    AutoComplPopDisable
    let self.reveal_autocomplpop = 1
  endif

endf

fun! g:acpguard_class.reveal()
  if exists('g:AutoComplPop_Behavior') && exists('reveal_autocomplpop')
    call s:echo("AutoComplPop Enabled.")
    AutoComplPopEnable
    unlet self.reveal_autocomplpop 
  endif
endf

fun! s:echo(msg)
  redraw
  echomsg a:msg
endf

"
"=VERSION 0.3

" search window manager
let swindow#class = { 'buf_nr' : -1 , 'mode' : 0 }
let swindow#class.loaded = 1
let swindow#class.version = 0.3

fun! swindow#class.open(pos,type,size)
  call g:acpguard_class.check()
  call self.split(a:pos,a:type,a:size)
endf

fun! swindow#class.split(position,type,size)
  if ! bufexists( self.buf_nr )
    if a:type == 'split' | let act = 'new' 
    elseif a:type == 'vsplit' | let act = 'vnew'
    else | let act = 'new' | endif

    let self.win_type = a:type

    exec a:position . ' ' . a:size . act
    let self.buf_nr = bufnr('%')
    setlocal noswapfile buftype=nofile bufhidden=hide
    setlocal nobuflisted nowrap cursorline nonumber fdc=0

    try
      call self.init_buffer()
      call self.init_syntax()
      call self.init_basic_mapping()
      call self.init_mapping()
    catch /^SKIP:/
      bw
      startinsert
      call cursor( line('.') , col('.') + 1 )
      call s:echo( v:exception )
      return
    catch /^ERROR:/
      bw " close buffer
      echo v:exception
      return
    endtry

    call self.start()
  elseif bufwinnr(self.buf_nr) == -1 
    exec a:position . ' ' . a:size . a:type
    execute self.buf_nr . 'buffer'
    call self.buffer_reload_init()
  elseif bufwinnr(self.buf_nr) != bufwinnr('%')
    execute bufwinnr(self.buf_nr) . 'wincmd w'
  endif
endf

" start():
" after a buffer is initialized , start() function will be called to
" setup.
fun! swindow#class.start()
  call cursor( 1, 1 )
  startinsert
endf

" buffer_reload_init() 
" will be triggered after search window opened and the
" buffer is loaded back , which doesn't need to initiailize.
fun! swindow#class.buffer_reload_init()   
endf

" init_buffer() 
" initialize a new buffer for search window.
fun! swindow#class.init_buffer() 
endf

" init_syntax() 
" setup the syntax for search window buffer
fun! swindow#class.init_syntax() 
endf

" init_mapping() 
" define your mappings for search window buffer
fun! swindow#class.init_mapping() 
endf

" init_base_mapping()
" this defines default set mappings
fun! swindow#class.init_basic_mapping()
  imap <buffer>     <Enter> <ESC>j<Enter>
  imap <buffer>     <C-a>   <Esc>0i
  imap <buffer>     <C-e>   <Esc>A
  imap <buffer>     <C-b>   <Esc>i
  imap <buffer>     <C-f>   <Esc>a
  inoremap <buffer> <C-n> <ESC>j
  nnoremap <buffer> <C-n> j
  nnoremap <buffer> <C-p> k
  nnoremap <buffer> <ESC> <C-W>q
  inoremap <buffer> <C-c> <ESC><C-W>q
endf

" reder_result()
" put list into buffer
fun! swindow#class.render_result(matches)
  let r=join( a:matches , "\n" )
  silent put=r
endf

fun! swindow#class.close()
  " since we call buffer back , we dont need to remove buffername
  " silent 0f
  call g:acpguard_class.reveal()
  redraw
endf

" ==== Window Manager =========================================== }}}

