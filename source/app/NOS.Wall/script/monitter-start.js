$(document).ready(function()
{
	$.getJSON('http://netopenspace.de/all-net-open-spaces.json?json=?',
		function(json)
		{
			var developmentFilter = function(item)
			{
				return !(!(/^http:\/\/nos\.local/i.test(document.URL)) && item.Private);
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
			
			var opacity	= function(i, limit, opaqueCount, minOpacity, maxOpacity)
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
								.addClass('bubble')
								.append($('<p>')
									.html(this.text.linkify().linkuser().linktag()))
							.after($('<div>')
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
});