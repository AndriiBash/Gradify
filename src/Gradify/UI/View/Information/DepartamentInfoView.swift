//
//  DepartamentInfoView.swift
//  Gradify
//
//  Created by Андрiй on 11.03.2024.
//

import SwiftUI

struct DepartamentInfoView: View
{
    @StateObject private var readModel              = ReadWriteModel()
    
    @State private var isExpandAllList:             Bool = false
    @State private var isShowAddDeprmentPanel:      Bool = false
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
                    ForEach(readModel.departmentList, id: \.self)
                    { departmentList in
                        DepartmentListView(departmentList: $readModel.departmentList[readModel.departmentList.firstIndex(of: departmentList)!],
                                        isExpandListForAll: $isExpandAllList,
                                        isUpdateList: $statusSaveEdit,
                                        searchString: $searchString,
                                        writeModel: readModel)
                    }// ForEach with list department
                    .padding(.top, 4)
                }// VStack with list department
                .padding(.vertical)
                .onAppear
                {
                    Task
                    {
                        await readModel.fetchDepartment(updateCountRecod: true)
                    }
                    
                    withAnimation
                    {
                        readModel.departmentList.sort(by: { isSotredList ? $0.name < $1.name : $0.name > $1.name })
                    }
                }
            }// Main ScrollView
        }// main ZStack
        .navigationTitle("Кафедри")
        .navigationSubtitle(searchString.isEmpty ? "\(readModel.countRecords) кафедр" : "Знайдено \(countSearched) кафедр")
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
                isShowAddDeprmentPanel.toggle()
            }
            label:
            {
                Label("Додати нову запис", systemImage: "plus.square")
            }
            .help("Додати нову запис")
        
            Spacer()
        }//.toolBar for main ZStack
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
        .sheet(isPresented: $isShowAddDeprmentPanel)
        {
            //AddFacultyView(isShowForm: $isShowAddFacultyPanel, statusSave: $statusSave, writeModel: readModel)
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
                            await readModel.fetchDepartment(updateCountRecod: true)
                            searchString = oldSearchString
                        }
                    }
            }
            else
            {
                ErrorSaveView(isAnimated: $statusSave)
            }
        }
        .onChange(of: isSotredList)
        { _, _ in
            withAnimation
            {
                readModel.departmentList.sort(by: { isSotredList ? $0.name < $1.name : $0.name > $1.name })
            }
        }
        .onChange(of: searchString)
        { oldValue,newValue in
            countSearched = 0

            if !searchString.isEmpty
            {
                for list in readModel.departmentList
                {
                    for department in list.deparment
                    {
                        if readModel.matchesSearch(department: department, searchString: searchString)
                        {
                            countSearched += 1
                        }
                    }
                }
            }
        }// onChange(of: searchString)
        .onChange(of: statusSaveEdit)
        { _, newValue in
            if statusSaveEdit
            {
                oldSearchString = searchString
                searchString = ""

                Task
                {
                    await readModel.fetchDepartment(updateCountRecod: true)
                    searchString = oldSearchString
                }
                
                statusSaveEdit = false
            }
        }
        .overlay
        {
            if readModel.isLoadingFetchData
            {
                LoadingScreen()
            }
        }// onChange(of: statusSaveEdit)

    }
}

/*
 #Preview
 {
    DepartamentInfoView()
 }
 */
