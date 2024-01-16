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
    
    var db = Firestore.firestore()
    
    
    func fetchData()
    {
        db.collection("listUsers").addSnapshotListener
        { (querySnapshot, error) in
            
            
            guard let document = querySnapshot?.documents else
            {
                print("noDoc")
                return
            }
            
            self.users = document.map
            { (queryDocumentSnapshot) -> User in
                let data = queryDocumentSnapshot.data ()
                
                let id = data["id"] as? Int ?? 12
                let name = data["name"] as? String ?? ""
                let surname = data["lastName"] as? String ?? ""
                
                print(data)
                
                return User(_id: id, name: name, lastName: surname)
            }
            
        
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
