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
    
    @State private var maxWidthForButton:   CGFloat = .zero

    var body: some View
    {
        ScrollView(showsIndicators: false)
        {
            VStack
            {
                ForEach(filterModel.itemConditionList, id: \.id)
                { item in
                    HStack {
                        ItemFilterViewModel(
                            itemCondition: $filterModel.itemConditionList.first(where: { $0.id == item.id })!,
                            onDelete:
                            {
                                removeRecord(item)
                            }
                        )
                        .id(item.id)
                    }
                }// ForEach with condition

                
                if filterModel.isShowMaxError
                {
                    Text("Максимальна кількість умов 15 штук")
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
                                filterModel.isShowMaxError = false
                            }
                            
                            self.filterModel.viewSize.height += 30
                        }
                        else
                        {
                            if !filterModel.isShowMaxError
                            {
                                withAnimation(Animation.easeOut(duration: 0.25))
                                {
                                    filterModel.isShowMaxError = true
                                }
                                
                                if filterModel.isShowMaxError
                                {
                                    self.filterModel.viewSize.height += 30
                                }
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
                        
                    }
                    label:
                    {
                        Text("Застосувати")
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
    }
    

    private func removeRecord(_ record: itemCondition)
    {
        // no use withAnimation beacause swift have bugs :/
        filterModel.removeRecord(item: record)

        if filterModel.isShowMaxError
        {
            withAnimation(Animation.easeOut(duration: 0.25))
            {
                filterModel.isShowMaxError = false
            }
            
            filterModel.viewSize.height -= 30 * 2
        }
        else
        {
            filterModel.viewSize.height -= 30
        }
    }
    
    private func deleteMessageAboutMaxRecord()
    {
        if filterModel.isShowMaxError
        {
            self.filterModel.viewSize.height -= 30
        }
        
        filterModel.isShowMaxError = false
    }
}

struct FilterView_Previews: PreviewProvider
{
    static var previews: some View
    {
        FilterView(filterModel: FilterViewModel())
    }
}
 
