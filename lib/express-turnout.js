window.expressTurnoutRendered= function(){
  if (window.callPhantom == null) {
    return;
  }

  // Wait for angular.$digest
  setTimeout(function(){
    var html= document.documentElement.outerHTML;
    window.callPhantom('expressTurnoutRendered', html);
  },0);
};