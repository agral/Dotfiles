local util = require("lspconfig.util")

local root_files = {
  ".clangd",
  ".clang-tidy",
  ".clang-format",
  "compile_commands.json",
  "compile_flags.txt",
  "configure.ac", -- autotools
}

return {
  cmd = { "clangd",
    "--all-scopes-completion",
    "--background-index",
    "--clang-tidy",
    "--compile_args_from=filesystem", -- in general case, compile_commands might not be present; lsp is to be used then
    "--completion-parse=always",
    "--completion-style=bundled",
    "--debug-origin",

    -- clangd 11+ supports reading from local .clangd configfile
    "--enable-config",

    "--fallback-style=google",
    "--function-arg-placeholders",
    "--header-insertion=iwyu",
    "--pch-storage=memory",
    "-j=12", --total workers
    "--log=error",
  },
  commands = {},
  filetypes = {"c", "cpp", "objc", "objcpp"},
  init_options = {
    compilationDatabasePath = {"./build", "."},
  },
  root_dir = function(filename)
    return util.root_pattern(unpack(root_files))(filename) or util.find_git_ancestor(filename)
  end,
  single_file_support = true,
}
