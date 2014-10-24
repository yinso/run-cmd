
child = require 'child_process'
_ = require 'underscore'
{EventEmitter} = require 'events'
loglet = require 'loglet'

#child.exec 'ls -al', (err, stdout, stderr) ->
#  console.log err
#  console.log stdout
#  console.log stderr

class CommandSpec
  @default: 
    prefix: '--'
    delim: ''
  @build: (program, options = {}) ->
    new CommandSpec program, options
  constructor: (@program, @options = {}) ->
    @options = _.extend {}, CommandSpec.default, @options
    builder = @
    @maker = class command extends EventEmitter
      constructor: (options) ->
        @builder = builder
        @args = []
        @initialize options
        @
      initialize: (options) ->
        for key, val of options 
          if @[key] instanceof Function
            if val instanceof Array
              @[key] val...
            else
              @[key] val
          else
            throw {error: 'syscall_unknown_key', key: key, val: val}
      spawn: () ->
        builder.spawn @args
      exec: (cb) ->
        builder.exec @args, cb
    @
  make: (options = {}) ->
    new @maker(options)
  flag: (key, options = {}) -> # by default everything can be multiple??? 
    @maker.prototype[key] = () ->
      @args.push @builder._makeFlag key, options
      @
    @[key] = () =>
      cmd = @make()
      cmd[key]()
    @
  keyval: (key, val, options = {}) ->
    @maker.prototype[key] = (val) ->
      @args.push @builder.makeFlag key, options
      @args.push val
      @
    @[key] = (val) =>
      cmd = @make()
      cmd[key](val)
    @
  default: (key) ->
    @maker.prototype[key] = (args...) ->
      @args = @args.concat args
      @
    @[key] = (args...) =>
      cmd = @make()
      cmd[key] args...
    @
  _makeFlag: (key, options) ->
    flag = 
      if options.proc
        options.proc() 
      else if options.key
        options.key 
      else if options.prefix 
        options.prefix + key + options.delim or @options.delim
      else
        @options.prefix + key + options.delim or @options.delim
    flag
  spawn: (args) ->
    child.spawn @program, args
  exec: (args, cb) ->
    child.exec @compile(args), cb
  compile: (args) ->
    escaped = 
      for arg in args
        @escape arg 
    cmd = [ @program ].concat(escaped).join(' ')
    loglet.debug 'cmd.compile', cmd
    cmd
  escape: (arg) ->
    regex = /([^a-zA-Z0-9])/g
    arg.replace regex, '\\$1'
    

module.exports = CommandSpec
