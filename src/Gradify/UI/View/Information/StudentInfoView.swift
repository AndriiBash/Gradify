//
//  GroupInfoView.swift
//  Gradify
//
//  Created by Андрiй on 01.02.2024.
//

import SwiftUI

struct StudentInfoView: View
{
    @StateObject private var readModel = ReadModel()
    
    @State private var isExpandAllList: Bool = true
   // @State private var selectedGroup: StudentGroup? // long proccess make function...

    var body: some View
    {
        ZStack
        {
            BlurBehindWindow()
                .ignoresSafeArea()
            
            ScrollView
            {                
                VStack(spacing: 0)
                {
                    ForEach($readModel.studentGroups)
                    { $group in
                        StudentListView(studentList: $group, isExpandList: $isExpandAllList)
                    }//  ForEach stundet's grouping on group
                }// VStack with list group student's
                .padding(.vertical)
                .onAppear
                {
                    Task
                    {
                        await readModel.fetchData()
                    }// need add wait view (monitor)
                }
                
            }// Main ScrollView
        }// main ZStack
        .navigationTitle("Студенти")
        .navigationSubtitle("\(readModel.countRecords) студентів")
        .toolbar
        {
            Button(action: {})
            {
                Text("TestButton")
                Image(systemName: "visionpro")
            }
            .help("what does this button!!")
            
            Button
            {
                isExpandAllList.toggle()
            }
            label:
            {
                Image(systemName: isExpandAllList ? "chevron.down.circle" : "chevron.right.circle")
            }// expand all list card in some view
            .help(isExpandAllList ? "Згорнути усі списки" : "Розгорнути усі списки")

        }//.toolBar for main ZStack
    }// body
}// struct GroupInfoView: View

#Preview
{
    StudentInfoView()
}
