cmd = require '../src/cmd'
path = require 'path'
loglet = require 'loglet'
assert = require 'assert'

describe 'command building test', () ->
  lsCmd = null
  it 'can build command', (done) ->
    try 
      lsCmd = cmd.build('ls', {prefix: '-'})
        .flag('all', {key: '-a'})
        .flag('list', {key: '-l'})
        .default('path')
      done null
    catch e
      done e
  it 'can execute command', (done) ->
    try 
      ls = lsCmd
        .all()
        .path(path.join(__dirname))
        .exec (err, stdout, stderr) ->
          stdoutStr = stdout.toString('utf8')
          stderrStr = stderr.toString('utf8')
          if err
            done err
          else if stdoutStr == ".\n..\ncmd.coffee\nobject.coffee\n"
            done null
          else
            loglet.error 'test.cmd.output', err, JSON.stringify(stdoutStr), JSON.stringify(stderrStr)
            done {error: 'output', output: stdoutStr, errout: stderrStr}
    catch e 
      done e

  it 'can execute command via make', (done) ->
    try 
      ls = lsCmd
        .make({all: true, path: [ __dirname ]})
        .exec (err, stdout, stderr) ->
          stdoutStr = stdout.toString('utf8')
          stderrStr = stderr.toString('utf8')
          if err
            done err
          else if stdoutStr == ".\n..\ncmd.coffee\nobject.coffee\n"
            done null
          else
            loglet.error 'test.cmd.output', err, JSON.stringify(stdoutStr), JSON.stringify(stderrStr)
            done {error: 'output', output: stdoutStr, errout: stderrStr}
    catch e 
      done e
