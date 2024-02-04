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


struct StudentGroup: Identifiable, Sendable
{
    var id = UUID()
    var name: String
    var students: [Student]
}

class ReadWriteModel: ObservableObject
{
    @Published var studentGroups: [StudentGroup] = []
    @Published var students = [Student]()

    @Published var maxIdStudent: Int = 0
    
   // @Published var studentGroups: [StudentGroup] = []
    
    @Published var valueFromInternet: String?
    
    
    @Published var fetchDataStatus = false
    
    @Published var countRecords: Int = 0
    
    
    var ref = Database.database().reference()
    var db = Firestore.firestore()
        
    func fetchStudentData() async
    {
        do
        {
            DispatchQueue.main.async
            {
                self.fetchDataStatus = false
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
                    

                    let date: Date
                    
                    if let dateBirthTimestamp = data["dateBirth"] as? TimeInterval
                    {
                        date = Date(timeIntervalSince1970: dateBirthTimestamp)
                    }
                    else
                    {
                        date = Date.from(year: 2000, month: 1, day: 1)!
                    }
                    
                    let contactNumber = data["contactNumber"] as? String ?? "+380 000 000 000"
                    let passportNumber = data["passportNumber"] as? String ?? ""
                    
                    let residenceAddress = data["residenceAddress"] as? String ?? ""

                    let group = data["group"] as? String ?? "Немає групи"

                    return Student(id: id, lastName: lastName, name: name, surname: surname, dateBirth: date, contactNumber: contactNumber, passportNumber: passportNumber, residenceAddress: residenceAddress, group: group)
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
                    self.fetchDataStatus = true
                }
            }
        }
        catch
        {
            print("Error fetching data: \(error)")
        }
    }

    
    // just example for me
    func addEnrty()
    {
        let object: [String: Any] =
        [ "name" : "macOS test" as NSObject,
          "YouTube" : "yep"
        ]
        
        db.collection("test").addDocument(data: object)
        
        //ref.child("test").setValue(object)
    }
    
    
    
    func addNewStudent(name: String, lastName: String, surname: String, dateBirth: String, contactNumber: String, passportNumber: String, residenceAddress: String, group: String) -> Bool
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
            "group": group
        ]

        db.collection("students").addDocument(data: object)
        { error in
            if let error = error
            {
                status = false
            }
        }

        maxIdStudent += 1
        
        return status
    }// func addNewStudent(name: String, lastName: String, surname: String, dateBirth: String, contactNumber: String, passportNumber: String, residenceAddress: String, group: String) -> Bool

    
    
    func readValue()
    {
        ref.child("test").observeSingleEvent(of: .value, with: 
        { snapshot in
            
            guard let value = snapshot.value as? [String: Any]
            else
            {
                return
            }
            
            self.valueFromInternet = value["name"] as? String ?? "noGet"
            
            print(value["name"] ?? "nil")
            print("myValue : " + (self.valueFromInternet ?? ""))
        })
    }// func readValue()
}

