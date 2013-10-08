
var days = {
  'On Demand': [],
  'Daily':     [],
  'Weekly':    [['Monday', 1],    ['Tuesday', 2],   ['Wednesday', 3], ['Thursday', 4],  ['Friday', 5],    ['Saturday', 6],  ['Sunday', 7]],
  'Monthly':   [['1st day', 1],   ['2nd day', 2],   ['3rd day', 3],   ['4th day', 4],   ['5th day', 5],   ['6th day', 6],   ['7th day', 7], 
                ['8th day', 8],   ['9th day', 9],   ['10th day', 10], ['11th day', 11], ['12th day', 12], ['13th day', 13], ['14th day', 14], 
                ['15th day', 15], ['16th day', 16], ['17th day', 17], ['18th day', 18], ['19th day', 19], ['20th day', 20], ['21st day', 21], 
                ['22nd day', 22], ['23rd day', 23], ['24th day', 24], ['25th day', 25], ['26th day', 26], ['27th day', 27], ['28th day', 28]]
};

var day_selected = null;

function modeSelected() {
  mode = $('#project_scheduler_mode').val();
  day_selected = $('#project_scheduler_day').val();
  $('#project_scheduler_day').empty();
  $.each(days[mode], function(i, day) {
    $('#project_scheduler_day').append(new Option(day[0], day[1]));
  });
  $('#project_scheduler_day').val(day_selected);
  
  if (mode == 'On Demand') {
    $('#scheduler_factor_field').hide();
    $('#scheduler_time_field').hide();
    $('#scheduler_day_field').hide();
  } else if (mode == 'Daily') {
    $('#scheduler_factor_field').show();
    $('#scheduler_factor_desc').html('day(s)');
    $('#scheduler_time_field').show();
    $('#scheduler_day_field').hide();
  } else if (mode == 'Weekly') {
    $('#scheduler_factor_desc').html('week(s)');
    $('#scheduler_factor_field').show();
    $('#scheduler_time_field').show();
    $('#scheduler_day_field').show();
  } else if (mode == 'Monthly') {
    $('#scheduler_factor_desc').html('month(s)');
    $('#scheduler_factor_field').show();
    $('#scheduler_time_field').show();
    $('#scheduler_day_field').show();
  }
}
