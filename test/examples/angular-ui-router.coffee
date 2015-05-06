# Environment
port= 59798

# Dependencies
express= require 'express'
turnout= require '../../'

# Setup express
app= express()
app.use turnout blacklist:[/^secret/]
app.use (req,res)->
  res.sendFile __dirname+'/angular-ui-router.html'

# Boot
app.listen port,->
  console.log 'listening at %s', port