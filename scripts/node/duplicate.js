/**********************************************************
PURPOSE IS TO FIND DUPLICATE FILES BASED ON TITLE COMPARE
**********************************************************/

// requiring path and fs modules
const path = require('path')
const fs = require('fs')
// joining path of directory
const directoryPath = path.join(__dirname, 'combine')
const extFilename = '.torrent'
// directory subs
fs.readdir(directoryPath, (err, files) => {
  if (err) return console.log('Unable to scan directory: ' + err)
  // get year sub directories
  const subPaths = files.filter((d) => Number(d))
  subPaths.forEach(sub => {
    // passsing directoryPath and callback function
    fs.readdir(path.join(directoryPath, sub), (err, files) => {
      // handling error
      if (err) return console.log('Unable to scan directory: ' + err)

      // file structres
      const m = files.map(f => {
        const m = f.indexOf('(')
        const y = f.substr(0, m) || path.basename(f, extFilename)
        return { filename: f, title: y.trim() }
      }).filter(d => {
        return path.extname(d.filename) === extFilename
      })

      // get titles, distinct
      const getTitles = Array.from(new Set(m.map(d => d.title)))

      // get duplicates
      const getDuplicates = getTitles.map(title => {
        return { title, count: m.filter(f => f.title === title).length }
      }).filter(f => f.count > 1)

      // print
      if (getDuplicates.length > 0) {
        console.log(sub)
        console.log(getDuplicates)
      }
    })
  })
})
