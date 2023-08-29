# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin 'application', preload: true
pin '@hotwired/turbo-rails', to: 'turbo.min.js', preload: true
pin '@hotwired/stimulus', to: 'stimulus.min.js', preload: true
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js', preload: true
pin_all_from 'app/javascript/controllers', under: 'controllers'

pin 'dayjs', to: 'https://ga.jspm.io/npm:dayjs@1.11.9/dayjs.min.js'
pin 'dayjs/plugin/utc', to: 'https://ga.jspm.io/npm:dayjs@1.11.9/plugin/utc.js'
pin 'dayjs/plugin/timezone', to: 'https://ga.jspm.io/npm:dayjs@1.11.9/plugin/timezone.js'
pin '@rails/request.js', to: 'https://ga.jspm.io/npm:@rails/request.js@0.0.8/src/index.js'
pin 'js-base64', to: 'https://ga.jspm.io/npm:js-base64@3.7.5/base64.mjs'
