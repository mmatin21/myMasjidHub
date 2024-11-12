import { Controller } from "@hotwired/stimulus"
import ApexCharts from "apexcharts"


// Connects to data-controller="pie-chart"
export default class extends Controller {
  static targets = ["chart"]

  static values = {
    labels: Array,
    series: Array
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
      chart: {
        height: '300',
        width: '100%',
        type: 'pie'
      },
      legend: { 
        show: false 
      },
      series: this.seriesValue,
      labels: this.labelsValue,
    }
  }
  disconnect() {
    this.chart.destroy();
  }
}
