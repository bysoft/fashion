
#
# * GET home page.
#
exports.index = (req, res) ->
  res.render('index', { user: req.user })

exports.sub = (req, res) ->
  res.render "merov",
    title: "merov"

exports.ui = (req, res) ->
  res.render "interface-elements",
    title: "hearst"

