yargs = require('yargs').usage '$0 [options] input.st'
    .describe 'o', 'Output file (the default file is a same name file with a `html` extension)'
    .describe 'w', 'Watch file changes'
    .describe 'v', 'Show the version number'
    .describe 'h', 'Show this message'
    .alias 'o', 'output'
    .alias 'w', 'watch'
    .alias 'v', 'version'
    .alias 'h', 'help'
    .boolean 'v'
    .boolean 'h'
    .boolean 'w'

exports.run = ->
    argv = yargs.argv
    yargs.showHelp() if argv.h

    console.log argv
    console.log('done')