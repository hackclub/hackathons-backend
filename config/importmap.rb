# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "local-time", to: "https://ga.jspm.io/npm:local-time@2.1.0/app/assets/javascripts/local-time.js"
pin "@appsignal/javascript", to: "https://ga.jspm.io/npm:@appsignal/javascript@1.3.26/dist/esm/index.js"
pin "@appsignal/stimulus", to: "https://ga.jspm.io/npm:@appsignal/stimulus@1.0.17/dist/esm/index.js"
pin "@appsignal/core", to: "https://ga.jspm.io/npm:@appsignal/core@1.1.19/dist/esm/index.js"
pin "https", to: "https://ga.jspm.io/npm:@jspm/core@2.0.1/nodelibs/browser/https.js"
pin "isomorphic-unfetch", to: "https://ga.jspm.io/npm:isomorphic-unfetch@3.1.0/browser.js"
pin "tslib", to: "https://ga.jspm.io/npm:tslib@2.6.1/tslib.es6.mjs"
pin "unfetch", to: "https://ga.jspm.io/npm:unfetch@4.2.0/dist/unfetch.js"
pin "appsignal", preload: true
pin "@appsignal/plugin-breadcrumbs-console", to: "https://ga.jspm.io/npm:@appsignal/plugin-breadcrumbs-console@1.1.27/dist/esm/index.js"
pin "@appsignal/plugin-breadcrumbs-network", to: "https://ga.jspm.io/npm:@appsignal/plugin-breadcrumbs-network@1.1.21/dist/esm/index.js"
pin "@appsignal/plugin-path-decorator", to: "https://ga.jspm.io/npm:@appsignal/plugin-path-decorator@1.0.15/dist/esm/index.js"
