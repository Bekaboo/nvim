local utils = require('colors.nvim-falcon.utils')
local plt = utils.reload('colors.nvim-falcon.palette')
local sch = {}

-- Common highlight groups
sch.Normal       = { fg = plt.smoke, bg = plt.jeans } -- Normal text
sch.NormalFloat  = { fg = sch.smoke } -- Normal text in floating windows.
sch.NormalNC     = { link = 'Normal' } -- normal text in non-current windows
sch.ColorColumn  = { link = 'CursorColumn' } -- Columns set with 'colorcolumn'
sch.Conceal      = { fg = plt.smoke } -- Placeholder characters substituted for concealed text (see 'conceallevel')
sch.Cursor       = { fg = plt.space, bg = plt.white } -- Character under the cursor
sch.CursorColumn = { bg = plt.deepsea } -- Screen-column at the cursor, when 'cursorcolumn' is set.
sch.CursorIM     = { bg = plt.flashlight, fg = plt.black } -- Like Cursor, but used when in IME mode |CursorIM|
sch.CursorLine   = { bg = plt.ocean } -- Screen-line at the cursor, when 'cursorline' is set. Low-priority if foreground (ctermfg OR guifg) is not set.
sch.CursorLineNr = { fg = plt.orange, bg = plt.ocean, bold = true } -- Like LineNr when 'cursorline' or 'relativenumber' is set for the cursor line.
sch.lCursor      = { link = 'Cursor' } -- Character under the cursor when |language-mapping| is used (see 'guicursor')
sch.TermCursor   = { reverse = true } -- Cursor in a focused terminal
sch.TermCursorNC = { bg = plt.smoke } -- Cursor in an unfocused terminal
sch.DiffAdd      = { bg = plt.aqua_blend } -- Diff mode: Added line |diff.txt|
sch.DiffChange   = { bg = plt.purple_blend } -- Diff mode: Changed line |diff.txt|
sch.DiffDelete   = { fg = plt.wine } -- Diff mode: Deleted line |diff.txt|
sch.DiffText     = { bg = plt.lavender_blend } -- Diff mode: Changed text within a changed line |diff.txt|
sch.Directory    = { fg = plt.pigeon } -- Directory names (and other special names in listings)
sch.EndOfBuffer  = { fg = plt.iron } -- Filler lines (~) after the end of the buffer. By default, this is highlighted like |hl-NonText|.
sch.ErrorMsg     = { fg = plt.scarlet } -- Error messages on the command line
sch.FoldColumn   = { fg = plt.iron } -- 'foldcolumn'
sch.Folded       = { fg = plt.iron, italic = true } -- Line used for closed folds
sch.FloatBorder  = { fg = plt.smoke } -- Border of floating windows.
sch.Search       = { fg = plt.flashlight, bold = true } -- Last search pattern highlighting (see 'hlsearch'). Also used for similar items that need to stand out.
sch.IncSearch    = { fg = plt.black, bg = plt.flashlight, bold = true } -- 'incsearch' highlighting; also used for the text replaced with ':s///c'
sch.LineNr       = { fg = plt.steel } -- Line number for ':number' and ':#' commands, and when 'number' or 'relativenumber' option is set.
sch.ModeMsg      = { fg = plt.smoke } -- 'showmode' message (e.g., '-- INSERT -- ')
sch.MoreMsg      = { fg = plt.aqua } -- |more-prompt|
sch.MsgArea      = { link = 'Normal' } -- Area for messages and cmdline
sch.MsgSeparator = { link = 'StatusLine' } -- Separator for scrolled messages, `msgsep` flag of 'display'
sch.MatchParen   = { bg = plt.thunder, bold = true }
sch.NonText      = { fg = plt.iron } -- '@' at the end of the window, characters from 'showbreak' and other characters that do not really exist in the text (e.g., '>' displayed when a double-wide character doesn't fit at the end of the line). See also |hl-EndOfBuffer|.
sch.Pmenu        = { fg = sch.smoke } -- Popup menu: Normal item.
sch.PmenuSbar    = {} -- Popup menu: Scrollbar.
sch.PmenuSel     = { fg = plt.white, bg = plt.thunder } -- Popup menu: Selected item.
sch.PmenuThumb   = { bg = plt.orange } -- Popup menu: Thumb of the scrollbar.
sch.Question     = { fg = plt.smoke } -- |hit-enter| prompt and yes/no questions
sch.QuickFixLine = { link = 'Visual' } -- Current |quickfix| item in the quickfix window. Combined with |hl-CursorLine| when the cursor is there.
sch.SignColumn   = { fg = plt.smoke } -- Column where |signs| are displayed
sch.SpecialKey   = { fg = plt.iron } -- Unprintable characters: text displayed differently from what it really is. But not 'listchars' whitespace. |hl-Whitespace|
sch.SpellBad     = { underdotted = true } -- Word that is not recognized by the spellchecker. |spell| Combined with the highlighting used otherwise.
sch.SpellCap     = { link = 'SpellBad' } -- Word that should start with a capital. |spell| Combined with the highlighting used otherwise.
sch.SpellLocal   = { link = 'SpellBad' } -- Word that is recognized by the spellchecker as one that is used in another region. |spell| Combined with the highlighting used otherwise.
sch.SpellRare    = { link = 'SpellBad' } -- Word that is recognized by the spellchecker as one that is hardly ever used. |spell| Combined with the highlighting used otherwise.
sch.StatusLine   = { bg = plt.deepsea } -- Status line of current window
sch.StatusLineNC = { bg = plt.space } -- Status lines of not-current windows. Note: If this is equal to 'StatusLine' Vim will use '^^^' in the status line of the current window.
sch.Substitute   = { link = 'Search' } -- |:substitute| replacement text highlighting
sch.TabLine      = { link = 'StatusLine' } -- Tab pages line, not active tab page label
sch.Title        = { fg = plt.pigeon, bold = true } -- Titles for output from ':set all', ':autocmd' etc.
sch.VertSplit    = { fg = plt.deepsea } -- Column separating vertically split windows
sch.Visual       = { bg = plt.deepsea } -- Visual mode selection
sch.VisualNOS    = { link = 'Visual' } -- Visual mode selection when vim is 'Not Owning the Selection'.
sch.WarningMsg   = { fg = plt.yellow } -- Warning messages
sch.Whitespace   = { link = 'SpecialKey' } -- 'nbsp', 'space', 'tab' and 'trail' in 'listchars'
sch.WildMenu     = { link = 'PmenuSel' } -- Current match in 'wildmenu' completion
sch.Winseparator = { link = 'VertSplit' } -- Separator between window splits. Inherts from |hl-VertSplit| by default, which it will replace eventually.

-- Syntax highlighting
sch.Comment        = { fg = plt.steel } -- Any comment
sch.Constant       = { fg = plt.turquoise } -- (*) Any constant
sch.String         = { fg = plt.turquoise } --   A string constant: 'this is a string'
sch.Character      = { fg = plt.orange } --   A character constant: 'c', '\n'
sch.Number         = { fg = plt.purple } --   A number constant: 234, 0xff
sch.Boolean        = { link = 'Constant' } --   A boolean     constant: TRUE, false
sch.Array          = { fg = plt.orange }
sch.Float          = { link = 'Number' } --   A floating point constant: 2.3e10
sch.Identifier     = { fg = plt.pigeon } -- (*) Any variable name
sch.Function       = { fg = plt.yellow } --   Function name (also: methods for classes)
sch.Statement      = { fg = plt.smoke } -- (*) Any statement
sch.Object         = { fg = plt.lavender } -- (*) Any statement
sch.Conditional    = { fg = plt.magenta } --   if, then, else, endif, switch, etc.
sch.Repeat         = { fg = plt.magenta } --   for, do, while, etc.
sch.Label          = { fg = plt.magenta } --   case, default, etc.
sch.Operator       = { fg = plt.orange } --   'sizeof', '+', '*', etc.
sch.Keyword        = { fg = plt.cerulean } --   any other keyword
sch.Exception      = { fg = plt.magenta } --   try, catch, throw
sch.PreProc        = { fg = plt.turquoise } -- (*) Generic Preprocessor
sch.PreCondit      = { link = 'PreProc' } --   Preprocessor #if, #else, #endif, etc.
sch.Include        = { link = 'PreProc' } --   Preprocessor #include
sch.Define         = { link = 'PreProc' } --   Preprocessor #define
sch.Macro          = { link = 'PreProc' } --   Same as Define
sch.Type           = { fg = plt.lavender } -- (*) int, long, char, etc.
sch.StorageClass   = { link = 'Keyword' } --   static, register, volatile, etc.
sch.Structure      = { link = 'Type' } --   struct, union, enum, etc.
sch.Typedef        = { fg = plt.beige } --   A typedef
sch.Special        = { fg = plt.orange } -- (*) Any special symbol
sch.SpecialChar    = { link = 'Special' } --   Special character in a constant
sch.Tag            = { fg = plt.flashlight, underline = true } --   You can use CTRL-] on this
sch.Delimiter      = { fg = plt.orange } --   Character that needs attention
sch.SpecialComment = { link = 'SpecialChar' } --   Special things inside a comment (e.g. '\n')
sch.Debug          = { link = 'Special' } --   Debugging statements
sch.Underlined     = { underline = true } -- Text that stands out, HTML links
sch.Ignore         = { fg = plt.iron } -- Left blank, hidden |hl-Ignore| (NOTE: May be invisible here in template)
sch.Error          = { fg = plt.scarlet } -- Any erroneous construct
sch.Todo           = { fg = plt.black, bg = plt.beige, bold = true } -- Anything that needs extra attention; mostly the keywords TODO FIXME and XXX

