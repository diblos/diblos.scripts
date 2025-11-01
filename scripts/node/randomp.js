const https = require('https');

// URL containing the list of words
const URL = 'https://raw.githubusercontent.com/asrafulsyifaa/Malay-Dataset/master/dictionary/malay-text.txt';

// Function to fetch the list of words from the URL
const fetchWords = (url) => {
  return new Promise((resolve, reject) => {
    https.get(url, (res) => {
      let data = '';

      res.on('data', (chunk) => {
        data += chunk;
      });

      res.on('end', () => {
        resolve(data);
      });
    }).on('error', (err) => {
      reject(err);
    });
  });
};

// Function to capitalize the first character of a word
const capitalize = (word) => {
  return word.charAt(0).toUpperCase() + word.slice(1);
};

// Function to get a random number
const randomNumber = () => {
  return Math.floor(Math.random() * 10);
};

// Function to get a random symbol (if needed)
// const randomSymbol = () => {
//   const symbols = '!@#$%^&*()-_+=<>?';
//   return symbols[Math.floor(Math.random() * symbols.length)];
// };

// Main function
const main = async () => {
  try {
    const words = await fetchWords(URL);
    const wordsArray = words.split('\n').filter(word => word.length <= 6);

    if (wordsArray.length < 3) {
      console.log('The list must contain at least 3 words.');
      process.exit(1);
    }

    const getRandomUniqueIndices = (array, count) => {
      const indices = new Set();
      while (indices.size < count) {
        indices.add(Math.floor(Math.random() * array.length));
      }
      return Array.from(indices);
    };

    const [word1Index, word2Index, word3Index] = getRandomUniqueIndices(wordsArray, 3);
    const word1 = capitalize(wordsArray[word1Index]);
    const word2 = capitalize(wordsArray[word2Index]);
    const word3 = capitalize(wordsArray[word3Index]);
    const number = randomNumber();
    // const symbol = randomSymbol();

    const passwordPattern = `${word1}-${word2}-${word3}-${number}`;
    console.log(passwordPattern);

  } catch (error) {
    console.log('Failed to fetch the list of words.');
    process.exit(1);
  }
};

main();
