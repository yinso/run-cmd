loglet = require 'loglet'

compile = (program, args) ->
  escaped = 
    for arg in args
      escape arg 
  cmd = [ program ].concat(escaped).join(' ')
  loglet.debug 'cmd.compile', cmd, program, args
  cmd

regex = /([^a-zA-Z0-9])/g

escape = (arg) ->
  arg.replace regex, '\\$1'
  
module.exports = 
  compile: compile
  escape: escape
