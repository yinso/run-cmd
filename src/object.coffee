# fast construction of command...
process = require 'child_process'
util = require './util'
loglet = require 'loglet'

buildFlag = (flagStyle, flag) ->
  if flag.length == 1
    flagStyle[0] + flag
  else if flag.indexOf(flagStyle[0]) == 0 # we explicitly pass in the flag.
    flag
  else
    flagStyle + flag

buildArgs = (args, options = {}) ->
  flagStyle = options.flagStyle or '--' # if it's a single character flag we will need a short version for them... 
  binaryFlag = if options.hasOwnProperty('binaryFlag') then options.binaryFlag else true
  skip = ['_'].concat(if options.skip instanceof Array then options.skip else [])
  
  parameters = []
  for key, val of args 
    if skip.indexOf(key) == -1
      parameters.push buildFlag(flagStyle, key)
      if typeof(val) == 'boolean' and binaryFlag
        continue
      else
        parameters.push val.toString() 
  if args.hasOwnProperty('_')
    parameters = 
      if args._ instanceof Array 
        parameters.concat(args._)
      else
        parameters.concat([ args._ ])
  parameters

class FromObject
  constructor: (@program, @args, @options = {}) ->
    @parameters = buildArgs @args, @options
  spawn: (args...) ->
    process.spawn @program, @parameters, args...
  exec: (args...) ->
    cmd = @commandLine()
    process.exec cmd, args...
  commandLine: () ->
    util.compile @program, @parameters
    

fromObj = (args...) ->
  new FromObject args...

module.exports = fromObj
 