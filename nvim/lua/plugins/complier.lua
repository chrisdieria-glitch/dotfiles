return {
  {
    "CRAG666/code_runner.nvim",
    config = function()
      require("code_runner").setup({
        mode = "toggleterm",

        focus = true,
        startinsert = true,

        filetype = {
          python = function()
            local venv_python = vim.fn.getcwd() .. "/.venv/bin/python"
            local file = vim.fn.expand("%:p")

            if vim.fn.executable(venv_python) == 1 then
              return venv_python .. " -u " .. file
            else
              return "python3 -u " .. file
            end
          end,
          javascript = "node",
          typescript = "bun run",
          sh = "bash",

          c = {
            "cd $dir &&",
            "gcc $fileName -o $fileNameWithoutExt &&",
            "./$fileNameWithoutExt",
          },

          cpp = {
            "cd $dir &&",
            "g++ $fileName -o $fileNameWithoutExt &&",
            "./$fileNameWithoutExt",
          },
        },
      })
    end,
  },
}
