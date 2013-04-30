$(function(){
  $("#per_week, #per_month, #all_the_time").live("click", function(){
      $.get( $(this).data("link"),null,null,"script");
      $("#result_options").show();
     return false;
  });
 $('#select_date_gap').on("change",'select',function(){
    var option = $('select').attr("id");
    var option_value = $('select option:selected').val();

       if(  option == "week"){
         per_week(parseInt(option_value));
       }else if(option == "month"){
         per_month(parseInt(option_value));
       }
    });
 $("#result_content").bind("plothover", function (event, pos, item) {
    if (item) {
        if ((previousPoint != item.dataIndex) || (previousLabel != item.series.label)) {
            previousPoint = item.dataIndex;
            previousLabel = item.series.label;

            $("#flot-tooltip").remove();

            var x = convertToDate(item.datapoint[0]),
            y = item.datapoint[1];
            z = item.series.color;

            showTooltip(item.pageX, item.pageY,
                "<b>" + "Survey Result" + "</b><br /> Date = " + x + "<br /> Score = " + y ,
                z);
        }
    } else {
        $("#flot-tooltip").remove();
        previousPoint = null;
    }
   });
});

var timestamp ={};
function per_week(range){
  var data = new Array();
  var rangedate = new Date(range);
  $.each(timestamp, function(key,val){
     subdata = new Array();
     subdata.push(key);
     subdata.push(val);
     data.push(subdata);
  });
    mindate = new Date(range);
    mindate.setDate(rangedate.getDate() - 7);
    var finaldata = [{data: data, points: {symbol: "circle"} }]
    $.plot($("#result_content"), finaldata, {
                                              series:{
                                                     lines: { show: true },
                                                     points:{
                                                             show: true
                                                            }
                                                     },
                                              xaxis: { mode: "time",
                                                    min: mindate.getTime(),
                                                    max: rangedate.getTime(),
                                                    axisLabel: "Days"
                                                   },
                                              yaxis: { min: 0, max: 6,
                                                       axisLabel: "Score" },
                                              grid:{
                                               hoverable: true
                                              }
                                         });
}
function per_month(range){
  var data = new Array();
  var rangedate = new Date(range);
  $.each(timestamp, function(key,val){
     subdata = new Array();
     subdata.push(key);
     subdata.push(val);
     data.push(subdata);
  });
  mindate = new Date(range);
    mindate.setDate(mindate.getDate() - 31);
    var finaldata = [{data: data, points: {symbol: "circle"} }]
    $.plot($("#result_content"), finaldata, { xaxis: { mode: "time",
                                                    min: mindate.getTime(),
                                                    max: rangedate.getTime(),
                                                    axisLabel: "Days"
                                                   },
                                           yaxis: { axisLabel: "Score", min: 0, max: 6 },
                                           series: {
                                                lines: { show: true },
                                                points: { show: true }
                                           },
                                           grid:{
                                               hoverable: true
                                              }
                                         });
}
function all_the_time(now,last){
  var data = new Array();
  $.each(timestamp, function(key,val){
     subdata = new Array();
     subdata.push(key);
     subdata.push(val);
     data.push(subdata);
  });
   var finaldata = [{ data:data,points: { symbol: "circle"} }]
    $.plot($("#result_content"), finaldata, { xaxis: { mode: "time", axisLabel: "Days"
                                                  },
                                           yaxis: { axisLabel: "Score", min: 0, max: 6 },
                                           series: {
                                                lines: { show: true },
                                                points: { show: true }
                                           },
                                           grid:{
                                               hoverable: true
                                           }
                                         });
}
function showTooltip(x, y, contents, z) {
    $('<div id="flot-tooltip">' + contents + '</div>').css({
        top: y - 30,
        left: x - 135,
        'border-color': z,
    }).appendTo("body").fadeIn(200);
}
function getMonthName(numericMonth) {
    var monthArray = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    var alphaMonth = monthArray[numericMonth];

    return alphaMonth;
}

function convertToDate(timestamp) {
    var newDate = new Date(timestamp);
    var dateString = newDate.getMonth();
    var dateNumber = newDate.getDate();
    var monthName = getMonthName(dateString) +" "+ dateNumber;

    return monthName;
}
