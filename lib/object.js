// Generated by CoffeeScript 1.4.0
(function() {
  var FromObject, buildArgs, buildFlag, fromObj, loglet, process, util,
    __slice = [].slice;

  process = require('child_process');

  util = require('./util');

  loglet = require('loglet');

  buildFlag = function(flagStyle, flag) {
    if (flag.length === 1) {
      return flagStyle[0] + flag;
    } else if (flag.indexOf(flagStyle[0]) === 0) {
      return flag;
    } else {
      return flagStyle + flag;
    }
  };

  buildArgs = function(args, options) {
    var binaryFlag, flagStyle, key, parameters, skip, val;
    if (options == null) {
      options = {};
    }
    flagStyle = options.flagStyle || '--';
    binaryFlag = options.hasOwnProperty('binaryFlag') ? options.binaryFlag : true;
    skip = ['_'].concat(options.skip instanceof Array ? options.skip : []);
    parameters = [];
    for (key in args) {
      val = args[key];
      if (skip.indexOf(key) === -1) {
        parameters.push(buildFlag(flagStyle, key));
        if (typeof val === 'boolean' && binaryFlag) {
          continue;
        } else {
          parameters.push(val.toString());
        }
      }
    }
    if (args.hasOwnProperty('_')) {
      parameters = args._ instanceof Array ? parameters.concat(args._) : parameters.concat([args._]);
    }
    return parameters;
  };

  FromObject = (function() {

    function FromObject(program, args, options) {
      this.program = program;
      this.args = args;
      this.options = options != null ? options : {};
      this.parameters = buildArgs(this.args, this.options);
    }

    FromObject.prototype.spawn = function() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return process.spawn.apply(process, [this.program, this.parameters].concat(__slice.call(args)));
    };

    FromObject.prototype.exec = function() {
      var args, cmd;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      cmd = this.commandLine();
      return process.exec.apply(process, [cmd].concat(__slice.call(args)));
    };

    FromObject.prototype.commandLine = function() {
      return util.compile(this.program, this.parameters);
    };

    return FromObject;

  })();

  fromObj = function() {
    var args;
    args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    return (function(func, args, ctor) {
      ctor.prototype = func.prototype;
      var child = new ctor, result = func.apply(child, args);
      return Object(result) === result ? result : child;
    })(FromObject, args, function(){});
  };

  module.exports = fromObj;

}).call(this);
