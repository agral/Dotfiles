local util = require("lspconfig.util")

local root_files = {
  ".clangd",
  ".clang-tidy",
  ".clang-format",
  "compile_commands.json",
  "compile_flags.txt",
  "compile", -- buildProject
  "configure.ac", --autotools
}

return {
  cmd = {
    "bash-language-server",
    "start",
  },
  cmd_env = {
    GLOB_PATTERN = "*@(.bash|.command|.inc|.sh)",
  },
  filetype = {
    "bash",
    "sh",
    "zsh",
  },
  root_dir = function(filename)
    return util.root_pattern(unpack(root_files))(filename) or util.find_git_ancestor(filename)
  end,
  single_file_support = true,
}
