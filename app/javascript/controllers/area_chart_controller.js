import { Controller } from "@hotwired/stimulus"
import ApexCharts from "apexcharts"


// Connects to data-controller="area-chart"
export default class extends Controller {
  static targets = ["chart"]

  static values = {
    labels: Array,
    series: Array
  }

  connect() {
    console.log("Area chart connected")
  }

  initialize() {
    this.chart = new ApexCharts(this.chartTarget, this.chartOptions);
    this.chart.render();
  }
  /*
  chart: {
        type: 'area',
        height: '375px',
        width: '100%',
        toolbar: {
          show: false,
        }
      },
      grid: {
        show: false,
        },
      series: [
        {
          name: "Amount",
          data: this.seriesValue,
          color: "#0E9F6E",
        }],
      labels: this.labelsValue,
    }
  */
  get chartOptions() {
    return { 
      chart: {
        height: "100%",
        maxWidth: "100%",
        type: "area",
        fontFamily: "Inter, sans-serif",
        dropShadow: {
          enabled: false,
        },
        toolbar: {
          show: false,
        },
      },
      tooltip: {
        enabled: true,
        x: {
          show: false,
        },
      },
      fill: {
        type: "gradient",
        gradient: {
          opacityFrom: 0.55,
          opacityTo: 0,
          shade: "#1C64F2",
          gradientToColors: ["#1C64F2"],
        },
      },
      dataLabels: {
        enabled: false,
      },
      stroke: {
        width: 6,
      },
      grid: {
        show: false,
        strokeDashArray: 4,
        padding: {
          left: 2,
          right: 2,
          top: 0
        },
      },
      series: [
        {
          name: "Amount",
          data: this.seriesValue,
          color: "#1A56DB",
        },
      ],
      xaxis: {
        categories: this.labelsValue,
        labels: {
          show: false,
        },
        axisBorder: {
          show: false,
        },
        axisTicks: {
          show: false,
        },
      },
      yaxis: {
        show: false,
      },
    }
  }

  disconnect() {
    this.chart.destroy();
  }
}
