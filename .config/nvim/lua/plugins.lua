require"scrollbar".setup {}
require "nvim-tree".setup {
  git = {
    enable = true,
  },
  view = {
    mappings = {
      custom_only = false,
      list = {
        { key = "<Tab>", action = "" },
      }
    }
  }
}
