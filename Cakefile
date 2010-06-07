sys: require "sys"
fs: require "fs"
coffee: require './lib/coffee/coffee-script'

client_files: {"client/index.html": "out/index.html",
               "client/client.coffee": "out/client.js",
               "lib/jQuery-1.4.2.min.js": "out/jQuery-1.4.2.min.js"}

task 'clean', 'clean output folder', ->
  for infile, outfile of client_files
    fs.unlink client_out + outfile

build: (infile, outfile) ->
  sys.puts infile + " -> " + outfile
  fs.readFile infile, "utf8", (err, code) ->
    compile: infile.substr(-7) == ".coffee"
    out: if compile then coffee.compile code else code
    fs.writeFile outfile, out

task 'build', 'build the client files', ->
  build infile, outfile for infile, outfile of client_files