-- LSP Highlighting
sch.LspReferenceText            = { link = 'Identifier' } -- Used for highlighting 'text' references
sch.LspReferenceRead            = { link = 'LspReferenceText' } -- Used for highlighting 'read' references
sch.LspReferenceWrite           = { link = 'LspReferenceText' } -- Used for highlighting 'write' references
sch.LspSignatureActiveParameter = { link = 'IncSearch' } -- Used to highlight the active parameter in the signature help. See |vim.lsp.handlers.signature_help()|.
sch.LspInfoBorder               = { link = 'FloatBorder' } -- Used to color the border of the info box

-- Diagnostic highlighting
sch.DiagnosticError            = { fg = plt.wine } -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
sch.DiagnosticWarn             = { fg = plt.earth } -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
sch.DiagnosticInfo             = { fg = plt.smoke } -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
sch.DiagnosticHint             = { fg = plt.pigeon } -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
sch.DiagnosticVirtualTextError = { fg = plt.wine, bg = plt.wine_blend } -- Used for 'Error' diagnostic virtual text.
sch.DiagnosticVirtualTextWarn  = { fg = plt.earth, bg = plt.earth_blend } -- Used for 'Warn' diagnostic virtual text.
sch.DiagnosticVirtualTextInfo  = { fg = plt.smoke, bg = plt.smoke_blend } -- Used for 'Info' diagnostic virtual text.
sch.DiagnosticVirtualTextHint  = { fg = plt.pigeon, bg = plt.pigeon_blend } -- Used for 'Hint' diagnostic virtual text.
sch.DiagnosticUnderlineError   = { undercurl = true, sp = plt.wine } -- Used to underline 'Error' diagnostics.
sch.DiagnosticUnderlineWarn    = { undercurl = true, sp = plt.earth } -- Used to underline 'Warn' diagnostics.
sch.DiagnosticUnderlineInfo    = { undercurl = true, sp = plt.flashlight } -- Used to underline 'Info' diagnostics.
sch.DiagnosticUnderlineHint    = { undercurl = true, sp = plt.white } -- Used to underline 'Hint' diagnostics.
sch.DiagnosticFloatingError    = { link = 'DiagnosticError' } -- Used to color 'Error' diagnostic messages in diagnostics float. See |vim.diagnostic.open_float()|
sch.DiagnosticFloatingWarn     = { link = 'DiagnosticWarn' } -- Used to color 'Warn' diagnostic messages in diagnostics float.
sch.DiagnosticFloatingInfo     = { link = 'DiagnosticInfo' } -- Used to color 'Info' diagnostic messages in diagnostics float.
sch.DiagnosticFloatingHint     = { link = 'DiagnosticHint' } -- Used to color 'Hint' diagnostic messages in diagnostics float.
sch.DiagnosticSignError        = { link = 'DiagnosticError' } -- Used for 'Error' signs in sign column.
sch.DiagnosticSignWarn         = { link = 'DiagnosticWarn' } -- Used for 'Warn' signs in sign column.
sch.DiagnosticSignInfo         = { link = 'DiagnosticInfo' } -- Used for 'Info' signs in sign column.
sch.DiagnosticSignHint         = { link = 'DiagnosticHint' } -- Used for 'Hint' signs in sign column.

