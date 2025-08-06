// Entry point for the build script in your package.json
import "chartjs-adapter-date-fns"
import Chart from "chart.js/auto"
import Chartkick from "chartkick"
Chartkick.use(Chart)

import "@hotwired/turbo-rails"
import "./controllers"
import Rails from "@rails/ujs"
Rails.start()
