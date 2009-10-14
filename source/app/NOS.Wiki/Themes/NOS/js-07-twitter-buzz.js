$(document).ready(function()
{
	var developmentFilter = function(item)
	{
		return !(!document.URL.startsWith("http://nos.local") && item.Private);
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
						.append($('<p>').append($('<a>').attr('href', 'http://live.netopenspace.de/').attr('target', '_blank').attr('title', 'Live-Ticker').text('Buzz')))
						.append($('<div>')
							.addClass('monitter')
							.attr('rel', query)
							.monitter()))
					.insertAfter("#HeaderDiv");
			});
});