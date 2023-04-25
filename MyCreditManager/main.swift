import Foundation

// protocol
protocol MenuControl: AnyObject {
    var data: String { get set }
    var pattern: String { get }
    
    func readData()
    func checkInput(_ input: String?) -> String
    
    func printText(type textType: TextType)
    func returnToMain()
    func mainProcess()
}

extension MenuControl {
    func readData() {
        printText(type: .basic)
        data = checkInput(readLine())
    }
    
    func checkInput(_ input: String?) -> String {
            if let _ = input?.range(of: pattern, options: .regularExpression) {
                 return input!
            } else {
                self.printText(type: .inputFormatError)
                return "0"
            }
    }
    
    func returnToMain() {
        currentMenu = menuOptions[0]
    }
}


// Helpers

enum TextType {
        case basic, inputFormatError, success, fail, exit
}

struct Student: Identifiable, Hashable {
    var id: String {
        return name
    }
    var name: String
    var grades: [String: String] = [:]
    
}

var students: [Student] = []

enum Grade: String {
    case AP = "A+"
    case BP = "B+"
    case CP = "C+"
    case DP = "D+"
    case A, B, C, D, F
    
    static var gradeValue: [String: Double] = ["A+" : 4.5, "A" : 4.0, "B+" : 3.5, "B" : 3.0, "C+" : 2.5, "C" : 2.0, "D+" : 1.5, "D" : 1.0, "F" : 0.0]
}

// global Variables

var programEnd = false
var menuOptions: [MenuControl] = [MainMenu(), AddStudent(), DeleteStudent(), AddGrade(), DeleteGrade(), PrintGrades()]
var currentMenu: MenuControl = menuOptions[0]


// MainMenu part

class MainMenu: MenuControl {
    var data: String = "0"
    let pattern: String = "^[1-5X]{1}$"
    
    func mainProcess() {
        readData()
        
        if data == "X" {
            printText(type: .exit)
            programEnd = true
        } else {
            let menuIndex = Int(data) ?? 0
            currentMenu = menuOptions[menuIndex]
        }
    }
}

extension MainMenu {
    func printText(type textType: TextType) {
        switch textType {
            case .basic:
                print("""
                원하는 기능을 입력해주세요
                1: 학생추가, 2: 학생삭제, 3: 성적추가(변경), 4: 성적삭제, 5: 평점보기, X: 종료
                """)
            case .inputFormatError:
                print("뭔가 입력이 잘못되었습니다. 1~5 사이의 숫자 혹은 X를 입력해주세요.")
            case .exit:
                print("프로그램을 종료합니다...")
            default:
                break
        }
    }
}
    


// 1. AddStudent Part

class AddStudent: MenuControl {
    var data: String = ""
    let pattern: String = "^[A-Za-z]+$"
    
    func mainProcess() {
        readData()
        if data != "0" {
            let isExist = students.contains{ $0.name == data }
            if isExist {
                self.printText(type: .fail)
            } else {
                students.append(Student(name: data))
                self.printText(type: .success)
            }
        }
        self.returnToMain()
    }
    
    func printText(type textType: TextType) {
        switch textType {
            case .basic:
                print("추가할 학생의 이름을 입력해주세요")
            case .inputFormatError:
                print("입력이 잘못되었습니다. 다시 확인해주세요.")
            case .success:
                print("\(data) 학생을 추가했습니다.")
            case .fail:
                print("\(data)은 이미 존재하는 학생입니다. 추가하지 않습니다.")
            default:
                break
        }
    }
    
    
    
}


// 2. DeleteStudent Part

class DeleteStudent: MenuControl {
    var data: String = ""
    let pattern: String = "^[A-Za-z]+$"
    
    func printText(type textType: TextType) {
        switch textType {
            case .basic:
                print("삭제할 학생의 이름을 입력해주세요")
            case .inputFormatError:
                print("입력이 잘못되었습니다. 다시 확인해주세요.")
            case .success:
                print("\(data) 학생을 삭제하였습니다.")
            case .fail:
                print("\(data) 학생을 찾지 못했습니다.")
            default:
                break
        }
    }
    
    
    func mainProcess() {
        readData()
        if data != "0" {
            if let index = students.firstIndex(where: { $0.name == data }) {
                students.remove(at: index)
                self.printText(type: .success)
            } else {
                self.printText(type: .fail)
            }
        }
        self.returnToMain()
    }
}


// 3. Add Grade Part

class AddGrade: MenuControl {
    var data: String = ""
    var splitData: [String] = ["", "", ""]
    
