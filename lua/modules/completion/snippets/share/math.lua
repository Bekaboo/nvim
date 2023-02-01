local funcs = require('modules.completion.snippets.utils.funcs')
local ifn = funcs.ifn
local fn = vim.fn
local ls = require('luasnip')
local ls_types = require('luasnip.util.types')
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require('luasnip.extras').lambda
local rep = require('luasnip.extras').rep
local p = require('luasnip.extras').partial
local m = require('luasnip.extras').match
local n = require('luasnip.extras').nonempty
local dl = require('luasnip.extras').dynamic_lambda
local fmt = require('luasnip.extras.fmt').fmt
local fmta = require('luasnip.extras.fmt').fmta
local types = require('luasnip.util.types')
local conds = require('luasnip.extras.expand_conditions')

local math_snippets = {
  snip = funcs.add_attr({ condition = funcs.in_mathzone, wordTrig = false }, {
    s({ trig = '(%a)(%d)', regTrig = true }, {
      d(1, function(_, snip)
        local symbol = snip.captures[1]
        local subscript = snip.captures[2]
        return sn(nil, { t(symbol), t '_', t(subscript) })
      end),
    }),
    s({ trig = '(.*%))//', regTrig = true }, {
      d(1, function(_, snip)
        local captured = vim.trim(snip.captures[1])
        if captured == nil or not captured:match('%S') then
          return sn(nil, { t '\\frac{', i(1), t '}{', i(2), t '}' })
        end

        local idx = #captured
        local depth = 0
        while idx > 0 do
          local char = captured:sub(idx, idx)
          if char == ')' then
            depth = depth + 1
          elseif char == '(' then
            depth = depth - 1
          end
          if depth == 0 then
            break
          end
          idx = idx - 1
        end

        if depth ~= 0 then
          return sn(nil, { t '\\frac{', i(1), t '}{', i(2), t '}' })
        end

        local numerator = captured:sub(idx + 1, -2)
        local prefix = ''
        if idx > 0 then
          prefix = captured:sub(1, idx - 1)
        end
        return sn(nil, { t(prefix), t '\\frac{', t(numerator), t '}{', i(1), t '}' })
      end),
      i(0),
    }),
    s({ trig = '(\\%w+{%S+})//', regTrig = true }, {
      d(1, function(_, snip)
        return sn(nil, { t '\\frac{', t(snip.captures[1]),
          t '}{', i(1), t '}' })
      end),
      i(0),
    }),
    s({ trig = '(\\?%w*)//', regTrig = true }, {
      d(1, function(_, snip)
        local numerator = snip.captures[1]
        if numerator == nil or not numerator:match('%S') then
          return sn(nil, { t '\\frac{', i(1), t '}{', i(2), t '}' })
        end
        return sn(nil, { t '\\frac{', t(numerator), t '}{', i(1), t '}' })
      end),
      i(0),
    }),
    -- matrix/vector bold font
    s({ trig = ';(%a)', regTrig = true, priority = 999,
        dscr = 'vector bold math font' }, {
      d(1, function(_, snip)
        return sn(nil, { t(string.format('\\mathbf{%s}', snip.captures[1])) })
      end),
      i(0),
    }),
    -- matrix/vector
    s({ trig = 'rowv', dscr = 'row vector' },
      fmta('\\begin{bmatrix} <el><underscore>{0<mod>} & <el><underscore>{1<mod>} & \\ldots & <el><underscore>{<end_idx><mod>} \\end{bmatrix}', {
        el = i(1, 'a'),
        end_idx = i(2, 'N-1'),
        underscore = i(3, '_'),
        mod = i(4),
      }, { repeat_duplicates = true })
    ),
    s({ trig = 'colv', dscr = 'column vector' },
      fmta('\\begin{bmatrix} <el><underscore>{0<mod>} \\\\ <el><underscore>{1,<mod>} \\\\ \\vdots \\\\ <el><underscore>{<end_idx><mod>} \\end{bmatrix}', {
        el = i(1, 'a'),
        end_idx = i(2, 'N-1'),
        underscore = i(3, '_'),
        mod = i(4),
      }, { repeat_duplicates = true })
    ),
    s({ trig = 'mt', dscr = 'matrix' },
      fmta([[
\begin{bmatrix}
<indent><el><underscore>{<mod0><comma><mod1>} & <el><underscore>{<mod0><comma><mod1>} & \ldots & <el><underscore>{<mod0><comma><width>} \\
<indent><el><underscore>{<mod0><comma><mod1>} & <el><underscore>{<mod0><comma><mod1>} & \ldots & <el><underscore>{<mod0><comma><width>} \\
<indent>\vdots & \vdots & \ddots & \vdots \\
<indent><el><underscore>{<height><comma>0} & <el><underscore>{<height><comma>1} & \ldots & <el><underscore>{<height><comma><width>} \\
\end{bmatrix}
      ]], {
        indent = ifn(1),
        el = i(1, 'a'),
        height = i(2, 'N-1'),
        width = i(3, 'M-1'),
        underscore = i(4, '_'),
        comma = i(5, ','),
        mod0 = i(6, '0'),
        mod1 = i(7, '1'),
    }, { repeat_duplicates = true })),
    s({ trig = 'inf' }, { t '\\infty', i(0) }),
    s({ trig = 'prop' }, t '\\propto ', i(0)),
    s({ trig = 'deg' }, { t '\\degree', i(0) }),
    s({ trig = 'ang' }, { t '\\angle ', i(0) }),
    s({ trig = 'mcal' }, { t '\\mathcal{', i(1), t '}', i(0) }),
    s({ trig = 'msrc' }, { t '\\mathsrc{', i(1), t '}', i(0) }),
    s({ trig = 'mbb' }, { t '\\mathbb{', i(1), t '}', i(0) }),
    s({ trig = 'mbf' }, { t '\\mathbf{', i(1), t '}', i(0) }),
    s({ trig = 'mff' }, { t '\\mff{', i(1), t '}', i(0) }),
    s({ trig = 'mrm' }, { t '\\mathrm{', i(1), t '}', i(0) }),
    s({ trig = 'xx' }, { t '\\times ', i(0) }),
    s({ trig = '**' }, { t '\\cdot ', i(0) }),
    s({ trig = 'o*' }, { t '\\circledast ', i(0) }),
    s({ trig = 'dd' }, { t '\\mathrm{d}', i(0) }),

    s({ trig = '!=' }, { t '\\neq ', i(0) }),
    s({ trig = '==' }, { t '&= ', i(0) }),
    s({ trig = '&= =' }, { t '\\equiv ', i(0) }),
    s({ trig = '>=' }, { t '\\ge ', i(0) }),
    s({ trig = '<=' }, { t '\\le ', i(0) }),
    s({ trig = '<->', priority = 999 }, { t '\\leftrightarrow ', i(0) }),
    s({ trig = '\\le >', priority = 999 }, { t '\\Leftrightarrow ', i(0) }),
    s({ trig = '<--', priority = 999 }, { t '\\leftarrow ', i(0) }),
    s({ trig = '\\le =', priority = 999 }, { t '\\Leftarrow ', i(0) }),
    s({ trig = '-->', priority = 999 }, { t '\\rightarrow ', i(0) }),
    s({ trig = '&= >', priority = 999 }, { t '\\Rightarrow ', i(0) }),
    s({ trig = 'x<->' }, { t '\\xleftrightarrow[', i(1), t ']{', i(2), t '} ', i(0) }),
    s({ trig = 'x\\le >' }, { t '\\xLeftrightarrow[', i(1), t ']{', i(2), t '} ', i(0) }),
    s({ trig = 'x<--' }, { t '\\xleftarrow[', i(1), t ']{', i(2), t '} ', i(0) }),
    s({ trig = 'x\\le =' }, { t '\\xLeftarrow[', i(1), t ']{', i(2), t '} ', i(0) }),
    s({ trig = 'x-->' }, { t '\\xrightarrow[', i(1), t ']{', i(2), t '} ', i(0) }),
    s({ trig = 'x&= >' }, { t '\\xRightarrow[', i(1), t ']{', i(2), t '} ', i(0) }),
    s({ trig = '->', priority = 998 }, { t '\\to ', i(0) }),
    s({ trig = '=>', priority = 998 }, { t '\\implies ', i(0) }),
    s({ trig = '|>' }, { t '\\mapsto ', i(0) }),
    s({ trig = '=>' }, t '\\implies ', i(0)),

    s({ trig = '%s*_', regTrig = true }, {
      d(1, function()
        local char_after = funcs.get_char_after()
        if char_after == '_' or char_after == '{' then
          return sn(nil, { t '_' })
        else
          return sn(nil, { t '_{', i(1), t'}' })
        end
      end)
    }),
    s({ trig = '%s*^', regTrig = true }, {
      d(1, function()
        local char_after = funcs.get_char_after()
        if char_after == '^' or char_after == '{' then
          return sn(nil, { t '^' })
        else
          return sn(nil, { t '^{', i(1), t'}' })
        end
      end)
    }),
    s({ trig = '>>' }, { t '\\gg ', i(0) }),
    s({ trig = '<<' }, { t '\\ll ', i(0) }),
    s({ trig = '...' }, { t '\\ldots' }),
    s({ trig = ':..' }, { t '\\vdots' }),
    s({ trig = '\\..' }, { t '\\ddots' }),
    s({ trig = '~~' }, { t '\\sim ' }),
    s({ trig = '~=' }, { t '\\approx ' }),
    s({ trig = '+-' }, { t '\\pm ' }),
    s({ trig = '-+' }, { t '\\mp ' }),
    s({ trig = '||' }, { t '\\mid ', i(0) }),
    s({ trig = '(%[.*%])rt', regTrig = true }, {
      d(1, function(_, snip)
        local order = snip.captures[1]
        return sn(nil, { t('\\sqrt' .. order .. '{'), i(1), t '}' })
      end),
    }),
    s({ trig = 'rt' }, { t '\\sqrt{', i(1), t '}' }),
    s({ trig = '\\\\\\' }, { t '\\setminus ', i(0) }),
    s({ trig = '%%' }, { t '\\%', i(0) }),
    s({ trig = '##' }, { t '\\#' }),

    s({ trig = '(%s*)compl', regTrig = true }, { t '^{C} ', i(0) }),
    s({ trig = '(%s*)inv', regTrig = true }, { t '^{-1}', i(0) }),
    s({ trig = '(%s*)sq', regTrig = true }, { t '^{2}', i(0) }),
    s({ trig = '(%s*)cb', regTrig = true }, { t '^{3}', i(0) }),
    s({ trig = '(%s*)ks', regTrig = true }, { t '^{*}', i(0) }), -- Kleene star
    s({ trig = 'set' }, { t '\\{', i(1), t '\\}', i(0) }),
    s({ trig = 'void' }, { t '\\emptyset' }),
    s({ trig = 'tt' }, { t '\\text{', i(1), t '}', i(0) }),
    s({ trig = 'cc' }, { t '\\subset ', i(0) }),
    s({ trig = ']c' }, { t '\\sqsubset ', i(0) }),
    s({ trig = '\\subset%s*=', regTrig = true }, { t '\\subseteq ', i(0) }),
    s({ trig = '\\subset%s*eq', regTrig = true }, { t '\\subseteq ', i(0) }),
    s({ trig = '\\sqsubset%s*=', regTrig = true }, { t '\\sqsubseteq ', i(0) }),
    s({ trig = '\\sqsubset%s*eq', regTrig = true }, { t '\\sqsubseteq ', i(0) }),
    s({ trig = 'c=' }, { t '\\subseteq ', i(0) }),
    s({ trig = 'notin' }, { t '\\notin ', i(0) }),
    s({ trig = 'in ' }, { t '\\in ', i(0) }),
    s({ trig = 'uu' }, { t '\\cup ', i(0) }),
    s({ trig = 'nn' }, { t '\\cap ', i(0) }),
    s({ trig = 'land' }, { t '\\land ', i(0) }),
    s({ trig = 'lor' }, { t '\\lor ', i(0) }),
    s({ trig = 'bigv' }, { t '\\big\\rvert_{', i(1), t '}' }),
    s({ trig = 'forall' }, { t '\\forall ', i(0) }),
    s({ trig = 'any' }, { t '\\forall ', i(0) }),
    s({ trig = 'exist' }, { t '\\exist ', i(0) }),
    s({ trig = 'transp' }, { t '^{\\intercal}', i(0) }),
    s({ trig = 'hat' }, { t '\\hat{', i(1), t '}' }),
    s({ trig = 'tilde' }, { t '\\tilde{', i(1), t '}' }),
    s({ trig = 'overl' }, { t '\\overline{', i(1), t '}' }),
    s({ trig = 'overs' }, { t '\\overset{', i(2), t '}{', i(1), t '}' }),

    s({ trig = 'log' }, { t '\\mathrm{log}_{', i(1, '10'), t '}\\left(', i(2), t '\\right)', i(0) }),
    s({ trig = 'ln', priority = 999 }, { t '\\mathrm{ln}', t '\\left(', i(1), t '\\right)', i(0) }),
    s({ trig = 'min', priority = 999 }, { t '\\mathrm{min}', t '\\left(', i(1), t '\\right)', i(0) }),
    s({ trig = 'max', priority = 999 }, { t '\\mathrm{min}', t '\\left(', i(1), t '\\right)', i(0) }),
    s({ trig = 'argmin' }, { t '\\mathrm{argmin}\\ ' }),
    s({ trig = 'argmax' }, { t '\\mathrm{argmin}\\ ' }),

    s({ trig = 'sin', priority = 999 }, { t '\\mathrm{sin}\\left(', i(1), t '\\right)', i(0) }),
    s({ trig = 'cos', priority = 999 }, { t '\\mathrm{cos}\\left(', i(1), t '\\right)', i(0) }),
    s({ trig = 'tan', priority = 999 }, { t '\\mathrm{tan}\\left(', i(1), t '\\right)', i(0) }),
    s({ trig = 'asin' }, { t '\\mathrm{arcsin}\\left(', i(1), t '\\right)', i(0) }),
    s({ trig = 'acos' }, { t '\\mathrm{arccos}\\left(', i(1), t '\\right)', i(0) }),
    s({ trig = 'atan' }, { t '\\mathrm{arctan}\\left(', i(1), t '\\right)', i(0) }),
    s({ trig = 'sc' }, { t '\\mathrm{sinc}\\left(', i(1), t '\\right)', i(0) }),

    s({ trig = 'abs' }, { t '\\left\\vert ', i(1), t ' \\right\\vert', i(0) }),
    s({ trig = 'lrv' }, { t '\\left\\vert ', i(1), t ' \\right\\vert', i(0) }),
    s({ trig = 'lrb' }, { t '\\left(', i(1), t '\\right)', i(0) }),
    s({ trig = 'lr)' }, { t '\\left(', i(1), t '\\right)', i(0) }),
    s({ trig = 'lr]' }, { t '\\left[', i(1), t '\\right]', i(0) }),
    s({ trig = 'lrB' }, { t '\\left{', i(1), t '\\right}', i(0) }),
    s({ trig = 'lr}' }, { t '\\left{', i(1), t '\\right}', i(0) }),
    s({ trig = 'lr>' }, { t '\\left<', i(1), t '\\right>', i(0) }),
    s({ trig = 'norm' }, { t '\\left\\lVert ', i(1), t ' \\right\\lVert', i(0) }),

    s({ trig = 'fl' }, { t '\\left\\lfloor ', i(1), t ' \\right\\rfloor', i(0) }),
    s({ trig = 'cl' }, { t '\\left\\lceil ', i(1), t ' \\right\\rceil', i(0) }),
    s({ trig = 'bmat' }, { t '\\begin{bmatrix} ', i(1), t ' \\end{bmatrix}', i(0) }),
    s({ trig = 'pmat' }, { t '\\begin{pmatrix} ', i(1), t ' \\end{pmatrix}', i(0) }),
    s({ trig = 'Bmat' }, { t { '\\begin{bmatrix}', '' }, ifn(1), i(1), t { '', '\\end{bmatrix}', '' } }),
    s({ trig = 'Pmat' }, { t { '\\begin{pmatrix}', '' }, ifn(1), i(1), t { '', '\\end{pmatrix}', '' } }),
    s({ trig = 'aln' }, fmta([[
\begin{<env>}
<indent><text>
\end{<env>}
    ]], {
      env = c(1, { i(nil, 'aligned'), i(nil, 'align*'), i(nil, 'align') }),
      indent = ifn(1),
      text = i(2),
    }, { repeat_duplicates = true })),
    s({ trig = 'eqt' }, fmta([[
\begin{<env>}
<indent><text>
\end{<env>}
    ]], {
      env = c(1, { i(nil, 'equation*'), i(nil, 'equation') }),
      indent = ifn(1),
      text = i(2),
    }, { repeat_duplicates = true })),
    s({ trig = 'cs' }, { t { '\\begin{cases}', '' }, ifn(1), i(1), t { '', '\\end{cases}' } }, i(0)),
    s({ trig = 'part' }, { t { '\\frac{\\partial ' }, i(1), t { '}{\\partial ' }, i(2), t { '}' }, i(0) }),
    s({ trig = 'diff' }, { t '\\frac{\\mathrm{d}', i(1), t '}{\\mathrm{d}', i(2), t '} ', i(0) }),
    s({ trig = 'int', priority = 998 }, { t '\\int_{', i(1), t '}^{', i(2), t '} ', i(0) }),
    s({ trig = 'iint', priority = 999 }, { t '\\iint_{', i(1), t '}^{', i(2), t '} ', i(0) }),
    s({ trig = 'iiint' }, { t '\\iiint_{', i(1), t '}^{', i(2), t '} ', i(0) }),
    s({ trig = 'sum' }, { t '\\sum_{', i(1, 'n=0'), t '}^{', i(2, 'N-1'), t '} ', i(0) }),
    s({ trig = 'so' }, { t '\\sum_{', i(1, 'x'), t '} ', i(0) }),
    s({ trig = 'lim' }, { t '\\lim_{', i(1, 'n'), t '\\to ', i(2, '\\infty'), t '} ', i(0) }),
    s({ trig = 'env' }, fmta([[
\begin{<env>}
<indent><text>
\end{<env>}
    ]] , {
      indent = ifn(1),
      env = i(1),
      text = i(2),
    }, { repeat_duplicates = true })),

    s({ trig = 'alpha' }, { t '\\alpha', i(0) }),
    s({ trig = 'beta' }, { t '\\beta', i(0) }),
    s({ trig = 'gamma' }, { t '\\gamma', i(0) }),
    s({ trig = 'delta' }, { t '\\delta', i(0) }),
    s({ trig = 'zeta' }, { t '\\zeta', i(0) }),
    s({ trig = 'mu' }, { t '\\mu', i(0) }),
    s({ trig = 'rho' }, { t '\\rho', i(0) }),
    s({ trig = 'sigma' }, { t '\\sigma', i(0) }),
    s({ trig = 'eta', priority = 998 }, { t '\\eta', i(0) }),
    s({ trig = 'eps', priority = 999 }, { t '\\epsilon', i(0) }),
    s({ trig = 'veps' }, { t '\\varepsilon', i(0) }),
    s({ trig = 'theta', priority = 999 }, { t '\\theta', i(0) }),
    s({ trig = 'vtheta' }, { t '\\vartheta', i(0) }),
    s({ trig = 'iota' }, { t '\\iota', i(0) }),
    s({ trig = 'kappa' }, { t '\\kappa', i(0) }),
    s({ trig = 'lambda' }, { t '\\lambda', i(0) }),
    s({ trig = 'nu' }, { t '\\nu', i(0) }),
    s({ trig = 'pi' }, { t '\\pi', i(0) }),
    s({ trig = 'tau' }, { t '\\tau', i(0) }),
    s({ trig = 'ups' }, { t '\\upsilon', i(0) }),
    s({ trig = 'phi' }, { t '\\phi', i(0) }),
    s({ trig = 'psi' }, { t '\\psi', i(0) }),
    s({ trig = 'omg' }, { t '\\omega', i(0) }),
    s({ trig = 'Alpha' }, { t '\\Alpha', i(0) }),
    s({ trig = 'Beta' }, { t '\\Beta', i(0) }),
    s({ trig = 'Gamma' }, { t '\\Gamma', i(0) }),
    s({ trig = 'Delta' }, { t '\\Delta', i(0) }),
    s({ trig = 'Zeta' }, { t '\\Zeta', i(0) }),
    s({ trig = 'Mu' }, { t '\\Mu', i(0) }),
    s({ trig = 'Rho' }, { t '\\Rho', i(0) }),
    s({ trig = 'Sigma' }, { t '\\Sigma', i(0) }),
    s({ trig = 'Eta' }, { t '\\Eta', i(0) }),
    s({ trig = 'Eps' }, { t '\\Epsilon', i(0) }),
    s({ trig = 'Theta' }, { t '\\Theta', i(0) }),
    s({ trig = 'Iota' }, { t '\\Iota', i(0) }),
    s({ trig = 'Kappa' }, { t '\\Kappa', i(0) }),
    s({ trig = 'Lambda' }, { t '\\Lambda', i(0) }),
    s({ trig = 'Nu' }, { t '\\Nu', i(0) }),
    s({ trig = 'Pi' }, { t '\\Pi', i(0) }),
    s({ trig = 'Tau' }, { t '\\Tau', i(0) }),
    s({ trig = 'Ups' }, { t '\\Upsilon', i(0) }),
    s({ trig = 'Phi' }, { t '\\Phi', i(0) }),
    s({ trig = 'Psi' }, { t '\\Psi', i(0) }),
    s({ trig = 'Omg' }, { t '\\Omega', i(0) }),

    -- special functions and other notations
    s({ trig = 'Cov' }, { t '\\mathrm{Cov}\\left(', i(1, 'X'), t ',', i(2, 'Y'), t '\\right)' }),
    s({ trig = 'Var' }, { t '\\mathrm{Var}\\left(', i(1, 'X'), t '\\right)' }),
    s({ trig = 'MSE' }, { t '\\mathrm{MSE}' }),
    s({ trig = 'bys', dscr = 'Bayes Formula' },
      fmta('\\frac{P(<cond_x> \\mid <cond_y>) P(<cond_y>)}{P(<cond_y>)}', {
        cond_x = i(2, 'X=x'),
        cond_y = i(1, 'Y=y'),
    }, { repeat_duplicates = true })),
  }),
  opts = { type = 'autosnippets' },
}

return math_snippets
