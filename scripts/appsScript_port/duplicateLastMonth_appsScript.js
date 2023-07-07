function onOpen() {
  var ui = SpreadsheetApp.getUi();
  // Or DocumentApp or FormApp.
  ui.createMenu('Language Coach Skrypciki :D')
      .addItem('Duplicate last months sheet with contents, formatting and a new name', 'duplicateLastMonthsSheetAsLastWithName')
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
    newSheet = targetSpreadsheet.insertSheet(newSheetName,sheetNumber, {template: lastMonth})
    newSheetControlRange = newSheet.getRange(3,6,15,3)
    newSheetControlRange.setValues([["X","X","X"],["X","X","X"],["X","X","X"],["X","X","X"],["X","X","X"],["X","X","X"],["X","X","X"],["X","X","X"],["X","X","X"],["X","X","X"],["X","X","X"],["X","X","X"],["X","X","X"],["X","X","X"],["X","X","X"]])
  }
}
