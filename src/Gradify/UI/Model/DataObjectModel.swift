//
//  DataObjectModel.swift
//  Gradify
//
//  Created by Андрiй on 26.01.2024.
//

import Foundation


struct Student: Identifiable
{
    var id: String = UUID().uuidString // maybe to fix for all struct data object
    
    var lastName: String = ""
    var name: String = ""
    var surname: String = ""
    
    var dateBirth: Date = Date()
    var contactNumber: String = "" // or can use "mobileNumber" ¯\_(ツ)_/¯
    var passportNumber: String = ""
    var residenceAddress: String = ""
    
    var group: String = ""
}// struct Student: Identifiable


struct Group: Identifiable
{
    var id: String = UUID().uuidString // !

    var name: String = ""
    
    var curator: String = ""
    var groupLeader: String = ""
    var departmentName: String = ""
    
    var studentList: [Student] = []
    
    var startYear: Int = 2000       // maybe use Data ?
    var endYear: Int = 2000

}// struct Group: Identifiable


struct Teacher: Identifiable
{
    var id: String = UUID().uuidString

    var lastName: String = ""
    var name: String = ""
    var surname: String = ""
    
    var dateBirth: Date = Date()
    var contactNumber: String = ""
    var passportNumber: String = ""
    var residenceAddress: String = ""
    
    var staffCategory: [String] = []
    var subjectSpecialization: [String] = []
    
    var profilePhoto: String = "" // realese ONLY on diplome
}// struct Teacher: Identifiable


struct Department: Identifiable // cafedra
{
    var id: String = UUID().uuidString

    var name: String = ""
    
    var description: String = ""
    var academicFocusArea: String = ""
    var leader: String = ""             // departmentLeader
    var viceLeader: String = ""
    
    var teacherList: [Teacher] = []
    var facultyOffice: String = ""      // departament room
    
    var creationYear: Int = 2000
}// struct Department: Identifiable


struct Subject: Identifiable
{
    var id: String = UUID().uuidString
    
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


struct Grades: Identifiable
{
    var id: String = UUID().uuidString
    
    var subject: Subject = Subject()
    var recipient: Student = Student()
    var grader: Teacher = Teacher()
    
    var score: Int = 0
    var dateGiven: Date = Date()
    var gradeType: String = ""
    var retakePossible: Bool = false
    var comment: String = ""
} // struct Grades: Identifiable

