sys: require "sys"
fs: require "fs"
coffee: require './lib/coffee/coffee-script'

client_files: {"client/client.coffee": "client/client.js"}

task 'clean', 'clean output folder', ->
  for infile, outfile of client_files
    fs.unlink client_out + outfile

build: (infile, outfile) ->
  sys.puts infile + " -> " + outfile
  fs.readFile infile, "utf8", (err, code) ->
    compile: infile.substr(-7) == ".coffee"
    try
      out: if compile then coffee.compile code else code
      fs.writeFile outfile, out
    catch err
      sys.puts "error compiling"

task 'build', 'build the client files', ->
  build infile, outfile for infile, outfile of client_files

task 'run', 'run the server', ->
  exec 'cake build && coffee server.coffee', (err, stdout, stderr) ->
    sys.puts stdout if stdout
    sys.puts stderr if stderr
    throw err    if err