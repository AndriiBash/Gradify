//
//  DataObjectModel.swift
//  Gradify
//
//  Created by Андрiй on 26.01.2024.
//

import Foundation


struct Student: Identifiable, Sendable, Equatable, Hashable
{
    var id: Int = 0
    
    var lastName: String = ""
    var name: String = ""
    var surname: String = ""
    
    var dateBirth: Date = Date.from(year: 2000, month: 00, day: 01)!
    var contactNumber: String = ""
    var passportNumber: String = ""
    var residenceAddress: String = ""
    
    var educationProgram: String = ""
    var group: String = ""
}// struct Student: Identifiable


struct Group: Identifiable, Sendable, Equatable, Hashable
{
    var id: Int = 0

    var name: String = ""
    
    var curator: String = ""
    var groupLeader: String = ""
    var departmentName: String = ""
    var educationProgram: String = ""
    
    var studentList: [String] = [] //Student
}// struct Group: Identifiable


struct Teacher: Identifiable, Sendable, Equatable, Hashable
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
    
    var profilePhoto: String = "" // realese ONLY on diploma
}// struct Teacher: Identifiable


struct Department: Identifiable, Sendable, Equatable, Hashable // cafedra
{
    var id: Int = 0

    var name: String = ""
    
    var description: String = ""
    var specialization: String = ""
    
    var departmentLeader: String = ""
    var viceLeader: String = ""
    
    var teacherList: [Teacher] = []
    var facultyOffice: String = ""
    
    var creationYear: Int = 2000
}// struct Department: Identifiable


struct Subject: Identifiable, Sendable, Equatable, Hashable
{
    var id: Int = 0

    var name: String = ""
    var type: String = ""
    
    var teacherList: [Teacher] = []
    
    var departamentSubject: Department = Department() // maybe use string
    
    var totalHours: Int = 0
    var lectureHours: Int = 0
    var labHours: Int = 0
    var seminarHours: Int = 0
    var independentStudyHours: Int = 0
    var semester: Int = 0
    var semesterControl: String = ""
}// struct Subject: Identifiable


struct Grade: Identifiable, Sendable, Equatable, Hashable
{
    var id: Int = 0

    var subject: String = ""
    var recipient: String = ""
    var grader: String = ""
    
    var score: Int = 0
    var dateGiven: Date = Date()
    var gradeType: String = ""
    var retakePossible: Bool = false
    var comment: String = ""
} // struct Grades: Identifiable


struct Faculty: Identifiable, Sendable, Equatable, Hashable
{
    var id: Int = 0
    
    var name: String
    var dean: String // Decan
    
    var description: String
    var departments: [Department] = []
}// struct Faculty: Identifiable, Sendable


struct Specialization: Identifiable, Sendable, Equatable, Hashable
{
    var id: Int = 0

    var name: String = ""
    var description: String = ""
    var field: String
}// struct Specialization: Identifiable, Sendableu


struct Specialty: Identifiable, Sendable, Equatable, Hashable
{
    var id: Int = 0

    var name: String = ""
    var duration: String = ""
    var tuitionCost: Int
    var subjects: [String] = []
    var specialization: String = ""
}// struct Specialty: Identifiable, Sendable


struct EducationalProgram: Identifiable, Sendable, Equatable, Hashable
{
    var id: Int = 0
    
    var name: String = ""
    
    var specializations: [String] = []

    var specialty: String = ""
    var level: String = ""
    var duration: String = ""
    var description: String = ""
}// struct EducationalProgram: Identifiable, Sendable