sch.rainbowcol1               = { fg = plt.smoke } -- default light is too bright
sch['@field']                 = { fg = plt.smoke }
sch['@property']              = { fg = plt.smoke }
sch['@annotation']            = { link = 'Operator' }
sch['@comment']               = { link = 'Comment' }
sch['@none']                  = { bg = 'NONE', fg = 'NONE' }
sch['@preproc']               = { link = 'PreProc' }
sch['@define']                = { link = 'Define' }
sch['@operator']              = { link = 'Operator' }
sch['@punctuation.delimiter'] = { link = 'Delimiter' }
sch['@punctuation.bracket']   = { fg = plt.smoke }
sch['@punctuation.special']   = { link = 'Delimiter' }
sch['@string']                = { link = 'String' }
sch['@string.regex']          = { link = 'String' }
sch['@string.escape']         = { link = 'SpecialChar' }
sch['@string.special']        = { link = 'SpecialChar' }
sch['@character']             = { link = 'Character' }
sch['@character.special']     = { link = 'SpecialChar' }
sch['@boolean']               = { link = 'Boolean' }
sch['@number']                = { link = 'Number' }
sch['@float']                 = { link = 'Float' }
sch['@function']              = { link = 'Function' }
sch['@function.call']         = { link = 'Function' }
sch['@function.builtin']      = { link = 'Special' }
sch['@function.macro']        = { link = 'Macro' }
sch['@method']                = { link = 'Function' }
sch['@method.call']           = { link = 'Function' }
sch['@constructor']           = { link = 'Special' }
sch['@parameter']             = { link = 'Identifier' }
sch['@keyword']               = { link = 'Keyword' }
sch['@keyword.function']      = { link = 'Keyword' }
sch['@keyword.return']        = { link = 'Keyword' }
sch['@conditional']           = { link = 'Conditional' }
sch['@repeat']                = { link = 'Repeat' }
sch['@debug']                 = { link = 'Debug' }
sch['@label']                 = { link = 'Keyword' }
sch['@include']               = { link = 'Include' }
sch['@exception']             = { link = 'Exception' }
sch['@type']                  = { link = 'Type' }
sch['@type.builtin']          = { link = 'Type' }
sch['@type.qualifier']        = { link = 'Type' }
sch['@type.definition']       = { link = 'Typedef' }
sch['@storageclass']          = { link = 'StorageClass' }
sch['@attribute']             = { link = 'PreProc' }
sch['@field']                 = { link = 'Identifier' }
sch['@property']              = { link = 'Identifier' }
sch['@variable']              = { link = 'Variable' }
sch['@variable.builtin']      = { link = 'Special' }
sch['@constant']              = { link = 'Constant' }
sch['@constant.builtin']      = { link = 'Special' }
sch['@constant.macro']        = { link = 'Macro' }
sch['@namespace']             = { fg = plt.ochre }
sch['@symbol']                = { link = 'Identifier' }
sch['@text']                  = { link = 'String' }
sch['@text.title']            = { link = 'Title' }
sch['@text.literal']          = { link = 'String' }
sch['@text.uri']              = { link = 'Underlined' }
sch['@text.math']             = { link = 'Special' }
sch['@text.environment']      = { link = 'Macro' }
sch['@text.environment.name'] = { link = 'Type' }
sch['@text.reference']        = { link = 'Constant' }
sch['@text.todo']             = { link = 'Todo' }
sch['@text.todo.unchecked']   = { link = 'Todo' }
sch['@text.todo.checked']     = { link = 'Done' }
sch['@text.note']             = { link = 'SpecialComment' }
sch['@text.warning']          = { link = 'WarningMsg' }
sch['@text.danger']           = { link = 'ErrorMsg' }
sch['@text.diff.add']         = { link = 'DiffAdded' }
sch['@text.diff.delete']      = { link = 'DiffRemoved' }
sch['@tag']                   = { link = 'Tag' }
sch['@tag.attribute']         = { link = 'Identifier' }
sch['@tag.delimiter']         = { link = 'Delimiter' }
sch['@text.strong']           = { bold = true }
sch['@text.strike']           = { strikethrough = true }
sch['@text.emphasis']         = { fg = plt.black, bg = plt.beige, bold = true, italic = true }
sch['@text.underline']        = { underline = true }
sch['@keyword.operator']      = { link = 'Operator' }

