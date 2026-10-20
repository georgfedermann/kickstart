-- ============================================================
-- SECTION 2: KEYMAPS & AUTOCMDS
-- basic keymaps, basic autocmds
-- ============================================================

do
  vim.keymap.set('n', '<leader>pv', vim.cmd.Explore, { desc = 'Open Vim file explorer' })
  vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up and center cursor line' })
  vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down and center cursor line' })
  vim.keymap.set('n', '<C-e>', '<C-e>jzz', { desc = 'Scroll down one line and center cursor line' })
  vim.keymap.set('n', '<C-y>', '<C-y>kzz', { desc = 'Scroll up one line and center cursor line' })
  vim.keymap.set('x', '<leader>b', '"_dP', { desc = 'Delete selection to black hole register and paste' })

  -- Compile / run keymaps for single-file C programs with no build system.
  -- Effect: Entering a C buffer defines two buffer-local keymaps that
  -- whell out to clang in a terminal split. See docs/NEOVIM_GUIDE.md
  -- C Development section for the full workflow.
  vim.api.nvim_create_autocmd('FileType', {
    desc = 'Compile and run keymaps for C buffers',
    pattern = { 'c', 'cpp' },
    group = vim.api.nvim_create_augroup('c-cpp-build', { clear = true }),
    callback = function(event)
      local compiler = vim.bo[event.buf].filetype == 'cpp' and 'g++' or 'gcc'

      local function build_cmd()
        local file = vim.fn.expand '%:p'
        local out = vim.fn.expand '%:p:r'
        return string.format('%s -g -O0 -Wall -Wextra -std=%s -o %s %s', compiler, compiler == 'g++' and 'c++17' or 'c99', out, file)
      end

      vim.keymap.set('n', '<leader>cb', function()
        vim.cmd 'write'
        vim.cmd('botright split | terminal ' .. build_cmd())
      end, { buffer = event.buf, desc = '[C]ompile [B]uffer (debug build)'})

      vim.keymap.set('n', '<leader>cr', function()
        vim.cmd 'write'
        local out = vim.fn.expand '%:p:r'
        vim.cmd('botright split | terminal ' .. build_cmd() .. ' && ' .. out)
      end, { buffer = event.buf, desc = '[C]ompile and [R]un' })
    end
  })

end
