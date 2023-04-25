//
//  main.swift
//  MyCreditManager
//
//  Created by 이윤학 on 2023/04/25.
//


import Foundation

// global Variables

var students: [Student] = []
var programeWorking = true
var gradeValue: [String: Double] = ["A+" : 4.5, "A" : 4.0, "B+" : 3.5, "B" : 3.0, "C+" : 2.5, "C" : 2.0, "D+" : 1.5, "D" : 1.0, "F" : 0.0]
var menuOptions: [Menu] = [MainMenu(), AddStudent(), DeleteStudent(), AddGrade(), DeleteGrade(), PrintGrades()]
var currentMenu: Menu = menuOptions[0]


// MainMenu part

while programeWorking {
    currentMenu.mainProcess()
}
