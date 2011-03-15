(function($)
{
    $.fn.zoomer = function(params)
    {
        var defaults = {
            view: 400,
			display: 5000,
			remove: 400,
			parent: $("body"),
			previewContainer: function(element) {
				return $(element).closest(".bubble");
			}
        };
        
		var opts = $.extend(defaults, params);
		
		$(this).each(function() {
			var img = $("<img>")
						.addClass("preview")
						.attr("src", $(this).data("preview"))
						.hide();
						
			var layer = $("<div>")
							.addClass("preview")
							.css({
								left: $(this).position().left,
								top: $(this).position().top,
								width: $(this).width(),
								height: $(this).height(),
							}).append(img);
			
			opts.parent.append(layer);
			
			var container = opts.previewContainer(this);
			
			layer.animate({
				left: container.position().left,
				top: container.position().top,
				width: container.outerWidth(),
				height: container.outerHeight(),
			}, opts.view, function() { 
				layer.css("border", 0);
				img.fadeIn();
			}).delay(opts.display)
			.fadeOut(opts.remove, function() {
				$(this).remove();
			});
		});
				
		return $(this);
    }
}
)(jQuery);