//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require bootstrap
//= require jquery-ui
//= require jquery.maskedinput
//= require jquery.jgrowl_minimized
//= require kickstrap
//= require cocoon
//= require pages
//= require services 
//= require organizations
//= require ckeditor/init
//= require colorbox-rails
//= require fix_ie

var Organizer = { calendar_draggable: false, draggable_item: null};

Array.max = function( array ){
  return Math.max.apply( Math, array );
};

// Function to get the Min value in Array
Array.min = function( array ){
 return Math.min.apply( Math, array );
};

document.cookie="offset=" + (new Date()).getTimezoneOffset();
