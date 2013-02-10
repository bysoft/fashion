(function() {
  var giltUrl, infiniteScroll, val;

  window.Fashion = window.Fashion || {};

  Fashion.story = function() {
    var req, url;
    url = 'http://hearst.api.mashery.com/Article/search?_pretty=0&shape=full&start=100&limit=100&sort=publish_date%2Cdesc&total=0&api_key=v6xqmhe5q4pqtwkr6bem549x';
    req = $.ajax({
      url: url,
      dataType: 'jsonp',
      jsonp: '_callback',
      cache: true
    });
    return req.done(function(e) {
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
  };

  Fashion.story();

  Fashion.video = function() {
    var req2, req4, url, url2;
    url2 = 'http://hearst.api.mashery.com/ArticleType/search?_pretty=0&organization_id=1&name=%25video%25&start=0&limit=50&sort=name%2Casc&total=0&api_key=v6xqmhe5q4pqtwkr6bem549x';
    req2 = $.ajax({
      url: url2,
      dataType: 'jsonp',
      jsonp: '_callback',
      cache: true
    });
    req2.done(function(e) {
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
          req3 = $.ajax({
            url: preurl,
            dataType: 'jsonp',
            jsonp: '_callback',
            cache: true
          });
          return req3.done(function(e) {});
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
    return req4.done(function(e) {
      return $(e).each(function() {
        return $(this.items).each(function() {
          return $(this.body).each(function() {
            return $(this.video_player).each(function() {
              var data, snip, source, template;
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
              $('#loader').remove();
              return $('#wall').append(snip);
            });
          });
        });
      });
    });
  };

  $('.video-nav a').on('click', function() {
    $('#wall').empty().append('<img id=loader src=/css/loader.gif>');
    return Fashion.video();
  });

  $('.story-nav a').on('click', function() {
    $('#wall').empty();
    return Fashion.story();
  });

  val = ($(window).width() - 600) / 2;

  $('#my_video_1').css('left', val);

  $(window).resize(function() {
    val = ($(window).width() - 600) / 2;
    return $('#my_video_1').css('left', val);
  });

  $('body').on('click', '#overlay', function() {
    return $('#my_video_1,#overlay').hide();
  });

  Fashion.story2 = function(num) {
    var req, url;
    url = 'http://hearst.api.mashery.com/Article/search?_pretty=0&shape=full&start=' + num + '&limit=100&sort=publish_date%2Cdesc&total=0&api_key=v6xqmhe5q4pqtwkr6bem549x';
    req = $.ajax({
      url: url,
      dataType: 'jsonp',
      jsonp: '_callback',
      cache: true
    });
    return req.done(function(e) {
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
  };

  $('.video video').on('click', function() {
    var thisUrl;
    thisUrl = $(this).attr('data-url_info');
    $('#overlay,#my_video_1').show();
    $('#my_video_1 source').attr('src', thisUrl);
    return _V_('my_video_1').load();
  });

  infiniteScroll = function() {
    var loadMore;
    window.startNum = 1;
    loadMore = function() {
      var loadGilt;
      $('<img src=/images/loader.gif class=loader >').insertBefore('#footer');
      window.startNum = window.startNum + 50;
      Fashion.story(startNum);
      loadGilt = function() {
        var req, url;
        url = '/js/women.active.json';
        req = $.ajax({
          url: url
        });
        return req.done(function(e) {
          return $(e.sales).each(function() {
            return $(this.image_urls).each(function() {
              return $(this['612x526']).each(function() {
                var img;
                img = $('<img width=20% src=' + this.url + '>');
                return $('#wall').append(img);
              });
            });
          });
        });
      };
      return loadGilt();
    };
    if ($(document).height() - $(window).scrollTop() < 1100) return loadMore();
  };

  $(window).scroll(function() {
    return infiniteScroll();
  });

  $('body').on('click', '.picture a', function(e) {
    return e.preventDefault();
  });

  $('body').on('click', '.nav a', function() {
    return $('#overlay,#my_video_1').hide();
  });

  giltUrl = 'https://api.gilt.com/v1/sales/women/active.json?apikey=c6fe9aceed780deefe31eb7aedcccb58';

}).call(this);
