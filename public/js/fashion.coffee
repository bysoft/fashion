url = 'http://hearst.api.mashery.com/Article/search?_pretty=0&shape=full&start=100&limit=100&sort=publish_date%2Cdesc&total=0&api_key=v6xqmhe5q4pqtwkr6bem549x'
req = $.ajax
    url: url
    dataType:'jsonp'
    jsonp:'_callback'
    cache:true

req.done (e) ->
    console.log e
    $('#wall').empty()
    $(e).each ->
        #console.log @items
        $(@items).each ->
            #console.log @
            source = $('#entry-template').html()
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









