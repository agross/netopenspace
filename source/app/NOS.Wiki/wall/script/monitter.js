jQuery.fn.reverse = Array.prototype.reverse;

String.prototype.linkify = function () {
    return this.replace(/[A-Za-z]+:\/\/[A-Za-z0-9-_]+\.[A-Za-z0-9-_:%&\?\/.=]+/g, function (m) {
        return m.link(m);
    });
};

String.prototype.linkuser = function () {
    return this.replace(/[@]+[A-Za-z0-9-_]+/g, function (u) {
        var username = u.replace("@", "")
        return u.link("http://twitter.com/" + username);
    });
};

String.prototype.linktag = function () {
    return this.replace(/[#]+[A-Za-z0-9-_]+/, function (t) {
        var tag = t.replace("#", "%23")
		return t.link("http://search.twitter.com/search?q=" + tag);
    });
};

function opacity(i, limit, opaque, minOpacity, maxOpacity) {
	if (i <= opaque)
	{
		return maxOpacity;
	}
	
	i = i - opaque;
	limit = limit - opaque;
	
	return (-1 * (maxOpacity - minOpacity) / limit)  * i + maxOpacity;
}

function fetch_tweets(elem) {
    elem = $(elem);
    query = elem.attr('rel').replace(/#/g, '%23');
	
    if (query != window.monitter['query-' + query]) {
        window.monitter['query-' + query] = query;
		window.monitter['last_id' + query] = 0;
		window.monitter['limit-' + query] = 12;
    }
	
	var url = "http://search.twitter.com/search.json?q=" + query + "&rpp=" + window.monitter['limit-' + query] + "&since_id=" + window.monitter['last_id' + query] + "&callback=?";
	
    $.getJSON(url, function (json) {
        $(json.results).reverse().each(function (i) {
            if ($('#tw' + this.id, elem).length == 0) {
				
				var tweet = $('<div>')
					.attr('id', 'tw' + this.id)
					.addClass('tweet')
					.attr('style', 'display: block;')
					.append($('<div>')
						.addClass('bubble')
						.append($('<p>')
							.html(this.text.linkify().linkuser().linktag())))
					.append($('<div>')
						.addClass('author')
						.append($('<a>')
							.attr('href', 'http://twitter.com/' + this.from_user)
							.attr('target', '_blank')
							.attr('title', this.from_user)
							.append($('<img>')
								.addClass('avatar')
								.attr('src', this.profile_image_url))
							.append($('<span>')
								.html(this.from_user))));
					
		
                window.monitter['last_id' + query] = this.id;
                elem.prepend(tweet);
			}
        });
		
		$('div.tweet:gt(' + (window.monitter['limit-' + query] - 1) + ')', elem).each(function () {
			$(this).remove();
		});
		
		$('div.tweet', elem).each(function (i) {
			$(this).fadeTo('normal', opacity(i, window.monitter['limit-' + query], 2, .4, 1));
		});
		
        setTimeout(function () {
			fetch_tweets(elem)
		}, 10000);
    });
	
    return (false);
}

$(document).ready(function () {
    window.monitter = {};
	
	jQuery.fn.monitter = function() {
		fetch_tweets(this);
		return this;
	}; 
});