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

class ReadModel: ObservableObject
{
    var ref = Database.database().reference()
    
    @Published var valueFromInternet: String?
    @Published var users = [User]()
    @Published var fetchDataStatus = false
    
    var db = Firestore.firestore()
    
    
   
        
        
    func fetchData() async
    {
        do
        {
            DispatchQueue.main.async
            {
                self.fetchDataStatus = false
            }
            
            let querySnapshot = try await db.collection("listUsers").getDocuments()
            
            DispatchQueue.main.async
            {
                self.users = querySnapshot.documents.map { queryDocumentSnapshot in
                    let data = queryDocumentSnapshot.data()
                    let id = data["id"] as? Int ?? 12
                    let name = data["name"] as? String ?? ""
                    let surname = data["lastName"] as? String ?? ""
                    return User(_id: id, name: name, lastName: surname)
                }
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


/// need add in firebase

struct User: Identifiable
{
    var id: String = UUID().uuidString
    var _id: Int
    var name: String
    var lastName: String
}
