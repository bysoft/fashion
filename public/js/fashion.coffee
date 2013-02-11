
window.Fashion = window.Fashion || {}

Fashion.story = ->

  url = 'http://hearst.api.mashery.com/Article/search?_pretty=0&shape=full&start=100&limit=100&sort=publish_date%2Cdesc&total=0&api_key=v6xqmhe5q4pqtwkr6bem549x'
#url = '/v1/hearst-article-search/'
  req = $.ajax
      url: url
      dataType:'jsonp'
      jsonp:'_callback'
      cache:true

  req.done (e) ->
      #console.log e
      $(e).each ->
          #console.log @items
          $(@items).each ->
              #console.log @
              source = $('.entry-template').html()
              template = Handlebars.compile source
              data =
                  meta_title:@meta_title
                  creation_date:@creation_date
                  headline_image_title:@headline_image_title
                  article_id:@id
                  author_last_name:@author_last_name
                  extra_large_new_url:@IMAGE_1_extra_large_new_url
              snip = template data

              $(@).each ->
                 $('#wall').append snip if @IMAGE_1_extra_large_new_url != undefined
                #$('#wrap').append('foo') if @IMAGE_1_extra_large_new_url != undefined

Fashion.story()




Fashion.video = ->


  url2 = 'http://hearst.api.mashery.com/ArticleType/search?_pretty=0&organization_id=1&name=%25video%25&start=0&limit=50&sort=name%2Casc&total=0&api_key=v6xqmhe5q4pqtwkr6bem549x'
  req2 = $.ajax
    url:url2
    dataType:'jsonp'
    jsonp:'_callback'
    cache:true

  req2.done (e) ->
    #console.log e
    $(e).each ->
      #console.log @items
      dataArr = []
      $(@items).each ->
        data =
          article_type_id:@id
          site_id:@site_id
        dataArr.push data

      $(dataArr).each ->
        #console.log @
        preurl = 'http://hearst.api.mashery.com/Article/search?_pretty=0&shape=full&' + 'site_id=' + @site_id + '&article_type_id=' + @article_type_id + '&start=0&limit=50&sort=publish_date%2Cdesc&total=0&api_key=v6xqmhe5q4pqtwkr6bem549x'
        #console.log preurl
        req3 = $.ajax
          url:preurl
          dataType:'jsonp'
          jsonp:'_callback'
          cache:true
        req3.done (e) ->
          $('video').on 'click', ->
            videoUrl = $(@).attr('data-url_info')
            $('#my_video_1').find('source').attr('src',videoUrl)

            $('#overlay,#my_video_1').show()
            myPlayer = _V_("my_video_1")
            myPlayer.src(videoUrl)
            myPlayer.pause()
            myPlayer.play()





          #console.log e



  url = 'http://hearst.api.mashery.com/Article/search?_pretty=0&shape=full&site_id=17&article_type_id=1286&start=0&limit=150&sort=publish_date%2Cdesc&total=0&api_key=v6xqmhe5q4pqtwkr6bem549x'

  req4 = $.ajax
      url:url
      dataType:'jsonp'
      jsonp:'_callback'
      cache:true

  req4.done (e) ->
      # console.log e
      $(e).each ->
        $(@items).each ->
            # console.log @body
            $(@body).each ->
                # console.log @video_player
                $(@video_player).each ->
                    #console.log @
                    #console.log @url_info
                    #console.log 'find thumb src'
                    $(@).each ->
                      window.thumb_src = @thumb_src[0] if @thumb_src

                    source = $('.video-template').html()
                    template = Handlebars.compile source
                    data =
                      url_info:@url_info
                      thumb_src:window.thumb_src
                    snip = template data
                    #console.log snip
                    $('#loader').remove()
                    $('#wall').append snip



$('.video-nav a').on 'click', ->
  $('#wall').empty().append('<img id=loader src=/css/loader.gif>')
  Fashion.video()
$('.story-nav a').on 'click', ->
  $('#wall').empty()
  Fashion.story()


val = ($(window).width() - 600) / 2
$('#my_video_1').css('left',val).hide()
$(window).resize ->
  val = ($(window).width() - 600) / 2
  $('#my_video_1').css('left',val)

$('body').on 'click', '#overlay', ->
  $('#my_video_1,#overlay').hide()




Fashion.story2 = (num) ->

  url = 'http://hearst.api.mashery.com/Article/search?_pretty=0&shape=full&start=' + num + '&limit=100&sort=publish_date%2Cdesc&total=0&api_key=v6xqmhe5q4pqtwkr6bem549x'
#url = '/v1/hearst-article-search/'
  req = $.ajax
      url: url
      dataType:'jsonp'
      jsonp:'_callback'
      cache:true

  req.done (e) ->
      #console.log e
      $(e).each ->
          #console.log @items
          $(@items).each ->
              #console.log @
              source = $('.entry-template').html()
              template = Handlebars.compile source
              data =
                  meta_title:@meta_title
                  creation_date:@creation_date
                  headline_image_title:@headline_image_title
                  article_id:@id
                  author_last_name:@author_last_name
                  extra_large_new_url:@IMAGE_1_extra_large_new_url
              snip = template data

              $(@).each ->
                 $('#wall').append snip if @IMAGE_1_extra_large_new_url != undefined


$('.video video').on 'click', ->
    thisUrl = $(@).attr('data-url_info')
    #console.log thisUrl

    $('#overlay,#my_video_1').show()
    $('#my_video_1 source').attr('src', thisUrl)
    _V_('my_video_1').load()

infiniteScroll = ->
    window.startNum = 1
    loadMore = ->
        $('<img src=/images/loader.gif class=loader >').insertBefore('#footer')
        #console.log 'loading'
        window.startNum = window.startNum + 50
        #console.log startNum
        Fashion.story(startNum)

        loadGilt = ->
          url = '/js/women.active.json'
          req = $.ajax
            url:url

          req.done (e) ->
            $(e.sales).each ->
              $(@image_urls).each ->
                #console.log @['612x526']
                $(@['612x526']).each ->
                  #console.log @url
                  img = $('<img width=20% src=' + @url + '>')
                  $('#wall').append(img)
        loadGilt()



    loadMore() if $(document).height() - $(window).scrollTop() < 1100


$(window).scroll ->
    infiniteScroll()

$('body').on 'click','.picture a', (e) ->
    e.preventDefault()


$('body').on 'click', '.nav a', ->
  $('#overlay,#my_video_1').hide()




giltUrl = 'https://api.gilt.com/v1/sales/women/active.json?apikey=c6fe9aceed780deefe31eb7aedcccb58'
