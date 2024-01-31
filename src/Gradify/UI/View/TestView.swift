//
//  TestView.swift
//  Gradify
//
//  Created by Андрiй on 13.01.2024.
//

import SwiftUI

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
                        
                        //LazyHGrid(rows: [GridItem(.flexible())], spacing: 4) {}

                        //ScrollView(.horizontal)
                        ScrollView(.horizontal, showsIndicators: false)
                        {
                            LazyHGrid(rows: [GridItem(.flexible())], spacing: 6)
                            {
                                ForEach(readModel.users.indices, id: \.self)
                                { index in
                                    textViewRow(name: readModel.users[index].name, lastName: readModel.users[index].lastName)
                                        .scaleEffect(readModel.fetchDataStatus ? 1 : 0)
                                        .padding(4)
                                        .transition(.opacity)
                                }
                            }// LazyHGrid
                            .padding()
                        }//scrollvIEW
                        
                    }// Section with data
                    .navigationTitle("NavigationNameTestRow")
                    //.padding(.vertical, 6)
            
                }// main VStack
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }// main ScrollView
            //.background(Color("BackgroundLeftLoginView").opacity(0.35))
        }// main ZStack
        .navigationTitle("testName")
        
    }
}


struct textViewRow: View
{
    var name: String
    var lastName: String
    
    var body: some View
    {
        VStack
        {
            Spacer()
         
            Text("\(name)")
                .font(.title)
            Text("\(lastName)")
                .font(.subheadline)
            
            Spacer()
            
            VStack
            {
                Text("Test text in bottom")
            }
            .padding(.vertical, 6)
            .frame(maxWidth: .infinity)
            .background(Color.green)
            .cornerRadius (10, corners: [.bottomRight, .bottomLeft])
            .clipped()
        }
        .foregroundColor(Color.white)
        .frame(width: 250, height: 150)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.thinMaterial)
                .shadow(radius: 8)
        )
        .padding()
    }
}



#Preview
{
    TestView()
}


