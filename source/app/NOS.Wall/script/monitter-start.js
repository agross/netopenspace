$(document).ready(function()
{
	var yfrog = {
		name: "yfrog",
		match: function (text)
		{
			return text.match(/^http:\/\/yfrog\.com\/([a-z0-9]+)/i);
		},
		process: function(tweet, link) {
			var rematch = yfrog.match(link);
			var img_id = RegExp.$1;
			var anchor = $("<a>")
				.attr("href", link)
				.attr("target", "_blank");
			return anchor
					.clone()
					.append($("<img>")
						.attr("src", "http://yfrog.com/" + img_id + ".th.jpg")
						.data("preview", "http://yfrog.com/" + img_id + ":iphone"))
				.prependTo(tweet.append(anchor.text(link)));
		}
	};
	
	var twitpic = {
		name: "twitpic",
		match: function (text)
		{
			return text.match(/^http:\/\/twitpic\.com\/([a-z0-9]+)/i);
		},
		process: function(tweet, link) {
			var rematch = twitpic.match(link);
			var img_id = RegExp.$1;
			var anchor = $("<a>")
				.attr("href", link)
				.attr("target", "_blank");
			return anchor
					.clone()
					.append($("<img>")
						.attr("src", "http://twitpic.com/show/mini/" + img_id)
						.data("preview", "http://twitpic.com/show/thumb/" + img_id))
				.prependTo(tweet.append(anchor.text(link)));
		}
	};

	var link = {
		name: "link",
		match: function (text) {
			return text.match(/^[a-z]+:\/\/[a-z0-9-_]+\.[a-z0-9-_:%&\?\/.=]+/i);
		},
		process: function(tweet, link) {
			return tweet.append($("<a>")
				.attr("href", link)
				.attr("target", "_blank")
				.text(link));
		}
	};
	
	var user = {
		name: "user",
		match: function (text) {
			return text.match(/^@[\w-äöüß]+/i);
		},
		process: function(tweet, user) {
			var u = user.replace("@", "")
			return tweet.append($("<a>")
				.attr("href", "http://twitter.com/" + u)
				.attr("target", "_blank")
				.text(user));
		}
	};
	
	var tag = {
		name: "tag",
		match: function (text) {
			return text.match(/^#[\w-äöüß]+/i);
		},
		process: function(tweet, tag) {
			var t = tag.replace("#", "%23")
			return tweet
				.append($("<a>")
				.attr("href", "http://search.twitter.com/search?q=" + t)
				.attr("target", "_blank")
				.text(tag));
		}
	};
	
	var whitespace = {
		name: "whitespace",
		match: function (text) {
			return text.match(/^\s+/i);
		},
		process: function(tweet, text) {
			return tweet
				.append(text);
		}
	};
	
	var text = {
		name: "text",
		match: function (text) {
			return text.match(/^\s*\S+\s*/i);
		},
		process: function(tweet, text) {
			return tweet
				.append(text);
		}
	};
	
	$.fn.tweet = function(tweet) {
		var result = $("<span>");
		var parsers = [whitespace, yfrog, twitpic, link, tag, user, text];
		
		// console.log("remainder: <" + tweet + ">");
		while(tweet)
		{
			for(var k = 0; k < parsers.length; k++)
			{
				var parser = parsers[k];
				var match = parser.match(tweet);
				if (match)
				{
					match = match[0];
					
					// console.log(parser.name + ": <" + match + "> ");
					parser.process(result, match);
					
					tweet = tweet.substring(match.length);
					// console.log("remainder: <" + tweet + ">");
					break;
				}
			}
		};
		
		// console.log("result: <" + result.html() + ">");	
		return $(this).html(result);
	};
	
	$.getJSON('http://netopenspace.de/all-net-open-spaces.json?json=?',
		function(json)
		{
			var developmentFilter = function(item)
			{
				return !(!(/^http:\/\/.*nos\.local/i.test(document.URL)) && item.Private);
			}
			
			json = $.grep(json, developmentFilter);
						
			var query = $(json).map(function() {
				return this.TwitterSearch;
			});
			
			query = $.makeArray(query).join(' OR ');
			
			$('.loading').fadeOut();
			
			var prefixWithZero = function(value)
			{
				if (value < 10)
				{
					return '0' + value;
				}
				return value;
			}
			
			var opacity = function(i, limit, opaqueCount, minOpacity, maxOpacity)
			{
				if (i <= opaqueCount)
				{
					return maxOpacity;
				}
				
				i = i - opaqueCount;
				limit = limit - opaqueCount;
				
				return (-1 * (maxOpacity - minOpacity) / limit)  * i + maxOpacity;
			};
			
			$('#tweets')
				.monitter({
					query: query,
					limit: 12,
					timeout: 10000,
					buildTweet: function() {
						var element = 
							$('<div>')
							.append($('<div>')
								.addClass('bubble')
								.append($('<p>').tweet(this.text)))
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
										.text(this.from_user))));
						return element;
					},
					showTweet: function(index, limit) {
						this.fadeTo('normal', opacity(index, limit, 2, .4, 1));
					},					
					updated: function(params, status) {
						var nextUpdate = new Date();
						nextUpdate = new Date(params.timeout + nextUpdate.getTime());
						
						var hours = prefixWithZero(nextUpdate.getHours());
						var minutes = prefixWithZero(nextUpdate.getMinutes());
						var seconds = prefixWithZero(nextUpdate.getSeconds());
						$('#next-update')
							.attr('class', status)
							.text("Nächste Aktualisierung: " + hours + ":" + minutes + ":" + seconds);
					}
				});
		});
	
	var currentPreview = 0;
	$(document).everyTime("10s", function() {
		var nextPreview = $(".bubble img")
			.filter(function() {
				return $(this).closest(".tweet").data("id") < currentPreview;
			}).first();
		
		if (!nextPreview.length)
		{
			nextPreview = $(".bubble img:first");
		}
		
		currentPreview = nextPreview.first().closest(".tweet").data("id");
		nextPreview.zoomer({ parent: $("#wrapper") }); 
	});
});