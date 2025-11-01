/**********************************************************
PURPOSE IS TO MOVIE LIST FROM MOVIE COLLECTION FILES & FOLDERS
**********************************************************/
const path = require('path')
const fs = require('fs')
const csv = require('./lib/csv-parser')
const { result, toLower } = require('./lib/lodash')

// var _ = require('lodash/core');

const imdb = 'final_dataset.webarchive'
const extFilename = '.torrent'
const movColPath = path.join(__dirname, 'combine')
const excludedDirs = ['.git']

arrHeaders = ['id', 'title', 'link', 'year', 'duration', 'mpa', 'rating', 'votes', 'budget', 'grossWorldWide', 'gross_US_Canada', 'opening_weekend_Gross', 'directors', 'writers', 'stars', 'genres', 'countries_origin', 'filming_locations', 'production_companies', 'languages', 'wins', 'nominations', 'oscars']
imdbData = []

async function main() {
  try {
    // readCSVFile(path.join(__dirname, imdb), (data) => {
    //   // console.log(data)
    //   imdbData = data
    // })

    imdbData = (await readCSVFile(path.join(__dirname, imdb))).filter(v => !!v.title)
    // console.log(imdbData[0]);
    // console.log(imdbData[1]);
    // console.log(imdbData[2]);


    const subPaths = getSubDirectories(movColPath)
    const result = await processSubDirectories(subPaths).then(result => {
      return result.flat(1).filter(v => v !== null)
        .sort((a, b) => {
          if (a.year < b.year) {
            // return -1
            return 1
          } else if (a.imdb > b.imdb) {
            // return 1
            return -1
          } else { // SORT BY NAME
            return a.title.localeCompare(b.title)
          }
        })
        .map((v, i) => Object.assign({ index: i }, v))
    })
    // console.log(result)
    writeJSONFile('movies2watch.json', result)
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
    // console.log(subDirectoryPath);
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
          // const inputString: string = "100 Things (2018) [BluRay] [720p] [YTS.AM]";

          // Regular expression pattern
          const regex = /(.+?) \((\d{4})\) \[(.+?)\] \[(.+?)\] \[(.+?)\]/;

          // Match the pattern
          const match = filename.match(regex);

          if (match) {
            const title = match[1] || null
            const year = match[2] || null
            const quality = match[3] || null
            const source = match[4] || null
            const imdb = result(imdbData.find(v => v.title.toLowerCase() === title.toLowerCase() && v.year === year), 'rating', null)

            return {
              origin: filename,
              title,
              year: parseInt(year),
              quality,
              source,
              imdb: imdb? parseFloat(imdb): null,
            }

          } else {
            return null
          }

        })
      resolve(movies.flat(1))
    })
  })
}

// function readCSVFile(filePath, callback) {
//   const results = [];
//   fs.createReadStream(filePath)
//     .pipe(csv(arrHeaders))
//     .on('data', (data) => results.push(data))
//     .on('end', () => {
//       callback(results);
//     });
// }

function readCSVFile(filePath) {
  return new Promise((resolve, reject) => {
    const results = [];
    fs.createReadStream(filePath)
      .pipe(csv(arrHeaders))
      .on('data', (data) => results.push(data))
      .on('end', () => {
        resolve(results);
      })
      .on('error', (error) => {
        reject(error);
      });
  });
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
