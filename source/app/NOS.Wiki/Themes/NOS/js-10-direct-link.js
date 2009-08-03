function addLink(element) {
    element = $(element);
	
	var anchor = element.children('a[id]:first')
	if (anchor.length === 0)
	{
		anchor = element.prev('a[id]');
	}
	
	if (anchor.length === 1)
	{
		element
			.html($.trim(element.html()))
			.append($('<a>')
				.addClass('direct-link')
				.attr('href', '#' + anchor.attr('id'))
				.attr('title', 'Verknüpfung zu diesem Abschnitt')
				.html('&para;'));
	}
}

$(document).ready(function () {
	jQuery.fn.directLink = function() {
		$(this).each(function() {
			addLink(this);
		});
	
		return this;
	};  
	
	$('#PageContentDiv h1.separator, #PageContentDiv h2.separator, #PageContentDiv h3.separator, #PageContentDiv h4.separator').directLink();
});