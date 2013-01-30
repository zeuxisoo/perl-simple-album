(function($) {

	$(document).ready(function() {
		// Active the navigation elements when url match
		$('ul.nav > li').removeClass('active');
		$('ul.nav > li > a[href="' + document.location.href + '"]').parent().addClass('active');
	});

})(jQuery);