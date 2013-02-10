express = require("express")
routes = require("./routes")
user = require("./routes/user")
http = require("http")
path = require("path")
mongoose = require("mongoose")
express = require("express")
partials = require("express-partials")
passport = require("passport")



ensureAuthenticated = (req, res, next) ->
  return next()  if req.isAuthenticated()
  res.redirect "/login"
SinglyStrategy = require("passport-singly").Strategy
SINGLY_APP_ID = "4e29395f3c7d8e613bed77ba91d981de"
SINGLY_APP_SECRET = "afe699372d771865af7542bf543e288b"
CALLBACK_URL = process.env.CALLBACK_URL or "http://localhost:3000/auth/singly/callback"
passport.serializeUser (user, done) ->
  done null, user

passport.deserializeUser (obj, done) ->
  done null, obj


# Use the SinglyStrategy within Passport.
#   Strategies in Passport require a `verify` function, which accept
#   credentials (in this case, an accessToken, refreshToken, and Singly
#   profile), and invoke a callback with a user object.
passport.use new SinglyStrategy(
  clientID: SINGLY_APP_ID
  clientSecret: SINGLY_APP_SECRET
  callbackURL: CALLBACK_URL
, (accessToken, refreshToken, profile, done) ->

  # asynchronous verification, for effect...
  process.nextTick ->

    # To keep the example simple, the user's Singly profile is returned to
    # represent the logged-in user.  In a typical application, you would want
    # to associate the Singly account with a user record in your database,
    # and return that user instead.
    console.log accessToken, refreshToken, profile
    done null, profile

)




app = express()
app.configure ->
  app.set "port", process.env.PORT or 3000
  app.set "views", __dirname + "/views"
  app.set "view engine", "ejs"
  #app.set "view engine", "ejs"
  app.use express.favicon()
  app.use partials()
  app.use express.logger("dev")
  app.use express.cookieParser()
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express.session(secret: "keyboard cat")
  app.use express["static"](path.join(__dirname, "public"))

app.configure "development", ->
  app.use express.errorHandler()

app.get "/merov", routes.sub
app.get "/hearst", routes.hearst


app.get "/v1/hearst-article-search", routes.hearstArticleSearch
app.get "/v1/hearst-ad-category", routes.hearstAdCategory
app.get "/v1/hearst-article-category-search", routes.hearstArticleCategorySearch
app.get "/v1/hearst-article-image-search", routes.hearstImageSearch




app.get "/account", ensureAuthenticated, (req, res) ->
  res.render "account",
    user: req.user


app.get "/login", (req, res) ->
  res.render "login",
    user: req.user



# GET /auth/singly/callback
#   Use passport.authenticate() as route middleware to authenticate the
#   request.  If authentication fails, the user will be redirected back to the
#   login page.  Otherwise, the primary route function function will be called,
#   which, in this example, will redirect the user to the home page.
app.get "/auth/singly/callback", passport.authenticate("singly",
  failureRedirect: "/login"
  successReturnToOrRedirect: "/"
)

# GET /auth/singly
#   Use passport.authenticate() as route middleware to authenticate the
#   request.  The first step in Singly authentication will involve
#   redirecting the user to api.singly.com.  After authorization, Singly will
#   redirect the user back to this application at /auth/singly/callback
app.get "/auth/singly/:service", passport.authenticate("singly")
app.get "/logout", (req, res) ->
  req.logout()
  res.redirect "/"





app.get "/v1/gilt-category", routes.giltcategory
app.get "/ui", routes.ui
app.get "/users", user.list
app.get "/cyborg", user.store
http.createServer(app).listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")

