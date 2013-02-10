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
app.get "/", routes.hearst


app.get "/v1/hearst-article-search", routes.hearstArticleSearch
app.get "/v1/hearst-ad-category", routes.hearstAdCategory
app.get "/v1/hearst-article-category-search", routes.hearstArticleCategorySearch
app.get "/v1/hearst-article-image-search", routes.hearstImageSearch
#app.get "/v1/hearst-article-section-search", routes.hearstArticleSectionSearch
#app.get "/v1/hearst-article-type-search", routes.hearstArticleTypeSearch
#app.get "/v1/hearst-author-search", routes.hearstAuthorSearch
#app.get "/v1/hearst-source-search", routes.hearstSourceSearch
#app.get "/v1/hearst-template-search", routes.hearstTemplateSearch


app.get "/v1/gilt-category", routes.giltcategory
app.get "/ui", routes.ui
app.get "/users", user.list
app.get "/cyborg", user.store
http.createServer(app).listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")

