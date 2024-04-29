import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="result-chart"
// This generated chart is mostly AI-Prompted. Tried to implement a candlestick-like chart but charting isn't my thing.
export default class extends Controller {
  connect() {
    const ctx = this.element.getContext('2d');
    const data = JSON.parse(this.element.getAttribute('data-result-data'));

    const datasets = [
      {
        label: 'High',
        data: data.high,
        backgroundColor: 'rgba(255, 99, 132, 0.5)', // Red color for high with transparency
        borderColor: 'rgba(255, 99, 132, 1)', // Red color for high border
        borderWidth: 2,
        fill: false,
        type: 'bar', // Set high prices as a bar graph
      },
      {
        label: 'Low',
        data: data.low,
        backgroundColor: 'rgba(54, 162, 235, 0.5)', // Blue color for low with transparency
        borderColor: 'rgba(54, 162, 235, 1)', // Blue color for low border
        borderWidth: 2,
        fill: false,
        type: 'bar', // Set low prices as a bar graph
      },
      {
        label: 'Open',
        data: data.open,
        borderColor: 'rgba(255, 206, 86, 1)', // Yellow color for open border
        borderWidth: 2,
        fill: false,
        yAxisID: 'price-axis',
      },
      {
        label: 'Closing',
        data: data.close,
        borderColor: 'rgba(75, 192, 192, 1)', // Green color for closing border
        borderWidth: 2,
        fill: false,
        yAxisID: 'price-axis',
      }
    ];

    new Chart(ctx, {
      type: 'line',
      data: {
        labels: data.timestamps, // Use timestamps as labels
        datasets: datasets,
      },
      options: {
        responsive: true,
        scales: {
          x: {
            type: 'linear',
            ticks: {
              display: false,
            },
            grid: {
              display: false,
            },
          },
          y: {
            id: 'price-axis', // Assign a custom y-axis ID
            type: 'linear',
            position: 'left',
            display: false, // Hide the unnecessary y-axis scale
          },
        },
        plugins: {
          legend: {
            labels: {
              usePointStyle: true, // Use point style for legend labels
            },
          },
        },
      },
    });
  }
}