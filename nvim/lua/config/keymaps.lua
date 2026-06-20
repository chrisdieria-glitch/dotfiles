-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local Terminal = require("toggleterm.terminal").Terminal

local runner = Terminal:new({
  direction = "horizontal",
  hidden = true,
})

vim.keymap.set("n", "<c-l>", function()
  vim.cmd("w")

  local file = vim.fn.expand("%:p")
  local venv_python = vim.fn.getcwd() .. "/.venv/bin/python"

  if not runner:is_open() then
    runner:toggle()
  end

  if vim.fn.executable(venv_python) == 1 then
    runner:send(venv_python .. " " .. file, true)
  else
    runner:send("python3 " .. file, true)
  end
end, { desc = "Run Python" })

vim.keymap.set("n", "<c-;>", function()
  runner:toggle()
end, { desc = "Toggle Term" })
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]])
