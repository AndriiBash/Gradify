//
//  ReadModel.swift
//  Gradify
//
//  Created by Андрiй on 13.01.2024.
//

import Foundation
import FirebaseDatabase
import FirebaseDatabaseInternal
import FirebaseFirestore
import SwiftUI


struct StudentGroupList: Identifiable, Hashable
{
    var id = UUID()
    var name: String
    var students: [Student]
}// struct StudentGroup: Identifiable, Sendable, Hashable


struct GroupList: Identifiable, Hashable
{
    var id = UUID()
    var name: String
    var groups: [Group]
}// struct DepartmentGroup: Identifiable, Hashable


struct GradeList: Identifiable, Hashable
{
    var id = UUID()
    var name: String
    var grades: [Grade]
}// struct GradeList: Identifiable, Hashable


struct SubjectList: Identifiable, Hashable
{
    var id = UUID()
    var name: String
    var subject: [Subject]
}// struct SubjectList: Identifiable, Hashable


struct SpecializationList: Identifiable, Hashable
{
    var id = UUID()
    var name: String
    var specialization: [Specialization]
}// struct SpecializationList: Identifiable, Hashable


struct SpecialityList: Identifiable, Hashable
{
    var id = UUID()
    var name: String
    var speciality: [Specialty]
}// struct SpecialityList: Identifiable, Hashable


struct EducationalProgramList: Identifiable, Hashable
{
    var id = UUID()
    var name: String
    var educationalProgram: [EducationalProgram]
}// struct EducationalProgramList: Identifiable, Hashable


struct FacultyList: Identifiable, Hashable
{
    var id = UUID()
    var name: String
    var faculty: [Faculty]
}// struct FacultyList: Identifiable, Hashable


struct DepartmentList: Identifiable, Hashable
{
    var id = UUID()
    var name: String
    var deparment: [Department]
}// struct DepartmentList: Identifiable, Hashable


struct TeacherList: Identifiable, Hashable
{
    var id = UUID()
    var name: String
    var teacher: [Teacher]
}// struct DepartmentList: Identifiable, Hashable



class ReadWriteModel: ObservableObject
{
    @Published var studentList:                 [StudentGroupList] = []
    @Published var groupList:                   [GroupList] = []
    @Published var specializationList:          [SpecializationList] = []
    @Published var specialityList:              [SpecialityList] = []
    @Published var educationalProgramList:      [EducationalProgramList] = []
    @Published var facultyList:                 [FacultyList] = []
    @Published var departmentList:              [DepartmentList] = []
    @Published var teacherList:                 [TeacherList] = []

    @Published var subjectList:                 [SubjectList] = []
    
    
    
    @Published var gradeList:                   [GradeList] = []

    
    
    // delete this
    @Published var groups                       = [Group]()
    @Published var teachers                     = [Teacher]()
    @Published var departments                  = [Department]()
    @Published var subjects                     = [Subject]()
    @Published var grades                       = [Grade]()
    @Published var facultys                     = [Faculty]()
    @Published var specializations              = [Specialization]()
    @Published var specialtys                   = [Specialty]()
    @Published var educationalPrograms          = [EducationalProgram]()
    
    @Published var maxIdRecord:                 Int = 0
    @Published var countRecords:                Int = 0
    
    @Published var isLoadingFetchData = false

    private var ref = Database.database().reference()
    private var db = Firestore.firestore()
    
    
    //MARK: - Method's
    
    
    func getEducatProgramNameList(withOut: String) async -> [String]
    {
        if educationalProgramList.isEmpty
        {
            await fetchEducationalProgram(updateCountRecod: false)
        }
        
        var educationalProgramListName: [String] = []
        
        for educationProgramList in educationalProgramList
        {
            for educationProgram in educationProgramList.educationalProgram
            {
                if educationProgram.name != withOut
                {
                    educationalProgramListName.append(educationProgram.name)
                }
            }
        }
        
        return educationalProgramListName
    }// func getEducatProgramNameList(withOut: String) async -> [String]
    
    
    func getTeacherCategory() async -> [String]
    {
        return ["Спеціаліст", "Спеціаліст другої категорії", "Спеціаліст першої категорії", "Спеціаліст вищої категорії"]
    }// func getTeacherCategory() async -> [String]
    
    
    func getSubjectType() async -> [String]
    {
        return ["type1", "type2", "type3"]
    }// func getSubjectType() async -> [String]
    
    
    func getSubjectNameList(withOut: String) async -> [String]
    {
        return ["Programming","Math", "Deutch Language"]
    } // func getSubjectNameList(withOut: String) async -> [String]
    
    
    func getBranchName() async -> [String]
    {
        return ["Освіта", "Культура і мистецтво", "Гуманітарні науки", "Богослов’я", "Соціальні та поведінкові науки", "Журналістика", "Управління та адміністрування", "Право", "Біологія", "Природничі науки", "Математика та статистика", "Інформаційні технології", "Механічна інженерія", "Електрична інженерія", "Автоматизація та приладобудування", "Хімічна та біоінженерія", "Електроніка та телекомунікації", "Виробництво та технології", "Архітектура та будівництво", "Аграрні науки та продовольство", "Ветеринарна медицина", "Охорона здоров’я", "Соціальна робота", "Сфера обслуговування", "Воєнні науки, національна безпека, безпека державного кордону", "Цивільна безпека", "Транспорт"]
    }// func getBranchName() async -> [String]
    
    
    func getLevelList() async -> [String]
    {
        return ["Рівень стандарту", "Профільний рівень", "Поглиблений рівень", "Авторський рівень"]
    }// func getLevelList() async -> [String]
    
    
    func getTypeSubjectList() async -> [String]
    {
        return ["Навчальний", "Профільний", "Додатковий"]
    }// func getTypeSubjectList() async -> [String]

    
    func getSemesterControlList() async -> [String]
    {
        return ["Залік", "Екзамен"]
    }// func getSemesterControlList() async -> [String]
    
    
    func getFacultyName(withOut: String) async -> [String]
    {
        if facultyList.isEmpty
        {
            await fetchFacultyData(updateCountRecod: false)
        }
        
        var facultyListName: [String] = []
        
        for facultyList in facultyList
        {
            for faculty in facultyList.faculty
            {
                if faculty.name != withOut
                {
                    facultyListName.append(faculty.name)
                }
            }
        }
        
        return facultyListName
    }// func getFacultyName(withOut: String) async -> [String]

    
    func getSpecialityNameList(withOut: String) async -> [String]
    {
        if specialityList.isEmpty
        {
            await fetchSpecialityData(updateCountRecod: false)
        }
        
        var specialityListName: [String] = []
        
        for specialityList in specialityList
        {
            for specialty in specialityList.speciality
            {
                if specialty.name != withOut
                {
                    specialityListName.append(specialty.name)
                }
            }
        }
        
        return specialityListName
    }// func getSpecialityNameList(withOut: String) async -> [String]

    
    func getSpecializationNameList(branch: String) async -> [String]
    {
        if specializationList.isEmpty
        {
            await fetchSpecializationData(updateCountRecod: false)
        }
        
        var specializationListName: [String] = []
        
        for specializationList in specializationList
        {
            for specialization in specializationList.specialization
            {
                if specialization.field == branch
                {
                    specializationListName.append(specialization.name)
                }
            }
        }
        
        return specializationListName
    }// func getSpecializationNameList(branch: String) async -> [String]
    
    
    func getSpecializationNameList(withOut: String = "") async -> [String]
    {
        if specializationList.isEmpty
        {
            await fetchSpecializationData(updateCountRecod: false)
        }
        
        var specializationListName: [String] = []
        
        for specicializationList in specializationList
        {
            for specialization in specicializationList.specialization
            {
                if specialization.name != withOut
                {
                    specializationListName.append(specialization.name)
                }
            }
        }
        
        return specializationListName
    }// func getSpecializationNameList(withOut: String) async -> [String]
    
    
    func getGroupNameList(withOut: String) async -> [String]
    {
        if groupList.isEmpty
        {
            await fetchBigGroupData(updateCountRecod: false)
        }
        
        var groupListName: [String] = []
        
        for groupArray in groupList
        {
            for group in groupArray.groups
            {
                if group.name != withOut
                {
                    groupListName.append(group.name)
                }
            }
        }
        
        return groupListName
    }// func getGroupNameList(withOut: String) async -> [String]
    
    
    func getStudentList(groupName: String) async -> [String]
    {
        do
        {
            var filteredStudents: [String] = []
            
            if studentList.isEmpty
            {
                await fetchStudentData(updateCountRecod: false)
            }
            
            for group in self.studentList
            {
                for student in group.students
                {
                    if student.group == groupName
                    {
                        filteredStudents.append("\(student.lastName) \(student.name) \(student.surname)")
                    }
                }
            }

            return filteredStudents
        }
        catch
        {
            print("Error fetching student data : \(error)")
            return []
        }
    }// func getStudentList(groupName: String) async -> [String]

    
    func getTeacherList(withDepartment: String) async -> [String]
    {
        do
        {
            var filteredTeachers: [String] = []
            
            if departmentList.isEmpty
            {
                await fetchDepartment(updateCountRecod: false)
            }
            
            for list in self.departmentList
            {
                for department in list.deparment
                {
                    if department.name == withDepartment
                    {
                        filteredTeachers = department.teacherList
                    }
                }
            }

            return filteredTeachers
        }
        catch
        {
            print("Error fetching teacher data : \(error)")
            return []
        }
    }// func getTeacherList(withDepartment: String) async -> [String]
    
    
    func getTeacherList(withOut: String) async -> [String]
    {
        do
        {
            var filteredTeachers: [String] = []
            
            if studentList.isEmpty
            {
                await fetchTeacher(updateCountRecod: false, checkStatusUpdate: false)
            }
            
            for list in self.teacherList
            {
                for teacher in list.teacher
                {
                    if !withOut.contains("\(teacher.lastName) \(teacher.name) \(teacher.surname)")
                    {
                        filteredTeachers.append("\(teacher.lastName) \(teacher.name) \(teacher.surname)")
                    }
                }
            }

            return filteredTeachers
        }
        catch
        {
            print("Error fetching teacher data : \(error)")
            return []
        }
    }// func getTeacherList(withOut: String) async -> [String]

    
    func getDeprmentNameList(withOut: String) async -> [String]
    {
        if departmentList.isEmpty
        {
            await fetchDepartment(updateCountRecod: false, checkStatusUpdate: false)
        }
        
        var departmentListName: [String] = []
        
        for departmentList in departmentList
        {
            for department in departmentList.deparment
            {
                if department.name != withOut
                {
                    departmentListName.append(department.name)
                }
            }
        }
        
        return departmentListName
    }// func getDeprmentNameList(withOut: String) async -> [String]
    
    
    func getGroupNameList() async -> [String]
    {
        do
        {
            await fetchSmallGroupData(updateCountRecod: false)
            
            var groupNameList: [String] = []
            
            for list in self.groupList
            {
                for groups in list.groups
                {
                    groupNameList.append("\(groups.name)")
                }
            }
            
            return groupNameList
        }
        catch
        {
            print("Error fetching group data : \(error)")
            return []
        }
    }// func getGroupName() async -> [String]
    
    
    // MARK: - maybe delete
    func getGroupStudent(of nameStudent: String) async -> String
    {
        return "sd"
    }// func getGroupStudent(of nameStudent: String) async -> String


