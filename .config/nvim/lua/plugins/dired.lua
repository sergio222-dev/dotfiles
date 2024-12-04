if true then return {} end

return {
  "X3eRo0/dired.nvim",
  requires = "MunifTanjim/nui.nvim",
  config = function()
    require("dired").setup {
      path_separator = "/",
      show_banner = false,
      show_icons = false,
      show_hidden = true,
      show_dot_dirs = true,
      show_colors = true,
    }
  end
}
