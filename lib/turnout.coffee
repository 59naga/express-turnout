# Dependencies
debug= (require 'debug') 'express:turnout'

# phantomjsNode= require 'phantom'
Promise= require 'bluebird'
exec= (require 'child_process').exec
phantomScript= require.resolve './turnout.phantom.js'
querystring= require 'querystring'

class Turnout
  constructor: (@options={})->
    @options.ua?= ['Googlebot','Twitterbot']
    @options.blacklist?= []
    @options.whitelist?= []

    @options.timeout?= 2000
    @options.eventName?= 'expressTurnoutRendered'

    debug 'new Turnout',@options

  isBot: (req)->
    ua= req.headers['user-agent'] ? ''

    bot= null
    bot?= ua.match key for key in @options.ua
    bot?= req.query._escaped_fragment_?

    debug bot,'isBot',ua

    bot

  render: (req)->
    uri= @getUri req
    options= @options

    debug "Render #{uri} Limit by #{options.timeout}ms"

    new Promise (resolve,reject)->
      url= req.originalUrl.slice 1

      if options.blacklist.length
        for pattern in options.blacklist
          debug (url.match pattern),'blacklisted',url,'by',pattern

          if url.match pattern
            return reject 'Disallow by blacklist "'+pattern+'"'

      if options.whitelist.length
        matched= no
        for pattern in options.whitelist
          debug (url.match pattern),'whitelisted',url,'by',pattern
          
          if url.match pattern
            matched= yes
            break
        
        return reject 'Disallow by whitelist' unless matched

      script= "phantomjs #{phantomScript} #{uri} #{options.timeout}"
      debug 'Execute '+script

      exec script,(error,stdout)->
        resolve stdout unless error?
        reject error if error?

  getUri: (req)->
    uri= req.protocol+'://'+req.get('host')+req.originalUrl
    [url,params]= uri.split '?',2
    qs= querystring.parse params
    delete qs._escaped_fragment_
    uri= url+'?'+querystring.stringify qs

    uri

module.exports= Turnout