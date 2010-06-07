sys: require "sys"
fs: require "fs"
coffee: require './lib/coffee/coffee-script'

client_in: "client/"
client_out: "out/"
client_files: {"index.html": "index.html",
               "client.coffee": "client.js"}

task 'clean', 'clean output folder', ->
  for infile, outfile of client_files
    fs.unlink client_out + outfile

build: (infile, outfile) ->
  sys.puts client_in + infile + " -> " + client_out + outfile
  fs.readFile client_in + infile, "utf8", (err, code) ->
    compile: infile.substr(-7) == ".coffee"
    out: if compile then coffee.compile code else code
    fs.writeFile client_out + outfile, out

task 'build', 'build the client files', ->
  build infile, outfile for infile, outfile of client_files
