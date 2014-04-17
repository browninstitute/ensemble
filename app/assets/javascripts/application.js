// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.sortable
//= require jquery.ui.effect-slide
//= require jquery.ui.datepicker
//= require twitter/bootstrap
//= require rails-timeago-all
//= require_tree .

/* Global ajax handler to show flash messages. */
$(document).ajaxComplete(function(event, request) {
  var msg = request.getResponseHeader('X-Message');
  if (!msg) { return; }
  var type = "";
  if (request.getResponseHeader('X-Message-Type') == "error") {
    type = "error";
  } else if (request.getResponseHeader('X-Message-Type') == "info") {
    type = "info";
  } else {
    type = "success";
  }
  $.bootstrapGrowl(msg, { type: type });
});

// Time ago to convert times into words on the client side
$(document).ready(function() {
  $("abbr.timeago").timeago();
});
