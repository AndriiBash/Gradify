//
//  GroupInfoView.swift
//  Gradify
//
//  Created by Андрiй on 01.02.2024.
//

import SwiftUI

struct StudentInfoView: View
{
    @StateObject private var readModel = ReadWriteModel()
    
    @State private var isExpandAllList: Bool = false
    @State private var isShowAddStudentPanel: Bool = false
    @State private var statusSave: Bool = false
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
                    ForEach($readModel.studentGroups.indices, id:\.self)
                    { index in
                        StudentListView(studentList: $readModel.studentGroups[index], isExpandList: $isExpandAllList)
                    }//  ForEach stundet's grouping on group
                    .padding(.top, 4)
                }// VStack with list group student's
                .padding(.vertical)
                .onAppear
                {
                    Task
                    {
                        await readModel.fetchStudentData()
                    }// need add wait view (monitor)
                }
                
            }// Main ScrollView
        }// main ZStack
        .navigationTitle("Студенти")
        .navigationSubtitle("\(readModel.countRecords) студентів")
        .sheet(isPresented: $isShowAddStudentPanel)
        {
            AddStudentView(isShowForm: $isShowAddStudentPanel, statusSave: $statusSave, writeModel: readModel)
        }
        .sheet(isPresented: $statusSave)
        {
            if statusSave
            {
                SuccessSaveView(isAnimated: $statusSave)
                    .onAppear
                    {
                        Task
                        {
                            await readModel.fetchStudentData()
                        }// need add wait view (monitor)
                    }
            }
            else
            {
                ErrorSaveView(isAnimated: $statusSave)
            }
        }
        .toolbar
        {
            Button
            {
                isShowAddStudentPanel.toggle()
            }
            label:
            {
                Image(systemName: "plus.square")
            }
            .help("Додати нову запис")
            
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
        .frame(minWidth: 300, minHeight: 170)
    }// body
}// struct GroupInfoView: View

#Preview
{
    StudentInfoView()
}
