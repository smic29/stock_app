import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="transaction-chart"
export default class extends Controller {
  connect() {
    this.fetchDataAndTurboStream();
  }

  fetchDataAndTurboStream() {
    fetch('/user/chart_data')
      .then(response => response.json())
      .then(data => {
        this.renderChart(data)
        this.fetchTurboStream();
      })
      .catch(error => console.error("Error fetching data:", error))
  }

  fetchTurboStream() {
    fetch('/user/chart_data', { headers: { Accept: 'text/vnd.turbo-stream.html'} })
      .then(response => response.text())
      .then(html => {
        const turboStreamElement = document.createElement('template')
        turboStreamElement.innerHTML = html;
        const turboStreamContent = turboStreamElement.content.firstElementChild
        document.body.appendChild(turboStreamContent)
      })
      .catch(error => console.error("Error fetching Turbo Stream:", error))
  }

  renderChart(data) {
    var ctx = this.element.getContext('2d')
    this.chart = new Chart(ctx, {
      type: "bar",
      data: {
        labels: data.labels,
        datasets: [{
          label: "Last 7 days transactions ",
          borderWidth: 0,
          borderTradius: 0,
          pointRadius: 0,
          backgroundColor: "transparent",
          borderColor: "transparent",
        },{
          label: "Buy",
          data: data.buy_data,
          backgroundColor: "#687864",
          borderColor: "#f7f9fb",
          borderWidth: 1,
          borderRadius: 5,
          pointStyle: 'rectRot',
          pointRadius: 5,
          pointBorderColor: 'rgb(0, 0, 0)'
        }, {
          label: "Sell",
          data: data.sell_data,
          backgroundColor: "#8fc1e3",
          borderColor: "#8fc1e3",
          borderWidth: 1,
          borderRadius: 5,
          pointStyle: 'rectRot',
          pointRadius: 5,
          pointBorderColor: 'rgb(0, 0, 0)'
        }],
      },
      options: {
        scales: {
          y: {
            beginAtZero: true,
          },
        },
        plugins: {
          legend: {
            labels: {
              usePointStyle: true,
            },
            align: 'start',
            position: 'top',
          },
          title: {
            display: false,
            text: 'Last 7 days transactions',
            align: 'start',
          }
        }
      }
    })
  }
}
