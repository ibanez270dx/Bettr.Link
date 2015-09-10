"use strict";

chrome.browserAction.onClicked.addListener(function(tab) {

  // chrome.tabs.captureVisibleTab(null, { format: 'jpeg', quality: 50 }, function(dataUrl){
  chrome.tabs.captureVisibleTab(null, { format: 'jpeg', quality: 80 }, function(dataUrl){

    chrome.tabs.executeScript(tab.id, {
      code: `var dataUrl = "${dataUrl}"`
    }, function(){
      chrome.tabs.executeScript(tab.id, {
        "file": "javascripts/sidebar.js"
      }, function(){
        console.log("Script Executed .. ");
      });
    });
  });
});
