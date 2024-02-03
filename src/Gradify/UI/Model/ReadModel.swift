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
    var students: [User]
}


/// need add in firebase
struct User: Identifiable, Sendable
{
    var id: String = UUID().uuidString
    var _id: Int
    var name: String
    var lastName: String
    var group: String
}


class ReadModel: ObservableObject
{
    var ref = Database.database().reference()
    
    @Published var studentGroups: [StudentGroup] = []

   // @Published var studentGroups: [StudentGroup] = []
    
    @Published var valueFromInternet: String?
    @Published var users = [User]()
    @Published var fetchDataStatus = false
    
    @Published var countRecords: Int = 0
    
    var db = Firestore.firestore()
        
    func fetchData() async
    {

        do
        {
            DispatchQueue.main.async
            {
                self.fetchDataStatus = false
                self.countRecords = 0
            }
            
            let querySnapshot = try await db.collection("listUsers").getDocuments()
            
            DispatchQueue.main.async
            {
                
                let groupedUsers = Dictionary(grouping: querySnapshot.documents.map { queryDocumentSnapshot in
                    let data = queryDocumentSnapshot.data()
                    let id = data["id"] as? Int ?? 12
                    let name = data["name"] as? String ?? ""
                    let surname = data["lastName"] as? String ?? ""
                    let group = data["group"] as? String ?? "Немає групи"
                    
                    return User(_id: id, name: name, lastName: surname, group: group)
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

    
    
    func addEnrty()
    {
        let object: [String: Any] =
        [ "name" : "macOS test" as NSObject,
          "YouTube" : "yep"
        ]
        
        ref.child("test").setValue(object)
    }
    
    
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

