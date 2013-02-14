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
		$("#filters div[data-preset]").click(function() {
			var id = "preset-image";

			// Make id
			var image  = $(".fileupload-exists > img");
			if (typeof image.attr("id") == "undefined") {
				image.attr("id", id);
			}

			//
			var filter_block = $(this);
			var filter_name  = filter_block.data("preset");
			var filter_html  = filter_block.html();

			$(this).html("Rendering...");

			Caman("#" + id, function() {
				this.revert();
				this[filter_name]().render(function() {
					filter_block.html(filter_html);

					$("input[name=image_data_uri]").attr('value', this.toBase64());
				});
			});
		});
	});

})(jQuery);
