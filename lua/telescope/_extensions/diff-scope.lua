local ok, telescope = pcall(require, 'telescope')

if not ok then
  error 'Install nvim-telescope/telescope.nvim to use lgeralds/diff-scope.'
end

local DiffScope = require('telescope._extensions.diff-scope.diff-scope-picker')
local opts = {
  -- path_a = vim.fn.getcwd(),
  path_a = [[/Users/lgeralds/Projects/t/ruby 3.2/r02/depot]],
  -- path_b = vim.fn.getcwd(),
  path_b = [[/Users/lgeralds/Projects/t/ruby 3.2/r02/code 2/rails7/depot_f]],
  ignore = { '.DS_Store', '.git', 'log', 'tmp', 'node_modules', '.Trash' }
}

return telescope.register_extension {
  setup = function(diff_scope_opts, o)
    -- print('DOPTS: ', vim.inspect(diff_scope_opts))
    -- print('O: ', vim.inspect(o))

    opts = vim.tbl_extend('force', opts, diff_scope_opts)
  end,
  exports = {
    diff = function()
      DiffScope.diff(opts)
    end,
    close = DiffScope.close,
    close_all = DiffScope.close_all,
    bail = DiffScope.bail,
  },
}
