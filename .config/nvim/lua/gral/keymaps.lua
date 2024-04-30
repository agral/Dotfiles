local vks = function(trigger, mapping, description, mode_override)
    local mode = mode_override or "n"
    vim.keymap.set(mode, trigger, mapping, { desc = description, noremap = true, silent = true, })
end

-- Set <Space> as leader key:
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vks("j", "gj", "Do not skip over a wrapped line", { "n", "x", "o" })
vks("k", "gk", "Do not skip over a wrapped line", { "n", "x", "o" })

--[[ "n": Normal mode mappings --]]
vks(";", ":", "Use ';' as ':'")
vks("<leader>hl", ":set hlsearch!<CR>", "Toggle search highlighting on/off")

vks("<leader>bn", ":bnext<CR>", "Switch to buffer: next")
vks("<leader>bp", ":bprevious<CR>", "Switch to buffer: previous")
vks("<leader>E", ":Lexplore 30<CR>", "Explore local directory with netrw (no plugins required)")

vks("<A-j>", ":m .+1<CR>==", "move current line down")
vks("<A-k>", ":m .-2<CR>==", "move current line up")

-- Diagnostic-related keymaps:
vks("<leader>de", vim.diagnostic.open_float, "Diagnostics: Show error message")
vks("<leader>dj", vim.diagnostic.goto_next, "Diagnostics: Jump to next")
vks("<leader>dn", vim.diagnostic.goto_next, "Diagnostics: Jump to next")
vks("<leader>dk", vim.diagnostic.goto_prev, "Diagnostics: Jump to previous")
vks("<leader>dp", vim.diagnostic.goto_prev, "Diagnostics: Jump to previous")
vks("<leader>dq", vim.diagnostic.setloclist, "Diagnostics: show quickfix list")

--[[ "v": Visual mode mappings --]]
vks("<", "<gv", "Decrease selection's indent level", "v")
vks(">", ">gv", "Increase selection's indent level", "v")
vks("<A-j>", ":m '>+1<CR>gv=gv", "Move selection down", "v")
vks("<A-k>", ":m '<-2<CR>gv=gv", "Move selection up", "v")

vks("p", '"_dP', "Do not substitute the contents of paste register " ..
    "with previous content when pasting into the selected block", "v")

--[[ "x": Visual block mode mappings --]]
vks("<A-j>", ":m '>+1<CR>gv=gv", "Move visual block down", "x")
vks("<A-k>", ":m '>-2<CR>gv=gv", "Move visual block up", "x")
