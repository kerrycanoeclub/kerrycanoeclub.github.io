// jQuery for page scrolling feature - requires jQuery Easing plugin
$(function() {
    $('a.page-scroll').bind('click', function(event) {
        var $anchor = $(this);
        $('html, body').stop().animate({
            scrollTop: $($anchor.attr('href')).offset().top
        }, 1500, 'easeInOutExpo');
        event.preventDefault();
    });
});

// Highlight the top nav as scrolling occurs
$('body').scrollspy({
    target: '.navbar-fixed-top'
})

// Closes the Responsive Menu on Menu Item Click
$('.navbar-collapse ul li a').click(function() {
    $('.navbar-toggle:visible').click();
});

$('div.modal').on('show.bs.modal', function() {
	var modal = this;
	var hash = modal.id;
	window.location.hash = hash;
	window.onhashchange = function() {
		if (!location.hash){
			$(modal).modal('hide');
		}
	}
});

function init_map() {

    var isDraggable = $(document).width() > 480 ? true : false;

    var myOptions = {
        draggable: isDraggable,
        scrollwheel: false,
        zoom: 15,
        // center: new google.maps.LatLng(52.105744550215384, -9.783696569836366),
        center: new google.maps.LatLng(52.104981, -9.780358),
        mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    map = new google.maps.Map(document.getElementById("map-container"), myOptions);
    marker = new google.maps.Marker({
        map: map,
        position: new google.maps.LatLng(52.105744550215384, -9.783696569836366)
    });
    infowindow = new google.maps.InfoWindow({content: "<b>Bianconi Carpark</b><br/>Off Annadale Road<br/> Killorglin"});
    google.maps.event.addListener(marker, "click", function () {
        infowindow.open(map, marker);
    });
    infowindow.open(map, marker);
}
google.maps.event.addDomListener(window, 'load', init_map);