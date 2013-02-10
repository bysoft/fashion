(function() {
  var req, req2, req4, url;

  url = 'http://hearst.api.mashery.com/Article/search?_pretty=0&shape=full&start=100&limit=100&sort=publish_date%2Cdesc&total=0&api_key=v6xqmhe5q4pqtwkr6bem549x';

  req = $.ajax({
    url: url,
    dataType: 'jsonp',
    jsonp: '_callback',
    cache: true
  });

  req.done(function(e) {
    console.log(e);
    return $(e).each(function() {
      return $(this.items).each(function() {
        var data, snip, source, template;
        source = $('.entry-template').html();
        template = Handlebars.compile(source);
        data = {
          meta_title: this.meta_title,
          creation_date: this.creation_date,
          headline_image_title: this.headline_image_title,
          article_id: this.id,
          author_last_name: this.author_last_name,
          extra_large_new_url: this.IMAGE_1_extra_large_new_url
        };
        snip = template(data);
        return $(this).each(function() {
          if (this.IMAGE_1_extra_large_new_url !== void 0) {
            return $('#wall').append(snip);
          }
        });
      });
    });
  });

  url = 'http://hearst.api.mashery.com/ArticleType/search?_pretty=0&organization_id=1&name=%25video%25&start=0&limit=50&sort=name%2Casc&total=0&api_key=v6xqmhe5q4pqtwkr6bem549x';

  req2 = $.ajax({
    url: url,
    dataType: 'jsonp',
    jsonp: '_callback',
    cache: true
  });

  req2.done(function(e) {
    console.log(e);
    return $(e).each(function() {
      var dataArr;
      dataArr = [];
      $(this.items).each(function() {
        var data;
        data = {
          article_type_id: this.id,
          site_id: this.site_id
        };
        return dataArr.push(data);
      });
      return $(dataArr).each(function() {
        var preurl, req3;
        preurl = 'http://hearst.api.mashery.com/Article/search?_pretty=0&shape=full&' + 'site_id=' + this.site_id + '&article_type_id=' + this.article_type_id + '&start=0&limit=50&sort=publish_date%2Cdesc&total=0&api_key=v6xqmhe5q4pqtwkr6bem549x';
        console.log(preurl);
        req3 = $.ajax({
          url: preurl,
          dataType: 'jsonp',
          jsonp: '_callback',
          cache: true
        });
        return req3.done(function(e) {
          return console.log(e);
        });
      });
    });
  });

  url = 'http://hearst.api.mashery.com/Article/search?_pretty=0&shape=full&site_id=17&article_type_id=1286&start=0&limit=150&sort=publish_date%2Cdesc&total=0&api_key=v6xqmhe5q4pqtwkr6bem549x';

  req4 = $.ajax({
    url: url,
    dataType: 'jsonp',
    jsonp: '_callback',
    cache: true
  });

  req4.done(function(e) {
    return $(e).each(function() {
      return $(this.items).each(function() {
        return $(this.body).each(function() {
          return $(this.video_player).each(function() {
            var data, snip, source, template;
            console.log(this);
            console.log('find thumb src');
            $(this).each(function() {
              if (this.thumb_src) return window.thumb_src = this.thumb_src[0];
            });
            source = $('.video-template').html();
            template = Handlebars.compile(source);
            data = {
              url_info: this.url_info,
              thumb_src: window.thumb_src
            };
            snip = template(data);
            console.log(snip);
            return $('#wall').append(snip);
          });
        });
      });
    });
  });

}).call(this);
