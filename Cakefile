fs: require "fs"

client_in: "client/"
client_out: "out/"
client_files: {"index.html": "index.html",
               "client.coffee": "client.js"}

task 'clean', 'clean output folder', ->
  for infile, outfile of client_files
    fs.unlink client_out + outfile

task 'build', 'build the client files', ->
  for infile, outfile of client_files
    fs.readFile client_in + infile, (err, code) ->
      compile: infile.substring(-7) == ".coffee"
      out: if compile then coffee.compile code else code
      fs.writeFile client_out + outfile, out