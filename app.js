var express = require('express');
var partials = require('express-partials');
var passport = require('passport');
var routes = require("./routes")

, user = require("./routes/user")

, http = require("http")

, path = require("path")

var SinglyStrategy = require('passport-singly').Strategy;

var SINGLY_APP_ID = process.env.SINGLY_APP_ID || "4e29395f3c7d8e613bed77ba91d981de";
var SINGLY_APP_SECRET = process.env.SINGLY_APP_SECRET || "afe699372d771865af7542bf543e288b";

var CALLBACK_URL = process.env.CALLBACK_URL || "http://fashion.jit.su/auth/singly/callback";

// Passport session setup.//{{{
//   To support persistent login sessions, Passport needs to be able to
//   serialize users into and deserialize users out of the session.  Typically,
//   this will be as simple as storing the user ID when serializing, and finding
//   the user by ID when deserializing.  However, since this example does not
//   have a database of user records, the complete Singly profile is serialized
//   and deserialized.//}}}
passport.serializeUser(function (user, done) {
  done(null, user);
});

passport.deserializeUser(function (obj, done) {
  done(null, obj);
});

// Simple route middleware to ensure user is authenticated.//{{{
//   Use this route middleware on any resource that needs to be protected.  If
//   the request is authenticated (typically via a persistent login session),
//   the request will proceed.  Otherwise, the user will be redirected to the
//   login page.//}}}
function ensureAuthenticated(req, res, next) {
  if (req.isAuthenticated()) {
    return next();
  }

  res.redirect('/login');
}

// Use the SinglyStrategy within Passport.//{{{
//   Strategies in Passport require a `verify` function, which accept
//   credentials (in this case, an accessToken, refreshToken, and Singly
//   profile), and invoke a callback with a user object.//}}}
passport.use(new SinglyStrategy({
    clientID: SINGLY_APP_ID,
    clientSecret: SINGLY_APP_SECRET,
    callbackURL: CALLBACK_URL
  },
  function (accessToken, refreshToken, profile, done) {
    // asynchronous verification, for effect...
    process.nextTick(function () {
      // To keep the example simple, the user's Singly profile is returned to//{{{
      // represent the logged-in user.  In a typical application, you would want
      // to associate the Singly account with a user record in your database,//}}}
      // and return that user instead.
      console.log(accessToken, refreshToken, profile);

      return done(null, profile);
    });
  }
));

var app = express();

// configure Express
app.configure(function () {
  app.set('views', __dirname + '/views');
  app.set('view engine', 'ejs');
  app.use(partials());
  app.use(express.logger());
  app.use(express.cookieParser());
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(express.session({ secret: 'keyboard cat' }));
  // Initialize Passport!  Also use passport.session() middleware, to support
  // persistent login sessions (recommended).
  app.use(passport.initialize());
  app.use(passport.session());
  app.use(app.router);
  app.use(express['static'](__dirname + '/public'));
});

//app.get('/', function (req, res) {
  //res.render('index', { user: req.user });
//});

app.get("/", routes.hearst);
app.get("/hearst", routes.hearst);

app.get('/account', ensureAuthenticated, function (req, res) {
  res.render('account', { user: req.user });
});

app.get('/login', function (req, res) {
  res.render('login', { user: req.user });
});

// GET /auth/singly/callback//{{{
//   Use passport.authenticate() as route middleware to authenticate the
//   request.  If authentication fails, the user will be redirected back to the
//   login page.  Otherwise, the primary route function function will be called,
//   which, in this example, will redirect the user to the home page.//}}}
app.get('/auth/singly/callback', passport.authenticate('singly', {
  failureRedirect: '/login',
  successReturnToOrRedirect: '/'
}));

// GET /auth/singly//{{{
//   Use passport.authenticate() as route middleware to authenticate the
//   request.  The first step in Singly authentication will involve
//   redirecting the user to api.singly.com.  After authorization, Singly will
//   redirect the user back to this application at /auth/singly/callback//}}}
app.get('/auth/singly/:service', passport.authenticate('singly'));

app.get('/logout', function (req, res) {
  req.logout();
  res.redirect('/');
});

app.listen(3000);
