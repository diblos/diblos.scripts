/**********************************************************
PURPOSE IS TO CALCULATE FILES IN EACH SUBFOLDER
**********************************************************/
// REQUIRING PATH AND FS MODULES
const path = require('path')
const fs = require('fs')
const MOVIES_PER_DAY = 4
// JOINING PATH OF DIRECTORY
const directoryPath = path.join(__dirname, 'combine')
const extFilename = '.torrent'
// DIRECTORY SUBS
fs.readdir(directoryPath, async (err, files) => {
  if (err) return echo('Unable to scan directory: ' + err)
  // GET YEAR SUB DIRECTORIES
  const subPaths = files.filter((d) => Number(d))
  await Promise.all(subPaths.map(sub => {
    return processSub(directoryPath, sub)
  })).then(result => {
    if (!result || result.length <= 0) {
      throw new Error('err')
    }
    result.sort((a, b) => a.year - b.year)
    result.forEach((item) => echo(item))
    const total = result.reduce((total, obj) => obj.count + total, 0)
    echo('-'.repeat(45))
    echo(`total movie years: ${result.length}`)
    echo(`total movie titles: ${total}`)
    const timeNeeded = total / (365 * MOVIES_PER_DAY)
    echo(`total time: ${Math.floor(timeNeeded)} yrs ${Math.round((timeNeeded - Math.floor(timeNeeded)) * 12)} mths (${MOVIES_PER_DAY} movies daily)`)
    return echo('='.repeat(45))
  }).catch(e => {
    return echoErr(e.message)
  })
})

const processSub = (directoryPath, sub) => {
  return new Promise((resolve, reject) => {
    // PASSSING DIRECTORYPATH AND CALLBACK FUNCTION
    fs.readdir(path.join(directoryPath, sub), (err, files) => {
      // HANDLING ERROR
      if (err) return echo('Unable to scan directory: ' + err)
      // FILE STRUCTRES
      const m = files.map(f => {
        const m = f.indexOf('(')
        const y = f.substr(0, m) || path.basename(f, extFilename)
        return { filename: f, title: y.trim() }
      }).filter(d => {
        return path.extname(d.filename) === extFilename
      })
      // RETURN
      return resolve({ year: Number(sub), count: m.length })
    })
  })
}

const echo = (obj) => console.log(obj)
const echoErr = (obj) => console.error(obj)
