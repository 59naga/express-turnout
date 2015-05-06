# Dependencies
express= require 'express'
turnout= require '../'

Promise= require 'bluebird'
request= Promise.promisify(require 'request')
cheerio= require 'cheerio'

# Environment
port= 59798
url= 'http://localhost:'+port+'/'

# Spec
describe 'expressTurnout',->
  server= null
  beforeEach (done)->
    app= express()
    app.use turnout()
    app.use (req,res)-> res.sendFile __dirname+'/fixture.html'

    server= app.listen port,done
  afterEach ->
    server.close()

  describe '?_escaped_fragment_',->
    it 'prerender /',(done)->
      request url+'?_escaped_fragment_'
      .spread (response)->
        expect(response.statusCode).toBe 200
        expect(response.headers['x-powered-by']).toBe 'Express-turnout'
        
        $= cheerio response.body
        expect($.find('h1').text()).toBe 'first'
        expect($.find('a').text()).toBe 'second'

        done()
    
    it 'prerender /second',(done)->
      request url+'second?_escaped_fragment_'
      .spread (response)->
        expect(response.statusCode).toBe 200
        expect(response.headers['x-powered-by']).toBe 'Express-turnout'
        
        $= cheerio response.body
        expect($.find('h1').text()).toBe 'second'
        expect($.find('a').text()).toBe 'first'

        done()

  describe 'User-Agent: Googlebot',->
    it 'prerender /',(done)->
      request
        url: url
        headers:
          'User-Agent': 'Googlebot'
      .spread (response)->
        expect(response.statusCode).toBe 200
        expect(response.headers['x-powered-by']).toBe 'Express-turnout'

        $= cheerio response.body
        expect($.find('h1').text()).toBe 'first'
        expect($.find('a').text()).toBe 'second'

        done()

    it 'prerender /second',(done)->
      request
        url: url+'second'
        headers:
          'User-Agent': 'Googlebot'
      .spread (response)->
        expect(response.statusCode).toBe 200
        expect(response.headers['x-powered-by']).toBe 'Express-turnout'
        
        $= cheerio response.body
        expect($.find('h1').text()).toBe 'second'
        expect($.find('a').text()).toBe 'first'

        done()

  describe 'User-Agent: Twitterbot',->
    it 'prerender /',(done)->
      request
        url: url
        headers:
          'User-Agent': 'Twitterbot'
      .spread (response)->
        expect(response.statusCode).toBe 200
        expect(response.headers['x-powered-by']).toBe 'Express-turnout'
        
        $= cheerio response.body
        expect($.find('h1').text()).toBe 'first'
        expect($.find('a').text()).toBe 'second'

        done()

    it 'prerender /second',(done)->
      request
        url: url+'second'
        headers:
          'User-Agent': 'Twitterbot'
      .spread (response)->
        expect(response.statusCode).toBe 200
        expect(response.headers['x-powered-by']).toBe 'Express-turnout'
        
        $= cheerio response.body
        expect($.find('h1').text()).toBe 'second'
        expect($.find('a').text()).toBe 'first'

        done()
