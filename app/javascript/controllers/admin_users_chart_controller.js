import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="admin-users-chart"
export default class extends Controller {
  connect() {
    this.fetchData();
  }

  fetchData() {
    fetch('/admin/chart_data')
      .then(response => response.json())
      .then(data => this.renderChart(data))
      .catch(error => console.error("Error fetching data:", error))
  }

  renderChart(data) {
    const totalUsers = data.verified + data.pending + data.unconfirmed;
    const totalUsersElement = document.getElementById('total_users')
    totalUsersElement.textContent = totalUsers;

    var ctx = this.element.getContext('2d')
    this.chart = new Chart(ctx, {
      type: "doughnut",
      data: {
        labels: data.labels,
        datasets: [{
          label: "App Users",
          data: [data.verified, data.pending, data.unconfirmed],
          backgroundColor: [
            '#8fc1e3', '#31708e', '#ff7f50'
          ],
          borderWidth: 2,
          borderColor: '#fff',
          hoverOffset: 4
        }]
      },
      options: {
        responsive: false,
        plugins: {
          title: {
            display: true,
            text: 'StockApp Users',
            font: {
              size: 16,
              weight: 'bold',
              family: 'Montserrat'
            }
          },
          legend: {
            position: 'bottom',
            labels: {
              usePointStyle: true,
              padding: 20
            }
          },
          doughnutlabel: {
            backgroundColor: '#31708e'
          }
        }
      }
    })
  }
}
