$(document).ready(function() {

  $('select').material_select();


  $('.datepicker').pickadate({
    selectMonths: true, // Creates a dropdown to control month
    selectYears: 15 // Creates a dropdown of 15 years to control year
  });

  $('.menu').sideNav({
      menuWidth: 240, // Default is 240
      edge: 'right', // Choose the horizontal origin
      closeOnClick: true // Closes side-nav on <a> clicks, useful for Angular/Meteor
    }
  );
  $('.collapsible').collapsible({
  accordion : false // A setting that changes the collapsible behavior to expandable instead of the default accordion style
  });


  $('.add-line').click(function(ev){
    ev.preventDefault();
    var line = 
    `<div class="row">
      <div class="input-field col s5 offset-s1">
        <input id="invited_name" name="invited_name[]" type="text" class="validate">
        <label for="invited_name">Name</label>
      </div>
      <div class="input-field col s5">
        <input id="invited_email" name="invited_email[]" type="email" class="validate">
        <label for="invited_email">Email</label>
      </div>
    </div>`;
    $('.button-row').before(line)
  });

});



var errorMessage = function(message) {
  Materialize.toast(message, 10000)
}
