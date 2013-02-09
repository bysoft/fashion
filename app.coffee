express = require("express")
routes = require("./routes")
user = require("./routes/user")
http = require("http")
path = require("path")
mongoose = require("mongoose")
app = express()
app.configure ->
  app.set "port", process.env.PORT or 3000
  app.set "views", __dirname + "/views"
  app.set "view engine", "jade"
  app.use express.favicon()
  app.use express.logger("dev")
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express["static"](path.join(__dirname, "public"))

app.configure "development", ->
  app.use express.errorHandler()

app.get "/", routes.index
app.get "/merov", routes.sub
app.get "/hearst", routes.hearst
app.get "/hearstjson", routes.hearstjson
app.get "/ui", routes.ui
app.get "/users", user.list
app.get "/cyborg", user.store
http.createServer(app).listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")

