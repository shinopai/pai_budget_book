# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

pin "header_dropdown", to: "header_dropdown.js"
pin "template_form", to: "template_form.js"
pin "chartkick" # @5.0.1
pin "Chart.bundle", to: "Chart.bundle.js"
