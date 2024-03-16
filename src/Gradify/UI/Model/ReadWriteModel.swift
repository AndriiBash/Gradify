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


struct StudentGroupList: Identifiable, Sendable, Hashable
{
    // maybe delete property sendable and related method's
    static func == (lhs: StudentGroupList, rhs: StudentGroupList) -> Bool // need move to async
    {
        return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.students == rhs.students
    }

    func hash(into hasher: inout Hasher)
    {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(students)
    }
    
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



class ReadWriteModel: ObservableObject
{
    @Published var studentList:         [StudentGroupList] = []
    @Published var groupList:           [GroupList] = []
    @Published var specializationList:  [SpecializationList] = []

    
    @Published var specialityList:      [SpecialityList] = []

    
    
    
    @Published var gradeList:         [GradeList] = []
    @Published var subjectList:        [SubjectList] = []

    
    
    
    
    
    @Published var groups               = [Group]()
    @Published var teachers             = [Teacher]()
    @Published var departments          = [Department]()
    @Published var subjects             = [Subject]()
    @Published var grades               = [Grade]()
    @Published var facultys             = [Faculty]()
    @Published var specializations      = [Specialization]()
    @Published var specialtys           = [Specialty]()
    @Published var educationalPrograms  = [EducationalProgram]()
    
    @Published var maxIdRecord:     Int = 0
    @Published var countRecords:    Int = 0
    
    @Published var isLoadingFetchData = false

    private var ref = Database.database().reference()
    private var db = Firestore.firestore()
    
    
    //MARK: - Method's
    
    func getEducatProgramNameList() async -> [String]
    {
        return ["program1", "program2"]
    }// func getEducatProgramNameList() async -> [String]
    
    func getTeacherCategory() async -> [String]
    {
        return ["Спеціаліст", "Спеціаліст другої категорії", "Спеціаліст першої категорії", "Спеціаліст вищої категорії"]
    }// func getTeacherCategory() async -> [String]
    
