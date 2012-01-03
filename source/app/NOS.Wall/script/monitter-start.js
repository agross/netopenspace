$(document).ready(function()
{
	var mobypicture = {
		name: "mobypicture",
		match: function (remainder)
		{
			return remainder.match(/^http:\/\/moby\.to\/([a-z0-9]+)/i);
		},
		process: function(remainder, link) {
			var anchor = $("<a>")
				.attr("href", link)
				.attr("target", "_blank");
			return anchor
					.clone()
					.append($("<img>")
						.attr("src", link + ":thumb")
						.data("preview", link + ":medium"))
				.prependTo(remainder.append(anchor.text(link)));
		}
	};
	
	var yfrog = {
		name: "yfrog",
		match: function (remainder)
		{
			return remainder.match(/^http:\/\/yfrog\.com\/([a-z0-9]+)/i);
		},
		process: function(remainder, link) {
			var anchor = $("<a>")
				.attr("href", link)
				.attr("target", "_blank");
			return anchor
					.clone()
					.append($("<img>")
						.attr("src", link + ".th.jpg")
						.data("preview", link + ":iphone"))
				.prependTo(remainder.append(anchor.text(link)));
		}
	};
	
	var twitpic = {
		name: "twitpic",
		match: function (remainder)
		{
			return remainder.match(/^http:\/\/twitpic\.com\/([a-z0-9]+)/i);
		},
		process: function(remainder, link) {
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
				.prependTo(remainder.append(anchor.text(link)));
		}
	};

	var picTwitter = {
		name: "picTwitter",
		match: function (remainder, tweet)
		{
			return tweet.entities.media;
		},
		process: function(remainder, ignored, tweet) {
			var media = tweet.entities.media[0].media_url;
			var link = tweet.entities.media[0].url;
			var anchor = $("<a>")
				.attr("href", link)
				.attr("target", "_blank");
			return anchor
					.clone()
					.append($("<img>")
						.attr("src", media)
						.data("preview", media))
				.prependTo(remainder.append(anchor.text(link)));
		}
	};

	var link = {
		name: "link",
		match: function (remainder) {
			return remainder.match(/^[a-z]+:\/\/[a-z0-9-_]+\.[a-z0-9-_:%&\?\/.=#]+/i);
		},
		process: function(remainder, link) {
			return remainder.append($("<a>")
				.attr("href", link)
				.attr("target", "_blank")
				.text(link));
		}
	};
	
	var user = {
		name: "user",
		match: function (remainder) {
			return remainder.match(/^@[\w-äöüß]+/i);
		},
		process: function(remainder, user) {
			var u = user.replace("@", "")
			return remainder.append($("<a>")
				.attr("href", "http://twitter.com/" + u)
				.attr("target", "_blank")
				.text(user));
		}
	};
	
	var tag = {
		name: "tag",
		match: function (remainder) {
			return remainder.match(/^#[\w-äöüß]+/i);
		},
		process: function(remainder, tag) {
			var t = tag.replace("#", "%23")
			return remainder
				.append($("<a>")
				.attr("href", "http://search.twitter.com/search?q=" + t)
				.attr("target", "_blank")
				.text(tag));
		}
	};
	
	var whitespace = {
		name: "whitespace",
		match: function (remainder) {
			return remainder.match(/^\s+/i);
		},
		process: function(remainder, text) {
			return remainder
				.append(text);
		}
	};
	
	var text = {
		name: "text",
		match: function (text) {
			return text.match(/^\s*\S+\s*/i);
		},
		process: function(remainder, text) {
			return remainder
				.append(text);
		}
	};
	
	$.fn.tweet = function(tweet) {
		var remainder = tweet.text;
		var result = $("<span>");
		var parsers = [whitespace, mobypicture, yfrog, twitpic, link, tag, user, text];
		
		// console.log("remainder: <" + remainder + ">");
		while(remainder)
		{
			for(var k = 0; k < parsers.length; k++)
			{
				var parser = parsers[k];
				var match = parser.match(remainder, tweet);
				if (match)
				{
					match = match[0];
					
					// console.log(parser.name + ": <" + match + "> ");
					parser.process(result, match, tweet);
					
					remainder = remainder.substring(match.length);
					// console.log("remainder: <" + remainder + ">");
					break;
				}
			}
		};
	
	if (picTwitter.match(remainder, tweet))
	{
		picTwitter.process(result, "", tweet);
	}
	
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
								.append($('<p>').tweet(this)))
							.append($('<div>')
								.addClass('author')
								.append($('<a>')
									.attr('href', 'http://twitter.com/' + this.from_user + '/status/' + this.id_str)
									.attr('target', '_blank')
									.attr('title', 'Tweet anzeigen')
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
