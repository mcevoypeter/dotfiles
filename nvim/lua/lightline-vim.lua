vim.g.lightline = {
  colorscheme = "powerline",
  active = {
    left = {
      { "mode", "paste" },
      { "gitbranch", "readonly", "filename", "modified" }
    },
    right = {
      { "lineinfo", "charvaluehex", "wordcount" },
      { "percent" },
      { "fileformat", "fileencoding", "filetype" }
    }
  },
  component = {
    charvaluehex = "0x%B",
    filename = "%f"
  },
  component_function = {
    gitbranch = "FugitiveHead",
    wordcount = "WordCount"
  },
  mode_map = {
    n = "N",
    i = "I",
    R = "R",
    v = "V",
    V = "VL",
    -- "\<C-v>"
    ["\22"] = "VB",
    c = "C",
    s = "S",
    S = "SL",
    -- "\<C-s>" = "SB"
    t= "T"
  }
}

-- from https://github.com/itchyny/lightline.vim/issues/295#issuecomment-373961016
vim.cmd([[
  function! WordCount()
    let currentmode = mode()
    if !exists("g:lastmode_wc")
      let g:lastmode_wc = currentmode
    endif
    " if we modify file, open a new buffer, be in visual ever, or switch modes
    " since last run, we recompute.
    if &modified || !exists("b:wordcount") || currentmode =~? '\c.*v' || currentmode != g:lastmode_wc
      let g:lastmode_wc = currentmode
      let l:old_position = getpos('.')
      let l:old_status = v:statusmsg
      execute "silent normal g\<c-g>"
      if v:statusmsg == "--No lines in buffer--"
        let b:wordcount = 0
      else
        let s:split_wc = split(v:statusmsg)
        if index(s:split_wc, "Selected") < 0
          let b:wordcount = str2nr(s:split_wc[11])
        else
          let b:wordcount = str2nr(s:split_wc[5])
        endif
        let v:statusmsg = l:old_status
      endif
      call setpos('.', l:old_position)
      return b:wordcount
    else
      return b:wordcount
    endif
  endfunction
]])
