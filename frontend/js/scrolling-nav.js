//jQuery to collapse the navbar on scroll
$(window).scroll(function() {
    if ($(".navbar").offset().top > 50) {
        $(".navbar-fixed-top").addClass("top-nav-collapse");
    } else {
        $(".navbar-fixed-top").removeClass("top-nav-collapse");
    }
});

//jQuery for page scrolling feature - requires jQuery Easing plugin
$(function() {
    $('a.page-scroll').bind('click', function(event) {
        var $anchor = $(this);
        var headerHeight = $(".header").height();
		if($(window).width() <= 990){
			headerHeight = 94;	
		}
        $('html, body').stop().animate({
           scrollTop: (($($anchor.attr('href')).offset().top)- headerHeight)
        }, 1500, 'easeInOutExpo');
        event.preventDefault();
    });
});
