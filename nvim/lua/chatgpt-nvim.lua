local chatgpt = require("chatgpt")

chatgpt.setup({
  openai_params = {
    model = "gpt-3.5-turbo",
  },
})

vim.keymap.set('n', '<Leader>a', ':ChatGPT<CR>')
vim.keymap.set('v', '<Leader>a', ':ChatGPTEditWithInstructions<CR>')
