var Organizer = { calendar_draggable: false, draggable_item: null};

Array.max = function( array ){
  return Math.max.apply( Math, array );
};

// Function to get the Min value in Array
Array.min = function( array ){
 return Math.min.apply( Math, array );
};

document.cookie="offset=" + (new Date()).getTimezoneOffset();
