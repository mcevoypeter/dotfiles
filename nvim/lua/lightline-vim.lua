vim.g.lightline = {
  colorscheme = "powerline",
  active = {
    left = {
      { "mode", "paste" },
      { "readonly", "filename", "modified" }
    },
    right = {
      { "lineinfo", "charvaluehex" },
      { "percent" },
      { "fileformat", "fileencoding", "filetype" }
    }
  },
  component = {
    charvaluehex = "0x%B",
    filename = "%f"
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
