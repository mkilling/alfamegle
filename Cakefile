sys: require "sys"
fs: require "fs"

task 'clean', 'clean output folder', ->
  fs.unlink 'client/client.js'

task 'build', 'build the client files', ->
  exec 'coffee -c client/client.coffee', (err, stdout, stderr) ->
    sys.puts stdout if stdout
    sys.puts stderr if stderr
    throw err    if err
