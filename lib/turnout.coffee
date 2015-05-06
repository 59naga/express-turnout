# Dependencies
debug= (require 'debug') 'express:turnout'

phantomjsNode= require 'phantom'
Promise= require 'bluebird'
querystring= require 'querystring'

class Turnout
  constructor: (@options={})->
    @options.ua?= ['Googlebot','Twitterbot']
    @options.blacklist?= []
    @options.whitelist?= []

    @options.timeout?= 1000
    @options.eventName?= 'expressTurnoutRendered'

    debug 'new Turnout',@options

  isBot: (req)->
    ua= req.headers['user-agent'] ? ''

    bot= yes if '_escaped_fragment_' in Object.keys(req.query)
    bot?= ua.match key for key in @options.ua
    bot?= req.query.bot?

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

      phantomjsNode.create (phantom)->
        rendered= (error,html='')->
          debug 'Rendered',html

          clearTimeout id
          phantom.exit()
          
          resolve html unless error?
          reject error if error?

        phantom.createPage (page)->
          page.open uri
          page.set 'onCallback',(name,html)->
            rendered null,html if name is options.eventName

        id= setTimeout ->
          rendered 'Timeout'
        ,options.timeout

  getUri: (req)->
    uri= req.protocol+'://'+req.get('host')+req.originalUrl
    [url,params]= uri.split '?',2
    qs= querystring.parse params
    delete qs['_escaped_fragment_']
    uri= url+'?'+querystring.stringify qs

    uri

module.exports= Turnout