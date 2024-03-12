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





class ReadWriteModel: ObservableObject
{
    @Published var studentGroups:       [StudentGroupList] = []
    @Published var groupList:           [GroupList] = []

    
    @Published var students             = [Student]()
    @Published var groups               = [Group]()
    @Published var teachers             = [Teacher]()
    @Published var departments          = [Department]()
    @Published var subjects             = [Subject]()
    @Published var grades               = [Grades]()
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
    
    func getGroupNameList() async -> [String]
    {
        do
        {
            await fetchGroupData()
            
            return self.groupList.map { $0.name }
        }
        catch
        {
            print("Error fetching group data: \(error)")
            return []
        }
    }// func getGroupName() async -> [String]
    
    func fetchGroupData() async
    {
        do
        {
            self.isLoadingFetchData = true
            self.countRecords = 0

            let querySnapshot = try await db.collection("groups").getDocuments()

            let groupedGroups = Dictionary(grouping: querySnapshot.documents.map{ (queryDocumentSnapshot) -> Group in
                let data = queryDocumentSnapshot.data()

                let id = data["id"] as? Int ?? -1
                if self.maxIdRecord <= id {
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


    
    
    
    
    
    
    
    
    
    
    
    
    func fetchStudentData() async
    {
        do
        {
            self.isLoadingFetchData = true
            self.countRecords = 0

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

            self.studentGroups = groupedUsers.map
            { group, users in
                StudentGroupList(name: group, students: users)
            }

            self.countRecords = self.studentGroups.flatMap { $0.students }.count

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
                print("Not anotteted error : \(error)")
                self.isLoadingFetchData = false
            }
        }
    }// func fetchStudentData() async

        
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
                    print("Error in delete student: \(error.localizedDescription)")
                }
            }
        }
        catch
        {
            print("Error in get data: \(error.localizedDescription)")
        }
    }// func deleteStudent(withId studentId: Int) async {

    
    
    
    
    
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
    }// func matchesSearch(group: Group, searchString: String) -> Bool {

}

