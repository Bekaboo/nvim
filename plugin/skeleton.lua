require('plugin.skeleton').setup({
  rules = {
    [''] = {
      ['.*%.scripts/'] = function(fallback)
        return fallback({ 'sh.skel', '.sh.skel' })
      end
    },
  },
})
