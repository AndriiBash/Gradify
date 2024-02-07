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


struct StudentGroup: Identifiable, Sendable, Hashable
{
    static func == (lhs: StudentGroup, rhs: StudentGroup) -> Bool // maybe delte async
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
}

class ReadWriteModel: ObservableObject
{
    @Published var studentGroups: [StudentGroup] = []
    @Published var students = [Student]()

    @Published var maxIdStudent: Int = 0
    @Published var countRecords: Int = 0
    
    @Published var isLoadingFetchData = false

    private var ref = Database.database().reference()
    private var db = Firestore.firestore()

    
    func getEducatProgramNameList() async -> [String]
    {
        return ["program1", "program2"]
    }// func getEducatProgramNameList() async -> [String]
    
    
    
    func getGroupNameList() async -> [String]
    {
        return ["Group 1", "group1", "group2", "IPZ-19"]
    }// func getGroupName() async -> [String]
    
        

    func fetchStudentData() async
    {
        do {
            DispatchQueue.main.async
            {
                self.isLoadingFetchData = true
                self.countRecords = 0
            }
            
            let querySnapshot = try await db.collection("students").getDocuments()
            
            let groupedUsers = Dictionary(grouping: querySnapshot.documents.map
                                          {queryDocumentSnapshot in
                let data = queryDocumentSnapshot.data()
                
                let id = data["id"] as? Int ?? -1
                if self.maxIdStudent <= id
                {
                    DispatchQueue.main.async
                    {
                        self.maxIdStudent = id + 1
                    }
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
            
            DispatchQueue.main.async
            {
                self.studentGroups = groupedUsers.map
                { group, users in
                    StudentGroup(name: group, students: users)
                }
                
                self.countRecords = self.studentGroups.flatMap { $0.students }.count
                
                // Выключаем индикатор загрузки после обновления данных
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
                print("Error fetching data: \(error)")
                self.isLoadingFetchData = false
            }
        }
    }// func fetchStudentData() async
    
    

    
    func addNewStudent(name: String, lastName: String, surname: String, dateBirth: String, contactNumber: String, passportNumber: String, residenceAddress: String, educationProgram: String, group: String) async -> Bool
    {
        let object: [String: Any] = [
            "id": maxIdStudent,
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
            maxIdStudent += 1
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
        do {
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
    

    func deleteStudent(withId studentId: Int)
    {
        db.collection("students").whereField("id", isEqualTo: studentId).getDocuments
        { (snapshot, error) in
            if let error = error {
                print("Error in get data : \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents
            else
            {
                print("No doc")
                return
            }

            for document in documents
            {
                document.reference.delete
                { error in
                    if let error = error
                    {
                        print("error in delete student: \(error.localizedDescription)")
                    }
                    else
                    {
                        // good it's work!
                    }
                }
            }
            
        }
    }// func deleteStudent(withId studentId: Int)

}

