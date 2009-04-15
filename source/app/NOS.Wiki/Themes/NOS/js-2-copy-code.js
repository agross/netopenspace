var copyCode =
{
	copyCodeText: "Kopieren",
	copyCodeTitle: "In die Zwischenablage kopieren",
	init: function()
	{
		if (!document.getElementsByTagName || !document.createElement)
		{
			return;
		}

		var pres = document.getElementsByTagName("pre");
		for (var i = 0; i < pres.length; i++)
		{
			var pre = pres[i];
			if(copyCode.isItemPre(pre))
			{
				var copyLink = document.createElement("a");
				copyLink.setAttribute("title", copyCode.copyCodeTitle);
				if (BrowserDetect.browser === "Explorer")
				{
					copyLink.onclick = function() { copyCode.copyToClipboard(this); };
				}
				else
				{
					copyLink.setAttribute("onclick", "copyCode.copyToClipboard(this);");
				}
				copyLink.className = "copy-code";
				copyLink.appendChild(document.createTextNode(copyCode.copyCodeText));

				pre.parentNode.insertBefore(copyLink, pre);
			}
		}
	},
	isInContent: function(element)
	{
		if(element.parentNode && typeof(element.parentNode.id) !== "undefined")
		{
			if(element.parentNode.id.search(/PageContentDiv/i) !== -1)
			{
				return true;
			}
			else
			{
				return copyCode.isInContent(element.parentNode);
			}
		}
		else
		{
			return false;
		}
	},
	isItemPre: function(pre)
	{
		return pre.className.search(/no-copy/i) === -1 && // Exclude explicitly excluded pres.
			copyCode.isInContent(pre);
	},
	copyToClipboard: function(link)
	{
		if (typeof(link) === "undefined")
		{
			return;
		}

		var text;

		if (window.clipboardData)
		{
			// IE.
			text = copyCode.trim(link.nextSibling.innerText);
			window.clipboardData.setData("Text", text);
		}
		else
		{
			text = copyCode.trim(link.nextSibling.textContent);

			if (!document.getElementById("flashcopier"))
			{
				var flash = document.createElement("div");
				flash.id = "flashcopier";
				document.body.appendChild(flash);
			}

			document.getElementById("flashcopier").innerHTML = "";
			var divinfo = '<embed src="Themes/NOS/clipboard.swf" FlashVars="clipboard=' + encodeURIComponent(text) + '" width="0" height="0" type="application/x-shockwave-flash"></embed>';
			document.getElementById("flashcopier").innerHTML = divinfo;
		}
	},
	// Taken from http://blog.stevenlevithan.com/archives/faster-trim-javascript.
	trim: function(str)
	{
		str = str.replace(/^\s\s*/, '');
		var whitespace = /\s/;
		var i = str.length;
		while (whitespace.test(str.charAt(--i)));

		return str.slice(0, i + 1);
	},
	addEvent: function(obj, eventTypes, callback)
	{
		var eventType;
		for(var i = 0; i < eventTypes.length; i++)
		{
			eventType = eventTypes[i];

			if (obj.attachEvent)
			{
				obj["e" + eventType + callback] = callback;
				obj[eventType + callback] = function()
				{
					obj["e" + eventType + callback](window.event);
				};
				obj.attachEvent("on" + eventType, obj[eventType + callback]);
			}
			else
			{
				obj.addEventListener(eventType, callback, false);
			}
		}
	}
};

copyCode.addEvent(window, ["load"], copyCode.init);