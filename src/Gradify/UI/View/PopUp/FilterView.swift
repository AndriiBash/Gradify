//
//  FilterView.swift
//  Gradify
//
//  Created by Андрiй on 23.02.2024.
//

import SwiftUI



struct FilterView: View
{
    @ObservedObject var filterModel:        FilterViewModel
    
    @State private var areConditionsValid:  Bool = true
    @State private var isShowMaxError:      Bool = false
    @State var isFiltered:                  Bool = false

    @State private var maxWidthForButton:   CGFloat = .zero
    
    
    var body: some View
    {
        ScrollView(showsIndicators: false)
        {
            VStack
            {
                ForEach(filterModel.itemConditionList, id: \.id)
                { item in
                    HStack
                    {
                        ItemFilterViewModel(
                            typeColumn: colummFilterType.student,
                            itemCondition: $filterModel.itemConditionList.first(where: { $0.id == item.id })!, 
                            statusFilter: $isFiltered,
                            isShowError: $areConditionsValid,
                            onDelete:
                            {
                                removeRecord(item)
                            }
                        )
                        .id(item.id)
                    }
                }// ForEach with condition

                if isShowMaxError
                {
                    Text("Максимальна кількість умов 15 штук")
                        .padding(.vertical, 6)
                        .foregroundColor(Color.red)
                        .font(.subheadline)
                }
                
                if !areConditionsValid
                {
                    Text("Заповніть усі поля та оберіть колонки та умови")
                        .padding(.vertical, 6)
                        .foregroundColor(Color.red)
                        .font(.subheadline)
                }
                
                if !filterModel.itemConditionList.isEmpty
                {
                    Divider()
                }
                
                HStack
                {
                    Button
                    {
                        self.filterModel.viewSize.height -= CGFloat(30 * self.filterModel.itemConditionList.count)

                        filterModel.itemConditionList.removeAll()
                        
                        deleteMessageAboutMaxRecord()
                    }
                    label:
                    {
                        Image(systemName: "trash")
                    }// Button for clear all
                    .padding(.leading, 12)
                    .help("Видалити усі умови")
                    .disabled(filterModel.itemConditionList.count == 0 ? true : false)
                    
                    Spacer()
                    
                    Button
                    {
                        if self.filterModel.itemConditionList.count < 15
                        {
                            withAnimation(Animation.easeOut(duration: 0.25))
                            {
                                let newRecord = itemCondition(
                                    id: UUID(),
                                    column: "Оберіть поле",
                                    condition: "Оберіть умову",
                                    conditionText: ""
                                )
                                filterModel.addRecord(record: newRecord)
                                
                                isShowMaxError = false
                                
                                if !areConditionsValid
                                {
                                    withAnimation(Animation.easeOut(duration: 0.25))
                                    {
                                        areConditionsValid = true
                                    }
                                    
                                    filterModel.viewSize.height -= 30
                                }
                            }
                            
                            self.filterModel.viewSize.height += 30
                            
                            //itemConditionsMatrix.append([true, true, true])
                            //print(itemConditionsMatrix)
                        }
                        else
                        {
                            if !isShowMaxError
                            {
                                withAnimation(Animation.easeOut(duration: 0.25))
                                {
                                    isShowMaxError = true
                                }
                                
                                self.filterModel.viewSize.height += 30
                                /*
                                if isShowMaxError
                                {
                                    self.filterModel.viewSize.height += 30
                                }
                                 */
                            }
                        }
                    }
                    label:
                    {
                        Text("Додати умову")
                            .frame(minWidth: maxWidthForButton)
                    }// Button add if
                    .padding(.top, 2)
                    
                    Button
                    {
                        if !areConditionsValid
                        {
                            withAnimation(Animation.easeOut(duration: 0.25))
                            {
                                areConditionsValid = true
                            }
                            
                            filterModel.viewSize.height -= 30
                        }
                            
                            
                        var allItemsNonEmpty = true

                        for index in filterModel.itemConditionList.indices
                        {
                            let item = filterModel.itemConditionList[index]
                            
                            if item.column == "Оберіть поле" || item.condition == "Оберіть умову" || item.conditionText.isEmpty
                            {
                                allItemsNonEmpty = false
                                //break
                            }
                        }
                            
                        if allItemsNonEmpty
                        {
                            // interested!!!
                            self.isFiltered.toggle()
                        }
                        else
                        {
                            withAnimation(Animation.easeOut(duration: 0.25))
                            {
                                areConditionsValid = false
                            }
                            
                            filterModel.viewSize.height += 30
                        }
                    }
                    label:
                    {
                        Text(!isFiltered ? "Застосувати" : "Скасувати")
                            .frame(minWidth: maxWidthForButton)
                    }// Button use filter
                    .keyboardShortcut(.defaultAction)
                    .disabled(filterModel.itemConditionList.count == 0 ? true : false)
                    .padding(.top, 2)
                    .padding(.trailing, 12)
                    
                }// HStack with button for edit filter
            }// Main VStack
            .padding(.vertical)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }// Main ScrollView
        .frame(width: self.filterModel.viewSize.width, height: self.filterModel.viewSize.height)
        .onDisappear
        {
            deleteMessageAboutMaxRecord()
        }
        .onAppear
        {
            let buttonWidth = getWidthFromString(for: "Додати умову")
            let doneButtonWidth = getWidthFromString(for: "Застосувати")

            maxWidthForButton = max(buttonWidth, doneButtonWidth)
        }
        .onChange(of: filterModel.itemConditionList.count)
        { _, _ in
            updateIsFiltered()
        }
    }
    
    private func updateIsFiltered()
    {
        if filterModel.itemConditionList.isEmpty
        {
            isFiltered = false
        }
    }// private func updateIsFiltered()
    
    private func removeRecord(_ record: itemCondition)
    {
        // no use withAnimation beacause swift have bugs :/
        filterModel.removeRecord(item: record)
        filterModel.viewSize.height -= 30
        
        if !areConditionsValid
        {
            withAnimation(Animation.easeOut(duration: 0.25))
            {
                areConditionsValid = true
            }
            
            filterModel.viewSize.height -= 30
        }
        
        if isShowMaxError
        {
            withAnimation(Animation.easeOut(duration: 0.25))
            {
                isShowMaxError = false
            }
            
            filterModel.viewSize.height -= 30
        }
        
    }// private func removeRecord(_ record: itemCondition)
    
    private func deleteMessageAboutMaxRecord()
    {
        if isShowMaxError
        {
            self.filterModel.viewSize.height -= 30
        }
        
        if !areConditionsValid
        {
            self.filterModel.viewSize.height -= 30
        }
        
        areConditionsValid = true
        isShowMaxError = false
    }// private func deleteMessageAboutMaxRecord()
}

struct FilterView_Previews: PreviewProvider
{
    static var previews: some View
    {
        FilterView(filterModel: FilterViewModel())
    }
}
 
