local snap = require'snap'

local fzf = snap.get'consumer.fzf'
local limit = snap.get'consumer.limit'
local producer_file = snap.get'producer.ripgrep.file'
local producer_vimgrep = snap.get'producer.ripgrep.vimgrep'
local producer_buffer = snap.get'producer.vim.buffer'
local select_file = snap.get'select.file'
local select_vimgrep = snap.get'select.vimgrep'
local preview_file = snap.get'preview.file'
local preview_vimgrep = snap.get'preview.vimgrep'

snap.register.map({'n'}, {'<C-f>'}, function ()
  snap.run({
    prompt = 'Files',
    producer = fzf(producer_file),
    select = select_file.select,
    multiselect = select_file.multiselect,
    views = {preview_file}
  })
end)

snap.register.map({'n'}, {'<Leader>fg'}, function ()
  snap.run({
    prompt = 'Grep',
    producer = limit(10000, producer_vimgrep),
    select = select_vimgrep.select,
    multiselect = select_vimgrep.multiselect,
    views = {preview_vimgrep}
  })
end)

snap.register.map({'n'}, {'<Leader>fb'}, function ()
  snap.run({
    prompt = 'Buffers',
    producer = fzf(producer_buffer),
    select = select_file.select,
    multiselect = select_file.multiselect,
    views = {preview_file}
  })
end)

