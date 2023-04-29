//
//  Helper.swift
//  MyCreditManager
//
//  Created by 이윤학 on 2023/04/25.
//

import Foundation

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
