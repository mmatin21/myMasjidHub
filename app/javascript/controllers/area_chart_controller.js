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
    console.log("Chart connected")
  }

  initialize() {
    this.chart = new ApexCharts(this.chartTarget, this.chartOptions);
    this.chart.render();
  }

  get chartOptions() {
    return {
      chart: {
        type: 'area',
        height: '375px',
        width: '1150px',
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
  }
  disconnect() {
    this.chart.destroy();
  }
}
