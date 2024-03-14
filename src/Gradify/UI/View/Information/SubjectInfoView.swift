//
//  SubjectInfoView.swift
//  Gradify
//
//  Created by Андрiй on 11.03.2024.
//

import SwiftUI

struct SubjectInfoView: View
{
    @StateObject private var readModel              = ReadWriteModel()
    
    @State private var isExpandAllList:             Bool = false
    @State private var isShowAddSubjectPanel:       Bool = false
    @State private var statusSave:                  Bool = false
    @State private var statusSaveEdit:              Bool = false
    @State private var showStatusSave:              Bool = false
    @State private var isSotredList:                Bool = false
    @State private var isFilterShow:                Bool = false

    @State private var searchString:                String = ""
    @State private var oldSearchString:             String = ""
    @State private var countSearched:               Int = 0

    
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
                    ForEach(readModel.subjectList, id: \.self)
                    { studentGroup in
                        
                        /*
                        StudentListView(
                            studentList: $readModel.studentGroups[readModel.studentGroups.firstIndex(of: studentGroup)!],
                            isExpandListForAll: $isExpandAllList,
                            isUpdateList: $statusSaveEdit,
                            searchString: $searchString,
                            writeModel: readModel)
                         */
                    }// ForEach with list student
                    .padding(.top, 4)
                }// VStack with list group student's
                .padding(.vertical)
                .onAppear
                {
                    Task
                    {
                        await readModel.fetchSubjectData()
                    }// need add wait view (monitor)
                    
                    withAnimation
                    {
                        readModel.gradeList.sort(by: { isSotredList ? $0.name < $1.name : $0.name > $1.name })
                    }
                }
            }// Main ScrollView
            
            
            
            
            
            
            
            
        }// main ZStack
        .navigationTitle("Предмети")
        .navigationSubtitle(searchString.isEmpty ? "\(readModel.countRecords) предметів" : "Знайдено \(countSearched) предметів")
        .frame(minWidth: 300, minHeight: 200)
        .searchable(text: $searchString){}
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
            .padding(.leading, 100)

            
            Button
            {
                isSotredList.toggle()
            }
            label:
            {
                Label(isSotredList ? "Сорторувати за зростанням" : "Сорторувати за спаданням", systemImage: isSotredList ? "arrow.down.circle" : "arrow.up.circle")
            }
            .help(isSotredList ? "Сорторувати за зростанням" : "Сорторувати за спаданням")

            Button
            {
                isShowAddSubjectPanel.toggle()
            }
            label:
            {
                Label("Додати нову запис", systemImage: "plus.square")
            }
            .help("Додати нову запис")
        
            Spacer()
        }//.toolBar for main ZStack
    }
}
