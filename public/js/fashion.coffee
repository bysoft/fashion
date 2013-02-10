url = 'http://hearst.api.mashery.com/Article/search?_pretty=0&shape=full&start=100&limit=100&sort=publish_date%2Cdesc&total=0&api_key=v6xqmhe5q4pqtwkr6bem549x'
#url = '/v1/hearst-article-search/'
req = $.ajax
    url: url
    dataType:'jsonp'
    jsonp:'_callback'
    cache:true

req.done (e) ->
    console.log e
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

url = 'http://hearst.api.mashery.com/ArticleType/search?_pretty=0&organization_id=1&name=%25video%25&start=0&limit=50&sort=name%2Casc&total=0&api_key=v6xqmhe5q4pqtwkr6bem549x'
req2 = $.ajax
  url:url
  dataType:'jsonp'
  jsonp:'_callback'
  cache:true

req2.done (e) ->
  console.log e
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
      console.log preurl
      req3 = $.ajax
        url:preurl
        dataType:'jsonp'
        jsonp:'_callback'
        cache:true
      req3.done (e) ->
        console.log e


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
                  console.log @
                  #console.log @url_info
                  console.log 'find thumb src'
                  $(@).each ->
                    window.thumb_src = @thumb_src[0] if @thumb_src

                  source = $('.video-template').html()
                  template = Handlebars.compile source
                  data =
                    url_info:@url_info
                    thumb_src:window.thumb_src
                  snip = template data
                  console.log snip
                  $('#wall').append snip






