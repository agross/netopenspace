/*
 * Based on Droppy 0.1.2
 * (c) 2008 Jason Frame (jason@onehackoranother.com)
 */
$.fn.droppy = function(options) {

	options = $.extend({speed: 250}, options || {});

	this.each(function() {

	var root = this, zIndex = 1000;

	function getSubnav(ele) {
		var subnav = $('ul', ele);
		return subnav.length ? subnav[0] : null;
	}

	function hide() {
		var subnav = getSubnav(root);
		if (!subnav) return;

		$.data(subnav, 'cancelHide', false);

		setTimeout(function() {
		if (!$.data(subnav, 'cancelHide'))
		{
			$(subnav).hide();
		}
		}, 500);
	}

	function show() {
		var subnav = getSubnav(root);
		if (!subnav) return;

		$.data(subnav, 'cancelHide', true);
		$(subnav).css({zIndex: zIndex++}).show();
	}

	$('> span > a', this).hover(show, hide);
	$('ul', $('#workspaces')).each(function(){ $(this).hover(show, hide); });
	});
};
