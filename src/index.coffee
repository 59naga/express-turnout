# Dependencies
Router= (require 'express').Router
Turnout= require './turnout'
path= require 'path'

turnoutMiddleware= (options={})->
  turnout= new Turnout options

  router= Router()
  router.get '/express-turnout.js',(req,res)->
    res.sendFile path.resolve __dirname,'..','lib','express-turnout.js'

  router.use (req,res,next)->
    return next() unless turnout.isBot req

    res.setHeader 'x-powered-by','Express-turnout'

    turnout.render req
    .then (html)->
      res.status 200
      res.set 'Content-Type','text/html'
      res.end html
    .catch Error,(error)->
      res.status 500
      res.end error.message
    .catch (error)->
      res.status 403
      res.end error

  router

module.exports= turnoutMiddleware