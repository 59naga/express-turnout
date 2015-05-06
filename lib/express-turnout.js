window.expressTurnoutRendered= function(){
  if (window.callPhantom == null) {
    return;
  }

  var html= document.documentElement.outerHTML;
  window.callPhantom('expressTurnoutRendered', html);
};