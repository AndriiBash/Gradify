//
//  StudentListView.swift
//  Gradify
//
//  Created by Андрiй on 03.02.2024.
//

import SwiftUI

struct StudentListView: View
{
    @Binding var studentList:                       StudentGroup
    @Binding var isExpandListForAll:                Bool
    @Binding var isUpdateList:                      Bool
    @Binding var searchString:                      String

    @State private var isScrollViewOpen:            Bool = false
    @State private var isAnimateButtonScrollview:   Bool = false
    @State private var hasSearchResult:             Bool = true
    @State private var scrollViewHeight:            CGFloat = 0
    
    @State private var cardVisibility:              [Bool] = []
    @State private var listVisibility:              Bool = true
    @ObservedObject var writeModel:                 ReadWriteModel
    @ObservedObject var filterModel:                FilterViewModel

    private let adaptiveColumns = [GridItem(.adaptive(minimum: 120))]
    
    
    init(studentList: Binding<StudentGroup>, isExpandListForAll: Binding<Bool>, isUpdateList: Binding<Bool>, searchString: Binding<String>, writeModel: ReadWriteModel, filterModel: FilterViewModel)
    {
        _studentList = studentList
        _isExpandListForAll = isExpandListForAll
        _isUpdateList = isUpdateList
        _searchString = searchString
        
        self.writeModel = writeModel
        self.filterModel = filterModel
        
        let initialCardVisibility = Array(repeating: true, count: studentList.wrappedValue.students.count)
        _cardVisibility = State(initialValue: initialCardVisibility)
        //print("\(cardSearchVisibleList)")
    }
    
    
    var body: some View
    {
        if hasSearchResult
        {
            if listVisibility
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
                .onChange(of: isExpandListForAll)
                { _,newValue in
                    isAnimateButtonScrollview = newValue
                    isScrollViewOpen = newValue
                    
                    withAnimation(Animation.easeInOut(duration: 0.2))
                    {
                        scrollViewHeight = newValue ? 190 : 0
                    }
                }
            }// if listVisibility
        }
        
