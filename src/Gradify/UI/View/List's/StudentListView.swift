//
//  StudentListView.swift
//  Gradify
//
//  Created by Андрiй on 03.02.2024.
//

import SwiftUI
import FirebaseAuth

struct StudentListView: View
{
    @Binding var studentList:  StudentGroup // Change type to StudentGroup
    @Binding var isExpandList: Bool
    @Binding var isUpdateList: Bool
    @Binding var searchString: String
    
    @State private var isScrollViewOpen:          Bool = false
    @State private var isAnimateButtonScrollview: Bool = false
    @State private var areCardsVisible:           Bool = false
    @State private var areSearchCardsVisible:     Bool = false
    @State private var hasResult:                 Bool = true
    @State private var scrollViewHeight:          CGFloat = 0

    @ObservedObject var writeModel: ReadWriteModel
    
    private let adaptiveColumns = [GridItem(.adaptive(minimum: 160))]
    
    var body: some View
    {
        if hasResult
        {
            HStack
            {
                Button
                {
                    isAnimateButtonScrollview.toggle()
                    
                    withAnimation(Animation.easeInOut(duration: 0.2))
                    {
                        self.isScrollViewOpen.toggle()
                        scrollViewHeight = isScrollViewOpen ? 190 : 0
                    }
                }
                label:
                {
                    HStack
                    {
                        Text(studentList.name)
                            .foregroundColor(Color("MainTextForBlur"))
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Image(systemName: isAnimateButtonScrollview ? "chevron.down" : "chevron.right")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 15, height: 15, alignment: .center)
                            .foregroundColor(Color("MainTextForBlur"))
                    }//Hstack button label
                    .background(Color.clear)
                    .contentShape(Rectangle())
                }// button for hide or unhine card with info
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
            }//HStack Button for expand list group student's
            .padding(.horizontal, 20)
            .onChange(of: isExpandList)
            { _,newValue in
                isAnimateButtonScrollview = newValue
                isScrollViewOpen = newValue
                
                withAnimation(Animation.easeInOut(duration: 0.2))
                {
                    scrollViewHeight = newValue ? 190 : 0
                }
                
            }
            .onChange(of: searchString)
            { _, newValue in
                if !searchString.isEmpty
                {
                    hasResult = !searchString.isEmpty && studentList.students.contains
                    { student in
                        return student.name.lowercased().contains(searchString.lowercased()) ||
                        student.lastName.lowercased().contains(searchString.lowercased()) ||
                        student.surname.lowercased().contains(searchString.lowercased())
                    }
                }
                else
                {
                    hasResult = true
                }
            }
        }
        
        ScrollView(.horizontal, showsIndicators: false)
        {
            LazyHGrid(rows: adaptiveColumns, spacing: 20)
            {
                ForEach(studentList.students, id: \.id)
                { student in
                    if searchString.isEmpty
                    {
                        StudentCardViewModel(student: .constant(student), updateList: $isUpdateList, writeModel: writeModel)
                            .opacity(areCardsVisible ? 1 : 0)
                            .scaleEffect(areCardsVisible ? 1 : 0.8)
                            .onAppear
                            {
                                withAnimation
                                {
                                    areCardsVisible = true
                                    hasResult = true
                                }
                            }
                        .onDisappear
                        {
                            withAnimation
                            {
                                areCardsVisible = false
                            }
                        }
                        
                    }
                    else if student.name.lowercased().contains(searchString.lowercased()) || student.lastName.lowercased().contains(searchString.lowercased()) || student.surname.lowercased().contains(searchString.lowercased())
                        {
                            StudentCardViewModel(student: .constant(student), updateList: $isUpdateList, writeModel: writeModel)
                                .opacity(areSearchCardsVisible ? 1 : 0)
                                .scaleEffect(areSearchCardsVisible ? 1 : 0.8)
                                .onAppear
                                {
                                    withAnimation
                                    {
                                        hasResult = true
                                        areSearchCardsVisible = true
                                    }
                                }
                                .onDisappear
                                {
                                    withAnimation
                                    {
                                        areSearchCardsVisible = false
                                    }
                                }
                        }
                    }// ForEach
                }// LazyHGrid(rows: adaptiveColumns, spacing: 20)
                .padding(.horizontal, 17)
            }// ScrollView
                .onChange(of: searchString)
                { _, newValue in
                    if !searchString.isEmpty
                    {
                        withAnimation
                        {
                            hasResult = !searchString.isEmpty && studentList.students.contains
                            { student in
                                return student.name.lowercased().contains(searchString.lowercased()) ||
                                student.lastName.lowercased().contains(searchString.lowercased()) ||
                                student.surname.lowercased().contains(searchString.lowercased())
                            }
                        }
                        
                        if !hasResult
                        {
                            isAnimateButtonScrollview = false
                            isScrollViewOpen = false
                            
                            withAnimation(Animation.easeInOut(duration: 0.2))
                            {
                                scrollViewHeight = 0
                            }
                            
                        }
                    }
                    else
                    {
                        hasResult = true
                    }
                }
            .frame(height: scrollViewHeight)
    }
}



struct StudentListView_Previews: PreviewProvider
{
    @State private static var listGroup = StudentGroup(name: "Some Group", students: [Student]())
    @State private static var isExapndAllList: Bool = false
    @State private static var isUpdateList: Bool = false
    @State private static var searchString: String = ""
    @StateObject private static var writeModel = ReadWriteModel()
    
    static var previews: some View
    {
        StudentListView(studentList: $listGroup, isExpandList: $isExapndAllList, isUpdateList: $isUpdateList, searchString: $searchString, writeModel: writeModel)
    }
}
