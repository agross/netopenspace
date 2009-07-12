/*
 * JavaScript Pretty Date
 * Copyright (c) 2008 John Resig (jquery.com)
 * Licensed under the MIT license.
 */

// Takes an ISO time and returns a string representing how
// long ago the date represents.
function prettyDate(time){
	var date = new Date((time || "").replace(/-/g,"/").replace(/[TZ]/g," ")),
		diff = (((new Date()).getTime() - date.getTime()) / 1000),
		day_diff = Math.floor(diff / 86400);
			
	if ( isNaN(day_diff) )
		return;
	if ( day_diff >= 31 )
		return date.getDate() + "." + date.getMonth() + "." + date.getFullYear();
			
	return day_diff <= 0 && (
			diff < 60 && "soeben" ||
			diff < 120 && "vor 1 Minute" ||
			diff < 3600 && "vor " + Math.floor( diff / 60 ) + " Minuten" ||
			diff < 7200 && "vor 1 Stunde" ||
			diff < 86400 && "vor " + Math.floor( diff / 3600 ) + " Stunden") ||
		day_diff == 1 && "gestern" ||
		day_diff < 7 && "vor " + day_diff + " Tagen" ||
		day_diff < 31 && "vor " + Math.ceil( day_diff / 7 ) + " Wochen";
}

// If jQuery is included in the page, adds a jQuery plugin to handle it as well
if ( typeof jQuery != "undefined" )
	jQuery.fn.prettyDate = function(){
		return this.each(function(){
			var date = prettyDate(this.title);
			if ( date )
				jQuery(this).text( date );
		});
	};

String.prototype.prettyDate = function()
{
	return prettyDate(this);
};
