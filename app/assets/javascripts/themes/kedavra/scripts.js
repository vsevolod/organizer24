/*
 *Kedavra HTML5 Multipurpose Template v2.0
 *Copyright 2015 8Guild.com
 *All scripts for Kedavra HTML5 Multipurpose Template
 */

/*Document Ready*////////////////////////////////////////////////////////////////////////////////////////////////////////////////
jQuery(document).ready(function($) {
	'use strict';
	
	/*Global Variables
	*******************************************/
	/// Header / Navigation Variables------------------------------------
	var $header = $('.header');
	var $headerToolbar = $('.header-toolbar');
	var $stickyHeader = $('.header.sticky');
	var $scrollHeader = $('.header.scroller');
	var $transpHeader = $('.header.transparent');
	var $menuItem = $('.menu ul li');
	var $naviToggle = $('#nav-toggle');
	var $exitOffCanv = $('.exit-off-canvas');
	var $megaSubmLink = $('.mega-menu .has-submenu a');
	var $megaSubmenu = $('.mega-menu .mega-submenu');
	var $megaMenu = $('.mega-menu');
	var $mobSubmenuToggle = $('.mobile-navi ul li span');
	var $mobButtonsToggle = $('.mobile-navi .buttons li > a');
	var $cartCarousel = $('.cart-dropdown .owl-carousel');
	var $cartPromo = $('.cart-dropdown .promo-code');
	var $cartPromoInput = $('.promo-code input[type="text"]');
	var $searchBtn = $('.header .search');
	
	/// Hero Units Variables--------------------------------------------
	var $heroFs = $('.hero-static.fullscreen');
	var $heroFsInner = $('.hero-static.fullscreen .inner');
	var $heroParallax = $('.hero-parallax')
	/// ----------------------------------------------------------------
	
	/// Forms Variables-------------------------------------------------
	var $contForm = $('.contact-form');
	var $qcForm = $('.quick-contact');
	var $scrollTopBtn = $('#scrollTop-btn');
	var $qcfBtn = $('#qcf-btn');
	var $qsForm = $('.header .quick-search');
	var $contForm = $('.contact-form');
	var $loginForm = $('.login-form');
	var $signupForm = $('.signup-form');
	var $accountSetForm = $('.account-settings');
	var $mailAddressForm = $('form[name="mailing-address"]');
	var $mailAddressForm = $('form[name="mailing-address"]');
	var $billAddressForm = $('form[name="billing-address"]');
	var $subscrWidgetForm = $('.sidebar .subscribe form');
	var $subscrFooterForm = $('.footer .subscribe form');
	var $commentForm = $('.comment-form');
	var $bookingForm = $('form[name="booking-form"]');
	var $eventRegistr = $('form[name="event-registration"]');
	var $signInForm = $('form[name="signin-form"]');
	var $checkoutForm = $('form[name="checkout"]');
	var $updateSubscribe = $('form[name="update-subscribe-form"]');
	/// ----------------------------------------------------------------
	
	///Interactive Widgets Variables------------------------------------
	var $harmonic = $('.harmonic .item');
	var $tooltip = $('.tooltipped');
	var $percentChart = $('.percent-chart');
	var $lightGallery = $('.lightGallery');
	var $logoCarousel = $('.logo-carousel');
	var $sidebarBtn = $('.sidebar-button');
	var $shareBar = $('.share-modal .bar');
	var $infoClose = $('.info-string .close');
	var $bannerClose = $('.info-block .close');
	/// ----------------------------------------------------------------
	
	/// Shop Variables------------------------------------------
	var $shareBtn = $('.item footer .tools .share-btn');
	var $clearChecks = $('.clearChecks');
	var $purchHistToggle = $('.shop-history .panel-heading a');
	var $packageCarousel = $('.package-carousel');
	var $scItemDelete = $('.shopping-cart .item .delete');
	var $interactiveCard = $('.card-fields');
	/// ----------------------------------------------------------------
	
	/// User Account Variables------------------------------------------
	var $editPass = $('.account-settings .pass-block .edit-btn');
	var $closePass = $('.account-settings .pass-block .close');
	/// ----------------------------------------------------------------
	
	
	///////////////////////////////////////////////////////////////////////
	/////////////////////  Fullscreen Hero Image  /////////////////////////
	//////////////////////////////////////////////////////////////////////
	
	$(window).on('load', function(){
		$heroFs.after('<div class="holder"></div>');
		$heroFs.css('min-height', $(window).height());
		$heroFsInner.css('min-height', $(window).height());
		$('.holder').css('min-height', $(window).height());
		if($stickyHeader.length > 0) {
			$('.holder').css('min-height', $(window).height()-$stickyHeader.height());
		}
	});
	$(window).on('resize', function(){
		$heroFs.css('min-height', $(window).height());
		$heroFsInner.css('min-height', $(window).height());
		$('.holder').css('min-height', $(window).height());
		if($stickyHeader.length > 0) {
			$('.holder').css('min-height', $(window).height()-$stickyHeader.height());
		}
	});

	///////////////////////////////////////////////////////////////////////
	///////////////////  Header / Navigation  /////////////////////////////
	//////////////////////////////////////////////////////////////////////
	
	/*Sticky Header
	*******************************************/
	$(window).on('load', function(){
		$stickyHeader.waypoint('sticky');
		$scrollHeader.waypoint('sticky');
	});
	
	/*Transparent Header
	*******************************************/
	$(window).on('load', function(){
		if($transpHeader.length > 0) {
			var $logoAlt = $transpHeader.find('.logo > img').data('logo-alt');
			$transpHeader.find('.logo > img').attr('src', $logoAlt);
		}
	});
	$(window).on('scroll', function(){
		var $logoAlt = $transpHeader.find('.logo > img').data('logo-alt');
		var $logoDefault = $transpHeader.find('.logo > img').data('logo-default');
		if($(window).scrollTop() > $(window).height()) {
			$transpHeader.addClass('opaque');
			$transpHeader.find('.logo > img').attr('src', $logoDefault);
		} else {
			$transpHeader.removeClass('opaque');
			$transpHeader.find('.logo > img').attr('src', $logoAlt);
		}
	});
		
	
	/*Navi Toggle Animation
	*******************************************/
	$naviToggle.click(function(){
		$(this).toggleClass('active');
		$header.find('.inner').toggleClass('no-shadow');
	});
	$exitOffCanv.click(function(){
		$naviToggle.removeClass('active');
		$header.find('.inner').removeClass('no-shadow');
	});
	
	/*Foundation Off-Canvas / Intercharge (for responsive images)
	***************************************************************************************/
	$(document).foundation({
		offcanvas : {
			open_method: 'move', // Sets method in which offcanvas opens, can also be 'overlap'
			close_on_click : true
		}
	});
	
	/*Mobile Navigation
	*******************************************/
	//Breakpoints
	$.breakpoint({
			condition: function () {
					return window.matchMedia('only screen and (max-width:1024px)').matches;
			},
			exit: function () {
				$(window).scrollTop(50); //Topper Issue fix on resize
				$exitOffCanv.trigger('click', function(){
					$naviToggle.removeClass('active');
				});
			}
	});
	
	//Submenu Toggles
	$mobSubmenuToggle.click(function(){
		if($(this).parent().hasClass('active')) {
			$(this).siblings('ul').removeClass('open');
			$(this).parent().removeClass('active');
		} else {
			$(this).parent().siblings('li').removeClass('active');
			$(this).parent().siblings('li').find('ul').removeClass('open');
			$(this).siblings('ul').toggleClass('open');
			$(this).parent().toggleClass('active');
		}
	});
	
	//Mobile Langs and Currency Toggles
	$mobButtonsToggle.click(function(e){
		if($(this).parent().hasClass('active')) {
			$(this).siblings('ul').removeClass('open');
			$(this).parent().removeClass('active');
			$mobButtonsToggle.removeClass('non-active');
		} else {
			$(this).parent().siblings('li').removeClass('active');
			$(this).parent().siblings('li').find('ul').removeClass('open');
			$(this).siblings('ul').toggleClass('open');
			$mobButtonsToggle.addClass('non-active');
			$(this).parent().toggleClass('active');
		}
		return false;
	});
	
	
	/*Cart Dropdown
	*******************************************/
	//Items Carousel
	$cartCarousel.owlCarousel({
		margin: 10,
		loop: false,
		dots: false,
		navText: [
			'<div class="arr01"></div><div class="arr02"></div>',
			'<div class="arr03"></div><div class="arr04"></div>'
		],
    responsive:{
        0:{
            items: 1,
            nav: true
        },
        600:{
            items: 3,
            nav: false
        },
        1000:{
            items: 3,
            nav: true
        }
    }
	});
	
	//Add(+/-) Button Number Incrementers
	$(".incr-btn").on("click", function(e) {
		var $button = $(this);
		var oldValue = $button.parent().find('.quantity').val();
		$button.parent().find('.incr-btn[data-action="decrease"]').removeClass('inactive');
		if ($button.data('action') == "increase") {
			var newVal = parseFloat(oldValue) + 1;
		} else {
		 // Don't allow decrementing below 1
			if (oldValue > 1) {
				var newVal = parseFloat(oldValue) - 1;
			} else {
				newVal = 1;
				$button.addClass('inactive');
			}
		}
		$button.parent().find('.quantity').val(newVal);
		e.preventDefault();
	});
	
	//Deleting Items
	$(document).on('click', '.cart-dropdown .item .delete', function(){
		var $emptyCart = $('.empty-cart');
		var $target = $(this).parent().parent();
		var $positions = $('.cart-dropdown .item');
		var $positionQty = parseInt($('.cart-btn > .link span').text());
		$target.fadeOut(300, function(){
			$.when($target.remove()).then( function(){
				$positionQty = $positionQty -1;
				$('.cart-btn > .link span').text($positionQty);
				if($positions.length === 4) {
					$('.cart-dropdown .owl-nav').hide();
				}
				if($positions.length === 1) {
					$('.cart-dropdown .wrap .container .row').remove();
					$emptyCart.appendTo($('.cart-dropdown .wrap .container'));
					$emptyCart.css('display', 'block');
				}
			});
		});
	});
	
	//Promo Code
	$('.cart-dropdown #promo-code-link').click(function(e){
		$(this).hide();
		$cartPromo.addClass('visible');	
		e.preventDefault();
	});
	$cartPromoInput.on('focus', function(){
		$(this).parent().find('.btn').removeClass('disabled').addClass('btn-primary');
	});
	$cartPromoInput.on('blur', function(){
		if($(this).val() === ''){
			$(this).parent().find('.btn').removeClass('btn-primary').addClass('disabled');
		}
	});
	
	
	/*Quick Search Form Animation
	*******************************************/
	$searchBtn.click(function() {
		$qsForm.toggleClass('open');
	});
	$('.topper, .page, .footer').click(function(){
		$qsForm.removeClass('open');
	});
	$(window).on('resize', function(){
		$qsForm.removeClass('open');
	});

	/*Mega Menu
	*******************************************/
	//Submenu Switching on Hover
	$megaSubmLink.on('mouseenter', function(){
		var $target = $(this).attr('data-target');
		$(this).parent().parent().find('.has-submenu').removeClass('active');
		$(this).parent().addClass('active');
		$(this).parent().parent().parent().parent().find($megaSubmenu).removeClass('active');
		$($target).addClass('active');
	});

	///////////////////////////////////////////////////////////////////////
	///////////  Parallax Backgrounds / OnScroll Animations  //////////////
	//////////////////////////////////////////////////////////////////////

	$(window).on('load', function(){
		/*Checking if it's touch device we disable parallax / Onscroll animations feature due to inconsistency*/
		if (Modernizr.touch) { 
		
			$('body').removeClass('parallax');
			$('body').removeClass('animated fadeIn');
			$('*').removeClass('animation');
		}
		
		/*Parallax Backgrounds
		*********************************************/
		if($('.parallax').length > 0){
			$('.parallax').stellar({
				horizontalScrolling: false,
				responsive:true
			});
		}
		
		/*Content Animations On Scroll
		*********************************************/
		if($('.animation').length > 0){
			$('.animation').waypoint(function() {
					 var $animation = $(this).data("animation");
					 $(this).addClass($animation);
					 $(this).addClass('animated');
			}, { offset: '82%' });
		}
		
	});
	
	///////////////////////////////////////////////////////////////////////
	/////////////////////////  Parallax Hero  ////////////////////////////
	//////////////////////////////////////////////////////////////////////
	
	$heroParallax.parallax();
	
	///////////////////////////////////////////////////////////////////////
	///////////////////////  Custom Widgets  /////////////////////////////
	//////////////////////////////////////////////////////////////////////
	
	/*Harmonic Widget
	*********************************************/
	$harmonic.hover(function(){
		$harmonic.addClass('collapsed');
		$(this).removeClass('collapsed').addClass('expanded');
	}, function(){
		$harmonic.removeClass('collapsed').removeClass('expanded');
	});
	
	/*Share Bars Animation + Mail (Share Modal)
	*********************************************/
	$shareBar.hover(function(){
		$shareBar.addClass('collapsed');
		$(this).removeClass('collapsed').addClass('expanded');
	}, function(){
		$shareBar.removeClass('collapsed').removeClass('expanded');
	});
	
	/*Animated Digits Widget
	************************************************************/
	//Function
	var countNumb = (function() {
		var that = {};
		that.init = function() {

				$(".animated-digits .digit").each(function() {
						var dataNumber = $(this).attr('data-number');

						$(this).numerator({
								easing: 'swing', // easing options.
								duration: 2500, // the length of the animation.
								delimiter: '.',
								rounding: 0, // decimal places.
								toValue: dataNumber // animate to this value.
						});
				});
		};

		return that;

	})();
	
	//Initialisation
	$('.digits').waypoint(function(direction) {
			countNumb.init() + 'down';
	}, {
			offset: '65%',
			triggerOnce: true
	});
	
	/*Countdown Widget
	************************************************************/
	// Under Construction Page Timer
	if($('#timer1').length > 0) {
		$('#timer1').countdown('2015/5/20', function(event) {
			$(this).html(event.strftime('%D : %H : %M : %S'));
		});
	}
	
	// Event Timer
	if($('#timer2').length > 0) {
		$('#timer2').countdown('2015/5/20', function(event) {
			$(this).html(event.strftime('%D : %H : %M : %S'));
		});
	}
	
	/*Date Picker Widget
	************************************************************/
	if($('#datePicker').length > 0) {
		$('#datePicker').datepicker().on('changeDate', function(e){
      $('#chosen_date').val(e.format('dd/mm/yyyy'))
    });;
		$('.datepicker .prev').html('<i class="fa fa-angle-left"></i>');
		$('.datepicker .next').html('<i class="fa fa-angle-right"></i>');
	}
	
	/*Slide Up/Down Home Events
	************************************************************/
	$('#slide-up-toggle').click(function(){
		$('.slide-up').toggleClass('open');
	});
	
	/*Dismissing / Closing Elements
	************************************************************/
	//Information Strip on top of header
	$infoClose.click(function(){
		var $target = $(this).parent().parent();
		$target.fadeOut(300, function(){
			$target.remove();
			$.waypoints('refresh');
		});
	});
	
	//Advertising Banner
	$bannerClose.click(function(){
		var $target = $(this).parent();
		$target.fadeOut(300, function(){
			$target.remove();
		});
	});
	
	/*Animated Percents Chart (Skills)
	************************************************************/
	var $barColor = $percentChart.data('bar-color');
	$percentChart.waypoint(function(direction) {
		$percentChart.easyPieChart({
			animate: 2000,
			easing: 'easeOutBounce',
			barColor: $barColor,
			trackColor: '#e1e4e6',
			size: 140,
			scaleLength: 0,
			lineWidth: 8,
			onStep: function(from, to, percent) {
				$(this.el).find('.percent').text(Math.round(percent));
			}
		}) + 'down';
			//countNumb.init() + 'down';
	}, {
			offset: '85%',
			triggerOnce: true
	});
	
	/*Thumbnail 3D Autoheight / Shopping Cart Column Autoheight
	***********************************************************************/
	$(window).load(function(){
		$('.thumbnail-3d .overlay').height($('.thumbnail-3d img').height()+2);
	});
	$(window).resize(function(){
		$('.thumbnail-3d .overlay').height($('.thumbnail-3d img').height()+2);
	});
	
	/*UI Slider
	*******************************************/
	var $minVal = parseInt($('.ui-slider').attr('data-min-val'));
	var $maxVal = parseInt($('.ui-slider').attr('data-max-val'));
	var $start = parseInt($('.ui-slider').attr('data-start'));
	var $step = parseInt($('.ui-slider').attr('data-step'));
	
	if($('#ui-slider').length>0){
		$('#ui-slider').noUiSlider({
			start: [$start],
			connect: "lower",
			step: $step,
			range: {
				'min': $minVal,
				'max': $maxVal
			},
			format: wNumb({
				decimals: 0,
				thousand: ' ',
				postfix: ' $'
			})
		});
		$("#ui-slider").Link('lower').to('-inline-<div class="tool-tip"></div>', function ( value ) {
			// The tooltip HTML is 'this', so additional
			// markup can be inserted here.
			$(this).html(
				'<span>' + value + '</span>'
			);
		});
	}
	
	/*Tooltips
	*******************************************/
	$tooltip.tooltip();
	
	/*Light Gallery (Lightbox)
	*******************************************/
	$lightGallery.lightGallery({caption: true});
	
	///////////////////////////////////////////////////////////////////////
	/////////////////////////////  Shop Tools  ////////////////////////////
	//////////////////////////////////////////////////////////////////////
	
	/*Share Button
	*******************************************/
	$shareBtn.click(function(e){
		$(this).toggleClass('active');	
		$(this).parent().parent().parent().find('.share-opts').toggleClass('show');	
		$(this).parent().parent().parent().find('.description').toggleClass('hide');
		e.preventDefault();	
	});
	
	/*Clear Checkbox filters (Shop Sidebar)
	*******************************************/
	$clearChecks.click(function(){
		$(this).parent().find('.icheckbox').removeClass('checked');
	});
	
	/*Color Switcher
	*******************************************/
	$('.color-switcher .color').click(function(){
		var $color = $(this).parent().find('.color');
		$color.removeClass('current');
		$(this).addClass('current');
	});
	$('.color-switcher .color[data-target]').click(function(){
		var $thumbs = $(this).parents('.item').find('.thumb img');
		var $target = $(this).data('target');
		$thumbs.removeClass('active');
		$($target).addClass('active');
	});
	
	/*Purchase History
	*******************************************/
	$purchHistToggle.on('click',function(e){
    if($(this).parents('.panel').children('.panel-collapse').hasClass('in')){
			e.preventDefault();
			e.stopPropagation();
    }
		var $preview = $(this).parents('.shop-history').find('.preview img');
		var $target = $(this).data('image');
		$preview.removeClass('active');
		$($target).addClass('active');
	});
	
	/*Shopping Cart Items Delete
	*******************************************/
	$(document).on('click', '.shopping-cart .item .delete', function(){
		var $target = $(this).parent();
		var $positions = $('.shopping-cart .item');
		var $positionQty = parseInt($('.shopping-cart').parents('.container').find('.page-heading h3 i').text());
		$target.fadeOut(300, function(){
			$.when($target.remove()).then( function(){
				$positionQty = $positionQty -1;
				$('.shopping-cart').parents('.container').find('.page-heading h3 i').text($positionQty);
				if($positions.length === 1) {
					$('.shopping-cart header').remove();
					$('.shopping-cart').parents('.container').find('.sidebar').remove();
					$('.shopping-cart').parents('.container').find('.page-heading h3').html('Shopping cart is empty!<span></span>');
				}
			});
		});
	});
	
	/*Wishlist Items Delete
	*******************************************/
	$(document).on('click', '.catalog-grid .item .delete', function(){
		var $target = $(this).parent().parent();
		var $positions = $('.catalog-grid .item');
		var $positionQty = parseInt($('.catalog-grid').parents('.container').find('.page-heading h3 i').text());
		$target.fadeOut(300, function(){
			$.when($target.remove()).then( function(){
				$positionQty = $positionQty -1;
				$('.catalog-grid').parents('.container').find('.page-heading h3 i').text($positionQty);
				if($positions.length === 1) {
					$('.send-wishlist').remove();
					$('.catalog-grid').parents('.container').find('.page-heading h3').html('Your Wishlist is empty!<span></span>');
				}
			});
		});
	});
	
	/*Interactive Credit Card
	*******************************************/
	if($interactiveCard.length > 0){
		$interactiveCard.card({
			container: $('.card-wrapper'),
			numberInput: 'input#cc_number',
			nameInput: 'input#cc_name',
			expiryInput: 'input#cc_expiry',
			cvcInput: 'input#cc_cvc'
		});
	}

	
	///////////////////////////////////////////////////////////////////////
	////////////////////////////  User Account  //////////////////////////
	//////////////////////////////////////////////////////////////////////
	
	/*Password Change Box
	*******************************************/
	$editPass.click(function(){
		$('.pass-block').addClass('expanded');
	});
	
	$closePass.click(function(){
		$('.pass-block').removeClass('expanded');
	});
	
	///////////////////////////////////////////////////////////////////////
	///////////////////  Gallery Grids + Filtering  //////////////////////
	//////////////////////////////////////////////////////////////////////

	/*Massonry Gallery Grid
	*******************************************/
	// Stitching class
	var $filter = $('.filters li a');
	$filter.click(function(){
		$filter.parent().removeClass('current');
		$(this).parent().addClass('current');
	});
	
	// Initialize isotope
	var $gallGridMassonry = $('.gallery-grid.masonry');
	$gallGridMassonry.isotope({
    itemSelector: '.item',
    masonry: {
      columnWidth: '.grid-sizer'
    }
	});
	
	// filter items when filter link is clicked
	$('.filters a').click(function(){
		var selector = $(this).attr('data-filter');
		$gallGridMassonry.isotope({ 
			filter: selector
		});
		return false;
	});
	

	///////////////////////////////////////////////////////////////////////
	/////////////////////////  Google Maps  //////////////////////////////
	//////////////////////////////////////////////////////////////////////
	var geocoder;
	var map;
	var query = $('.google-map').data('location');
	var zoom = $('.google-map').data('zoom');
	
	function initialize() {
		
		geocoder = new google.maps.Geocoder();
		var latlng = new google.maps.LatLng(-34.397, 150.644);
		
			var mapOptions = {
				center: latlng,
				zoom: zoom,
				scrollwheel: false,
				disableDefaultUI: true,
				styles: [{"featureType":"landscape","elementType":"labels","stylers":[{"visibility":"off"}]},{"featureType":"transit","elementType":"labels","stylers":[{"visibility":"off"}]},{"featureType":"poi","elementType":"labels","stylers":[{"visibility":"off"}]},{"featureType":"water","elementType":"labels","stylers":[{"visibility":"off"}]},{"featureType":"road","elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"stylers":[{"hue":"#00aaff"},{"saturation":-100},{"gamma":2.15},{"lightness":12}]},{"featureType":"road","elementType":"labels.text.fill","stylers":[{"visibility":"on"},{"lightness":24}]},{"featureType":"road","elementType":"geometry","stylers":[{"lightness":57}]}]
			};
			
			map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);
			
			codeAddress();
	}
	
	function codeAddress() {
		var image = 'img/map-marker.png';
		var address = query;
		geocoder.geocode( { 'address': address}, function(results, status) {
			if (status == google.maps.GeocoderStatus.OK) {
				map.setCenter(results[0].geometry.location);
				var marker = new google.maps.Marker({
						map: map,
						position: results[0].geometry.location,
						icon: image,
						title: 'My Kedavra Office'
				});
			} else {
				alert('Geocode was not successful for the following reason: ' + status);
			}
		});
	}
	
	if($('#map-canvas').length > 0) {
		google.maps.event.addDomListener(window, 'load', initialize);
	}
	

	///////////////////////////////////////////////////////////////////////
	/////////////////  Forms Validation and Styling  //////////////////////
	//////////////////////////////////////////////////////////////////////
	
	/*Quick Contact Form Validation
	*******************************************/
	$qcForm.validate();
	
	/*Contact Form Validation
	*******************************************/
	$contForm.validate();
	
	/*Login Form Validation
	*******************************************/
	$loginForm.validate();
	
	/*Sign Up Form Validation
	*******************************************/
	$signupForm.validate();
	
	/*Account Settings Form Validation
	*******************************************/
	$accountSetForm.validate();
	
	/*Mailing Adress Form Validation (User Account)
	************************************************/
	$mailAddressForm.validate();
	
	/*Billing Adress Form Validation (User Account)
	************************************************/
	$billAddressForm.validate();
	
	/*Sidebar Subscribe Widget Validation
	************************************************/
	$subscrWidgetForm.validate();
	
	/*Sidebar Subscribe Widget Validation
	************************************************/
	$subscrFooterForm.validate();
	
	/*Comment Form Validation
	************************************************/
	$commentForm.validate();
	
	/*Sign In Form Validation (Checkout Unregistered)
	************************************************/
	$signInForm.validate();
	
	/*Updates Subscription Form
	************************************************/
	$updateSubscribe.validate();
	
	/*Comment Form Validation
	************************************************/
	$bookingForm.validate({
		rules: {
			bf_phone: {
				required: true,
				number: true
			}
		}
	});
	
	/*Event Registration Form Validation
	************************************************/
	$eventRegistr.validate({
		rules: {
			er_phone: {
				required: true,
				number: true
			}
		}
	});
	
	/*Checkout Form Validation
	************************************************/
	$checkoutForm.validate({
		rules: {
			co_shipping_zip: {
				required: true,
				number: true
			},
			co_billing_zip: {
				required: true,
				number: true
			},
			co_billing_phone: {
				required: true,
				number: true
			}
		}
	});
	
	/*Adding Placeholder Support in Older Browsers
	************************************************/
	$('input, textarea').placeholder();
	
	/*Custom Style Checkboxes and Radios
	************************************************/
	$('input').iCheck({
    checkboxClass: 'icheckbox',
    radioClass: 'iradio'
  });
	
	///////////////////////////////////////////////////////////////////////
	///////////////////  User Account Interactions  ///////////////////////
	//////////////////////////////////////////////////////////////////////
	
	/*Hiding User Image in User Account Page - For Demo Only
	**********************************************************************/
	$('.user-avatar .delete').click(function(){
		$(this).hide();
		$(this).parent().find('.user-img').addClass('removed');
	});
	
	/*Adding / Canceling Addresses
	**********************************************************************/
	$('#adress-settings .add-address-btn').click(function(e){
		var $target = $(this).attr('href');
		$('#adress-settings').addClass('hidden');
		$('.hidden-form').removeClass('active');
		$($target).addClass('active');
		e.preventDefault();
	});
	$('.cancel-address-btn').click(function(e){
		$('#adress-settings').removeClass('hidden');
		$('.hidden-form').removeClass('active');
		e.preventDefault();
	});
	
	///////////////////////////////////////////////////////////////////////
	///////////////////  Interactive Radar Chart  /////////////////////////
	//////////////////////////////////////////////////////////////////////
	
	var fillColor = $('.chart').data('fill');
	var lineColor = $('.chart').data('lines');
	var radarChartData = {
		labels: ["Administrative", "Bankruptcy", "Employment/Labor", "Immigration", "Transactions", "Divorces", "Criminal Law"],
		datasets: [
			{
				label: "First dataset",
				fillColor: "rgba(220,220,220,0.2)",
				strokeColor: "rgba(220,220,220,1)",
				pointColor: "rgba(220,220,220,1)",
				pointStrokeColor: "#fff",
				pointHighlightFill: "#fff",
				pointHighlightStroke: "rgba(220,220,220,1)",
				data: [68,50,92,78,46,100,40]
			},
			{
				label: "Second dataset",
				fillColor: fillColor,
				strokeColor: lineColor,
				pointColor: lineColor,
				pointStrokeColor: "#fff",
				pointHighlightFill: "#fff",
				pointHighlightStroke: lineColor,
				data: [28,68,40,19,96,27,100]
			}
		]
	};

	window.onload = function(){
		if($('#chart').length > 0){
			window.myRadar = new Chart(document.getElementById("chart").getContext("2d")).Radar(radarChartData, {
				responsive: true
			});
		}
	}
	
	///////////////////////////////////////////////////////////////////////
	/////////////////// Sliders & Carousels  /////////////////////////////
	//////////////////////////////////////////////////////////////////////
	
	/*Fullscreen Hero Slider
	************************************************/
	var fs_slider = new MasterSlider();
 
	fs_slider.control("arrows", {autohide:true});
	fs_slider.setup("fs-slider", {
			width:1024,
			height:768,
			centerControls: false,
			layout:"fullscreen",
			preload: 'all',
			loop:true,
			speed:20
	});
	
	
	/*Partial View Slider
	************************************************/
	var partView = new MasterSlider();

    partView.control('arrows');
    partView.control('slideinfo',{insertTo:"#partial-view" , autohide:false, align:'bottom', size:100});
    partView.control('circletimer' , {color:"#FFFFFF" , stroke:9});

    partView.setup('slider01' , {
        width:760,
        height:400,
        space:10,
        loop:true,
        view:'partialWave',
        layout:'partialview'
    });
		
	/*Fullwidth Partial View Slider
	************************************************/
		var fsPartView = new MasterSlider();
		
		fsPartView.control('arrows');	
		fsPartView.control('slideinfo',{insertTo:"#fs-partial-view-info" , autohide:false, align:'bottom', size:160});
		fsPartView.control('circletimer' , {color:"#FFFFFF" , stroke:9});
		
		fsPartView.setup('fs-partial-view' , {
			width: 760,
			height: 400,
			space: 10,
			loop: true,
			view: 'fadeFlow',
			layout: 'partialview'
		});
		
	/*Display Slider
	************************************************/
	var slider = new MasterSlider();
    slider.setup('masterslider' , {
        width: 507,
        height: 286,
        speed: 20,
        preload: 0,
        space: 2,
        view: 'flow'
    });
    slider.control('arrows');  
    slider.control('bullets',{autohide:false});
		
	/*Staff 3D Carousel
	************************************************/
	var staffCar = new MasterSlider();
	
	staffCar.setup('slider02' , {
			loop:true,
			width:240,
			height:240,
			speed:20,
			view:'wave',
			preload:0,
			space:0
	});
	staffCar.control('arrows');
	staffCar.control('slideinfo',{insertTo:'#staff-info'});
	
	/*Product Showcase Slider
	************************************************/
	var showcaseSlider = new MasterSlider();
    showcaseSlider.setup('showcase-slider' , {
        width:1024 ,
        height:580,
        space:0,
        fillMode:'fit',
        speed:25,
        preload:'all',
        view:'flow',
        loop:true
    });
     
    showcaseSlider.control('arrows', {autohide:false});  
    showcaseSlider.control('bullets', {autohide:false, align:'bottom', margin:-30});
	
	/*Logos Carousel
	************************************************/
	var $autoplay = $logoCarousel.data('auto-play');
	var $timeout = $logoCarousel.data('timeout');
	$logoCarousel.owlCarousel({
		loop: true,
		dots: false,
		nav: false,
		autoplay: $autoplay,
		autoplayTimeout: $timeout,
    responsive:{
        0:{
            items: 2,
        },
        600:{
            items: 3,
        },
        1000:{
            items: 4,
        }
    }
	});
	
	/*Portfolio Single Slider
	************************************************/
	var portfolioSlider = new MasterSlider();
		portfolioSlider.setup('portfolioSlider' , {
				 width:800,    // slider standard width
				 height:840,   // slider standard height
				 space:5,
				 view: "flow"
				 // more slider options goes here...
				 // check slider options section in documentation for more options.
		});
		// adds Arrows navigation control to the slider.
		portfolioSlider.control('arrows');
		portfolioSlider.control('bullets', {autohide:false});
		
	/*Post Single Slider
	************************************************/
	var postSlider = new MasterSlider();
		postSlider.setup('postSlider' , {
				 width:750,    // slider standard width
				 height:480,   // slider standard height
				 space:5
		});
		// adds Arrows navigation control to the slider.
		postSlider.control('arrows');
		postSlider.control('bullets', {autohide:false});
		
	/*Single Product Slider
	************************************************/
	var spSlider = new MasterSlider();
    spSlider.control('thumblist' , {autohide:false ,dir:'h',arrows:false, align:'bottom', width:120, height:130, margin:5, space:0});
    spSlider.setup('spSlider' , {
        width:750,
        height:714,
        space:0,
        view:'scale'
    });	
		
	/*Goods Package Carousel
	************************************************/
	if($packageCarousel.length > 0){
		$packageCarousel.owlCarousel({
			margin:0,
			loop:true,
			items: 1,
			nav: true,
			navText: [
				'<div class="arr01"></div><div class="arr02"></div>',
				'<div class="arr03"></div><div class="arr04"></div>'
			]
		});
	}
		
	///////////////////////////////////////////////////////////////////////
	/////////  INTERNAL ANCHOR LINKS SCROLLING (NAVIGATION)  //////////////
	//////////////////////////////////////////////////////////////////////
	
	$(".scroll").click(function(event){		
		var $elemOffsetTop = $(this).data('offset-top');
		$('html, body').animate({scrollTop:$(this.hash).offset().top-$elemOffsetTop}, 1000, 'easeOutExpo');
		$naviToggle.removeClass('active');
		event.preventDefault();
	});
	$('.scrollup').click(function(e){
		e.preventDefault();
		$('html, body').animate({scrollTop : 0}, {duration: 700, easing:'easeOutExpo'});
		$naviToggle.removeClass('active');
	});

	
	$(window).scroll(function(){
		if ($(this).scrollTop() > 500) {
			$('#scroll-top').addClass('visible');
		} else {
			$('#scroll-top').removeClass('visible');
		}
	});
	
	//SCROLL-SPY
	// Cache selectors
	var lastId,
		topMenu = $(".scroll-menu"),
		topMenuHeight = topMenu.outerHeight(),
		// All list items
		menuItems = topMenu.find("a"),
		// Anchors corresponding to menu items
		scrollItems = menuItems.map(function(){
		  var item = $($(this).attr("href"));
		  if (item.length) { return item; }
		});
	
	// Bind to scroll
	$(window).scroll(function(){
	   // Get container scroll position
	   var fromTop = $(this).scrollTop()+topMenuHeight+200;
	   
	   // Get id of current scroll item
	   var cur = scrollItems.map(function(){
		 if ($(this).offset().top < fromTop)
		   return this;
	   });
	   // Get the id of the current element
	   cur = cur[cur.length-1];
	   var id = cur && cur.length ? cur[0].id : "";
	   
	   if (lastId !== id) {
		   lastId = id;
		   // Set/remove active class
		   menuItems
			 .parent().removeClass("active")
			 .end().filter("[href=#"+id+"]").parent().addClass("active");
	   }
	});
	////////////////////////////////////////////////////////////////////
	
	///////////////////////////////////////////////////////////////////////
	///////////////////  Scroll to Sidebar Button  ////////////////////////
	//////////////////////////////////////////////////////////////////////
	
	$sidebarBtn.click(function(event){		
		event.preventDefault();
		$('html, body').animate({scrollTop:$(this.hash).offset().top+2}, 800, 'easeOutExpo');
	});
	
	///////////////////////////////////////////////////////////////////////
	///////////////////////  Sticky Buttons  /////////////////////////////
	//////////////////////////////////////////////////////////////////////
	
	//Scroll to Top Button
	$(window).scroll(function(){
		if ($(this).scrollTop() > 500) {
			$scrollTopBtn.parent().addClass('scrolled');
		} else {
			$scrollTopBtn.parent().removeClass('scrolled');
		}
	});
	$scrollTopBtn.click(function(){
		$('html, body').animate({scrollTop : 0}, {duration: 700, easing:'easeOutExpo'});
	});
	
	//Quick Contact Form
	$qcfBtn.click(function(){
		$(this).parent().find('.quick-contact').toggleClass('visible');
	});
	
	//Hiding Contact Form On Clicking Out
	$('.inner-wrap').click(function(){
		$qcForm.removeClass('visible');
	});

});/*Document Ready End*//////////////////////////////////////////////////////////////////////////
	
/*Back Function: Manipulating the browser history
*************************************************/
function goBack() {
	window.history.back()
}
