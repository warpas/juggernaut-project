function onOpen() {
  var ui = SpreadsheetApp.getUi();
  // Or DocumentApp or FormApp.
  ui.createMenu('Juggernaut Control')
      .addItem('Add new sheet at start', 'addNewSheetAsFirst')
      .addItem('Add new sheet at end', 'addNewSheetAsLast')
      .addItem('Duplicate last sheet with contents', 'duplicateLastSheetAsLast')
      .addItem('Duplicate last sheet with contents and new name', 'duplicateLastSheetAsLastWithName')
      .addItem('Duplicate last months sheet with contents, formatting and a new name', 'duplicateLastMonthsSheetAsLastWithName')
      .addItem('Duplicate last months sheet with formatting and a new name', 'duplicateLastMonthsSheetAsLastWithNameButClearTheContent')
      .addItem('Duplicate last months sheet with formatting, formulas and a new name', 'duplicateLastMonthsSheetAsLastWithNameButClearTheContentAndGrabFormulas')
      // .addSeparator()
      // .addSubMenu(ui.createMenu('Sub-menu')
      //     .addItem('Second item', 'menuItem2'))
      .addToUi();
}

const monthNames = ["January", "February", "March", "April", "May", "June",
  "July", "August", "September", "October", "November", "December"
]
const spreadsheet = SpreadsheetApp.getActiveSpreadsheet();

function sheetNameFinder(newMonth = true) {
  // get todays date
  let currentDate = new Date
  // instantiate a variable sheetName which is a full month + year as string
  let sheetName = `${monthNames[currentDate.getMonth()]} ${currentDate.getFullYear()}`
  if (newMonth) {
    // if it's before 10th it's last month
    if (currentDate.getDay() < 10) {
      sheetName = `${monthNames[currentDate.getMonth() - 1]} ${currentDate.getFullYear()}`
    }
  } else {
    if (currentDate.getDay() < 10) {
      sheetName = `${monthNames[currentDate.getMonth() - 2]} ${currentDate.getFullYear()}`
    } else {
      sheetName = `${monthNames[currentDate.getMonth() - 1]} ${currentDate.getFullYear()}`
    }
  }
  return sheetName
}

function addNewSheetAsFirst(targetSpreadsheet = spreadsheet) {
  // insert sheet at index equal to number of sheets in spreadsheet aka. last
  targetSpreadsheet.insertSheet(0)
}

function addNewSheetAsLast(targetSpreadsheet = spreadsheet) {
  // find how many sheets are in the spreadsheets
  let sheetNumber = targetSpreadsheet.getSheets().length
  // insert sheet at index equal to number of sheets in spreadsheet aka. last
  targetSpreadsheet.insertSheet(sheetNumber)
}

function duplicateSheetAsLast(targetSpreadsheet = spreadsheet) {
  // find how many sheets are in the spreadsheets
  let sheetNumber = targetSpreadsheet.getSheets().length
  // find the last sheet in the spreadsheet as sheetObject
  let lastMonth = targetSpreadsheet.getSheets()[sheetNumber - 1]
  // insert sheet at index equal to number of sheets in spreadsheet aka. last from the template of current last sheet in spreadsheet
  targetSpreadsheet.insertSheet(sheetNumber, {template: lastMonth})
}

function duplicateLastSheetAsLastWithName(targetSpreadsheet = spreadsheet) {
  // find how many sheets are in the spreadsheets
  let sheetNumber = targetSpreadsheet.getSheets().length
  // find the last sheet in the spreadsheet as sheetObject
  let lastMonth = targetSpreadsheet.getSheets()[sheetNumber - 1]
  // find the appropriate name for the new sheet
  let newSheetName = sheetNameFinder()
  // insert sheet at index equal to number of sheets in spreadsheet aka. last from the template of current last sheet in the spreadsheet
  // if the correct name according to selection logic is not already the name of last spreadsheet
  if (lastMonth.getName() != newSheetName) {
    SpreadsheetApp.getUi().alert(`Created sheet ${newSheetName}`)
    targetSpreadsheet.insertSheet(newSheetName,sheetNumber, {template: lastMonth})
  }
}

function duplicateLastMonthsSheetAsLastWithName(targetSpreadsheet = spreadsheet) {
  // find how many sheets are in the spreadsheets
  let sheetNumber = targetSpreadsheet.getSheets().length
  // find the last sheet in the spreadsheet as sheetObject
  let lastMonth = targetSpreadsheet.getSheetByName(sheetNameFinder(newMonth = false))
  // find the appropriate name for the new sheet
  let newSheetName = sheetNameFinder()
  // insert sheet at index equal to number of sheets in spreadsheet aka. last from the template of last months sheet
  // if the correct name isn't already a sheet in the spreadsheet
  if (!targetSpreadsheet.getSheets().map( x => x.getName()).includes(newSheetName)) {
    SpreadsheetApp.getUi().alert(`Created sheet ${newSheetName} from template ${lastMonth.getSheetName()}`)
    targetSpreadsheet.insertSheet(newSheetName,sheetNumber, {template: lastMonth})
  }
}

function duplicateLastMonthsSheetAsLastWithNameButClearTheContent(targetSpreadsheet = spreadsheet) {
  // find how many sheets are in the spreadsheets
  let sheetNumber = targetSpreadsheet.getSheets().length
  // find the last sheet in the spreadsheet as sheetObject
  let lastMonth = targetSpreadsheet.getSheetByName(sheetNameFinder(newMonth = false))
  // find the appropriate name for the new sheet
  let newSheetName = sheetNameFinder()
  // insert sheet at index equal to number of sheets in spreadsheet aka. last from the template of last months sheet
  // if the correct name isn't already a sheet in the spreadsheet
  if (!targetSpreadsheet.getSheets().map( x => x.getName()).includes(newSheetName)) {
    newSheet = targetSpreadsheet.insertSheet(newSheetName,sheetNumber, {template: lastMonth})
    newSheet.clear( { contentsOnly: true } )
    SpreadsheetApp.getUi().alert(`Created sheet ${newSheetName} from template ${lastMonth.getSheetName()}`)
  }
}

// Formula copying requires a specific range containing formulas and can't be done in bulk, this approach will not work
function duplicateLastMonthsSheetAsLastWithNameButClearTheContentAndGrabFormulas(targetSpreadsheet = spreadsheet) {
  // find how many sheets are in the spreadsheets
  let sheetNumber = targetSpreadsheet.getSheets().length
  // find the last sheet in the spreadsheet as sheetObject
  let lastMonth = targetSpreadsheet.getSheetByName(sheetNameFinder(newMonth = false))
  // find the appropriate name for the new sheet
  let newSheetName = sheetNameFinder()
  // insert sheet at index equal to number of sheets in spreadsheet aka. last from the template of last months sheet
  // if the correct name isn't already a sheet in the spreadsheet
  if (!targetSpreadsheet.getSheets().map( x => x.getName()).includes(newSheetName)) {
    newSheet = targetSpreadsheet.insertSheet(newSheetName,sheetNumber, {template: lastMonth})
    newSheet.clear( { contentsOnly: true } )
    oldFormulas = lastMonth.getRange(1,1,20,20).getFormulasR1C1()
    newSheet.getRange(1,1,20,20).setFormulasR1C1(oldFormulas)
    SpreadsheetApp.getUi().alert(`Created sheet ${newSheetName} from template ${lastMonth.getSheetName()}`)
  }
}
