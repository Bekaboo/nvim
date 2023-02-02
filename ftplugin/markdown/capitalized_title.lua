local api = vim.api

---Given current line, determine if it is a title line
---@param current_line string current line
---@return boolean
local function on_title_line(current_line)
  return vim.bo.ft == 'markdown'
    and current_line:match('^#+') ~= nil
end

---Given current cursor position (column) and current line, determine if
---the cursor is on a word boundary
---@param line string current line
---@param col number current cursor position (column)
---@return boolean
local function on_word_boundary(line, col)
  local char_before = line:sub(col - 1, col - 1)
  if char_before:match('%w') then
    return false
  end
  return true
end

---Determine if a word is the first word on a line
---@param line string the line where the word is located
---@param col number current cursor position (column)
---@param word string word to check
---@return boolean
local function first_word(line, col, word)
  local text_before = line:sub(1, col - #word - 1)
  if text_before:match('%w') then
    return false
  end
  return true
end

---Given current cursor position (column) and current line, correct
---the word before the cursor if it should be in lower case
---@param line string current line
---@param col number current cursor position (column)
local function correct_word_before(line, col)
  local word_before = line:sub(1, col - 1):match('%w+$')
  if word_before ~= nil
    and #word_before < 4
    and not first_word(line, col, word_before)
    and not word_before:match('^%u%u+$')
  then
    word_before = word_before:lower()
    line = line:sub(1, col - #word_before - 1)
            .. word_before
            .. line:sub(col)
    api.nvim_set_current_line(line)
  end
end

---Capitalize the first letter of words on title line
local function format_title()
  local col = api.nvim_win_get_cursor(0)[2]
  local line = api.nvim_get_current_line()
  local char_current = line:sub(col, col)

  if not on_title_line(line) then
    return
  end

  if on_word_boundary(line, col)
    and char_current:match('%a')
  then
    line = line:sub(1, col - 1)
            .. string.upper(line:sub(col, col))
            .. line:sub(col + 1)
    api.nvim_set_current_line(line)
  elseif char_current:match('%W') and char_current ~= '-' then
    correct_word_before(line, col)
  end
end

api.nvim_create_autocmd('TextChangedI', {
  callback = format_title,
})
