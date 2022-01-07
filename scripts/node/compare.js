/*******************************************************************
PURPOSE IS TO COMPARING INVOICE FILES VS INVOICE LIST FROM JSON FILE
********************************************************************/
// REQUIRING FS MODULES
const fs = require('fs')
// JOINING PATH OF DIRECTORY
const filePath = '/Users/acs_mbp13_01/Desktop/@trouble/gunteng/20220107/invoices-202112'
const obj = JSON.parse(fs.readFileSync('/Users/acs_mbp13_01/Desktop/@trouble/gunteng/20220107/JSON/hafiz-invoice-202112.json', 'utf8'))
const invoiceList = Object.keys(obj)

// PASSSING RAWPATH AND CALLBACK FUNCTION
fs.readdir(filePath, (err, files) => {
  // HANDLING ERROR
  if (err) {
    return console.log('Unable to scan directory: ' + err)
  }

  const m = files.map(file => file.split('.')[0]).filter(f => !invoiceList.includes(f))
  const n = invoiceList.filter(f => !files.map(file => file.split('.')[0]).includes(f))

  console.log({ m, n })
})
