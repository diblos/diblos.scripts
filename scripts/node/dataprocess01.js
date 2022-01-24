/*******************************************************************
PURPOSE IS TO COMPARING INVOICE FILES VS INVOICE LIST FROM JSON FILE
********************************************************************/
// REQUIRING FS MODULES
const fs = require('fs')
const ROOTPATH = '/Users/acs_mbp13_01/Desktop/@trouble/datastats/202201'
const zasssProfileList = JSON.parse(fs.readFileSync(`${ROOTPATH}/zs_profile.json`, 'utf8'))
const userRegList = JSON.parse(fs.readFileSync(`${ROOTPATH}/userreg.json`, 'utf8'))
const jobList = JSON.parse(fs.readFileSync(`${ROOTPATH}/joblist.json`, 'utf8'))
const jobMatchList = JSON.parse(fs.readFileSync(`${ROOTPATH}/jobmatch.json`, 'utf8'))
const invoiceList = JSON.parse(fs.readFileSync(`${ROOTPATH}/invoice.json`, 'utf8'))

/*
listed service		zasss_svc_profile
total ticket sales RM		invoice
total ticket sales, vol		invoice
		
job post		job_list
job match		job_match
job accept		
*/
// console.log(invoiceList);

