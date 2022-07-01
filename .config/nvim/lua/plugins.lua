require"scrollbar".setup {}

require"toggleterm".setup {
    direction = 'float',
    shell     = vim.o.shell,
    open_mapping = [[<c-t>]],
    terminal_mappings = true,
}
