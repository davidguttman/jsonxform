# This script tranform objects in a JSON array
# This is useful for modifying the format of objects in a JSON file.

fs = require 'fs'
JSONStream = require 'JSONStream'
through = require 'through'

input = process.argv[2]
output = process.argv[3]
xform = process.argv[4]

unless input and output and xform
  console.error 'Usage: jsonxform <input> <output> "<tranform>" '
  process.exit 1 


tr = through (data) ->
  eval xform

  @emit 'data', data

rs = fs.createReadStream input
ws = fs.createWriteStream output

rs.pipe(JSONStream.parse [true]).pipe(tr)
  .pipe(JSONStream.stringify()).pipe(ws)