-- HTML
sch.htmlArg            = { fg = plt.pigeon }
sch.htmlBold           = { bold = true }
sch.htmlTag            = { fg = plt.smoke }
sch.htmlTagName        = { link = 'Tag' }
sch.htmlSpecialTagName = { fg = plt.yellow }
sch.htmlEndTag         = { fg = plt.yellow }
sch.htmlH1             = { fg = plt.yellow, bold = true }
sch.htmlH2             = { fg = plt.tea, bold = true }
sch.htmlH3             = { fg = plt.skyblue, bold = true }
sch.htmlH4             = { fg = plt.lavender, bold = true }
sch.htmlH5             = { fg = plt.purple, bold = true }
sch.htmlH6             = { fg = plt.pink, bold = true }
sch.htmlItalic         = { italic = true }
sch.htmlLink           = { fg = plt.flashlight, underline = true }
sch.htmlSpecialChar    = { fg = plt.beige }
sch.htmlTitle          = { fg = plt.pigeon }
-- Json
sch.jsonKeyword        = { link = 'Keyword' }
sch.jsonBraces         = { fg = plt.smoke }

-- Plugin highlights
-- nvim-cmp
sch.CmpItemAbbr            = { fg = plt.smoke }
sch.CmpItemAbbrDeprecated  = { strikethrough = true }
sch.CmpItemAbbrMatch       = { fg = plt.white }
sch.CmpItemAbbrMatchFuzzy  = { link = 'CmpItemAbbrMatch' }
sch.CmpItemKindText        = { link = 'String' }
sch.CmpItemKindMethod      = { link = 'Function' }
sch.CmpItemKindFunction    = { link = 'Function' }
sch.CmpItemKindConstructor = { link = 'Function' }
sch.CmpItemKindField       = { fg = plt.purple }
sch.CmpItemKindProperty    = { link = 'CmpItemKindField' }
sch.CmpItemKindVariable    = { fg = plt.aqua }
sch.CmpItemKindReference   = { link = 'CmpItemKindVariable' }
sch.CmpItemKindModule      = { fg = plt.magenta }
sch.CmpItemKindEnum        = { fg = plt.ochre }
sch.CmpItemKindEnumMember  = { link = 'CmpItemKindEnum' }
sch.CmpItemKindKeyword     = { link = 'Keyword' }
sch.CmpItemKindOperator    = { link = 'Operator' }
sch.CmpItemKindSnippet     = { fg = plt.tea }
sch.CmpItemKindColor       = { fg = plt.pink }
sch.CmpItemKindConstant    = { link = 'Constant' }
sch.CmpItemKindCopilot     = { fg = plt.magenta }
sch.CmpItemKindValue       = { link = 'Number' }
sch.CmpItemKindClass       = { link = 'Type' }
sch.CmpItemKindStruct      = { link = 'Type' }
sch.CmpItemKindEvent       = { fg = plt.flashlight }
sch.CmpItemKindInterface   = { fg = plt.flashlight }
sch.CmpItemKindFile        = { fg = plt.smoke }
sch.CmpItemKindFolder      = { fg = plt.pigeon }
sch.CmpItemKind            = { fg = plt.smoke }
sch.CmpItemMenu            = { fg = plt.smoke }

