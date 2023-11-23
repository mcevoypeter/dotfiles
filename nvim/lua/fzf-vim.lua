vim.cmd([[
  nnoremap <Leader>b :Buffers<CR>
  nnoremap <Leader>f :Files<CR>
  nnoremap <Leader>d :GFiles?<CR>
  nnoremap <Leader>s :GFiles<CR>
]])

vim.g.fzf_layout = {
  window = {
    width = 1.0,
    height = 0.25,
    relative = true,
    yoffset = 1.0
  }
}

vim.g.fzf_colors = {
  fg = { "fg", "Normal" },
  bg = { "bg", "Normal" },
  hl = { "fg", "Comment" },
  ["fg+"] = { "fg", "CursorLine", "CursorColumn", "Normal" },
  ["bg+"] = { "bg", "CursorLine", "CursorColumn" },
  ["hl+"] = { "fg", "Statement" },
  info = { "fg", "PreProc" },
  border = { "fg", "Ignore" },
  prompt = { "fg", "Conditional" },
  pointer = { "fg", "Exception" },
  marker = { "fg", "Keyword" },
  spinner = { "fg", "Label" },
  header = { "fg", "Comment" }
}

vim.g.fzf_action = {
  ["ctrl-s"] = "split",
  ["ctrl-v"] = "vsplit",
  ["ctrl-y"] = "tab split"
}
