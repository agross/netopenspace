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

	var developmentFilter = function(item)
	{
		return !(!(/^http:\/\/nos\.local/i.test(document.URL)) && item.Private);
	}
	
	var localEventFilter = function(item)
	{
		return document.URL.startsWith(item.URL, true);
	}

	var buildList = function(items, listClass, listHeader, itemText, itemTitle, itemUrl)
	{
		var ul = $("<ul>");

		var list = $("<div>")
		.addClass(listClass())
		.append($("<div>")
			.addClass("submenu")
			.append($("<p>").text(listHeader()))
			.append(ul));

		$(items).each(function(i, item)
		{
			var a = $("<a>").text(itemText(item)).attr("href", itemUrl(item)).attr("title", itemTitle(item));
			$('<li>').append(a).appendTo(ul);
		});

		list.droppy('> div');

		return list;
	}

	$.getJSON('http://netopenspace.de/all-net-open-spaces.json?json=?',
			function(json)
			{
				json = $.grep(json, developmentFilter);
				var local = $.grep(json, localEventFilter)[0];
				var remotes = $($.grep(json, localEventFilter, true));

				if (local && local.PastEvents)
				{
					buildList(local.PastEvents,
						function() { return "other-years no-print"; },
						function() { return "in " + local.City; },
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
						function() { return "andere Städte"; },
						function(item) { return item.City; },
						function(item) { return ".NET Open Space in " + item.City; },
						function(item) { return item.URL; }
					)
					.insertAfter("#HeaderDiv");
				}
			});
});