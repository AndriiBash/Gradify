//
//  SubjectListView.swift
//  Gradify
//
//  Created by Андрiй on 03.04.2024.
//

import SwiftUI

struct SubjectListView: View
{
    @Binding var subjectList:                       SubjectList
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

    private let adaptiveColumns = [GridItem(.adaptive(minimum: 120))]
    
    init(subjectList: Binding<SubjectList>, isExpandListForAll: Binding<Bool>, isUpdateList: Binding<Bool>, searchString: Binding<String>, writeModel: ReadWriteModel)
    {
        _subjectList = subjectList
        _isExpandListForAll = isExpandListForAll
        _isUpdateList = isUpdateList
        _searchString = searchString
        
        self.writeModel = writeModel
        
        let initialCardVisibility = Array(repeating: true, count: subjectList.wrappedValue.subject.count)
        _cardVisibility = State(initialValue: initialCardVisibility)
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
                            Text(subjectList.name)
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
                }//HStack Button for expand list group specizatlion
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
                ForEach(subjectList.subject.indices, id: \.self)
                {index in
                    let subject = subjectList.subject[index]
                    
                    if searchString.isEmpty
                    {
                        SubjectCardViewModel(subject: .constant(subject), isUpdateSubject: $isUpdateList, writeModel: writeModel)
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
                    else if writeModel.matchesSearch(subject: subject, searchString: searchString)
                    {
                        SubjectCardViewModel(subject: .constant(subject), isUpdateSubject: $isUpdateList, writeModel: writeModel)
                    }// else if
                }// ForEach
            }// LazyHGrid(rows: adaptiveColumns, spacing: 20)
            .padding(.horizontal, 17)
        }// ScrollView
        .frame(height: scrollViewHeight)
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
                    hasSearchResult = !searchString.isEmpty && subjectList.subject.contains
                    { subject in
                        return writeModel.matchesSearch(subject: subject, searchString: searchString)
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
            if UserDefaults.standard.bool(forKey: "list-status-open-\(subjectList.name)")
            {
                isScrollViewOpen = true
                isAnimateButtonScrollview = true

                withAnimation(Animation.easeInOut(duration: 0.2))
                {
                    scrollViewHeight = 190
                }
            }
            
            // for animation when list's in start a closed
            for index in subjectList.subject.indices
            {
                cardVisibility[index] = false
            }
        }
        .onChange(of: isScrollViewOpen)
        { oldValue, newValue in
            UserDefaults.standard.set(newValue, forKey: "list-status-open-\(subjectList.name)")
        }

    }
}
