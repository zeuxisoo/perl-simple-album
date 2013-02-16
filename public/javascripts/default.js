(function($) {

	$(document).ready(function() {
		// Active the navigation elements when url match
		$('ul.nav > li').removeClass('active');
		$('ul.nav > li > a[href="' + document.location.href + '"]').parent().addClass('active');

		// File upload
		$('.fileupload').fileupload({
			uploadtype: "image",
			name: "image"
		});

		//
		var is_busy = false;
		$("#filters div[data-preset]").click(function() {
			if (is_busy === true) {
				return;
			}

			var id = "preset-image";

			// Find image block
			var image  = $(".fileupload-exists > img,canvas");

			// Check is or not exists image
			if (image.length <= 0) {
				$.when(
					$("<span class='pull-right label label-warning'>Please select image first</span>")
						.css('opacity', 0.5)
						.insertAfter("#filters > h4")
						.hide()
						.slideDown()
				).done(function(target) {
					setTimeout(function() {
						target.slideUp();
					}, 2000);
				});
				return;
			}

			// Make id
			if (typeof image.attr("id") == "undefined") {
				image.attr("id", id);
			}

			// Make filter
			var filter_block = $(this);
			var filter_name  = filter_block.data("preset");
			var filter_html  = filter_block.html();

			is_busy = true;

			$(this).html("Rendering...");

			Caman("#" + id, function() {
				this.revert();
				this[filter_name]().render(function() {
					filter_block.html(filter_html);

					$("input[name=image_data_uri]").attr('value', this.toBase64());

					is_busy = false;
				});
			});
		});
	});

})(jQuery);
