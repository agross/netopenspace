jQuery.fn.reverse = Array.prototype.reverse;

String.prototype.linkify = function () {
    return this.replace(/[A-Za-z]+:\/\/[A-Za-z0-9-_]+\.[A-Za-z0-9-_:%&\?\/.=]+/g, function (m) {
        return m.link(m);
    });
};

String.prototype.linkuser = function () {
    return this.replace(/[@]+[A-Za-z0-9-_]+/g, function (u) {
        var username = u.replace("@", "")
        return u.link("http://twitter.com/" + username);
    });
};

String.prototype.linktag = function () {
    return this.replace(/[#]+[A-Za-z0-9-_]+/, function (t) {
        var tag = t.replace("#", "%23")
		return t.link("http://search.twitter.com/search?q=" + tag);
    });
};

function fetch_tweets(elem) {
    elem = $(elem);
    input = elem.attr('title').replace(/#/g, '%23');
    lang = elem.attr('lang');
	
    if (input != window.monitter['text-' + input]) {
        window.monitter['last_id' + input] = 0;
        window.monitter['text-' + input] = input;
        window.monitter['count-' + input] = 12;;
    }
	
    if (window.monitter['count-' + input] > 10) {
        elem.prepend('<div class="tweet">real time twitter by: <a href="http://monitter.com" target="_blank">monitter.com</a></div>');
        window.monitter['count-' + input] = 0;
    }
	
    var url = "http://search.twitter.com/search.json?q=" + input + "&lang=" + lang + "&rpp=" + rrp + "&since_id=" + window.monitter['last_id' + input] + "&callback=?";
	
    $.getJSON(url, function (json) {
        $('div.tweet:gt(' + window.monitter['limit'] + ')', elem).each(function () {
            $(this).fadeOut(1000)
        });
		
        $(json.results).reverse().each(function () {
            if ($('#tw' + this.id, elem).length == 0) {
                window.monitter['count-' + input]++;
                var thedatestr = this.created_at.prettyDate();
				
				var div = $('<div>')
					.attr('id', 'tw' + this.id)
					.addClass('tweet')
					.append($('<a>')
						.attr('href', 'http://twitter.com/' + this.from_user)
						.attr('target', '_blank')
						.attr('title', this.from_user)
						.append($('<img>')
							.attr('src', this.profile_image_url)))
					.append($('<p>')
						.addClass('text')
						.html(this.text.linkify().linkuser().linktag()))
					.append($('<p>')
						.addClass('time')
						.append($('<a>')
							.attr('href', 'http://twitter.com/' + this.from_user + '/status/' + this.id)
							.attr('target', '_blank')
							.text(this.created_at.prettyDate())))
		
                window.monitter['last_id' + input] = this.id;
                elem.prepend(div);
				
                div.hide().fadeIn(1000);
            }
        });
		
        input = escape(input);
        rrp = 1;
        setTimeout(function () {
            fetch_tweets(elem)
		}, 2000);
    });
	
    return (false);
}

$(document).ready(function () {
    window.monitter = {};
    $('.monitter').each(function (e) {
        rrp = 6;
        fetch_tweets(this);
    });
});