pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

pin "chartkick", to: "chartkick.js"
pin "chartkick_init", to: "chartkick_init.js"
pin "chart.js/auto", to: "https://esm.sh/chart.js@4.4.1/auto"