        ScrollView(.horizontal, showsIndicators: false)
        {
            LazyHGrid(rows: adaptiveColumns, spacing: 20)
            {
                ForEach(studentList.students.indices, id: \.self)
                {index in
                    let student = studentList.students[index]
                    
                    if searchString.isEmpty && !filterModel.isFiltered
                    {
                        StudentCardViewModel(student: .constant(student), isUpdateStudent: $isUpdateList, writeModel: writeModel)
                            .opacity(cardVisibility[index] ? 1 : 0)
                            .scaleEffect(cardVisibility[index] ? 1 : 0.8)
                            .onAppear
                            {
                                withAnimation
                                {
                                    cardVisibility[index] = true
                                    hasSearchResult = true
                                }
                            }
                            .onDisappear
                            {
                                withAnimation
                                {
                                    cardVisibility[index] = false
                                }
                            }
                    }
                    else if writeModel.matchesSearch(student: student, searchString: searchString)
                    {
                        StudentCardViewModel(student: .constant(student), isUpdateStudent: $isUpdateList, writeModel: writeModel)
                        /* //AHTUNG to use, anomaly in UI!!
                            .opacity(cardVisibility[index] ? 1 : 0)
                            .scaleEffect(cardVisibility[index] ? 1 : 0.8)
                            .onAppear
                            {
                                withAnimation
                                {
                                    hasResult = true
                                    cardVisibility[index] = true
                                }
                            }
                            .onDisappear
                            {
                                withAnimation
                                {
                                    cardVisibility[index] = false
                                }
                            }
                         */
                    }// else if
                    else if filterModel.isFiltered && cardVisibility[index]
                    {
                        StudentCardViewModel(student: .constant(student), isUpdateStudent: $isUpdateList, writeModel: writeModel)
                    }
                }// ForEach
            }// LazyHGrid(rows: adaptiveColumns, spacing: 20)
            .padding(.horizontal, 17)
        }// ScrollView
        .frame(height: scrollViewHeight)
        .onChange(of: filterModel.isFiltered)
        { oldValue, newValue in
            if filterModel.isFiltered
            {
                var hasResult: Bool = false
                
                let dictionary = ["name": "Ім'я",
                                   "lastName": "Прізвище",
                                   "surname": "По батькові",
                                   "contactNumber": "Номер телефона",
                                   "dateBirth": "Дата народження",
                                   "educationProgram": "Освітня програма",
                                   "group": "Група",
                                   "passportNumber": "Номер паспорту",
                                   "residenceAddress": "Адреса проживання"]
                
                for index in studentList.students.indices
                {
                    let mirror = Mirror(reflecting: studentList.students[index])
                    var statusFilterItem: Bool = false

                    for item in filterModel.itemConditionList
                    {
                        for (label, value) in mirror.children
                        {
                            if dictionary[label ?? ""] == item.column
                            {
                                var stringValue: String = ""
                                
                                if item.column != dictionary["dateBirth"]
                                {
                                    stringValue = value as? String ?? "nil"
                                }
                                else
                                {
                                    stringValue = dateFormatter.string(from: value as! Date)
                                }
                                
                                if item.condition == ">"
                                {
                                    if stringValue > item.conditionText
                                    {
                                        statusFilterItem = true
                                    }
                                }
                                else if item.condition == ">="
                                {
                                    if stringValue >= item.conditionText
                                    {
                                        statusFilterItem = true
                                    }
                                }
                                else if item.condition == "=="
                                {
                                    if stringValue == item.conditionText
                                    {
                                        statusFilterItem = true
                                    }
                                }
                                else if item.condition == "<"
                                {
                                    if stringValue < item.conditionText
                                    {
                                        statusFilterItem = true
                                    }
                                }
                                else if item.condition == "<="
                                {
                                    if stringValue <= item.conditionText
                                    {
                                        statusFilterItem = true
                                    }
                                }
                                else if item.condition == "!="
                                {
                                    if stringValue != item.conditionText
                                    {
                                        statusFilterItem = true
                                    }
                                }
                            }
                        }
                        
                        if !statusFilterItem
                        {
                            withAnimation
                            {
                                cardVisibility[index] = false
                            }
                        }
                        else
                        {
                            cardVisibility[index] = true
                            hasResult = true
                            statusFilterItem = false
                        }
                        
                    }
                    
                    if hasResult
                    {
                        withAnimation
                        {
                            listVisibility = true
                        }
                    }
                    else
                    {
                        isAnimateButtonScrollview = false
                        isScrollViewOpen = false
                        
                        withAnimation(Animation.easeInOut(duration: 0.2))
                        {
                            scrollViewHeight = 0
                        }
                        withAnimation
                        {
                            listVisibility = false
                        }
                    }
                    
                }
            }
            else if !newValue
            {
                for index in studentList.students.indices
                {
                    withAnimation
                    {
                        cardVisibility[index] = true
                    }
                }
                
                withAnimation
                {
                    listVisibility = true
                }
            }
        }
        .onChange(of: searchString)
        { _, newValue in
            if searchString.isEmpty
            {
                withAnimation
                {
                    hasSearchResult = true
                }
            }
            else
            {
                withAnimation
                {
                    hasSearchResult = !searchString.isEmpty && studentList.students.contains
                    { student in
                        return student.name.lowercased().contains(searchString.lowercased()) ||
                        student.lastName.lowercased().contains(searchString.lowercased()) ||
                        student.surname.lowercased().contains(searchString.lowercased()) ||
                        student.contactNumber.lowercased().contains(searchString.lowercased()) ||
                        student.passportNumber.lowercased().contains(searchString.lowercased()) ||
                        student.residenceAddress.lowercased().contains(searchString.lowercased()) ||
                        student.educationProgram.lowercased().contains(searchString.lowercased()) ||
                        student.group.lowercased().contains(searchString.lowercased())
                    }
                }
                    
                if !hasSearchResult
                {
                    isAnimateButtonScrollview = false
                    isScrollViewOpen = false
                    
                    withAnimation(Animation.easeInOut(duration: 0.2))
                    {
                        scrollViewHeight = 0
                    }
                }
            }
        }// onChange
        .onAppear
        {
            if UserDefaults.standard.bool(forKey: "list-status-open-\(studentList.name)")
            {
                isScrollViewOpen = true
                isAnimateButtonScrollview = true

                withAnimation(Animation.easeInOut(duration: 0.2))
                {
                    scrollViewHeight = 190
                }
            }
            
            // for animation when list's in start a closed
            for index in studentList.students.indices
            {
                cardVisibility[index] = false
            }
            //print("status open \(studentList.name) : \(isScrollViewOpen)")
        }
        .onChange(of: isScrollViewOpen)
        { oldValue, newValue in
            UserDefaults.standard.set(newValue, forKey: "list-status-open-\(studentList.name)")
            //print("change status open \(studentList.name) : \(isScrollViewOpen)")
        }
    }
    
}


struct StudentListView_Previews: PreviewProvider
{
    @State private static var listGroup = StudentGroup(name: "Some Group", students: [Student]())
    @State private static var isExapndAllList: Bool = false
    @State private static var isUpdateList: Bool = false
    @State private static var searchString: String = ""
    
    @StateObject private static var writeModel      = ReadWriteModel()
    @StateObject private static var filterViewModel = FilterViewModel()

    static var previews: some View
    {
        StudentListView(studentList: $listGroup, isExpandListForAll: $isExapndAllList, isUpdateList: $isUpdateList, searchString: $searchString, writeModel: writeModel, filterModel: filterViewModel)
    }
}
