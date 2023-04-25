//
//  Helper.swift
//  MyCreditManager
//
//  Created by 이윤학 on 2023/04/25.
//

import Foundation

enum TextType {
        case basic, inputFormatError, success, fail, exit
}

struct Student: Identifiable, Hashable {
    var id: String {
        return name
    }
    var name: String
    var grades: [String: String] = [:]
    
    func getSummary() -> String {
            var summary = ""
            
            for (course, grade) in grades {
                summary += (course + ": " + grade + "\n")
            }
            
            let average = grades.values.map{ gradeValue[$0] ?? 0.0 }.reduce(0, +) / Double(grades.values.count)
            
            let roundDownFormatter = NumberFormatter()
            roundDownFormatter.roundingMode = .floor
            roundDownFormatter.maximumFractionDigits = 2
            
            var formattedAverage = roundDownFormatter.string(for: average) ?? "Error"
            if formattedAverage == "0" && average != 0.0 {
                formattedAverage = "0.00"
            }
            
            summary += formattedAverage
            
            return summary
        }
    
}


var gradeValue: [String: Double] = ["A+" : 4.5, "A" : 4.0, "B+" : 3.5, "B" : 3.0, "C+" : 2.5, "C" : 2.0, "D+" : 1.5, "D" : 1.0, "F" : 0.0]