-- gitsigns
sch.GitSignsAdd                = { fg = plt.tea }
sch.GitSignsDelete             = { fg = plt.scarlet }
sch.GitSignsChange             = { fg = plt.lavender }
sch.GitSignsCurrentLineBlame   = { fg = plt.turquoise }
sch.GitSignsAddInline          = { fg = plt.tea, bg = plt.tea_blend }
sch.GitSignsAddLnInline        = { fg = plt.tea, bg = plt.tea_blend }
sch.GitSignsChangeInline       = { fg = plt.lavender, bg = plt.lavender_blend }
sch.GitSignsChangeLnInline     = { fg = plt.lavender, bg = plt.lavender_blend }
sch.GitSignsDeleteInline       = { fg = plt.scarlet, bg = plt.scarlet_blend }
sch.GitSignsDeleteLnInline     = { fg = plt.scarlet, bg = plt.scarlet_blend }
sch.GitSignsDeleteVirtLnInLine = { fg = plt.scarlet, bg = plt.scarlet_blend }
sch.GitSignsDeletePreview      = { fg = plt.scarlet, bg = plt.wine_blend }

-- barbar
sch.BufferCurrent        = { fg = plt.smoke }
sch.BufferCurrentIndex   = { fg = plt.orange, bold = true }
sch.BufferCurrentMod     = { fg = plt.orange, bold = true }
sch.BufferCurrentSign    = { fg = plt.orange }
sch.BufferInactive       = { fg = plt.pigeon, bg = plt.deepsea }
sch.BufferInactiveIcon   = { link = 'StatusLine' }
sch.BufferInactiveIndex  = { fg = plt.pigeon, bg = plt.deepsea }
sch.BufferInactiveMod    = { fg = plt.wine, bg = plt.deepsea }
sch.BufferInactiveSign   = { fg = plt.pigeon, bg = plt.deepsea }
sch.BufferInactiveTarget = { fg = plt.wine, bg = plt.deepsea }
sch.BufferVisible        = { fg = plt.pigeon }
sch.BufferVisibleIndex   = { fg = plt.pigeon }
sch.BufferVisibleMod     = { fg = plt.orange }
sch.BufferTabpageFill    = { fg = plt.pigeon, bg = plt.ocean }

