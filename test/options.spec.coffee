# Dependencies
express= require 'express'
turnout= require '../src'

Promise= require 'bluebird'
request= Promise.promisify(require 'request')
cheerio= require 'cheerio'

# Environment
port= 59798
url= 'http://localhost:'+port+'/'

# Spec
describe 'Options',->
  server= null

  describe 'blacklist',->
    beforeAll (done)->
      options=
        blacklist: [
          /^secret/
        ]

      app= express()
      app.use turnout options
      app.use (req,res)-> res.sendFile __dirname+'/fixture.html'

      server= app.listen port,done
    afterAll ->
      server.close()

    it 'Allow /first',(done)->
      request
        url: url+'first'
        headers:
          'User-Agent': 'Googlebot'
      .spread (response)->
        expect(response.statusCode).toBe 200
        expect(response.headers['x-powered-by']).toBe 'Express-turnout'
        expect(response.headers['content-type']).toBe 'text/html; charset=utf-8'
        
        $= cheerio response.body
        expect($.find('h1').text()).toBe 'first'
        expect($.find('a').text()).toBe 'second'
        expect($.find('meta').length).toBe 1+5

        done()

    it 'Allow /second',(done)->
      request
        url: url+'second'
        headers:
          'User-Agent': 'Googlebot'
      .spread (response)->
        expect(response.statusCode).toBe 200
        expect(response.headers['x-powered-by']).toBe 'Express-turnout'
        expect(response.headers['content-type']).toBe 'text/html; charset=utf-8'

        $= cheerio response.body
        expect($.find('h1').text()).toBe 'second'
        expect($.find('a').text()).toBe 'first'
        expect($.find('meta').length).toBe 1+5
        
        done()
        
    it 'Disallow /secret',(done)->
      request
        url: url+'secret'
        headers:
          'User-Agent': 'Googlebot'
      .spread (response)->
        expect(response.statusCode).toBe 403

        done()

  describe 'whitelist',->
    beforeAll (done)->
      options=
        whitelist: [
          /^first/
          /^second/
        ]

      app= express()
      app.use turnout options
      app.use (req,res)-> res.sendFile __dirname+'/fixture.html'

      server= app.listen port,done
    afterAll ->
      server.close()

    it 'Allow /first',(done)->
      request
        url: url+'first'
        headers:
          'User-Agent': 'Googlebot'
      .spread (response)->
        expect(response.statusCode).toBe 200
        expect(response.headers['x-powered-by']).toBe 'Express-turnout'
        expect(response.headers['content-type']).toBe 'text/html; charset=utf-8'
        
        $= cheerio response.body
        expect($.find('h1').text()).toBe 'first'
        expect($.find('a').text()).toBe 'second'
        expect($.find('meta').length).toBe 1+5

        done()

    it 'Allow /second',(done)->
      request
        url: url+'second'
        headers:
          'User-Agent': 'Googlebot'
      .spread (response)->
        expect(response.statusCode).toBe 200
        expect(response.headers['x-powered-by']).toBe 'Express-turnout'
        expect(response.headers['content-type']).toBe 'text/html; charset=utf-8'

        $= cheerio response.body
        expect($.find('h1').text()).toBe 'second'
        expect($.find('a').text()).toBe 'first'
        expect($.find('meta').length).toBe 1+5
        
        done()
        
    it 'Disallow /secret',(done)->
      request
        url: url+'secret'
        headers:
          'User-Agent': 'Googlebot'
      .spread (response)->
        expect(response.statusCode).toBe 403
        expect(response.headers['x-powered-by']).toBe 'Express-turnout'

        done()

  describe 'timeout',->
    beforeAll (done)->
      options=
        timeout: 1

      app= express()
      app.use turnout options
      app.use (req,res)-> res.sendFile __dirname+'/fixture.html'

      server= app.listen port,done
    afterAll ->
      server.close()

    it 'Timeout 1ms /first',(done)->
      request
        url: url+'first'
        headers:
          'User-Agent': 'Googlebot'
      .spread (response)->
        expect(response.statusCode).toBe 403
        expect(response.headers['x-powered-by']).toBe 'Express-turnout'
        
        expect(response.body).toBe 'Timeout by 1ms'
        
        done()

  describe 'maxBuffer',->
    beforeAll (done)->
      options=
        maxBuffer: 1

      app= express()
      app.use turnout options
      app.use (req,res)-> res.sendFile __dirname+'/fixture.html'

      server= app.listen port,done
    afterAll ->
      server.close()

    it 'Timeout 1ms /first',(done)->
      request
        url: url+'first'
        headers:
          'User-Agent': 'Googlebot'
      .spread (response)->
        expect(response.statusCode).toBe 500
        expect(response.headers['x-powered-by']).toBe 'Express-turnout'
        
        expect(response.body).toBe 'stdout maxBuffer exceeded.'
        
        done()

  describe 'ua',->
    beforeAll (done)->
      options=
        ua: ['先行者']

      app= express()
      app.use turnout options
      app.use (req,res)-> res.sendFile __dirname+'/fixture.html'

      server= app.listen port,done
    afterAll ->
      server.close()

    it 'Change target defaults to "先行者"',(done)->
      request
        url: url+'first'
        headers:
          'User-Agent': 'Googlebot'
      .spread (response)->
        expect(response.statusCode).toBe 200
        expect(response.headers['x-powered-by']).toBe 'Express'
        
        done()
