/*******************************************************************************
PURPOSE IS TO MOVE TORRENT FILES FROM DOWNLOAD FOLDER TO WORKING TORRENT FOLDER
********************************************************************************/

// REQUIRING PATH AND FS MODULES
const path = require('path')
const fs = require('fs')
// JOINING PATH OF DIRECTORY
const sourcePath = '/Users/acs_mbp13_01/Downloads'
const destinationPath = path.join(__dirname, 'torrents')
const extFilename = '.torrent'

// PASSSING SOURCEPATH AND CALLBACK FUNCTION
fs.readdir(sourcePath, (err, files) => {
  // HANDLING ERROR
  if (err) {
    return console.log('Unable to scan directory: ' + err)
  }

  // FILE STRUCTRES
  const m = files.map(f => {
    var m = f.indexOf('(')
    var y = f.substr(m + 1, 4)
    return { filename: f, sub: y }
  }).filter(d => {
    return path.extname(d.filename) === extFilename && Number(d.sub)
  })

  // MOVE FILE TO DESTINATION FOLDER
  m.forEach((file) => {
    var oldPath = path.join(sourcePath, file.filename)
    var newPath = path.join(destinationPath, file.filename)
    fs.rename(oldPath, newPath, (err) => {
      if (err) throw err
      console.log(`Successfully moved: ${file.filename}`)
    })
  })
  console.log(`Moved ${m.length} file(s)!`);
  
})
