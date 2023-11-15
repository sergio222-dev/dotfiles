return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      {
        "<leader>fd",
        function()
          require("telescope.builtin").find_files({
            hidden = true,
            cwd = "~/.config",
          })
        end,
        desc = "Find hidden",
      },
    },
  },
}
