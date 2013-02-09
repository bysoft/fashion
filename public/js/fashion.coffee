Fashion = Fashion or (($) ->
  Utils = {} # Your Toolbox
  Ajax = {} # Your Ajax Wrapper
  Events = {} # Event-based Actions
  Routes = {} # Your Page Specific Logic
  App = {} # Your Global Logic and Initializer
  Public = {} # Your Public Functions
  Utils =
    settings:
      debug: true
      meta: {}
      init: ->
        $("meta[name^=\"app-\"]").each ->
          Utils.settings.meta[@name.replace("app-", "")] = @content


    cache:
      window: window
      document: document

    home_url: (path) ->
      path = ""  if typeof path is "undefined"
      Utils.settings.meta.homeURL + path + "/"

    log: (what) ->
      console.log what  if Utils.settings.debug

    parseRoute: (input) ->
      delimiter = input.delimiter or "/"
      paths = input.path.split(delimiter)
      check = input.target[paths.shift()]
      exists = typeof check isnt "undefined"
      isLast = paths.length is 0
      input.inits = input.inits or []
      if exists
        input.inits.push check.init  if typeof check.init is "function"
        if isLast
          input.parsed.call `undefined`,
            exists: true
            type: typeof check
            obj: check
            inits: input.inits

        else
          Utils.parseRoute
            path: paths.join(delimiter)
            target: check
            delimiter: delimiter
            parsed: input.parsed
            inits: input.inits

      else
        input.parsed.call `undefined`,
          exists: false


    route: ->
      Utils.parseRoute
        path: Utils.settings.meta.route
        target: Routes
        delimiter: "/"
        parsed: (res) ->
          if res.exists and res.type is "function"
            unless res.inits.length is 0
              for i of res.inits
                res.inits[i].call()
            res.obj.call()


  _log = Utils.log
  Ajax =
    ajaxUrl: Utils.home_url("ajax")
    send: (type, method, data, returnFunc) ->
      $.ajax
        type: "POST"
        url: Ajax.ajaxUrl + method
        dataType: "json"
        data: data
        success: returnFunc


    call: (method, data, returnFunc) ->
      Ajax.send "POST", method, data, returnFunc

    get: (method, data, returnFunc) ->
      Ajax.send "GET", method, data, returnFunc

  Events =
    endpoints: {}
    bindEvents: ->
      $("[data-event]").each ->
        _this = this
        method = _this.dataset.method or "click"
        name = _this.dataset.event
        bound = _this.dataset.bound
        unless bound
          Utils.parseRoute
            path: name
            target: Events.endpoints
            delimiter: "."
            parsed: (res) ->
              if res.exists
                _this.dataset.bound = true
                $(_this).on method, (e) ->
                  res.obj.call _this, e




    init: ->
      Events.bindEvents()

  Routes = {}
  App =
    logic: {}
    init: ->
      Utils.settings.init()
      Events.init()
      Utils.route()

  Public = init: App.init
  Public
)(window.jQuery)
jQuery(document).ready Fashion.init
