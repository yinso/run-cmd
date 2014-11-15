object = require '../src/object'
loglet = require 'loglet'
path = require 'path'

describe 'a object builder test', () ->
  
  it 'can build from object', (done) ->
    try
      object('ls', {a: true, _: __dirname})
        .exec (err, stdout, stderr) ->
          stdoutStr = stdout.toString('utf8')
          stderrStr = stderr.toString('utf8')
          if err
            done err
          else if stdoutStr == ".\n..\ncmd.coffee\nobject.coffee\n"
            done null
          else
            loglet.error 'test.object.output', err, JSON.stringify(stdoutStr), JSON.stringify(stderrStr)
            done {error: 'output', output: stdoutStr, errout: stderrStr}
    catch e 
      done e
  
  it 'can explicitly pass in flag', (done) ->
    try
      object('ls', {'-a': true, _: __dirname})
        .exec (err, stdout, stderr) ->
          stdoutStr = stdout.toString('utf8')
          stderrStr = stderr.toString('utf8')
          if err
            done err
          else if stdoutStr == ".\n..\ncmd.coffee\nobject.coffee\n"
            done null
          else
            loglet.error 'test.object.output', err, JSON.stringify(stdoutStr), JSON.stringify(stderrStr)
            done {error: 'output', output: stdoutStr, errout: stderrStr}
    catch e 
      done e
  