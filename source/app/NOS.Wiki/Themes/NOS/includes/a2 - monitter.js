var monitter =
{
	init: function()
	{
		jQuery.fn.reverse = Array.prototype.reverse;

		String.prototype.linkify = function () {
			return this.replace(/[a-z]+:\/\/[a-z0-9-_]+\.[a-z0-9-_:%&\?\/.=]+/gi, function (m) {
				return m.link(m);
			});
		};

		String.prototype.linkuser = function () {
			return this.replace(/@[\w-äöüß]+/gi, function (u) {
				var username = u.replace("@", "")
				return u.link("http://twitter.com/" + username);
			});
		};

		String.prototype.linktag = function () {
			return this.replace(/#[\w-äöüß]+/gi, function (t) {
				var tag = t.replace("#", "%23")
				return t.link("http://search.twitter.com/search?q=" + tag);
			});
		};
	},
	
	fetchTweets: function(element, params) {
		element = $(element);
		query = params.query.replace(/#/g, '%23');
		
		if (!params.lastId)
		{
			params.lastId = 0;
		}
		
		var url = "http://search.twitter.com/search.json?q=" + query + "&rpp=" + params.limit + "&since_id=" +  params.lastId + "&callback=?";
	
		$.jsonp({
			url: url,
			timeout: params.timeout,
			success: function(json, textStatus)
			{
				$(json.results).reverse().each(function() {
					if ($('#tw' + this.id, element).length != 0)
					{
						return;
					}
					
					var tweet = $('<div>')
							.attr('id', 'tw' + this.id)
							.data('id', this.id)
							.addClass('tweet')
							.append(params.buildTweet.call(this))
							.hide();
						
					params.lastId = this.id;
					element.prepend(tweet);
				});
				
				$('div.tweet:gt(' + (params.limit - 1) + ')', element).each(function() {
					if (params.hideTweet)
					{
						params.hideTweet.call($(this));
					}
					else
					{
						$(this).remove();
					}
				});
				
				$('div.tweet', element).each(function(index) {
					if (params.showTweet)
					{
						params.showTweet.call($(this), index, params.limit);
					}
					else
					{
						$(this).show();
					}
				});
			},
			complete: function(xOptions, textStatus)
			{
				if (params.updated)
				{
					params.updated(params, textStatus);
				}
				
				setTimeout(function() {
					monitter.fetchTweets(element, params)
				}, params.timeout);  
			}});
	}
}

$(document).ready(function () {
	monitter.init();
	
	jQuery.fn.monitter = function(params) {
		monitter.fetchTweets(this, params);
		return this;
	}; 
});