-- telescope
sch.TelescopeNormal         = { link = 'NormalFloat' }
sch.TelescopeBorder         = { link = 'FloatBorder' }
sch.TelescopeSelection      = { bg = plt.thunder }
sch.TelescopeMultiSelection = { bg = plt.thunder, bold = true }
sch.TelescopePreviewLine    = { bg = plt.thunder }
sch.TelescopeMatching       = { link = 'Search' }
sch.TelescopePromptCounter  = { link = 'Comment' }
sch.TelescopePromptPrefix   = { fg = plt.orange }
sch.TelescopeSelectionCaret = { fg = plt.orange, bg = plt.thunder }

-- nvim-navic
sch.NavicIconsFile          = { link = 'File' }
sch.NavicIconsModule        = { link = 'CmpItemKindModule' }
sch.NavicIconsNamespace     = { fg = plt.ochre }
sch.NavicIconsPackage       = { link = 'CmpItemKindModule' }
sch.NavicIconsClass         = { link = 'CmpItemKindClass' }
sch.NavicIconsMethod        = { link = 'CmpItemKindMethod' }
sch.NavicIconsProperty      = { link = 'CmpItemKindProperty' }
sch.NavicIconsField         = { link = 'CmpItemKindField' }
sch.NavicIconsConstructor   = { link = 'CmpItemKindConstructor' }
sch.NavicIconsEnum          = { link = 'CmpItemKindEnum' }
sch.NavicIconsInterface     = { link = 'CmpItemKindInterface' }
sch.NavicIconsFunction      = { link = 'Function' }
sch.NavicIconsVariable      = { link = 'CmpItemKindVariable' }
sch.NavicIconsConstant      = { link = 'Constant' }
sch.NavicIconsString        = { link = 'String' }
sch.NavicIconsNumber        = { link = 'Number' }
sch.NavicIconsBoolean       = { link = 'Boolean' }
sch.NavicIconsArray         = { link = 'Array' }
sch.NavicIconsObject        = { link = 'Object' }
sch.NavicIconsKey           = { link = 'Keyword' }
sch.NavicIconsNull          = { link = 'Constant' }
sch.NavicIconsEnumMember    = { link = 'CmpItemKindEnumMember' }
sch.NavicIconsStruct        = { link = 'CmpItemKindStruct' }
sch.NavicIconsEvent         = { link = 'CmpItemKindEvent' }
sch.NavicIconsOperator      = { link = 'Operator' }
sch.NavicIconsTypeParameter = { link = 'CmpItemKind' }
sch.NavicPath               = { fg = plt.smoke }
sch.NavicText               = { fg = plt.smoke }
sch.NavicSeparator          = { fg = plt.orange }

-- aerial
sch.AerialLine              = { fg = plt.white, bg = plt.thunder, bold = true }
sch.AerialArrayIcon         = { link = 'Array' }
sch.AerialBooleanIcon       = { link = 'Boolean' }
sch.AerialClassIcon         = { link = 'CmpItemKindClass' }
sch.AerialConstantIcon      = { link = 'CmpItemKindConstant' }
sch.AerialConstructorIcon   = { link = 'CmpItemKindConstructor' }
sch.AerialEnumIcon          = { link = 'CmpItemKindEnum' }
sch.AerialEnumMemberIcon    = { link = 'CmpItemKindEnumMember' }
sch.AerialEventIcon         = { link = 'CmpItemKindEvent' }
sch.AerialFieldIcon         = { link = 'CmpItemKindField' }
sch.AerialFileIcon          = { link = 'CmpItemKindFile' }
sch.AerialFunctionIcon      = { link = 'CmpItemKindFunction' }
sch.AerialInterfaceIcon     = { link = 'CmpItemKindInterface' }
sch.AerialKeyIcon           = { link = 'CmpItemKindKeyword' }
sch.AerialMethodIcon        = { link = 'CmpItemKindMethod' }
sch.AerialModuleIcon        = { link = 'CmpItemKindModule' }
sch.AerialNamespaceIcon     = { link = '@namespace' }
sch.AerialNullIcon          = { link = 'Boolean' }
sch.AerialNumberIcon        = { link = 'CmpItemKindValue' }
sch.AerialObjectIcon        = { link = 'Object' }
sch.AerialOperatorIcon      = { link = 'CmpItemKindOperator' }
sch.AerialPackageIcon       = { link = 'CmpItemKindModule' }
sch.AerialPropertyIcon      = { link = 'CmpItemKindProperty' }
sch.AerialStringIcon        = { link = 'CmpItemKindText' }
sch.AerialStructIcon        = { link = 'CmpItemKindStruct' }
sch.AerialTypeParameterIcon = { link = 'CmpItemKind' }
sch.AerialVariableIcon      = { link = 'CmpItemKindVariable' }

