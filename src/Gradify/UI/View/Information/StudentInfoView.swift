//
//  GroupInfoView.swift
//  Gradify
//
//  Created by Андрiй on 01.02.2024.
//

import SwiftUI

struct StudentInfoView: View
{
    @StateObject private var readModel              = ReadWriteModel()
    
    @State private var isExpandAllList: Bool        = false
    @State private var isShowAddStudentPanel: Bool  = false
    @State private var statusSave:      Bool        = false
    @State private var statusSaveEdit:  Bool        = false
    @State private var showStatusSave:  Bool        = false
    @State private var searchString:    String      = ""
    @State private var oldSearchString: String      = ""
    
    // @State private var selectedGroup: StudentGroup
    // long proccess make this function...
    
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
                    ForEach(readModel.studentGroups.sorted(by: { $0.name < $1.name }), id: \.self)
                    { studentGroup in
                        StudentListView(
                            studentList: $readModel.studentGroups[readModel.studentGroups.firstIndex(of: studentGroup)!],
                            isExpandListForAll: $isExpandAllList,
                            isUpdateList: $statusSaveEdit,
                            searchString: $searchString,
                            writeModel: readModel)
                    }// ForEach with list student
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
        .onChange(of: statusSave)
        {
            if statusSave
            {
                showStatusSave = true
            }
            else
            {
                showStatusSave = false
            }
        }
        .sheet(isPresented: $showStatusSave)
        {
            if statusSave
            {
                SuccessSaveView(isAnimated: $statusSave)
                    .onAppear
                    {
                        oldSearchString = searchString
                        searchString = ""

                        Task
                        {
                            await readModel.fetchStudentData()
                            searchString = oldSearchString
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
                isExpandAllList.toggle()
            }
            label:
            {
                Label(isExpandAllList ? "Згорнути усі списки" : "Розгорнути усі списки", systemImage: isExpandAllList ? "chevron.down.circle" : "chevron.right.circle")
            }// expand all list card in some view
            .help(isExpandAllList ? "Згорнути усі списки" : "Розгорнути усі списки")
            .padding(.leading, 160)
            
            Button
            {
                isShowAddStudentPanel.toggle()
            }
            label:
            {
                Label("Додати нову запис", systemImage: "plus.square")
            }
            .help("Додати нову запис")
        
            Spacer()
        }//.toolBar for main ZStack
        .frame(minWidth: 300, minHeight: 200)
        .searchable(text: $searchString) {}
        .onChange(of: statusSaveEdit)
        { _,newValue in
            if statusSaveEdit
            {
                oldSearchString = searchString
                searchString = ""

                Task
                {
                    await readModel.fetchStudentData()
                    searchString = oldSearchString

                }// need add wait view (monitor)
                
                statusSaveEdit = false
            }
        }
        .overlay
        {
            if readModel.isLoadingFetchData
            {
                LoadingScreen()
            }
        }
    }// body
}// struct GroupInfoView: View

#Preview
{
    StudentInfoView()
}
