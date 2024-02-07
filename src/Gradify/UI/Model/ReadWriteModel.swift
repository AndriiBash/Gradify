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
    static func == (lhs: StudentGroup, rhs: StudentGroup) -> Bool
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
        do
        {
            DispatchQueue.main.async
            {
                self.isLoadingFetchData = true
                self.countRecords = 0
            }
            
            let querySnapshot = try await db.collection("students").getDocuments()
            
            DispatchQueue.main.async
            {
                
                let groupedUsers = Dictionary(grouping: querySnapshot.documents.map
                { queryDocumentSnapshot in
                    let data = queryDocumentSnapshot.data()
                        
                    let id = data["id"] as? Int ?? 0
                    
                    if self.maxIdStudent <= id
                    {
                        self.maxIdStudent = id + 1
                    }
                    
                    let name = data["name"] as? String ?? ""
                    let lastName = data["lastName"] as? String ?? ""
                    let surname = data["surname"] as? String ?? ""
                                        
                    let date: Date = dateFormatter.date(from: (data["dateBirth"] as? String) ?? "") ?? Date.from(year: 2000, month: 12, day: 12)!

                    let contactNumber = data["contactNumber"] as? String ?? "+380 000 000 000"
                    let passportNumber = data["passportNumber"] as? String ?? ""
                    
                    let residenceAddress = data["residenceAddress"] as? String ?? ""

                    let educationProgram = data ["educationProgram"] as? String ?? "Немає програми"
                    let group = data["group"] as? String ?? "Немає групи"
                
                    return Student(id: id, lastName: lastName, name: name, surname: surname, dateBirth: date, contactNumber: contactNumber, passportNumber: passportNumber, residenceAddress: residenceAddress, educationProgram: educationProgram, group: group)
                }, by: { $0.group })

                self.studentGroups = groupedUsers.map
                { group, users in
                    StudentGroup(name: group, students: users)
                }
                
                self.countRecords = self.studentGroups.flatMap { $0.students }.count
            }

            
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
            print("Error fetching data: \(error)")
        }
    }// func fetchStudentData() async

    
    // just example for me
    func addEnrty()
    {
        let object: [String: Any] =
        [ "name" : "macOS test" as NSObject,
          "YouTube" : "yep"
        ]
        
        db.collection("test").addDocument(data: object)
    }
    
    func addNewStudent(name: String, lastName: String, surname: String, dateBirth: String, contactNumber: String, passportNumber: String, residenceAddress: String, educationProgram: String, group: String) -> Bool
    {
        var status: Bool = true
        
        let object: [String: Any] =
        [
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

        db.collection("students").addDocument(data: object)
        { error in
            if error != nil
            {
                status = false
            }
        }

        maxIdStudent += 1
        
        return status
    }// func addNewStudent(name: String, lastName: String, surname: String, dateBirth: String, contactNumber: String, passportNumber: String, residenceAddress: String, group: String) -> Bool
    
    
    func updateStudent(id: Int, name: String, lastName: String, surname: String, dateBirth: String, contactNumber: String, passportNumber: String, residenceAddress: String, educationProgram: String, group: String) -> Bool
    {
        var status = true
        
        let object: [String: Any] =
        [
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

        
        db.collection("students").whereField("id", isEqualTo: id).getDocuments
        {(snapshot, error) in
            
            if error != nil
            {
                print ("Error in update data")
                status = false
                return
            }
            
            guard let documents = snapshot?.documents else
            {
                print("No documents")
                status = false
                return
            }
            
            if documents.count == 1
            {
                let document = documents[0]
                let studentRef = self.db.collection("students").document(document.documentID)
                
                studentRef.updateData(object)
                { updateError in
                    
                    if let updateError = updateError
                    {
                        print("Error updating document : \(updateError)")
                        status = false
                    }
                    else
                    {
                        // Document successfully updated
                        //print("Document successfully updated")
                        status = true
                    }
                }
            }
            else
            {
                print("Error : Multiple documents found for the given ID")
                status = false
            }
        }
            
        return status
    }//     func updateStudent(id: Int, name: String, lastName: String, surname: String, dateBirth: String, contactNumber: String, passportNumber: String, residenceAddress: String, educationProgram: String, group: String) -> Bool
    
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

