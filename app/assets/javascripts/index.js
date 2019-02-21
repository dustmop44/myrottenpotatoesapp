/* global $ */

var MovieListFilter2 = {
  filter_adult: function () {
    // 'this' is *unwrapped* element that received event (checkbox)
    if ($(".aria").is(':checked')) {
      $('tr.adult').hide();
    } else {
      $('tr.adult').show();
    };
  },
  setup: function() {
    $('.aria').change(MovieListFilter2.filter_adult);
  }
}
$(MovieListFilter2.setup); // run setup function when document ready

$(document).on('turbolinks:load', function() {
  
})

function sayhello() {
  alert("hello")
}

var MovieListFilter = {
  filter_adult: function () {
    // 'this' is *unwrapped* element that received event (checkbox)
    if ($(this).is(':checked')) {
      $('tr.adult').hide();
    } else {
      $('tr.adult').show();
    };
  },
  setup: function() {
    // construct checkbox with label
    var labelAndCheckbox =
      $('<label for="filter">Only movies suitable for children</label>' +
        '<input type="checkbox" id="filter"/>' );
    labelAndCheckbox.insertBefore('#movies');
    $('#filter').change(MovieListFilter.filter_adult);
  }
}
$(MovieListFilter.setup); // run setup function when document ready