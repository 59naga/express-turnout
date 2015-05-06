var system= require('system');
var url= system.args[1];
var timeout= parseInt(system.args[2]);
var callbackName= 'expressTurnoutRendered';
var callback= function(error,html){
  var code= 0;
  if(error!=null){
    code=1;
    console.log(error);
  }
  if(html!=null){
    console.log(html);
  }

  page.stop();
  phantom.exit(code);
}

setTimeout(function(){
  callback('Timeout by '+timeout+'ms');
},timeout);

var page= require('webpage').create();
page.settings.resourceTimeout= timeout;
page.open(url,function(status){
  if(status!=='success'){
    callback(status);
  }
});
page.onCallback= function(name,html){
  if(name===callbackName){
    callback(null,html);
  }
};