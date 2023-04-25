import Foundation

// global Variables

var programEnd = false

var menuOptions: [MenuControl] = [MainMenu(), AddStudent(), DeleteStudent(), AddGrade(), DeleteGrade(), PrintGrades()]
var currentMenu: MenuControl = menuOptions[0]

var students: [Student] = []

// MainMenu part

while !programEnd {
    currentMenu.mainProcess()
}
