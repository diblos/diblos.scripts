/**********************************************************
PURPOSE IS TO MOVIE LIST FROM MOVIE COLLECTION FILES & FOLDERS
**********************************************************/
const path = require('path')
const fs = require('fs')

const extFilename = '.txt'
// const directoryPath = path.join(__dirname, 'combine')
const movColPath = '/Users/acs_mbp13_01/workspace/misc/diblos.mov.col'
const excludedDirs = ['.git']

async function main() {
  try {
    const subPaths = getSubDirectories(movColPath)
    const result = await processSubDirectories(subPaths).then(result => {
      return result.flat(1).sort((a, b) => {
        if (a.year < b.year) {
          return -1
        } else if (a.year > b.year) {
          return 1
        } else { // SORT BY NAME
          return a.title.localeCompare(b.title)
        }
      }).map((v, i) => Object.assign({ index: i }, v))
    })
    // console.log(result)
    writeJSONFile('movies.json', result)
  } catch (error) {
    console.error(error)
  }
}

function getSubDirectories(directoryPath) {
  return fs.readdirSync(directoryPath, { withFileTypes: true })
    .filter(dirent => dirent.isDirectory() && !excludedDirs.includes(dirent.name))
    .map(dirent => dirent.name)
}

function processSubDirectories(subPaths) {
  return Promise.all(subPaths.map(sub => {
    const subDirectoryPath = path.join(movColPath, sub)
    return processSub(subDirectoryPath)
  }))
}

function processSub(subDirectoryPath) {
  return new Promise((resolve, reject) => {
    fs.readdir(subDirectoryPath, (err, files) => {
      if (err) {
        reject(new Error('Unable to scan directory: ' + err))
        return
      }
      const movies = files
        .filter(file => path.extname(file) === extFilename)
        .map(file => {
          const filename = path.basename(file, extFilename)
          const fileContent = fs.readFileSync(path.join(subDirectoryPath, file), 'utf8')
          const movies = fileContent.split('\n').map(movieStr => {
            const regex = /\[.*?\]/g
            const cMovie = movieStr.replace(regex, '')
            return cMovie.trim()
          }).sort()
          return movies.map(movie => {
            return {
              sub: path.basename(subDirectoryPath),
              year: parseInt(filename),
              title: movie
            }
          })
        })
      resolve(movies.flat(1))
    })
  })
}

function writeJSONFile(filename, obj) {
  const jsonString = JSON.stringify(obj, null, 2)
  fs.writeFile(filename, jsonString, (err) => {
    if (err) {
      console.error(err)
    } else {
      console.log('File written successfully!')
    }
  })
}

main()
