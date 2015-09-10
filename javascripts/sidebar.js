"use strict";

var bettrDocument;
var original = {}
var scrollTop;
var pageTitle;
var template;
var bodyClasses;

////////////////////////////////////////////////////////////////////////////////
// Build new DOM
////////////////////////////////////////////////////////////////////////////////

function insertStylesheets(files) {
  for(let path of files) {
    let element = document.createElement('link');
    element.setAttribute("rel", "stylesheet");
    element.setAttribute("media", "all");
    element.setAttribute("href", chrome.extension.getURL(`stylesheets/${path}`));
    $('head').append(element);
  }
}

function buildSidebar(template) {
  document.body.innerHTML = `${template} <img id="bettrlink-screenshot" src="${dataUrl}" />`
  $(document.body).addClass('bettrlink');
  $('#bettrlink-page-title').text($('title').text());
  $('#bettrlink-page-url').text(window.location.href);
}

function init() {
  if(window.jQuery) {
    $.ajax({
      url: chrome.extension.getURL('views/sidebar.html'),
      success: function(template) {
        original.document = document;
        original.scrollTop = document.body.scrollTop;
        buildSidebar(template);
      }
    });
  } else {
    setTimeout('init()', 10);
  }
}

init();
