# ![icon][.svg] expressTurnout [![NPM version][npm-image]][npm] [![Build Status][travis-image]][travis] [![Coverage Status][coveralls-image]][coveralls]

> Angular.js pre-rendering for crawlers.

## Setup

1. Install [phantomjs](https://github.com/sgentle/phantomjs-node#installation)
2. Install modules
  ```bash
  $ npm install express express-turnout --save
  ```

3. Use express-turnout before routing. 

  Example:
  ```js
  // Environment
  var port= 59798;

  // Dependencies
  var express= require('express');
  var turnout= require('express-turnout');

  // Setup express
  var app= express();
  app.use(turnout());
  app.use(function(req, res) {
    res.sendFile(__dirname + '/index.html');
  });
  app.listen(port, function() {
    console.log('listening at %s', port);
  });
  ```

4. Add below to &lt;head&gt; in index.html:
  ```html
  <script src="/express-turnout.js"></script>
  ```

5. Finally, Execute window.expressTurnoutRendered() at Timing of Should be read for crawlers.

  Example:
  ```js
    angular.module('myApp',['ui.router'])
    .run(function($rootScope,$window){
      $rootScope.$on('$viewContentLoaded',function(){
        var renderedTemplate= document.body.innerHTML.trim().length>0
        if(renderedTemplate){
          $window.expressTurnoutRendered();
        }
      });
    })
    .config(function($stateProvider){
      // states...
    })
    ;
  ```

## How it works the source code for crawlers?
Add '?_escaped_fragment_' to URL.

Example:

```bash
$ curl http://localhost:59798/?_escaped_fragment_

<html lang="en" ng-app="myApp" class="ng-scope"><head><style type="text/css">@charset "UTF-8";[ng\:cloak],[ng-cloak],[data-ng-cloak],[x-ng-cloak],.ng-cloak,.x-ng-cloak,.ng-hide:not(.ng-hide-animate){display:none !important;}ng\:form{display:block;}</style>
  <meta charset="UTF-8">
  <title>Welcome googlebot!</title>
  <base href="/">
  <script src="https://cdnjs.cloudflare.com/ajax/libs/angular.js/1.3.15/angular.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/angular-ui-router/0.2.14/angular-ui-router.js"></script>

  <script src="/express-turnout.js"></script>
  <script>
  //...
  </script>
</head>
<!-- uiView:  --><body ui-view="" class="ng-scope"><h1 class="ng-scope">first</h1><a ui-sref="second" class="ng-scope" href="/second">second</a></body></html>
```

# API
## express-turnout(options)
### Options
#### `blacklist`
Return 403 If matched URL in RegExps.

Default: `[]`

#### `whitelist`
Return 403 Unless matched URL in RegExps.

Default: `[]`

#### `timeout`
Return 403 if exceeded the time.

Default: `1000` ms

#### `ua`
Do Pre-rendering If matched UserAgent in RegExps.

Default: `['Googlebot','Twitterbot']`

## `DEBUG=express:turnout`
> See [Debugging Express](http://expressjs.com/guide/debugging.html)

Example:
```bash
$ curl -A Googlebot http://localhost:59798/second

$ DEBUG=express:turnout node test/examples/angular-ui-router
#  express:turnout new Turnout +0ms {"ua":["Googlebot","Twitterbot"],"blacklist":[],"whitelist":[],"timeout":1000,"eventName":"expressTurnoutRendered"}
#  express:turnout [ 'Googlebot', index: 0, input: 'Googlebot' ] +1m isBot Googlebot
#  express:turnout Render http://localhost:59798/second? Limit by 1000ms +2ms
#  express:turnout Rendered +298ms <html lang="en" ng-app="myApp" class="ng-scope">...<!-- uiView:  --><body ui-view="" class="ng-scope"><h1 class="ng-scope">second</h1><a ui-sref="first" class="ng-scope" href="">first</a></body></html>
```

## /express-turnout.js
### `window.expressTurnoutRendered`
Finish the Pre-rendering If Execute via express-turnout.

## Inspired
[prerender-node / AngularJS SEO with Prerender.io | Scotch](https://scotch.io/tutorials/angularjs-seo-with-prerender-io)

License
===
[MIT][License]

[License]: 59naga.mit-license.org

[.svg]: https://cdn.rawgit.com/59naga/express-turnout/master/.svg

[npm-image]:https://img.shields.io/npm/v/express-turnout.svg?style=flat-square
[npm]: https://npmjs.org/package/express-turnout
[travis-image]: http://img.shields.io/travis/59naga/express-turnout.svg?style=flat-square
[travis]: https://travis-ci.org/59naga/express-turnout
[coveralls-image]: http://img.shields.io/coveralls/59naga/express-turnout.svg?style=flat-square
[coveralls]: https://coveralls.io/r/59naga/express-turnout?branch=master