    func getSubjectType() async -> [String]
    {
        return ["type1", "type2", "type3"]
    }
    
    
    func getSubjectNameList(withOut: String) async -> [String]
    {
        return ["ds","ds"]
    } // func getSubjectNameList(withOut: String) async -> [String]
    
    
    func getSpecialityNameList(withOut: String) async -> [String]
    {
        if specialityList.isEmpty
        {
            await fetchSpecialityData()
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

    
    
    func getSpecializationNameList(withOut: String) async -> [String]
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
            await fetchBigGroupData()
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
            
            await fetchStudentData(updateCountRecod: false)
            
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

    
    func getTeacherList() async -> [String]
    {
        return ["taecher1", "taecher2", "taecher3"]
    }// func getTeacherList() async -> [String]

    
    func getDeprmentList() async -> [String]
    {
        return ["department1", "department2", "department3"]
    }// func getDeprmentList() async -> [String]
    
    
    func getGroupNameList() async -> [String]
    {
        do
        {
            await fetchSmallGroupData()
            
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
    
    
    func getGroupStudent(of nameStudent: String) async -> String
    {
        return "sd"
    }// func getGroupStudent(of nameStudent: String) async -> String

    
    
    func fetchSpecialityData() async
    {
        do
        {
            self.isLoadingFetchData = true
            self.countRecords = 0
            
            let querySnapshot = try await db.collection("speciality").getDocuments()

            let groupedSpeciality = Dictionary(grouping: querySnapshot.documents.map
            { queryDocumentSnapshot in
            
                let data = queryDocumentSnapshot.data()

                let id = data["id"] as? Int ?? -1
                
                if self.maxIdRecord <= id
                {
                    self.maxIdRecord = id + 1
                }
                                
                let name = data["name"] as? String ?? ""
                let duration = data["duration"] as? String ?? ""
                let tuitionCost = data["tuitionCost"] as? Int ?? 0
                let subjects = data["subjects"] as? [String] ?? []
                let specialization = data["specialization"] as? String ?? ""
                
                return Specialty(id: id, name: name, duration: duration, tuitionCost: tuitionCost, subjects: subjects, specialization: specialization)
                
            }, by: { $0.specialization })

            self.specialityList = groupedSpeciality.map
            { name, speciality in
                SpecialityList(name: name, speciality: speciality)
            }

            self.countRecords = self.specialityList.flatMap { $0.speciality }.count

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
                
                if self.maxIdRecord <= id
                {
                    self.maxIdRecord = id + 1
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    func fetchGradeData() async
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
                
                if self.maxIdRecord <= id
                {
                    self.maxIdRecord = id + 1
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
    
    
    
    
    
    func fetchSubjectData() async
    {
        do
        {
            self.isLoadingFetchData = true
            self.countRecords = 0

            let querySnapshot = try await db.collection("subjects").getDocuments()

            var intermediateSubjects: [Subject] = []
            
            for queryDocumentSnapshot in querySnapshot.documents
            {
                let data = queryDocumentSnapshot.data()

                print(data)

                let id = data["id"] as? Int ?? -1
                
                if self.maxIdRecord <= id
                {
                    self.maxIdRecord = id + 1
                }
                                
                let name = data["name"] as? String ?? ""
                let type = data["type"] as? String ?? ""
                
                var teacherList: [String] = []
                
                

                for queryDocumentSnapshot in querySnapshot.documents
                {
                    let data = queryDocumentSnapshot.data()

                    // Отримання списку учителів з даних
                    let teachers = data["teachers"] as? String ?? ""

                    let teacherArray = teachers.split(separator: ",").map { String($0) }
                    
                    teacherList.append(contentsOf: teacherArray)
                }

                print(teacherList)
                
                let departamentSubject = data["departamentSubject"] as? String ?? ""
                
                let totalHours = data["totalHours"] as? Int ?? -1
                let lectureHours = data["lectureHours"] as? Int ?? -1
                let labHours = data["labHours"] as? Int ?? -1
                let seminarHours = data["seminarHours"] as? Int ?? -1
                let independentStudyHours = data["independentStudyHours"] as? Int ?? -1
                let semester = data["semester"] as? Int ?? -1
                let semesterControl = data["semesterControl"] as? String ?? ""

                let subject = Subject(id: id,
                                      name: name,
                                      type: type,
                                      teacherList: teacherList,
                                      departamentSubject: departamentSubject,
                                      totalHours: totalHours,
                                      lectureHours: lectureHours,
                                      labHours: labHours,
                                      seminarHours: seminarHours,
                                      independentStudyHours: independentStudyHours,
                                      semester: semester,
                                      semesterControl: semesterControl)
                
                intermediateSubjects.append(subject)
            }

            let groupedSubjects = Dictionary(grouping: intermediateSubjects, by: { $0.type })

                  // self.gradeList = groupedSubjects.map { (subject, grades) -> GradeList in
                  //     return GradeList(name: subject, grades: grades)
                  // }
            
            self.countRecords = self.subjectList.flatMap { $0.subject }.count

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
    }// func fetchSubjectData() async
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func fetchBigGroupData() async
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
                
                if self.maxIdRecord <= id
                {
                    self.maxIdRecord = id + 1
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

    }// func fetchBigGroupData() async
    
    
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
        
        print(object)
        
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
    

    func fetchSmallGroupData() async
    {
        do
        {
            self.isLoadingFetchData = true
            self.countRecords = 0

            let querySnapshot = try await db.collection("groups").getDocuments()

            let groupedGroups = Dictionary(grouping: querySnapshot.documents.map{ (queryDocumentSnapshot) -> Group in
                let data = queryDocumentSnapshot.data()

                let id = data["id"] as? Int ?? -1
                
                if self.maxIdRecord <= id
                {
                    self.maxIdRecord = id + 1
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
            
            /*
            DispatchQueue.main.async
            {
                withAnimation(Animation.easeOut(duration: 0.5))
                {
                    self.isLoadingFetchData = false
                }
            }
             */
        }
        /*catch let error as NSError
        {
            DispatchQueue.main.async
            {
                print("Error Firestore : \(error.localizedDescription)")
                self.isLoadingFetchData = false
            }
        }
         */
        catch
        {
            DispatchQueue.main.async
            {
                print("Not anotteted error : \(error)")
                self.isLoadingFetchData = false
            }
        }
    }// func fetchStudentData() async

                                           
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
    }//     func addNewStudent(name: String, lastName: String, surname: String, dateBirth: String, contactNumber: String, passportNumber: String, residenceAddress: String, educationProgram: String, group: String) async -> Bool
    
                                           
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
    }// func deleteGrade(withId gradeId: Int) async

    
    
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
    }// func deleteStudent(withId studentId: Int) async {
      
    
    func addNewSpeciality(name: String, duration: String, tuitionCost: Int, specialization: String, subjects: [String]) async -> Bool
    {        
        let object: [String: Any] = [
        "id": maxIdRecord,
        "name": name,
        "duration": duration,
        "tuitionCost": tuitionCost,
        "subjects" : [],
        "specialization": specialization
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
    }// func addNewSpeciality(name: String, duration: String, tuitionCost: Int, specialization: String, subjects: [String]) async -> Bool

    
    
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
}
