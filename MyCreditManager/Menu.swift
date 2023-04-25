//
//  Menu.swift
//  MyCreditManager
//
//  Created by 이윤학 on 2023/04/25.
//

// protocol
import Foundation


protocol MenuControl: AnyObject {
    var input: String? { get set }
    var pattern: String { get }
    
    func getInput(with: String)
    func checkPattern(_ input: String?, pattern: String) -> String?
    
    func inputError()
}

extension Menu {
    func getInput(with description: String) {
        print(description)
        input = checkPattern(readLine(), pattern: pattern)
    }
    
    func inputError() {
        print("입력이 잘못되었습니다. 다시 확인해주세요.")
    }
    
    func checkPattern(_ input: String?, pattern: String) -> String? {
        if let _ = input?.range(of: pattern, options: .regularExpression) {
             return input
        } else {
            return nil
        }
    }
}

protocol Menu: MenuControl {
   func mainProcess()
   func returnToMain()
}

extension Menu {
    func returnToMain() {
        currentMenu = menuOptions[0]
    }
}


// MainMenu part

class MainMenu: Menu {
    var input: String? = nil
    let pattern: String = "^[1-5X]{1}$"
    
    func mainProcess() {
        getInput()
        
        if let select = input {
            select == "X" ? endProgram() : moveMenu(to: select)
        } else {
            inputError()
            returnToMain()
        }
    }
}

extension MainMenu {

    func getInput() {
        getInput(with:
            """
            원하는 기능을 입력해주세요
            1: 학생추가, 2: 학생삭제, 3: 성적추가(변경), 4: 성적삭제, 5: 평점보기, X: 종료
            """
        )
    }
    
    func moveMenu(to number: String) {
        let menuIndex = Int(number) ?? 0
        currentMenu = menuOptions[menuIndex]
    }
    
    func endProgram() {
        print("프로그램을 종료합니다...")
        programeWorking = false
    }
    
    func inputError() {
        print("뭔가 입력이 잘못되었습니다. 1~5 사이의 숫자 혹은 X를 입력해주세요.")
    }
}
    


// 1. AddStudent Part

class AddStudent: Menu {
    var input: String? = nil
    let pattern: String = "^[A-Za-z]+$"
    
    func mainProcess() {
        getInput()
        
        if let name = input {
            students.contains{ $0.name == name } ? addFail(name: name) : addSuccess(name: name)
        } else {
            inputError()
        }
        
        returnToMain()
    }
}

extension AddStudent {
    func getInput() {
        getInput(with: "추가할 학생의 이름을 입력해주세요")
    }
    
    func addFail(name: String) {
        print("\(name)은 이미 존재하는 학생입니다. 추가하지 않습니다.")
    }
    
    func addSuccess(name: String) {
        addStudent(name: name)
        print("\(name) 학생을 추가했습니다.")
    }
    
    func addStudent(name: String) {
        students.append(Student(name: name))
    }
}


// 2. DeleteStudent Part

class DeleteStudent: Menu {
    var input: String? = nil
    let pattern: String = "^[A-Za-z]+$"
    
    func mainProcess() {
        getInput()
        
        if let name = input {
            if let index = students.firstIndex(where: { $0.name == name }) {
                deleteStudent(name: name, at: index)
            } else {
                deleteFail(name: name)
            }
        } else {
            inputError()
        }
        
        returnToMain()
    }
}

extension DeleteStudent {
     func deleteStudent(name: String, at index: Int) {
        students.remove(at: index)
        print("\(name) 학생을 삭제하였습니다.")
    }
    
    func deleteFail(name: String) {
        print("\(name) 학생을 찾지 못했습니다.")
    }
    
    func getInput() {
        getInput(with: "삭제할 학생의 이름을 입력해주세요")
    }
}

// 3. Add Grade Part

class AddGrade: Menu {
    var input: String?
    let pattern: String = "^([A-Za-z]+) ([A-Za-z]+) ([ABCDF]{1}[+]?)$"
    
    func mainProcess() {
        getInput()
        
        if let gradeData = input?.split(whereSeparator: { $0 == " " }).map({ String($0) }) {
            if let index = students.firstIndex(where: { $0.name == gradeData[0]}) {
                addGrade(gradeData: gradeData, at: index)
            } else {
                addFail(gradeData: gradeData)
            }
        } else {
            inputError()
        }
        
        returnToMain()
    }
}

extension AddGrade {
    func getInput() {
        getInput(with: """
                성적을 추가할 학생의 이름, 과목 이름, 성적(A+, A, F 등)을 띄어쓰기로 구분하여 차례로 작성해주세요.
                입력예) Mickey Swift A+
                만약에 학생의 성적 중 해당 과목이 존재하면 기존 점수가 갱신됩니다.
                """)
    }
    
    func addFail(gradeData: [String]) {
        print("\(gradeData[0]) 학생을 찾지 못했습니다.")
    }
    
    func addGrade(gradeData: [String], at index: Int) {
        students[index].grades[gradeData[1]] = gradeData[2]
        print("\(gradeData[0]) 학생의 \(gradeData[1]) 과목이 \(gradeData[2])로 추가(변경)되었습니다.")
    }
    
}


// 4. Delete Grade Part

class DeleteGrade: Menu {
    var input: String?
    let pattern: String = "^([A-Za-z]+) ([A-Za-z]+)$"
    
    func mainProcess() {
        getInput()
        
        if let deleteData = input?.split(whereSeparator: { $0 == " " }).map({ String($0) }) {
            if let index = students.firstIndex(where: { $0.name == deleteData[0] }) {
                addGrade(deleteData: deleteData, at: index)
            } else {
                addFail(deleteData: deleteData)
            }
        } else {
            inputError()
        }
        
        self.returnToMain()
    }
}

extension DeleteGrade {
    
    func getInput() {
        getInput(with:"""
                성적을 삭제할 학생의 이름, 과목 이름을 띄어쓰기로 구분하여 차례로 작성해주세요.
                입력예) Mickey Swift
                """)
    }
    
    func addFail(deleteData: [String]) {
        print("\(deleteData[0]) 학생을 찾지 못했습니다.")
    }
    
    func addGrade(deleteData: [String], at index: Int) {
        students[index].grades[deleteData[1]] = nil
        print("\(deleteData[0]) 학생의 \(deleteData[1]) 과목의 성적이 삭제되었습니다.")
    }
}


// 5. PrintGrades Part

class PrintGrades: Menu {
    var input: String?
    let pattern: String = "^[A-Za-z]+$"
    
    func mainProcess() {
        getInput()
        if let name = input {
            if let student = students.first(where: { $0.name == name }) {
                printSuccess(student: student)
            } else {
                addFail(name: name)
            }
        } else {
            inputError()
        }
        
        returnToMain()
    }
}

extension PrintGrades {
    
    func getInput() {
        getInput(with: "평점을 알고싶은 학생의 이름을 입력해주세요")
    }
    
    func addFail(name: String) {
        print("\(name) 학생을 찾지 못했습니다.")
    }
    
    func printSuccess(student: Student) {
        print(student.getSummary())
    }
}
