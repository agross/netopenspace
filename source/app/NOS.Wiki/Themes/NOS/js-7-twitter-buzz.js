$(document).ready(function()
{
	$('<div>')
		.addClass('buzz')
		.addClass('no-print')
		.append($('<div>').addClass('content')
			.append($('<p>').text('Buzz'))
			.append($('<div>')
				.addClass('monitter')
				.attr('title', '#netos2009 OR #nos_sued')))
		.insertAfter("#HeaderDiv");
});