    func fetchDepartment(updateCountRecod: Bool, checkStatusUpdate: Bool = true) async
    {
        do
        {
            if checkStatusUpdate
            {
                self.isLoadingFetchData = true
            }
            
            if updateCountRecod
            {
                self.countRecords = 0
            }
            
            let querySnapshot = try await db.collection("departments").getDocuments()

            let groupedDepartments = Dictionary(grouping: querySnapshot.documents.map
            { queryDocumentSnapshot in
            
                let data = queryDocumentSnapshot.data()

                let id = data["id"] as? Int ?? -1
                
                if updateCountRecod
                {
                    if self.maxIdRecord <= id
                    {
                        self.maxIdRecord = id + 1
                    }
                }
                
                let name = data["name"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let specialization = data["specialization"] as? String ?? ""
                
                let departmentLeader = data["departmentLeader"] as? String ?? ""
                let viceLeader = data["viceLeader"] as? String ?? ""

                let teacherList = data["teacherList"] as? [String] ?? []
                let departmentOffice = data["departmentOffice"] as? String ?? ""

                let creationYear = data["creationYear"] as? Int ?? 2000
                
                return Department(id: id, name: name, description: description ,specialization: specialization, departmentLeader: departmentLeader, viceLeader: viceLeader, teacherList: teacherList, departmentOffice: departmentOffice, creationYear: creationYear)
            }, by: { $0.specialization })

            self.departmentList = groupedDepartments.map
            { name, department in
                DepartmentList(name: name, deparment: department)
            }

            if updateCountRecod
            {
                self.countRecords = self.departmentList.flatMap { $0.deparment }.count
            }

            if checkStatusUpdate
            {
                withAnimation(Animation.easeOut(duration: 0.5))
                {
                    self.isLoadingFetchData = false
                }
            }
        }
        catch
        {
            DispatchQueue.main.async
            {
                print("Not anotteted error : \(error)")
                
                if checkStatusUpdate
                {
                    self.isLoadingFetchData = false
                }
            }
        }
    }// func fetchDepartment(updateCountRecod: Bool) async
    
    
    func fetchTeacher(updateCountRecod: Bool, checkStatusUpdate: Bool = true) async
    {
        do
        {
            if checkStatusUpdate
            {
                self.isLoadingFetchData = true
            }
            
            if updateCountRecod
            {
                self.countRecords = 0
            }
            
            let querySnapshot = try await db.collection("teachers").getDocuments()

            let groupedTeachers = Dictionary(grouping: querySnapshot.documents.map
                                             { queryDocumentSnapshot in
                
                let data = queryDocumentSnapshot.data()
                
                let id = data["id"] as? Int ?? -1
                
                if updateCountRecod
                {
                    if self.maxIdRecord <= id
                    {
                        self.maxIdRecord = id + 1
                    }
                }
                                
                let name = data["name"] as? String ?? ""
                let lastName = data["lastName"] as? String ?? ""
                let surname = data["surname"] as? String ?? ""
                
                let date: Date = dateFormatter.date(from: (data["dateBirth"] as? String) ?? "") ?? Date.from(year: 2000, month: 12, day: 12)!
                
                let contactNumber = data["contactNumber"] as? String ?? "+380 000 000 000"
                let passportNumber = data["passportNumber"] as? String ?? ""
                let residenceAddress = data["residenceAddress"] as? String ?? ""
                
                let category = data["category"] as? String ?? "Немає категорії"
                let specialization = data["specializations"] as? [String] ?? []

                //code for loading photo
                /*
                    var profilePhoto: String = "" // realese ONLY on diploma
                 */

                return Teacher(id: id, lastName: lastName, name: name, surname: surname, dateBirth: date, contactNumber: contactNumber, passportNumber: passportNumber, residenceAddress: residenceAddress, category: category, specialization: specialization)
            }, by: { $0.category })

            self.teacherList = groupedTeachers.map
            { name, teachers in
                TeacherList(name: name, teacher: teachers)
            }

            if updateCountRecod
            {
                self.countRecords = self.teacherList.flatMap { $0.teacher }.count
            }

            if checkStatusUpdate
            {
                withAnimation(Animation.easeOut(duration: 0.5))
                {
                    self.isLoadingFetchData = false
                }
            }
        }
        catch
        {
            DispatchQueue.main.async
            {
                print("Not anotteted error : \(error)")
                
                if checkStatusUpdate
                {
                    self.isLoadingFetchData = false
                }
            }
        }
    }// func fetchTeacher(updateCountRecod: Bool) async
    
    
    func fetchEducationalProgram(updateCountRecod: Bool) async
    {
        do
        {
            self.isLoadingFetchData = true
            
            if updateCountRecod
            {
                self.countRecords = 0
            }
            
            let querySnapshot = try await db.collection("educationalPrograms").getDocuments()

            let groupedEducationalPrograms = Dictionary(grouping: querySnapshot.documents.map
            { queryDocumentSnapshot in
            
                let data = queryDocumentSnapshot.data()

                let id = data["id"] as? Int ?? -1
                
                if updateCountRecod
                {
                    if self.maxIdRecord <= id
                    {
                        self.maxIdRecord = id + 1
                    }
                }
                
                let name = data["name"] as? String ?? ""
                let specialty = data["specialty"] as? String ?? ""
                let level = data["level"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let duration = data["duration"] as? String ?? ""

                let specializations = data["specializations"] as? [String] ?? []
                
                return EducationalProgram(id: id, name: name, specializations: specializations, specialty: specialty, level: level, duration: duration, description: description)
                
            }, by: { $0.specialty })

            self.educationalProgramList = groupedEducationalPrograms.map
            { name, educationProgram in
                EducationalProgramList(name: name, educationalProgram: educationProgram)
            }

            if updateCountRecod
            {
                self.countRecords = self.educationalProgramList.flatMap { $0.educationalProgram }.count
            }

            withAnimation(Animation.easeOut(duration: 0.5))
            {
                self.isLoadingFetchData = false
            }
        }
        catch
        {
            DispatchQueue.main.async
            {
                print("Not anotteted error : \(error)")
                self.isLoadingFetchData = false
            }
        }
    }// func fetchEducationalProgram(updateCountRecod: Bool) async

    
    func fetchSpecialityData(updateCountRecod: Bool) async
    {
        do
        {
            self.isLoadingFetchData = true
            
            if updateCountRecod
            {
                self.countRecords = 0
            }
            
            let querySnapshot = try await db.collection("speciality").getDocuments()

            let groupedSpeciality = Dictionary(grouping: querySnapshot.documents.map
            { queryDocumentSnapshot in
            
                let data = queryDocumentSnapshot.data()

                let id = data["id"] as? Int ?? -1
                
                if updateCountRecod
                {
                    if self.maxIdRecord <= id
                    {
                        self.maxIdRecord = id + 1
                    }
                }
                                
                let name = data["name"] as? String ?? ""
                let duration = data["duration"] as? String ?? ""
                let tuitionCost = data["tuitionCost"] as? Int ?? 0
                let subjects = data["subjects"] as? [String] ?? []
                let specialization = data["specialization"] as? String ?? ""
                let branch = data["branch"] as? String ?? ""

                return Specialty(id: id, name: name, duration: duration, tuitionCost: tuitionCost, subjects: subjects, branch: branch, specialization: specialization)
                
            }, by: { $0.branch })

            self.specialityList = groupedSpeciality.map
            { name, speciality in
                SpecialityList(name: name, speciality: speciality)
            }

            if updateCountRecod
            {
                self.countRecords = self.specialityList.flatMap { $0.speciality }.count
            }

            withAnimation(Animation.easeOut(duration: 0.5))
            {
                self.isLoadingFetchData = false
            }
        }
        catch
        {
            DispatchQueue.main.async
            {
                print("Not anotteted error : \(error)")
                self.isLoadingFetchData = false
            }
        }
    }// func fetchSpecialityData() async
    
    
    func fetchFacultyData(updateCountRecod: Bool) async
    {
        do
        {
            self.isLoadingFetchData = true
            
            if updateCountRecod
            {
                self.countRecords = 0
            }

            let querySnapshot = try await db.collection("faculty").getDocuments()

            let groupedFaculty = Dictionary(grouping: querySnapshot.documents.map
            { queryDocumentSnapshot in
            
                let data = queryDocumentSnapshot.data()

                let id = data["id"] as? Int ?? -1
                
                if updateCountRecod
                {
                    if self.maxIdRecord <= id
                    {
                        self.maxIdRecord = id + 1
                    }
                }
                
                let name = data["name"] as? String ?? ""
                let dean = data["dean"] as? String ?? ""
                let description = data["description"] as? String ?? ""

                let specialiazation = data["specialiazation"] as? [String] ?? []
                let departments = data["departments"] as? [String] ?? []


                return Faculty(id: id, name: name, dean: dean, description: description, specialiazation: specialiazation, departments: departments)
            }, by: { $0.dean })

            self.facultyList = groupedFaculty.map
            { name, faculty in
                FacultyList(name: name, faculty: faculty)
            }

            if updateCountRecod
            {
                self.countRecords = self.facultyList.flatMap { $0.faculty }.count
            }

            withAnimation(Animation.easeOut(duration: 0.5))
            {
                self.isLoadingFetchData = false
            }
        }
        catch
        {
            DispatchQueue.main.async
            {
                print("Not anotteted error : \(error)")
                self.isLoadingFetchData = false
            }
        }
    }// func fetchFacultynData(updateCountRecod: Bool) async
    
    
    func fetchSpecializationData(updateCountRecod: Bool) async
    {
        do
        {
            self.isLoadingFetchData = true
            
            if updateCountRecod
            {
                self.countRecords = 0
            }

            let querySnapshot = try await db.collection("specializations").getDocuments()

            let groupedSpecialization = Dictionary(grouping: querySnapshot.documents.map
            { queryDocumentSnapshot in
            
                let data = queryDocumentSnapshot.data()

                let id = data["id"] as? Int ?? -1
                
                if updateCountRecod
                {
                    if self.maxIdRecord <= id
                    {
                        self.maxIdRecord = id + 1
                    }
                }

                let name = data["name"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let field = data["field"] as? String ?? ""

                return Specialization(id: id, name: name, description: description, field: field)
            }, by: { $0.field })

            self.specializationList = groupedSpecialization.map
            { name, specialization in
                SpecializationList(name: name, specialization: specialization)
            }

            if updateCountRecod
            {
                self.countRecords = self.specializationList.flatMap { $0.specialization }.count
            }

            withAnimation(Animation.easeOut(duration: 0.5))
            {
                self.isLoadingFetchData = false
            }
        }
        catch
        {
            DispatchQueue.main.async
            {
                print("Not anotteted error : \(error)")
                self.isLoadingFetchData = false
            }
        }
    }// func fetchStudentData() async
    
    
    func fetchGradeData(updateCountRecod: Bool) async
    {
        do
        {
            self.isLoadingFetchData = true
            self.countRecords = 0

            let querySnapshot = try await db.collection("grades").getDocuments()

            var intermediateGrades: [Grade] = []

            for queryDocumentSnapshot in querySnapshot.documents
            {
                let data = queryDocumentSnapshot.data()

                let id = data["id"] as? Int ?? -1
                
                if updateCountRecod
                {
                    if self.maxIdRecord <= id
                    {
                        self.maxIdRecord = id + 1
                    }
                }

                let subject = data["subject"] as? String ?? ""
                let recipient = data["recipient"] as? String ?? ""
                let grader = data["grader"] as? String ?? ""
                
                let score = data["score"] as? Int ?? -1
                let dateGiven: Date = dateFormatter.date(from: (data["dateGiven"] as? String) ?? "") ?? Date.from(year: 2000, month: 12, day: 12)!
                let gradeType = data["gradeType"] as? String ?? ""
                let retakePossible = data["retakePossible"] as? Bool ?? false
                let comment = data["comment"] as? String ?? ""
                                
                let grade = Grade(
                    id: id,
                    subject: subject,
                    recipient: recipient,
                    grader: grader,
                    score: score,
                    dateGiven: dateGiven,
                    gradeType: gradeType,
                    retakePossible: retakePossible,
                    comment: comment)

                intermediateGrades.append(grade)
            }

            let groupedGrades = Dictionary(grouping: intermediateGrades, by: { $0.subject })

                   self.gradeList = groupedGrades.map { (subject, grades) -> GradeList in
                       return GradeList(name: subject, grades: grades)
                   }
            
            self.countRecords = self.gradeList.flatMap { $0.grades }.count

            DispatchQueue.main.async
            {
                withAnimation(Animation.easeOut(duration: 0.5))
                {
                    self.isLoadingFetchData = false
                }
            }
        }
        catch
        {
            DispatchQueue.main.async
            {
                print("Error fetching data : \(error)")
                self.isLoadingFetchData = false
            }
        }
    }// func fetchGradeData() async
    
    
    func fetchSubjectData(updateCountRecod: Bool) async
    {
        do
        {
            self.isLoadingFetchData = true
            
            if updateCountRecod
            {
                self.countRecords = 0
            }
            
            let querySnapshot = try await db.collection("subjects").getDocuments()

            let groupedSubject = Dictionary(grouping: querySnapshot.documents.map
            { queryDocumentSnapshot in
                
                let data = queryDocumentSnapshot.data()
                
                let id = data["id"] as? Int ?? -1
                
                if updateCountRecod
                {
                    if self.maxIdRecord <= id
                    {
                        self.maxIdRecord = id + 1
                    }
                }
                                
                let name = data["name"] as? String ?? ""
                let type = data["type"] as? String ?? ""
                let departamentSubject = data["departamentSubject"] as? String ?? ""

                let teacherList = data["teacherList"] as? [String] ?? []
                
                let totalHours = data["totalHours"] as? Int ?? 0
                let lectureHours = data["lectureHours"] as? Int ?? 0
                let labHours = data["labHours"] as? Int ?? 0
                let seminarHours = data["seminarHours"] as? Int ?? 0
                let independentStudyHours = data["independentStudyHours"] as? Int ?? 0
                
                let semester = data["semester"] as? String ?? ""
                let semesterControl = data["semesterControl"] as? String ?? ""

                
                return Subject(id: id, name: name, type: type, teacherList: teacherList, departamentSubject: departamentSubject, totalHours: totalHours, lectureHours: lectureHours, labHours: labHours, seminarHours: seminarHours, independentStudyHours: independentStudyHours, semester: semester, semesterControl: semesterControl)
            }, by: { $0.type })

            self.subjectList = groupedSubject.map
            { name, subject in
                SubjectList(name: name, subject: subject)
            }

            if updateCountRecod
            {
                self.countRecords = self.subjectList.flatMap { $0.subject }.count
            }

            withAnimation(Animation.easeOut(duration: 0.5))
            {
                self.isLoadingFetchData = false
            }
        }
        catch
        {
            DispatchQueue.main.async
            {
                print("Not anotteted error : \(error)")
                self.isLoadingFetchData = false
            }
        }

    }// func fetchSubjectData() async
    

    func fetchBigGroupData(updateCountRecod: Bool) async
    {
        do
        {
            self.isLoadingFetchData = true
            self.countRecords = 0

            let querySnapshot = try await db.collection("groups").getDocuments()

            var intermediateGroups: [Group] = []

            for queryDocumentSnapshot in querySnapshot.documents
            {
                let data = queryDocumentSnapshot.data()
                
                let id = data["id"] as? Int ?? -1
                
                if updateCountRecod
                {
                    if self.maxIdRecord <= id
                    {
                        self.maxIdRecord = id + 1
                    }
                }

                let name = data["name"] as? String ?? ""
                let curator = data["curator"] as? String ?? ""
                let groupLeader = data["groupLeader"] as? String ?? ""
                let departmentName = data["departmentName"] as? String ?? ""
                let educationProgram = data["educationProgram"] as? String ?? ""
                
                let studentList = await getStudentList(groupName: name)
                
                let group = Group(
                    id: id,
                    name: name,
                    curator: curator,
                    groupLeader: groupLeader,
                    departmentName: departmentName,
                    educationProgram: educationProgram,
                    studentList: studentList
                )

                intermediateGroups.append(group)
            }

            let groupedGroups = Dictionary(grouping: intermediateGroups, by: { $0.departmentName })

            self.groupList = groupedGroups.map { (department, groups) -> GroupList in
                return GroupList(name: department, groups: groups)
            }

            self.countRecords = self.groupList.flatMap { $0.groups }.count

            withAnimation(Animation.easeOut(duration: 0.5))
            {
                self.isLoadingFetchData = false
            }
        }
        catch
        {
            DispatchQueue.main.async
            {
                print("Error fetching data : \(error)")
                self.isLoadingFetchData = false
            }
        }

    }// func fetchBigGroupData() async
    
    
    func updateSpeciality(id: Int, name: String, duration: String, tuitionCost: Int, specialization: String, branch: String, subjects: [String]) async -> Bool
    {
        let object: [String: Any] = [
        "id": maxIdRecord,
        "name": name,
        "duration": duration,
        "tuitionCost": tuitionCost,
        "subjects" : subjects,
        "specialization": specialization,
        "branch": branch
        ]
                        
        do
        {
            let snapshot = try await db.collection("speciality").whereField("id", isEqualTo: id).getDocuments()
            
            guard let document = snapshot.documents.first else
            {
                print("No documents or multiple documents found")
                return false
            }
            
            try await db.collection("speciality").document(document.documentID).updateData(object)
            return true
        }
        catch
        {
            print("Error in update data: \(error)")
            return false
        }

    }// func updateSpeciality(id: Int, name: String, duration: String, tuitionCost: Int, specialization: String, branch: String, subjects: [String]) async -> Bool

    
    func updateDepartment(id: Int, name: String, description: String, specialization: String, departmentLeader: String, viceLeader: String, teacherList: [String], departmentOffice: String, creationYear: Int) async -> Bool
    {
        let object: [String: Any] = [
        "id": id,
        "name": name,
        "description": description,
        "specialization": specialization,
        "departmentLeader": departmentLeader,
        "viceLeader" : viceLeader,
        "teacherList": teacherList,
        "departmentOffice": departmentOffice,
        "creationYear": creationYear
        ]

        do
        {
            let snapshot = try await db.collection("departments").whereField("id", isEqualTo: id).getDocuments()
            
            guard let document = snapshot.documents.first else
            {
                print("No documents or multiple documents found")
                return false
            }
            
            try await db.collection("departments").document(document.documentID).updateData(object)
            return true
        }
        catch
        {
            print("Error in update data: \(error)")
            return false
        }

    }// func updateDepartment(id: Int, name: String, description: String, specialization: String, departmentLeader: String, viceLeader: String, teacherList: [String], departmentOffice: String, creationYear: Int) async -> Bool
    
    
    func updateSubject(id: Int, name: String, type: String, teacherList: [String], departamentSubject: String, totalHours: Int, lectureHours: Int, labHours: Int, seminarHours: Int, independentStudyHours: Int, semester: String, semesterControl: String) async -> Bool
    {
        let object: [String: Any] = [
        "id": id,
        "name": name,
        "type": type,
        "teacherList": teacherList,
        "departamentSubject": departamentSubject,
        "totalHours" : totalHours,
        "lectureHours": lectureHours,
        "labHours": labHours,
        "seminarHours": seminarHours,
        "independentStudyHours": independentStudyHours,
        "semester": semester,
        "semesterControl": semesterControl,
        ]
        

        do
        {
            let snapshot = try await db.collection("subjects").whereField("id", isEqualTo: id).getDocuments()
            
            guard let document = snapshot.documents.first else
            {
                print("No documents or multiple documents found")
                return false
            }
            
            try await db.collection("subjects").document(document.documentID).updateData(object)
            return true
        }
        catch
        {
            print("Error in update data: \(error)")
            return false
        }

    }// func updateSubject(id: Int, name: String, type: String, teacherList: [String], departamentSubject: String, totalHours: Int, lectureHours: Int, labHours: Int, seminarHours: Int, independentStudyHours: Int, semester: String, semesterControl: String) async -> Bool
    
        
    func updateFaculty(id: Int, name: String, dean: String, description: String, deparments: [String], specialization: [String]) async -> Bool
    {
        let object: [String: Any] = [
        "id": maxIdRecord,
        "name": name,
        "dean": dean,
        "description": description,
        "specialiazation": specialization,
        "departments" : deparments
        ]

        do
        {
            let snapshot = try await db.collection("faculty").whereField("id", isEqualTo: id).getDocuments()
            
            guard let document = snapshot.documents.first else
            {
                print("No documents or multiple documents found")
                return false
            }
            
            try await db.collection("faculty").document(document.documentID).updateData(object)
            return true
        }
        catch
        {
            print("Error in update data: \(error)")
            return false
        }

    }// func updateFaculty(id: Int, name: String, dean: String, description: String, deparments: [String], specialization: [String]) async -> Bool

    
    func updateGroup(id: Int, name: String, curator: String, leaderGroup: String, department: String, educationProgram: String) async -> Bool
    {
        let object: [String: Any] = [
        "id": id,
        "name": name,
        "curator": curator,
        "departmentName": department,
        "educationProgram": educationProgram,
        "groupLeader": leaderGroup
    ]
        
        do
        {
            let snapshot = try await db.collection("groups").whereField("id", isEqualTo: id).getDocuments()
            
            guard let document = snapshot.documents.first else
            {
                print("No documents or multiple documents found")
                return false
            }
            
            try await db.collection("groups").document(document.documentID).updateData(object)
            return true
        }
        catch
        {
            print("Error in update data: \(error)")
            return false
        }
    }// func updateGroup(id: Int, name: String, curator: String, leaderGroup: String, department: String, educationProgram: String) async -> Bool
    
    
    func updateSpecialization(id: Int, name: String, description: String, field: String) async -> Bool
    {
        let object: [String: Any] = [
        "id": id,
        "name": name,
        "description": description,
        "field": field
        ]
                
        do
        {
            let snapshot = try await db.collection("specializations").whereField("id", isEqualTo: id).getDocuments()
            
            guard let document = snapshot.documents.first else
            {
                print("No documents or multiple documents found")
                return false
            }
            
            try await db.collection("specializations").document(document.documentID).updateData(object)
            return true
        }
        catch
        {
            print("Error in update data: \(error)")
            return false
        }
    }// func updateSpecialization(id: Int, name: String, description: String, field: String) async -> Bool
    

    func fetchSmallGroupData(updateCountRecod: Bool) async
    {
        do
        {
            self.isLoadingFetchData = true
            self.countRecords = 0

            let querySnapshot = try await db.collection("groups").getDocuments()

            let groupedGroups = Dictionary(grouping: querySnapshot.documents.map{ (queryDocumentSnapshot) -> Group in
                let data = queryDocumentSnapshot.data()

                let id = data["id"] as? Int ?? -1
                
                if updateCountRecod
                {
                    if self.maxIdRecord <= id
                    {
                        self.maxIdRecord = id + 1
                    }
                }

                let name = data["name"] as? String ?? ""
                let curator = data["curator"] as? String ?? ""
                let groupLeader = data["groupLeader"] as? String ?? ""
                let departmentName = data["departmentName"] as? String ?? ""
                let educationProgram = data["educationProgram"] as? String ?? ""
                                
                return Group(
                    id: id,
                    name: name,
                    curator: curator,
                    groupLeader: groupLeader,
                    departmentName: departmentName,
                    educationProgram: educationProgram,
                    studentList: []
                )
            }, by: { $0.departmentName })

            self.groupList = groupedGroups.map
            { (department, groups) -> GroupList in
                return GroupList(name: department, groups: groups)
            }

            self.countRecords = self.groupList.flatMap { $0.groups }.count
            
            DispatchQueue.main.async
            {
                withAnimation(Animation.easeOut(duration: 0.5))
                {
                    self.isLoadingFetchData = false
                }
            }
        }
        catch let error as NSError
        {
            DispatchQueue.main.async
            {
                print("Error Firestore : \(error.localizedDescription)")
                self.isLoadingFetchData = false
            }
        }
        catch
        {
            DispatchQueue.main.async
            {
                print("Error fetching data : \(error)")
                self.isLoadingFetchData = false
            }
        }
    }// func fetchGroupData() async


    func fetchStudentData(updateCountRecod: Bool) async
    {
        do
        {
            self.isLoadingFetchData = true
            
            if updateCountRecod
            {
                self.countRecords = 0
            }

            let querySnapshot = try await db.collection("students").getDocuments()

            let groupedUsers = Dictionary(grouping: querySnapshot.documents.map
            { queryDocumentSnapshot in
            
                let data = queryDocumentSnapshot.data()

                let id = data["id"] as? Int ?? -1
                if self.maxIdRecord <= id
                {
                    self.maxIdRecord = id + 1
                }

                let name = data["name"] as? String ?? ""
                let lastName = data["lastName"] as? String ?? ""
                let surname = data["surname"] as? String ?? ""
                let date: Date = dateFormatter.date(from: (data["dateBirth"] as? String) ?? "") ?? Date.from(year: 2000, month: 12, day: 12)!
                let contactNumber = data["contactNumber"] as? String ?? "+380 000 000 000"
                let passportNumber = data["passportNumber"] as? String ?? ""
                let residenceAddress = data["residenceAddress"] as? String ?? ""
                let educationProgram = data["educationProgram"] as? String ?? "Немає програми"
                let group = data["group"] as? String ?? "Немає групи"

                return Student(id: id, lastName: lastName, name: name, surname: surname, dateBirth: date, contactNumber: contactNumber, passportNumber: passportNumber, residenceAddress: residenceAddress, educationProgram: educationProgram, group: group)
            }, by: { $0.group })

            self.studentList = groupedUsers.map
            { group, users in
                StudentGroupList(name: group, students: users)
            }

            if updateCountRecod
            {
                self.countRecords = self.studentList.flatMap { $0.students }.count
            }
            
            withAnimation(Animation.easeOut(duration: 0.5))
            {
                self.isLoadingFetchData = false
            }
        }
        catch
        {
            DispatchQueue.main.async
            {
                print("Not anotteted error : \(error)")
                self.isLoadingFetchData = false
            }
        }
    }// func fetchStudentData() async

                      
    func addNewEducationProgram(name: String, level: String, duration: String, description: String, specialty: String, specializations: [String]) async -> Bool
    {
        let object: [String: Any] = [
        "id": maxIdRecord,
        "name": name,
        "specialty": specialty,
        "level": level,
        "duration": duration,
        "description": description,
        "specializations" : specializations
        ]
        
        do
        {
            try await db.collection("educationalPrograms").addDocument(data: object)
            self.maxIdRecord += 1
            return true
        }
        catch
        {
            return false
        }
    }// func addNewEducationProgram(name: String, level: String, duration: String, description: String, specialty: String, specializations: [String]) async -> Bool

    
    func addNewGroup(name: String, curator: String, leaderGroup: String, department: String, educationProgram: String) async -> Bool
    {
        let object: [String: Any] = [
        "id": maxIdRecord,
        "name": name,
        "curator": curator,
        "departmentName": department,
        "educationProgram": educationProgram,
        "groupLeader": leaderGroup
        ]
        
        do
        {
            try await db.collection("groups").addDocument(data: object)
            self.maxIdRecord += 1
            return true
        }
        catch
        {
            return false
        }
    }// func addNewGroup(name: String, curator: String, leaderGroup: String, department: String, educationProgram: String) async -> Bool

    func updateEducationProgram(id: Int, name: String, level: String, duration: String, description: String, specialty: String, specializations: [String]) async -> Bool
    {
        let object: [String: Any] = [
        "id": maxIdRecord,
        "name": name,
        "specialty": specialty,
        "level": level,
        "duration": duration,
        "description": description,
        "specializations" : specializations
        ]

        do
        {
            let snapshot = try await db.collection("educationalPrograms").whereField("id", isEqualTo: id).getDocuments()
            
            guard let document = snapshot.documents.first else
            {
                print("No documents or multiple documents found")
                return false
            }
            
            try await db.collection("educationalPrograms").document(document.documentID).updateData(object)
            return true
        }
        catch
        {
            print("Error in update data: \(error)")
            return false
        }

    }// func updateEducationProgram(id: Int, name: String, level: String, duration: String, description: String, specialty: String, specializations: [String]) async -> Bool

    
    
    func addNewStudent(name: String, lastName: String, surname: String, dateBirth: String, contactNumber: String, passportNumber: String, residenceAddress: String, educationProgram: String, group: String) async -> Bool
    {
        let object: [String: Any] = [
            "id": maxIdRecord,
            "name": name,
            "lastName": lastName,
            "surname": surname,
            "dateBirth": dateBirth,
            "contactNumber": contactNumber,
            "passportNumber": passportNumber,
            "residenceAddress": residenceAddress,
            "educationProgram": educationProgram,
            "group": group
        ]
        
        do
        {
            try await db.collection("students").addDocument(data: object)
            self.maxIdRecord += 1
            return true
        }
        catch
        {
            return false
        }
    }// func addNewStudent(name: String, lastName: String, surname: String, dateBirth: String, contactNumber: String, passportNumber: String, residenceAddress: String, educationProgram: String, group: String) async -> Bool
    
                                           
    func updateStudent(id: Int, name: String, lastName: String, surname: String, dateBirth: String, contactNumber: String, passportNumber: String, residenceAddress: String, educationProgram: String, group: String) async -> Bool
    {    let object: [String: Any] = [
        "id": id,
        "name": name,
        "lastName": lastName,
        "surname": surname,
        "dateBirth": dateBirth,
        "contactNumber": contactNumber,
        "passportNumber": passportNumber,
        "residenceAddress": residenceAddress,
        "educationProgram": educationProgram,
        "group": group
    ]
        
        do
        {
            let snapshot = try await db.collection("students").whereField("id", isEqualTo: id).getDocuments(
            )
            guard let document = snapshot.documents.first else
            {
                print("No documents or multiple documents found")
                return false
            }
            
            try await db.collection("students").document(document.documentID).updateData(object)
            return true
        } catch
        {
            print("Error in update data: \(error)")
            return false
        }
    }// func updateStudent(id: Int, name: String, lastName: String, surname: String, dateBirth: String, contactNumber: String, passportNumber: String, residenceAddress: String, educationProgram: String, group: String) async -> Bool

                
    func addNewTeacher(name: String, lastName: String, surname: String, dateBirth: String, contactNumber: String, passportNumber: String, residenceAddress: String, category: String, specialization: [String]) async -> Bool
    {
        let object: [String: Any] = [
            "id": maxIdRecord,
            "name": name,
            "lastName": lastName,
            "surname": surname,
            "dateBirth": dateBirth,
            "contactNumber": contactNumber,
            "passportNumber": passportNumber,
            "residenceAddress": residenceAddress,
            "specializations": specialization,
            "category": category
        ]
        
        do
        {
            try await db.collection("teachers").addDocument(data: object)
            self.maxIdRecord += 1
            return true
        }
        catch
        {
            return false
        }
    }// func addNewTeacher(name: String, lastName: String, surname: String, dateBirth: String, contactNumber: String, passportNumber: String, residenceAddress: String, category: String, specialization: [String]) async -> Bool
    
    
    func updateTeacher(id: Int, name: String, lastName: String, surname: String, dateBirth: String, contactNumber: String, passportNumber: String, residenceAddress: String, category: String, specialization: [String]) async -> Bool
    {    let object: [String: Any] = [
        "id": id,
        "name": name,
        "lastName": lastName,
        "surname": surname,
        "dateBirth": dateBirth,
        "contactNumber": contactNumber,
        "passportNumber": passportNumber,
        "residenceAddress": residenceAddress,
        "specializations": specialization,
        "category": category
    ]
        
        do
        {
            let snapshot = try await db.collection("teachers").whereField("id", isEqualTo: id).getDocuments(
            )
            guard let document = snapshot.documents.first else
            {
                print("No documents or multiple documents found")
                return false
            }
            
            try await db.collection("teachers").document(document.documentID).updateData(object)
            return true
        } catch
        {
            print("Error in update data: \(error)")
            return false
        }
    }// func updateStudent(id: Int, name: String, lastName: String, surname: String, dateBirth: String, contactNumber: String, passportNumber: String, residenceAddress: String, educationProgram: String, group: String) async -> Bool

    
    
    
    func deleteGrade(withId gradeId: Int) async
    {
        do
        {
            let snapshot = try await db.collection("grades").whereField("id", isEqualTo: gradeId).getDocuments()
            
            if snapshot.documents.isEmpty
            {
                print("No documents found")
                return
            }
            
            for document in snapshot.documents
            {
                do
                {
                    try await document.reference.delete()
                }
                catch
                {
                    print("Error in delete grade: \(error.localizedDescription)")
                }
            }
        }
        catch
        {
            print("Error in get data: \(error.localizedDescription)")
        }
    }// func deleteGrade(withId gradeId: Int) async

    
    func deleteEducationProgram(withId educationProgramId: Int) async
    {
        do
        {
            let snapshot = try await db.collection("educationalPrograms").whereField("id", isEqualTo: educationProgramId).getDocuments()
            
            if snapshot.documents.isEmpty
            {
                print("No documents found")
                return
            }
            
            for document in snapshot.documents
            {
                do
                {
                    try await document.reference.delete()
                }
                catch
                {
                    print("Error in delete education program: \(error.localizedDescription)")
                }
            }
        }
        catch
        {
            print("Error in get data: \(error.localizedDescription)")
        }
    }// func deleteEducationProgram(withId educationProgramId: Int) async
    
    
    func deleteSpeciality(withId specialityId: Int) async
    {
        do
        {
            let snapshot = try await db.collection("speciality").whereField("id", isEqualTo: specialityId).getDocuments()
            
            if snapshot.documents.isEmpty
            {
                print("No documents found")
                return
            }
            
            for document in snapshot.documents
            {
                do
                {
                    try await document.reference.delete()
                }
                catch
                {
                    print("Error in delete specialty: \(error.localizedDescription)")
                }
            }
        }
        catch
        {
            print("Error in get data: \(error.localizedDescription)")
        }
    }// func deleteSpeciality(withId specialityId: Int) async

    
    func deleteStudent(withId studentId: Int) async
    {
        do
        {
            let snapshot = try await db.collection("students").whereField("id", isEqualTo: studentId).getDocuments()
            
            if snapshot.documents.isEmpty
            {
                print("No documents found")
                return
            }
            
            for document in snapshot.documents
            {
                do
                {
                    try await document.reference.delete()
                }
                catch
                {
                    print("Error in delete student: \(error.localizedDescription)")
                }
            }
        }
        catch
        {
            print("Error in get data: \(error.localizedDescription)")
        }
    }// func deleteStudent(withId studentId: Int) async
      
    
    func deleteTeacher(withId teacherID: Int) async
    {
        do
        {
            let snapshot = try await db.collection("teachers").whereField("id", isEqualTo: teacherID).getDocuments()
            
            if snapshot.documents.isEmpty
            {
                print("No documents found")
                return
            }
            
            for document in snapshot.documents
            {
                do
                {
                    try await document.reference.delete()
                }
                catch
                {
                    print("Error in delete teacher: \(error.localizedDescription)")
                }
            }
        }
        catch
        {
            print("Error in get data: \(error.localizedDescription)")
        }
    }// func deleteTeacher(withId teacherID: Int) async
    
    
    func deleteSubject(withId subjectID: Int) async
    {
        do
        {
            let snapshot = try await db.collection("subjects").whereField("id", isEqualTo: subjectID).getDocuments()
            
            if snapshot.documents.isEmpty
            {
                print("No documents found")
                return
            }
            
            for document in snapshot.documents
            {
                do
                {
                    try await document.reference.delete()
                }
                catch
                {
                    print("Error in delete subject: \(error.localizedDescription)")
                }
            }
        }
        catch
        {
            print("Error in get data: \(error.localizedDescription)")
        }
    }// func deleteSubject(withId subjectID: Int) async
    
    
    func addNewFaculty(name: String, dean: String, description: String, deparments: [String], specialization: [String]) async -> Bool
    {
        let object: [String: Any] = [
        "id": maxIdRecord,
        "name": name,
        "dean": dean,
        "description": description,
        "specialiazation": specialization,
        "departments" : deparments
        ]
        
        do
        {
            try await db.collection("faculty").addDocument(data: object)
            self.maxIdRecord += 1
            return true
        }
        catch
        {
            return false
        }
    }// func addNewFaculty(name: String, dean: String, description: String, deparments: [String], specialization: [String]) async -> Bool
    
    func addNewSubject(name: String, type: String, teacherList: [String], departamentSubject: String, totalHours: Int, lectureHours: Int, labHours: Int, seminarHours: Int, independentStudyHours: Int, semester: String, semesterControl: String) async -> Bool
    {
        let object: [String: Any] = [
        "id": maxIdRecord,
        "name": name,
        "type": type,
        "teacherList": teacherList,
        "departamentSubject": departamentSubject,
        "totalHours" : totalHours,
        "lectureHours": lectureHours,
        "labHours": labHours,
        "seminarHours": seminarHours,
        "independentStudyHours": independentStudyHours,
        "semester": semester,
        "semesterControl": semesterControl,
        ]
        
        do
        {
            try await db.collection("subjects").addDocument(data: object)
            self.maxIdRecord += 1
            return true
        }
        catch
        {
            return false
        }
    }// func addNewSubject(name: String, type: String, teacherList: [String], departamentSubject: String, totalHours: Int, lectureHours: Int, labHours: Int, seminarHours: Int, independentStudyHours: Int, semester: String, semesterControl: String) async -> Bool
    
    
    func addNewDepartment(name: String, description: String, specialization: String, departmentLeader: String, viceLeader: String, teacherList: [String], departmentOffice: String, creationYear: Int) async -> Bool
    {
        let object: [String: Any] = [
        "id": maxIdRecord,
        "name": name,
        "description": description,
        "specialization": specialization,
        "departmentLeader": departmentLeader,
        "viceLeader" : viceLeader,
        "teacherList": teacherList,
        "departmentOffice": departmentOffice,
        "creationYear": creationYear
        ]
        
        do
        {
            try await db.collection("departments").addDocument(data: object)
            self.maxIdRecord += 1
            return true
        }
        catch
        {
            return false
        }
    }// func addNewDepartment(name: String, description: String, specialization: String, departmentLeader: String, viceLeader: String, teacherList: [String], departmentOffice: String, creationYear: Int) async -> Bool
    
    
    func addNewSpeciality(name: String, duration: String, tuitionCost: Int, specialization: String, branch: String, subjects: [String]) async -> Bool
    {
        let object: [String: Any] = [
        "id": maxIdRecord,
        "name": name,
        "duration": duration,
        "tuitionCost": tuitionCost,
        "subjects" : subjects,
        "specialization": specialization,
        "branch": branch
        ]
        
        do
        {
            try await db.collection("speciality").addDocument(data: object)
            self.maxIdRecord += 1
            return true
        }
        catch
        {
            return false
        }
    }// func addNewSpeciality(name: String, duration: String, tuitionCost: Int, specialization: String, branch: String, subjects: [String]) async -> Bool

    
    func addNewSpecialization(name: String, description: String, field: String) async -> Bool
    {
        let object: [String: Any] = [
        "id": maxIdRecord,
        "name": name,
        "description": description,
        "field": field
        ]
        
        do
        {
            try await db.collection("specializations").addDocument(data: object)
            self.maxIdRecord += 1
            return true
        }
        catch
        {
            return false
        }
    }// func addNewSpecialization(name: String, description: String, field: String) async -> Bool

    
    func deleteSpecialization(withId specializationId: Int) async
    {
        do
        {
            let snapshot = try await db.collection("specializations").whereField("id", isEqualTo: specializationId).getDocuments()
            
            if snapshot.documents.isEmpty
            {
                print("No documents found")
                return
            }
            
            for document in snapshot.documents
            {
                do
                {
                    try await document.reference.delete()
                }
                catch
                {
                    print("Error in delete specialization: \(error.localizedDescription)")
                }
            }
        }
        catch
        {
            print("Error in get data: \(error.localizedDescription)")
        }
    }// func deleteSpecialization(withId specializationId: Int) async

    
    func deleteDepartment(withId departmentId: Int) async
    {
        do
        {
            let snapshot = try await db.collection("departments").whereField("id", isEqualTo: departmentId).getDocuments()
            
            if snapshot.documents.isEmpty
            {
                print("No documents found")
                return
            }
            
            for document in snapshot.documents
            {
                do
                {
                    try await document.reference.delete()
                }
                catch
                {
                    print("Error in delete department : \(error.localizedDescription)")
                }
            }
        }
        catch
        {
            print("Error in get data : \(error.localizedDescription)")
        }
    }// func deleteDepartment(withId departmentId: Int) async
    
    
    func deleteFaculty(withId specializationId: Int) async
    {
        do
        {
            let snapshot = try await db.collection("faculty").whereField("id", isEqualTo: specializationId).getDocuments()
            
            if snapshot.documents.isEmpty
            {
                print("No documents found")
                return
            }
            
            for document in snapshot.documents
            {
                do
                {
                    try await document.reference.delete()
                }
                catch
                {
                    print("Error in delete faculty: \(error.localizedDescription)")
                }
            }
        }
        catch
        {
            print("Error in get data: \(error.localizedDescription)")
        }
    }// func deleteFaculty(withId specializationId: Int) async
    
                                           
    func deleteGroup(withId groupId: Int) async
    {
        do
        {
            let snapshot = try await db.collection("groups").whereField("id", isEqualTo: groupId).getDocuments()
            
            if snapshot.documents.isEmpty
            {
                print("No documents found")
                return
            }
            
            for document in snapshot.documents
            {
                do
                {
                    try await document.reference.delete()
                }
                catch
                {
                    print("Error in delete group: \(error.localizedDescription)")
                }
            }
        }
        catch
        {
            print("Error in get data: \(error.localizedDescription)")
        }
    }// func deleteGroup(withId groupId: Int) async

                                           
    func matchesSearch(student: Student, searchString: String) -> Bool
    {
        return student.name.lowercased().contains(searchString.lowercased()) ||
               student.lastName.lowercased().contains(searchString.lowercased()) ||
               student.surname.lowercased().contains(searchString.lowercased()) ||
               student.contactNumber.lowercased().contains(searchString.lowercased()) ||
               student.passportNumber.lowercased().contains(searchString.lowercased()) ||
               student.residenceAddress.lowercased().contains(searchString.lowercased()) ||
               student.educationProgram.lowercased().contains(searchString.lowercased()) ||
               student.group.lowercased().contains(searchString.lowercased())
    }// private func matchesSearch(_ student: Student) -> Bool

                                           
    func matchesSearch(group: Group, searchString: String) -> Bool
    {
        return group.name.lowercased().contains(searchString.lowercased()) ||
               group.curator.lowercased().contains(searchString.lowercased()) ||
               group.groupLeader.lowercased().contains(searchString.lowercased()) ||
               group.departmentName.lowercased().contains(searchString.lowercased()) ||
               group.educationProgram.lowercased().contains(searchString.lowercased())
    }// func matchesSearch(group: Group, searchString: String) -> Bool
    
    
    func matchesSearch(department: Department, searchString: String) -> Bool
    {
        return department.name.lowercased().contains(searchString.lowercased()) ||
               department.departmentLeader.lowercased().contains(searchString.lowercased()) ||
               department.description.lowercased().contains(searchString.lowercased()) ||
               department.specialization.lowercased().contains(searchString.lowercased()) ||
               department.teacherList.contains { $0.lowercased().contains(searchString.lowercased()) } ||
               department.departmentOffice.lowercased().contains(searchString.lowercased())
    }// func matchesSearch(department: Department, searchString: String) -> Bool

    
    func matchesSearch(faculty: Faculty, searchString: String) -> Bool
    {
        return faculty.name.lowercased().contains(searchString.lowercased()) ||
               faculty.dean.lowercased().contains(searchString.lowercased()) ||
               faculty.description.lowercased().contains(searchString.lowercased()) ||
               faculty.specialiazation.contains { $0.lowercased().contains(searchString.lowercased()) } ||
               faculty.departments.contains { $0.lowercased().contains(searchString.lowercased()) }
    }// func matchesSearch(faculty: Faculty, searchString: String) -> Bool
    
    
    func matchesSearch(specialization: Specialization, searchString: String) -> Bool
    {
        return specialization.name.lowercased().contains(searchString.lowercased()) ||
               specialization.description.lowercased().contains(searchString.lowercased()) ||
               specialization.field.lowercased().contains(searchString.lowercased())
    }// func matchesSearch(specialization: Specialization, searchString: String) -> Bool
 
    
    func matchesSearch(specialty: Specialty, searchString: String) -> Bool
    {
        return specialty.name.lowercased().contains(searchString.lowercased()) ||
               specialty.duration.lowercased().contains(searchString.lowercased()) ||
               String(specialty.tuitionCost).contains(searchString) ||
               specialty.subjects.contains { $0.lowercased().contains(searchString.lowercased()) } ||
               specialty.specialization.lowercased().contains(searchString.lowercased())
    }// func matchesSearch(specialty: Specialty, searchString: String) -> Bool

    
    func matchesSearch(educationalProgram: EducationalProgram, searchString: String) -> Bool
    {
        return educationalProgram.name.lowercased().contains(searchString.lowercased()) ||
               educationalProgram.specialty.lowercased().contains(searchString.lowercased()) ||
               educationalProgram.level.lowercased().contains(searchString.lowercased()) ||
               educationalProgram.duration.lowercased().contains(searchString.lowercased()) ||
               educationalProgram.description.lowercased().contains(searchString.lowercased()) ||
               educationalProgram.specializations.contains { $0.lowercased().contains(searchString.lowercased()) }
    }// func matchesSearch(educationalProgram: EducationalProgram, searchString: String) -> Bool

    
    func matchesSearch(grade: Grade, searchString: String) -> Bool
    {
        return grade.subject.lowercased().contains(searchString.lowercased()) ||
               grade.recipient.lowercased().contains(searchString.lowercased()) ||
               grade.grader.lowercased().contains(searchString.lowercased()) ||
               String(grade.score).contains(searchString) ||  // move to string for ==
               grade.dateGiven.description.lowercased().contains(searchString.lowercased()) ||
               grade.gradeType.lowercased().contains(searchString.lowercased()) ||
               String(grade.retakePossible).lowercased().contains(searchString.lowercased()) ||  // move to string for ==
               grade.comment.lowercased().contains(searchString.lowercased())
    }// func matchesSearch(grade: Grade, searchString: String) -> Bool
    
    
    func matchesSearch(teacher: Teacher, searchString: String) -> Bool
    {
        return teacher.lastName.lowercased().contains(searchString.lowercased()) ||
               teacher.name.lowercased().contains(searchString.lowercased()) ||
               teacher.surname.lowercased().contains(searchString.lowercased()) ||
               teacher.contactNumber.lowercased().contains(searchString.lowercased()) ||
               teacher.passportNumber.lowercased().contains(searchString.lowercased()) ||
               teacher.residenceAddress.lowercased().contains(searchString.lowercased()) ||
               teacher.category.lowercased().contains(searchString.lowercased()) ||
               teacher.specialization.contains { $0.lowercased().contains(searchString.lowercased()) }
    }// func matchesSearch(teacher: Teacher, searchString: String) -> Bool
    
    
    func matchesSearch(subject: Subject, searchString: String) -> Bool
    {
        return subject.name.lowercased().contains(searchString.lowercased()) ||
               subject.type.lowercased().contains(searchString.lowercased()) ||
               subject.teacherList.contains { $0.lowercased().contains(searchString.lowercased()) } ||
               subject.departamentSubject.lowercased().contains(searchString.lowercased()) ||
               "\(subject.totalHours)".contains(searchString) ||
               "\(subject.lectureHours)".contains(searchString) ||
               "\(subject.labHours)".contains(searchString) ||
               "\(subject.seminarHours)".contains(searchString) ||
               "\(subject.independentStudyHours)".contains(searchString) ||
               subject.semester.lowercased().contains(searchString.lowercased()) ||
               subject.semesterControl.lowercased().contains(searchString.lowercased())
    }// func matchesSearch(teacher: Teacher, searchString: String) -> Bool

}
