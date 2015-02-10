//= require moment
//= require moment-locale-ru
//= require jquery
//= require angular
//= require angular-i18n/angular-locale_ru-ru
//= require angular-animate
//= require angular-ui-router
//= require angular-ui-bootstrap-bower
//= require angular-rails-templates
//= require_tree ./angular/templates
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
  'ui.bootstrap',
  'templates',
  'ui.router'
]);
