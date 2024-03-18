//
//  EducationalProgramInfoView.swift
//  Gradify
//
//  Created by Андрiй on 11.03.2024.
//

import SwiftUI

struct EducationalProgramInfoView: View
{
    @StateObject private var readModel                          = ReadWriteModel()
    
    @State private var isExpandAllList:                         Bool = false
    @State private var isShowAddEducationalProgramPanel:        Bool = false
    @State private var statusSave:                              Bool = false
    @State private var statusSaveEdit:                          Bool = false
    @State private var showStatusSave:                          Bool = false
    @State private var isSotredList:                            Bool = false
    @State private var isFilterShow:                            Bool = false

    @State private var searchString:                            String = ""
    @State private var oldSearchString:                         String = ""
    @State private var countSearched:                           Int = 0

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
                    ForEach(readModel.educationalProgramList, id: \.self)
                    { educationalList in
                        EducationalProgramListView(
                            educationalProgramList: $readModel.educationalProgramList[readModel.educationalProgramList.firstIndex(of: educationalList)!],
                           isExpandListForAll: $isExpandAllList,
                           isUpdateList: $statusSaveEdit,
                           searchString: $searchString,
                           writeModel: readModel)
                    }// ForEach with list educationalList
                    .padding(.top, 4)
                }// VStack with list educationalList
                .padding(.vertical)
                .onAppear
                {
                    Task
                    {
                        await readModel.fetchEducationalProgram(updateCountRecod: true)
                    }
                    
                    withAnimation
                    {
                        readModel.educationalProgramList.sort(by: { isSotredList ? $0.name < $1.name : $0.name > $1.name })
                    }
                }
            }// Main ScrollView
        }// main ZStack
        .navigationTitle("Навчальні програми")
        .navigationSubtitle(searchString.isEmpty ? "\(readModel.countRecords) навчальних програм" : "Знайдено \(countSearched) навчальних програм")
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
                isShowAddEducationalProgramPanel.toggle()
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
        .sheet(isPresented: $isShowAddEducationalProgramPanel)
        {
            AddEducationProgramView(isShowForm: $isShowAddEducationalProgramPanel, statusSave: $statusSave, writeModel: readModel)
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
                            await readModel.fetchEducationalProgram(updateCountRecod: true)
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
                readModel.educationalProgramList.sort(by: { isSotredList ? $0.name < $1.name : $0.name > $1.name })
            }
        }
        .onChange(of: searchString)
        { oldValue,newValue in
            countSearched = 0

            if !searchString.isEmpty
            {
                for list in readModel.educationalProgramList
                {
                    for educationalProgram in list.educationalProgram
                    {
                        if readModel.matchesSearch(educationalProgram: educationalProgram, searchString: searchString)
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
                    await readModel.fetchEducationalProgram(updateCountRecod: true)
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
        }

    }
}

/*
#Preview {
    EducationalProgramInfoView()
}
*/
