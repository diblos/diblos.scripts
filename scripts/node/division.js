/**********************************************************
PURPOSE IS TO DEVIDE FILES INTO SUBFOLDERS OF YEARS (YYYY)
**********************************************************/

// requiring path and fs modules
const path = require('path')
const fs = require('fs')
// joining path of directory
const directoryPath = path.join(__dirname, 'combine')
const extFilename = '.torrent'
// passsing directoryPath and callback function
fs.readdir(directoryPath, (err, files) => {
  // handling error
  if (err) {
    return console.log('Unable to scan directory: ' + err)
  }

  // file structres
  const m = files.map(f => {
    var m = f.indexOf('(')
    var y = f.substr(m + 1, 4)
    return { filename: f, sub: y }
  }).filter(d => {
    return path.extname(d.filename) === extFilename && Number(d.sub)
  })

  // get subs, distinct
  const getSubs = Array.from(new Set(m.map(d => d.sub)))

  // create subs
  getSubs.forEach((sub) => {
    var dir = path.join(directoryPath, sub)
    if (!fs.existsSync(dir)) fs.mkdirSync(dir, 0744); // eslint-disable-line
  })

  // move file to subs
  m.forEach((file) => {
    var oldPath = path.join(directoryPath, file.filename)
    var newPath = path.join(directoryPath, file.sub, file.filename)
    fs.rename(oldPath, newPath, (err) => {
      if (err) throw err
      console.log(`Successfully moved: ${file.filename}`)
    })
  })
})
