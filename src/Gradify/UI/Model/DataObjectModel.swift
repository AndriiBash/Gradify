//
//  DataObjectModel.swift
//  Gradify
//
//  Created by Андрiй on 26.01.2024.
//

import Foundation


struct Student: Identifiable, Sendable
{
    var id: Int = 0// maybe to fix for all struct data object
    
    var lastName: String = ""
    var name: String = ""
    var surname: String = ""
    
    var dateBirth: Date = Date.from(year: 2000, month: 00, day: 01)!
    var contactNumber: String = "" // or can use "mobileNumber" for name var ¯\_(ツ)_/¯
    var passportNumber: String = ""
    var residenceAddress: String = ""
    
    var group: String = ""
}// struct Student: Identifiable


struct Group: Identifiable, Sendable
{
    var id: Int = 0 // !

    var name: String = ""
    
    var curator: String = ""
    var groupLeader: String = ""
    var departmentName: String = ""
    
    var studentList: [Student] = []
    
    var startYear: Int = 2000       // maybe use Date ?
    var endYear: Int = 2000

}// struct Group: Identifiable


struct Teacher: Identifiable, Sendable
{
    var id: Int = 0

    var lastName: String = ""
    var name: String = ""
    var surname: String = ""
    
    var dateBirth: Date = Date.from(year: 2000, month: 00, day: 01)!
    var contactNumber: String = ""
    var passportNumber: String = ""
    var residenceAddress: String = ""
    
    var staffCategory: [String] = []
    var subjectSpecialization: [String] = []
    
    var profilePhoto: String = "" // realese ONLY on diplome
}// struct Teacher: Identifiable


struct Department: Identifiable, Sendable // cafedra
{
    var id: Int = 0

    var name: String = ""
    
    var description: String = ""
    var academicFocusArea: String = ""
    var leader: String = ""             // departmentLeader
    var viceLeader: String = ""
    
    var teacherList: [Teacher] = []
    var facultyOffice: String = ""      // departament room
    
    var creationYear: Int = 2000
}// struct Department: Identifiable


struct Subject: Identifiable, Sendable
{
    var id: Int = 0
    
    var name: String = ""
    var type: String = ""
    
    var teacherList: [Teacher] = []
    
    var totalHours: Int = 0
    var lectureHours: Int = 0
    var labHours: Int = 0
    var seminarHours: Int = 0
    var independentStudyHours: Int = 0
    var semester: Int = 0
    var semesterControl: String = ""
}// struct Subject: Identifiable


struct Grades: Identifiable, Sendable
{
    var id: Int = 0
    
    var subject: Subject = Subject()
    var recipient: Student = Student()
    var grader: Teacher = Teacher()
    
    var score: Int = 0
    var dateGiven: Date = Date()
    var gradeType: String = ""
    var retakePossible: Bool = false
    var comment: String = ""
} // struct Grades: Identifiable

