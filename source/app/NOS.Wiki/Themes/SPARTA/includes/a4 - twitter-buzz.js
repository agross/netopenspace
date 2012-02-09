$(document).ready(function()
{
	var developmentFilter = function(item)
	{
		return !(!(/^http:\/\/nos\.local/i.test(document.URL)) && item.Private);
	}
	
	$.getJSON('http://netopenspace.de/all-net-open-spaces.json?json=?',
			function(json)
			{
				json = $.grep(json, developmentFilter);
				
				var query = $(json).map(function() {
					return this.TwitterSearch;
				});
				
				query = $.makeArray(query).join(' OR ');
				
				$('<div>')
					.addClass('buzz')
					.addClass('no-print')
					.append($('<div>').addClass('content')
						.append($('<p>').append($('<a>').attr('href', 'http://live.netopenspace.de/').attr('target', '_blank').attr('title', 'Live-Ticker').text('Buzz').addClass('header')))
						.append($('<div>')
							.monitter({
								query: query,
								limit: 6,
								timeout: 60000,
								buildTweet: function() {
									var element = 
										$('<div>')
										.append($('<a>')
											.attr('href', 'http://twitter.com/' + this.from_user)
											.attr('target', '_blank')
											.attr('title', this.from_user)
											.append($('<img>')
												.attr('src', this.profile_image_url)))
										.append($('<p>')
											.addClass('text')
											.html(this.text.linkify().linkuser().linktag()))
										.append($('<p>')
											.addClass('time')
											.append($('<a>')
												.attr('href', 'http://twitter.com/' + this.from_user + '/status/' + this.id)
												.attr('target', '_blank')
												.text(this.created_at.prettyDate())));
									return element;
								},
								showTweet: function(parent)
								{
									this.slideDown(1000);
								},
								hideTweet: function()
								{
									this.fadeOut(500, function(){ $(this).remove(); });
								}
							})))
					.insertAfter("#HeaderDiv");
			})
});