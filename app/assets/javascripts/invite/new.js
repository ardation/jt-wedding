$(document).on('turbolinks:load', function() {
  function setFormState(styleValue) {
      $('.address, .email').hide();
      if (styleValue == 'email') {
      $('.email').show();
    }
    else if (styleValue == 'physical') {
      $('.address').show();
    }
  }

  $("input[type=radio][name='invite[style]']").change(function() {
    setFormState(this.value);
  });

  setFormState($("input[type=radio][name='invite[style]']:checked").val());
});
