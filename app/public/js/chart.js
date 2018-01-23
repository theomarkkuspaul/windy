
var Windy = Windy || {};

// IIFE to instantiate Chart into global namespace
(function(){

  Windy.Chart = (function () {

    var publicMethods = {
      initChart: initChart
    }

    function loadData (callback) {
      $.get('/data', function(resp){
        callback(resp);
      })
    }

    function initChart () {
      loadData(function(data){

        Highcharts.chart('chart', {
          chart: {
            zoomType: 'x'
          },
          title: {
              text: 'Wind Speed'
          },
          xAxis: {
            type: 'datetime'
          },
          yAxis: {
              title: {
                  text: 'Wind Speed (kmh)'
              }
          },
          plotOptions: {
              line: {
              }
          },

          tooltip: {
            valueDecimals: 2
          },
          series: [{
              name: 'Wind',
              data: data
          }]
        });

      })
    }

    return publicMethods;

  })();

})();
