$(document).ready ->
  $("#vis_prompt_opendate").datepicker({
    changeYear: true,
    changeMonth: true,
    minDate: 0,
    altFormat: "yy-mm-dd 00:00:00 UTC",
    altField: "#prompt_opendate"})
  $("#vis_prompt_deadline").datepicker({
    changeYear: true,
    changeMonth: true,
    minDate: 0,
    altFormat: "yy-mm-dd 00:00:00 UTC",
    altField: "#prompt_deadline"
    })
  fillInDateText("prompt_opendate")
  fillInDateText("prompt_deadline")

fillInDateText = (elementID) ->
  date = $("#" + elementID).val()
  if date != "" && date?
    formattedDate = $.datepicker.formatDate("mm/dd/yy", $.datepicker.parseDate("yy-mm-dd 00:00:00 UTC", date))
    $("#vis_" + elementID).val(formattedDate)