-- fidget
sch.FidgetTitle = { link = 'Title' }
sch.FidgetTask  = { link = 'Comment' }

-- mini.indentscope
sch.MiniIndentscopeSymbol = { fg = plt.pigeon }

-- nvim-dap-ui
sch.DapUIBreakpointsCurrentLine = { link = 'CursorLineNr' }
sch.DapUIBreakpointsInfo        = { fg = plt.tea }
sch.DapUIBreakpointsPath        = { link = 'Directory' }
sch.DapUICurrentFrameName       = { fg = plt.tea, bold = true }
sch.DapUIDecoration             = { fg = plt.yellow }
sch.DapUIFloatBorder            = { link = 'FloatBorder' }
sch.DapUILineNumber             = { link = 'LineNr' }
sch.DapUIModifiedValue          = { fg = plt.skyblue, bold = true }
sch.DapUIPlayPause              = { fg = plt.tea }
sch.DapUIPlayPauseNC            = { fg = plt.tea }
sch.DapUIRestart                = { fg = plt.tea }
sch.DapUIRestartNC              = { fg = plt.tea }
sch.DapUIScope                  = { fg = plt.orange }
sch.DapUISource                 = { link = 'Directory' }
sch.DapUIStepBack               = { fg = plt.lavender }
sch.DapUIStepBackRC             = { fg = plt.lavender }
sch.DapUIStepInto               = { fg = plt.lavender }
sch.DapUIStepIntoRC             = { fg = plt.lavender }
sch.DapUIStepOut                = { fg = plt.lavender }
sch.DapUIStepOutRC              = { fg = plt.lavender }
sch.DapUIStepOver               = { fg = plt.lavender }
sch.DapUIStepOverRC             = { fg = plt.lavender }
sch.DapUIStop                   = { fg = plt.scarlet }
sch.DapUIStopNC                 = { fg = plt.scarlet }
sch.DapUIStoppedThread          = { fg = plt.tea }
sch.DapUIThread                 = { fg = plt.aqua }
sch.DapUIType                   = { link = 'Type' }
sch.DapUIVariable               = { link = 'Variable' }
sch.DapUIWatchesEmpty           = { link = 'Comment' }
sch.DapUIWatchesError           = { link = 'Error' }
sch.DapUIWatchesValue           = { fg = plt.orange }

