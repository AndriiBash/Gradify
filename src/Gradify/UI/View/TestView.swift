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
    @State private var scaleLevel: Int = 0

    var body: some View
    {
        ZStack
        {
            BlurBehindWindow().ignoresSafeArea()
            
            ScrollView
            {
                Button
                {
                    Task
                    {
                        do
                        {
                            await readModel.fetchData()
                        }
                    }// Task
                }
                label:
                {
                    Text("Get data")
                        .padding(.vertical)
                }
                .padding(.vertical)
                
                VStack
                {
                    Section
                    {
                        ForEach(readModel.users.indices, id: \.self)
                        { index in
                            VStack(alignment: .leading)
                            {
                                textViewRow(name: readModel.users[index].name, lastName: readModel.users[index].lastName)
                                    .scaleEffect(readModel.fetchDataStatus ? 1 : 0)
                                //.animation(.easeInOut(duration: 0.5)) don't use, use only withAnimat{}
                            }
                            .transition(.opacity)
                        }
                        
                    }// Section with data
                    .padding(.vertical, 6)
            
                }// main VStack
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }// main ScrollView
            .background(Color("BackgroundLeftLoginView").opacity(0.35))
        }// main ZStack
        .navigationTitle("testName")
        
    }
}


struct textViewRow: View {
    var name: String
    var lastName: String
    
    var body: some View {
        VStack {
            Text("\(name)")
                .font(.title)
            Text("\(lastName)")
                .font(.subheadline)
        }
        .foregroundColor(Color.white)
        .padding()
        .frame(maxWidth: 290, maxHeight: 230)
        .background(Color.black.opacity(0.4))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    LinearGradient(gradient: Gradient(colors: [Color.red.opacity(0.7), Color.blue.opacity(0.7)]), startPoint: .topLeading, endPoint: .bottomTrailing),
                    lineWidth: 2
                )
        )
        .cornerRadius(12)
        .shadow(radius: 12)
    }
}



#Preview
{
    TestView()
}
