jQuery.fn.reverse = Array.prototype.reverse,

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
	
var monitter =
{
	opacity: function(i, limit, opaqueCount, minOpacity, maxOpacity)
	{
		if (i <= opaqueCount)
		{
			return maxOpacity;
		}
		
		i = i - opaqueCount;
		limit = limit - opaqueCount;
		
		return (-1 * (maxOpacity - minOpacity) / limit)  * i + maxOpacity;
	},

	fetchTweets: function(element, params) {
		element = $(element);
		query = element.attr('rel').replace(/#/g, '%23');
		
		var url = "http://search.twitter.com/search.json?q=" + query + "&rpp=" + params.limit + "&since_id=" +  params.lastId + "&callback=?";
		
		$.getJSON(url, function (json) {
			$(json.results).reverse().each(function (i) {
				if ($('#tw' + this.id, element).length != 0)
				{
					return;
				}
					
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
					
		
				params.lastId = this.id;
				element.prepend(tweet);
			});
			
			$('div.tweet:gt(' + (params.limit - 1) + ')', element).each(function () {
				$(this).remove();
			});
			
			$('div.tweet', element).each(function (i) {
				$(this).fadeTo('normal', monitter.opacity(i, params.limit, 2, .4, 1));
			});
			
			if ($.isFunction(params.callback))
			{
				params.callback(params);
			}
			
			setTimeout(function () {
				monitter.fetchTweets(element, params)
			}, params.timeout);  
		});
	}
}

$(document).ready(function () {
	jQuery.fn.monitter = function(params) {
		monitter.fetchTweets(this, params);
		return this;
	}; 
});