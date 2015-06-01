var system= require('system');
var url= system.args[1];
var timeout= parseInt(system.args[2]);
var exit= function(error,html){
  if(error!=null){
    system.stderr.write(error);
    phantom.exit(1);
  }
  else{
    system.stdout.write(html);
    phantom.exit(0);
  }
}

setTimeout(function(){
  exit('Timeout by '+timeout+'ms');
},timeout);

var page= require('webpage').create();
page.settings.resourceTimeout= timeout;
page.open(url,function(status){
  if(status!=='success'){
    exit(status);
  }
});
page.onCallback= function(name,html){
  if(name==='expressTurnoutRendered'){
    exit(null,html);
  }
};