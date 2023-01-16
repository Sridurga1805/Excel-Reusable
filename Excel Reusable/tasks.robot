*** Settings ***
Documentation       This Process compares Input excel file with Template file
...                 Reads Template file Sheet and Column names
...                 Reads Input File Sheet and Coulmn names
...                 Compares Sheet and Column names are mataching or not from both files

Library             RPA.Tables
Library             RPA.Excel.Files
Library             RPA.FileSystem
Library             RPA.JSON


*** Variables ***
${ExcelHeaders}
@{tempSheetname}
@{ipSheetName}
${inExcelHeaders}
${ErrorMessage}


*** Tasks ***
Simple Task
    Read Json File
    TRY
        Get Details from Template Excel
        Get Details from Input File
        Check Coulmn and Sheet names are matching?
    EXCEPT    AS    ${ErrorMessage}
        Log    ${ErrorMessage}
    END


*** Keywords ***
Read Json File
    ${config}=    Load JSON from file    Config.Json
    ${templateFilePath}=    Get value from JSON    ${config}    [templateFilePath]
    ${inputFilepath}=    Get value from JSON    ${config}    [inputFilepath]
    Set Global Variable    ${templateFilePath}
    Set Global Variable    ${inputFilepath}

Get Details from Template Excel
    RPA.Excel.Files.Open Workbook    ${templateFilePath}
    @{tempSheetname}=    List Worksheets
    ${table}=    Read Worksheet As Table
    ${ExcelHeaders}=    Get table row    ${table}    0
    Close Workbook

Get Details from Input File
    RPA.Excel.Files.Open workbook    ${inputFilepath}
    @{ipSheetName}=    List Worksheets
    ${Intable}=    Read Worksheet As Table
    ${inExcelHeaders}=    Get table row    ${Intable}    0

    Close Workbook

Check Coulmn and Sheet names are matching?
    IF    '${ExcelHeaders}' == '${inExcelHeaders}'
        Log    Column names are equal
    ELSE
        Log    Column names are not equal
    END

    IF    @{tempSheetname} == @{ipSheetName}
        Log    Sheet names are equal
    ELSE
        Log    Sheet names are not macthing
    END
