local M = {}
local opt = require('tabline.config').options

local tabline = function(options)
    local icons = require('tabline.icons')
    local utils = require('tabline.utils')

    local s = ''
    for index = 1, vim.fn.tabpagenr('$') do
        local winnr = vim.fn.tabpagewinnr(index)
        local bufnr = vim.fn.tabpagebuflist(index)[winnr]
        local bufname = vim.fn.bufname(bufnr)
        local bufmodified = vim.fn.getbufvar(bufnr, "&mod")
        local filename = utils.find_filename(bufname)
        local extension = vim.fn.fnamemodify(bufname, ':e')
        local padding = string.rep(' ', opt.padding)

        -- Make clickable
        s = s .. '%' .. index .. 'T'

        local active = index == vim.fn.tabpagenr()

        local tabline_items = {
            utils.get_item('TabLineSeparator', options.separator, active),             -- Left separator
            utils.get_item('TabLinePadding', padding, active),                         -- Padding
            icons.get_devicon(active, filename, extension),                            -- DevIcon
            utils.get_item('TabLine', filename, active, true),                         -- Filename
            utils.get_item('TabLinePadding', padding, active),                         -- Padding
            icons.get_modified_icon('TabLineModified', active, bufmodified),           -- Modified icon
            icons.get_close_icon('TabLineClose', index, bufmodified),                  -- Closing icon
            icons.get_right_separator('TabLineSeparator', index, opt.right_separator), -- Rigth separator
        }
        s = s .. table.concat(tabline_items)
    end
    return s
end

M.setup = function(user_options)
    opt = vim.tbl_extend('force', opt, user_options)

    function _G.nvim_tabline()
        return tabline(opt)
    end

    if opt.always_show_tabs then
        vim.o.showtabline = 2
    else
        vim.o.showtabline = 1
    end
    vim.o.tabline = "%!v:lua.nvim_tabline()"

    vim.g.loaded_nvim_tabline = 1
end

return M
