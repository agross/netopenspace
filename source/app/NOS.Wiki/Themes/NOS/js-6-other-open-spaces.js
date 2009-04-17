function isLocalEvent(item)
{
	return document.URL.startsWith(item.URL, true);
}

function buildList(items, listClass, listHeader, itemText, itemTitle, itemUrl)
{
	var ul = $("<ul>");
					
	var list = $("<div>")
		.attr("class", listClass())
		.append("<p>")
		.text(listHeader())
		.append(ul);
						
	$(items).each(function(i, item) {
		var a = $("<a>").text(itemText(item)).attr("href", itemUrl(item)).attr("title", itemTitle(item));
		$('<li>').append(a).appendTo(ul); 
	});
	
	return list;
}

$(document).ready(function()
{
	String.prototype.startsWith = function(instance, ignoreCase)
	{
		if (ignoreCase)
		{
			return (instance == this.substring(0, instance.length));
		}

		return (instance.toLowerCase() == this.substring(0, instance.length).toLowerCase());
	};

	$.getJSON('http://netopenspace.de/all-net-open-spaces.json?json=?',
			function(json)
			{
				var local = $.grep(json, isLocalEvent)[0];
				var remotes = $($.grep(json, isLocalEvent, true));

				if (local && local.PastEvents)
				{
					buildList(local.PastEvents,
						function() { return "past-spaces no-print"; },
						function() { return "Vergangene .NET Open Spaces in " + local.City; },
						function(item) { return item.Year; },
						function(item) { return ".NET Open Space " + item.Year + " in " + local.City; },
						function(item) { return item.URL; }
					)
					.insertAfter("#HeaderDiv");
				}

				if (remotes)
				{
					buildList(remotes,
						function() { return "remote-spaces no-print"; },
						function() { return "Andere .NET Open Spaces"; },
						function(item) { return item.City; },
						function(item) { return ".NET Open Space in " + item.City; },
						function(item) { return item.URL; }
					)
					.insertAfter("#HeaderDiv");
				}
			});
});