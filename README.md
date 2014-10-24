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

