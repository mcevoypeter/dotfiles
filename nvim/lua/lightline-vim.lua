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