    let pattern: String = "^([A-Za-z]+) ([A-Za-z]+) ([ABCDF]{1}[+]?)$"
    
    func printText(type textType: TextType) {
        switch textType {
            case .basic:
                print("""
                성적을 추가할 학생의 이름, 과목 이름, 성적(A+, A, F 등)을 띄어쓰기로 구분하여 차례로 작성해주세요.
                입력예) Mickey Swift A+
                만약에 학생의 성적 중 해당 과목이 존재하면 기존 점수가 갱신됩니다.
                """)
            case .inputFormatError:
                print("입력이 잘못되었습니다. 다시 확인해주세요.")
            case .success:
                print("\(splitData[0]) 학생의 \(splitData[1]) 과목이 \(splitData[2])로 추가(변경)되었습니다.")
            case .fail:
                print("\(splitData[0]) 학생을 찾지 못했습니다.")
            default:
                break
        }
    }
    
    
    func mainProcess() {
        readData()
        
        if data != "0" {
            self.splitData = data.split{ $0 == " " }.map{ String($0) }
            
            if let index = students.firstIndex(where: { $0.name == self.splitData[0] }) {
                students[index].grades[splitData[1]] = splitData[2]
                self.printText(type: .success)
            } else {
                self.printText(type: .fail)
            }
        }
        self.returnToMain()
    }
}


// 4. Delete Grade Part

class DeleteGrade: MenuControl {
    var data: String = ""
    var splitData: [String] = ["", ""]
    
    let pattern: String = "^([A-Za-z]+) ([A-Za-z]+)$"
    
    func printText(type textType: TextType) {
        switch textType {
            case .basic:
                print("""
                성적을 삭제할 학생의 이름, 과목 이름을 띄어쓰기로 구분하여 차례로 작성해주세요.
                입력예) Mickey Swift
                """)
            case .inputFormatError:
                print("입력이 잘못되었습니다. 다시 확인해주세요.")
            case .success:
                print("\(splitData[0]) 학생의 \(splitData[1]) 과목의 성적이 삭제되었습니다.")
            case .fail:
                print("\(splitData[0]) 학생을 찾지 못했습니다.")
            default:
                break
        }
    }
    
    
    func mainProcess() {
        readData()
        if data != "0" {
            self.splitData = data.split{ $0 == " " }.map{ String($0) }
            
            if let index = students.firstIndex(where: { $0.name == self.splitData[0] }) {
                students[index].grades[splitData[1]] = nil
                self.printText(type: .success)
            } else {
                self.printText(type: .fail)
            }
        }
        self.returnToMain()
    }
}


// 5. PrintGrades Part

class PrintGrades: MenuControl {
    var data: String = ""
    var successText = ""
    let pattern: String = "^[A-Za-z]+$"
    
    func printText(type textType: TextType) {
        switch textType {
            case .basic:
                print("평점을 알고싶은 학생의 이름을 입력해주세요")
            case .inputFormatError:
                print("입력이 잘못되었습니다. 다시 확인해주세요.")
            case .success:
                print(successText)
            case .fail:
                print("\(data) 학생을 찾지 못했습니다.")
            default:
                break
        }
    }
    
    func mainProcess() {
        readData()
        if data != "0" {
            if let index = students.firstIndex(where: { $0.name == self.data }) {
                let grades = students[index].grades
                
                for (course, grade) in grades {
                    successText += (course + ": " + grade + "\n")
                }
                successText += formattingAverage(grades: grades)
                self.printText(type: .success)
                successText = ""
            } else {
                self.printText(type: .fail)
            }
        }
        self.returnToMain()
    }
}

extension PrintGrades {
    func formattingAverage(grades: [String: String]) -> String {
        let average = calculateAverage(grades: grades)
        let numberFormatter = roundDownFormatter(maximumFractionDigits: 2)
        return formattingNumber(average, numberFormatter)
    }
    
    
    func calculateAverage(grades: [String: String]) -> Double {
        var sum: Double = 0.0
        for grade in grades.values {
            sum += Grade.gradeValue[grade] ?? 0.0
        }
        return sum / Double(grades.values.count)
    }
    
    func roundDownFormatter(maximumFractionDigits: Int) -> NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.roundingMode = .floor
        numberFormatter.maximumFractionDigits = maximumFractionDigits
        
        return numberFormatter
    }
    
    func formattingNumber(_ number: Double, _ numberFormatter: NumberFormatter) -> String {
        var result = numberFormatter.string(for: number) ?? "Error"
        if result == "0" && number != 0.0 {
            result = "0.00"
        }
        return result
    }
}
while !programEnd {
    currentMenu.mainProcess()
}

