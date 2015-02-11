//= require underscore
//= require moment
//= require moment-locale-ru
//= require jquery
//= require angular
//= require angular-i18n/angular-locale_ru-ru
//= require angular-animate
//= require angular-ui-router
//= require angular-bootstrap-checkbox
//= require angular-ui-bootstrap-bower
//= require angular-wizard
//= require angularjs/rails/resource
//= require angular-rails-templates
//= require_tree ./angular/templates
//= require_tree ./angular/modules
//= require ng-bs-animated-button
//= require_self
//= require_tree ./angular/controllers
//= require ./angular/router

moment.locale('ru', {
  week: {
    dow: 1
  }
})

var Organizer = angular.module('Organizer', [
  'mgo-angular-wizard',
  'ui.checkbox',
  'ui.bootstrap',
  'templates',
  'ui.router',
  'worker.services'
]);
