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
    
    @State private var isShowAddStudentPanel:       Bool = false
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
            
        }// main ZStack
        .navigationTitle("Кафедри")
        .frame(minWidth: 300, minHeight: 200)
        .searchable(text: $searchString){}
        .toolbar
        {
            Button
            {
                isSotredList.toggle()
            }
            label:
            {
                Label(isSotredList ? "Сорторувати за зростанням" : "Сорторувати за спаданням", systemImage: isSotredList ? "arrow.down.circle" : "arrow.up.circle")
            }
            .help(isSotredList ? "Сорторувати за зростанням" : "Сорторувати за спаданням")
            .padding(.leading, 45)

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
    }
}

/*
 #Preview
 {
    DepartamentInfoView()
 }
 */