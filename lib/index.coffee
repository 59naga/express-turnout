# Dependencies
Router= (require 'express').Router
Turnout= require './turnout'

turnoutMiddleware= (options={})->
  turnout= new Turnout options

  router= Router()
  router.get '/express-turnout.js',(req,res)->
    js= ->
      window.expressTurnoutRendered= ->
        return unless window.callPhantom?

        html= document.documentElement.outerHTML
        window.callPhantom 'expressTurnoutRendered',html
    
    res.send ';('+js.toString()+')();';

  router.use (req,res,next)->
    return next() unless turnout.isBot req

    turnout.render req
    .then (html)->
      res.status 200
      res.end html
    .catch (error)->
      throw error if typeof error isnt 'string'
      res.status 403
      res.end error

  router

module.exports= turnoutMiddleware