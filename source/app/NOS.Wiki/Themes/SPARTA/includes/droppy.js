$.fn.droppy = function(hoverOn, options)
{
	options = $.extend({ speed: 250 }, options || {});

	this.each(function()
	{
		var root = this, zIndex = 1000;

		function getSubnav(ele)
		{
			var subnav = $(hoverOn, ele);
			return subnav.length ? subnav[0] : null;
		}

		function hide()
		{
			var subnav = getSubnav(root);
			if (!subnav) return;

			$.data(subnav, 'cancelHide', false);

			setTimeout(function()
			{
				if (!$.data(subnav, 'cancelHide'))
				{
					$(subnav).hide();
				}
			}, 500);
		}

		function show()
		{
			var subnav = getSubnav(root);
			if (!subnav) return;

			$.data(subnav, 'cancelHide', true);
			$(subnav).css({ zIndex: zIndex++ }).show();
		}

		if (hoverOn)
		{
			$(hoverOn, root).hover(show, hide);
		}

		$(root).each(function() { $(this).hover(show, hide); });
	});
};
