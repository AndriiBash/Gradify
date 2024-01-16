//
//  TestView.swift
//  Gradify
//
//  Created by Андрiй on 13.01.2024.
//

import SwiftUI
import FirebaseAuth

struct TestView: View
{
    @ObservedObject private var readModel = ReadModel()

    var body: some View
    {
        ScrollView
        {
            VStack
            {
                Section
                {
                    Text("test")
                    
                    
                    ForEach(readModel.users)
                    { user in
                        
                        VStack(alignment: .leading)
                        {
                            Text(user.name).font(.title)
                            Text(user.lastName).font(.subheadline)
                        }
                    }
                    
                }
                
                Button
                {
                    readModel.fetchData()
                }
                label:
                {
                    Text("Get data")
                        .padding(.vertical)
                }
                
                
                
            }// main VStack
        }// main ScrollView
    }
}

#Preview
{
    TestView()
}
