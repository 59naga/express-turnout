# Dependencies
Router= (require 'express').Router
Turnout= require './turnout'
path= require 'path'

turnoutMiddleware= (options={})->
  turnout= new Turnout options

  router= Router()
  router.get '/express-turnout.js',(req,res)->
    res.sendFile path.join __dirname,'express-turnout.js'

  router.use (req,res,next)->
    return next() unless turnout.isBot req

    turnout.render turnout.getUri req
    .then (html)->
      res.status 200
      res.end html
    .catch (error)->
      throw error if typeof error isnt 'string'
      res.status 403
      res.end error

  router

module.exports= turnoutMiddleware