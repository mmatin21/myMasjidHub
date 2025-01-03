import { Controller } from "@hotwired/stimulus"
import ApexCharts from "apexcharts"


// Connects to data-controller="pie-chart"
export default class extends Controller {
  static targets = ["chart"]

  static values = {
    revenueLabels: Array,
    expenseLabels: Array,
    revenueSeries: Array,
    expenseSeries: Array
    }

  connect() {
    console.log("Pie Chart connected")
  }

  initialize() {
    this.chart = new ApexCharts(this.chartTarget, this.chartOptions);
    this.chart.render();
  }

  update(event){
    console.log("Pie Update")
  }

   get chartOptions() {
    return {
      series: [ 
        this.revenueSeriesValue
      ],
      chart: {
        height: 420,
        width: "100%",
        type: "pie",
      },
      stroke: {
        colors: ["white"],
        lineCap: "",
      },
      plotOptions: {
        pie: {
          labels: {
            show: true,
          },
          size: "100%",
          dataLabels: {
            offset: -25
          }
        },
      },
      labels: [
        this.revenueLabelsValue
      ],
      dataLabels: {
        enabled: true,
        style: {
          fontFamily: "Inter, sans-serif",
        },
      },
      legend: {
        position: "bottom",
        fontFamily: "Inter, sans-serif",
      },
      yaxis: {
        labels: {
          formatter: function (value) {
            return "$" + value 
          },
        },
      },
      xaxis: {
        labels: {
          formatter: function (value) {
            return "$" + value 
          },
        },
        axisTicks: {
          show: false,
        },
        axisBorder: {
          show: false,
        },
      },
    }
  }
  disconnect() {
    this.chart.destroy();
  }
}
