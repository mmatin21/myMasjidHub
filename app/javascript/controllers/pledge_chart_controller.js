import { Controller } from "@hotwired/stimulus"
import ApexCharts from "apexcharts"

// Connects to data-controller="pledge-chart"
export default class extends Controller {
  static targets = ["chart"]
  static values = {
    labels: Array,
    pledges: Array,
    donations: Array
  }

  connect() {
    console.log("chart connected")
  }

  initialize() {
    this.chart = new ApexCharts(this.chartTarget, this.chartOptions);
    this.chart.render();
  }

  get chartOptions() {
    return {
      series: [
        {
          name: "Pledge",
          color: "#1d4ed8",
          data: this.pledgesValue,
        },
        {
          name: "Donations",
          data: this.donationsValue,
          color: "#31C48D",
        }
      ],
      chart: {
        sparkline: {
          enabled: false,
        },
        type: "bar",
        width: "95%",
        height: 200,
        toolbar: {
          show: false,
        }
      },
      fill: {
        opacity: 1,
      },
      plotOptions: {
        bar: {
          horizontal: false,
          columnWidth: "50%",
          borderRadiusApplication: "end",
          borderRadius: 6,
          dataLabels: {
            position: "top",
          },
        },
      },
      legend: {
        show: true,
        position: "bottom",
      },
      dataLabels: {
        enabled: false,
      },
      tooltip: {
        shared: true,
        intersect: false,
        formatter: function (value) {
          return "$" + value
        }
      },
      xaxis: {
        labels: {
          show: true,
          style: {
            fontFamily: "Inter, sans-serif",
            cssClass: 'text-xs font-normal fill-gray-500 dark:fill-gray-400'
          },
          formatter: function(value) {
            return value
          }
        },
        categories: this.labelsValue,
        axisTicks: {
          show: false,
        },
        axisBorder: {
          show: false,
        },
      },
      yaxis: {
        labels: {
          show: true,
          style: {
            fontFamily: "Inter, sans-serif",
            cssClass: 'text-xs font-normal fill-gray-500 dark:fill-gray-400'
          }
        }
      },
      grid: {
        show: true,
        
        padding: {
          left: 10,
          right: 2,
          top: -20
        },
      },
      fill: {
        opacity: 1,
      }
    }
  }
  
  disconnect() {
    this.chart.destroy();
  }
}