-- vimtex
sch.texArg                = { fg = plt.pigeon }
sch.texArgNew             = { fg = plt.skyblue }
sch.texCmd                = { fg = plt.yellow }
sch.texCmdBib             = { link = 'texCmd' }
sch.texCmdClass           = { link = 'texCmd' }
sch.texCmdDef             = { link = 'texCmd' }
sch.texCmdE3              = { link = 'texCmd' }
sch.texCmdEnv             = { link = 'texCmd' }
sch.texCmdEnvM            = { link = 'texCmd' }
sch.texCmdError           = { link = 'ErrorMsg' }
sch.texCmdFatal           = { link = 'ErrorMsg' }
sch.texCmdGreek           = { link = 'texCmd' }
sch.texCmdInput           = { link = 'texCmd' }
sch.texCmdItem            = { link = 'texCmd' }
sch.texCmdLet             = { link = 'texCmd' }
sch.texCmdMath            = { link = 'texCmd' }
sch.texCmdNew             = { link = 'texCmd' }
sch.texCmdPart            = { link = 'texCmd' }
sch.texCmdRef             = { link = 'texCmd' }
sch.texCmdSize            = { link = 'texCmd' }
sch.texCmdStyle           = { link = 'texCmd' }
sch.texCmdTitle           = { link = 'texCmd' }
sch.texCmdTodo            = { link = 'texCmd' }
sch.texCmdType            = { link = 'texCmd' }
sch.texCmdVerb            = { link = 'texCmd' }
sch.texComment            = { link = 'Comment' }
sch.texDefParm            = { link = 'Keyword' }
sch.texDelim              = { fg = plt.pigeon }
sch.texE3Cmd              = { link = 'texCmd' }
sch.texE3Delim            = { link = 'texDelim' }
sch.texE3Opt              = { link = 'texOpt' }
sch.texE3Parm             = { link = 'texParm' }
sch.texE3Type             = { link = 'texCmd' }
sch.texEnvOpt             = { link = 'texOpt' }
sch.texError              = { link = 'ErrorMsg' }
sch.texFileArg            = { link = 'Directory' }
sch.texFileOpt            = { link = 'texOpt' }
sch.texFilesArg           = { link = 'texFileArg' }
sch.texFilesOpt           = { link = 'texFileOpt' }
sch.texLength             = { fg = plt.lavender }
sch.texLigature           = { fg = plt.pigeon }
sch.texOpt                = { fg = plt.smoke }
sch.texOptEqual           = { fg = plt.orange }
sch.texOptSep             = { fg = plt.orange }
sch.texParm               = { fg = plt.pigeon }
sch.texRefArg             = { fg = plt.lavender }
sch.texRefOpt             = { link = 'texOpt' }
sch.texSymbol             = { fg = plt.orange }
sch.texTitleArg           = { link = 'Title' }
sch.texVerbZone           = { fg = plt.pigeon }
sch.texZone               = { fg = plt.aqupigeon }
sch.texMathArg            = { fg = plt.pigeon }
sch.texMathCmd            = { link = 'texCmd' }
sch.texMathSub            = { fg = plt.pigeon }
sch.texMathOper           = { fg = plt.orange }
sch.texMathZone           = { fg = plt.yellow }
sch.texMathDelim          = { fg = plt.smoke }
sch.texMathError          = { link = 'Error' }
sch.texMathGroup          = { fg = plt.pigeon }
sch.texMathSuper          = { fg = plt.pigeon }
sch.texMathSymbol         = { fg = plt.yellow }
sch.texMathZoneLD         = { fg = plt.pigeon }
sch.texMathZoneLI         = { fg = plt.pigeon }
sch.texMathZoneTD         = { fg = plt.pigeon }
sch.texMathZoneTI         = { fg = plt.pigeon }
sch.texMathCmdText        = { link = 'texCmd' }
sch.texMathZoneEnv        = { fg = plt.pigeon }
sch.texMathArrayArg       = { fg = plt.yellow }
sch.texMathCmdStyle       = { link = 'texCmd' }
sch.texMathDelimMod       = { fg = plt.smoke }
sch.texMathSuperSub       = { fg = plt.smoke }
sch.texMathDelimZone      = { fg = plt.pigeon }
sch.texMathStyleBold      = { fg = plt.smoke, bold = true }
sch.texMathStyleItal      = { fg = plt.smoke, italic = true }
sch.texMathEnvArgName     = { fg = plt.lavender }
sch.texMathErrorDelim     = { link = 'Error' }
sch.texMathDelimZoneLD    = { fg = plt.steel }
sch.texMathDelimZoneLI    = { fg = plt.steel }
sch.texMathDelimZoneTD    = { fg = plt.steel }
sch.texMathDelimZoneTI    = { fg = plt.steel }
sch.texMathZoneEnsured    = { fg = plt.pigeon }
sch.texMathCmdStyleBold   = { fg = plt.yellow, bold = true }
sch.texMathCmdStyleItal   = { fg = plt.yellow, italic = true }
sch.texMathStyleConcArg   = { fg = plt.pigeon }
sch.texMathZoneEnvStarred = { fg = plt.pigeon }


-- Extra highlight groups
sch.Yellow     = { fg = plt.yellow }
sch.Earth      = { fg = plt.earth }
sch.Orange     = { fg = plt.orange }
sch.Scarlet    = { fg = plt.scarlet }
sch.Ochre      = { fg = plt.ochre }
sch.Wine       = { fg = plt.wine }
sch.Pink       = { fg = plt.pink }
sch.Tea        = { fg = plt.tea }
sch.Flashlight = { fg = plt.flashlight }
sch.Aqua       = { fg = plt.aqua }
sch.Cerulean   = { fg = plt.cerulean }
sch.SkyBlue    = { fg = plt.skyblue }
sch.Turquoise  = { fg = plt.turquoise }
sch.Lavender   = { fg = plt.lavender }
sch.Magenta    = { fg = plt.magenta }
sch.Purple     = { fg = plt.purple }
sch.Thunder    = { fg = plt.thunder }
sch.White      = { fg = plt.white }
sch.Beige      = { fg = plt.beige }
sch.Pigeon     = { fg = plt.pigeon }
sch.Steel      = { fg = plt.steel }
sch.Smoke      = { fg = plt.smoke }
sch.Iron       = { fg = plt.iron }
sch.Deepsea    = { fg = plt.deepsea }
sch.Ocean      = { fg = plt.ocean }
sch.Space      = { fg = plt.space }
sch.Black      = { fg = plt.black }

return sch
