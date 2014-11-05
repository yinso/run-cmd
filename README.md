# Run CMD - an easy shell command builder and runner

## Installation 

    npm install run-cmd

## Usage 

    var cmd = require('run-cmd');
    
    // specify the command ls [-a] [-l] [path ...]
    var lsCmd = cmd.build('ls')
      .flag('all', '-a') // creates a function all(), which will generate -a when called.
      .flag('list', '-l') // crates a function list(), which will generate -l when called.
      .default('path'); // allows you to call path('path_to_file')
    
    // use the command and spawn a child process.
    
    var lsProc = lsCmd
      .all()
      .list()
      .path('.')
      .spawn();
    
    // another way is via make by passing in arguments as an option object... the flags are true/false
    var lsProc2 = lsCmd
      .make({
        all: true
        , list: true
        , path: [ '.' ]
      }).spawn();
      
    // one can also use exec instead of spawn...
    
    lsCmd.all().list().path('.').exec(function (err, stdout, stderr) {
        ....
    });

We can also build from an object structure without first creating the definition of the command itself - this is a single-use approach. 

    var cmd = require('run-cmd);
    cmd.object('ls', {a: true, l: true, _: [ '.', '..' ]}).exec(function(err, stdout, stderr) {
      ...
    });

In such case, use `_` as the rest argument - passing an array for them. 

You can also use a third option parameter to control the following: 

* `flagStyle` - defaults to `--` for flags that are more than one character, and `-` for a single character flag. The way it does is to take the first character from `flagStyle` for the single character flag. 
* `binaryFlag` - defaults to `true`, which will not append the value if it's `true` or `false`. i.e. `{a: true}` will transformed into `-a`
* `skip` - an array of flags to be skipped for inclusion into the command parameter. By default `_` is included because it's parsed as the rest parameter.

