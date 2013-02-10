(function() {
  var req, url;

  url = 'http://hearst.api.mashery.com/Article/search?_pretty=0&shape=full&start=100&limit=100&sort=publish_date%2Cdesc&total=0&api_key=v6xqmhe5q4pqtwkr6bem549x';

  req = $.ajax({
    url: url,
    dataType: 'jsonp',
    jsonp: '_callback',
    cache: true
  });

  req.done(function(e) {
    console.log(e);
    $('#wall').empty();
    return $(e).each(function() {
      return $(this.items).each(function() {
        var data, snip, source, template;
        source = $('#entry-template').html();
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

}).call(this);
