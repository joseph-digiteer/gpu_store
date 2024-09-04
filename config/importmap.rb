# Pin npm packages by running ./bin/importmap

pin "application"
#add my controller.
pin "controllers", to: "controllers.js"
pin "controllers/product_controller", to: "controllers/product_controller.js"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
