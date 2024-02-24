//
//  FilterView.swift
//  Gradify
//
//  Created by Андрiй on 23.02.2024.
//

import SwiftUI

struct FilterView: View
{
    @ObservedObject var filterModel:    FilterViewModel
    
    var body: some View
    {
        ScrollView(showsIndicators: false)
        {
            VStack
            {
                
                ForEach(filterModel.itemConditionList, id: \.id)
                { record in
                    ItemFilterViewModel(
                        itemCondition: $filterModel.itemConditionList[filterModel.itemConditionList.firstIndex(of: record)!],
                        onDelete: {
                            removeRecord(record)
                        }
                    )
                }// For each with condition for filter
                
                if filterModel.isShowMaxError
                {
                    Text("Максимальна кількість умов 15 штук")
                        .foregroundColor(Color.red)
                        .font(.subheadline)
                }
                
                HStack
                {
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
                            .padding(.horizontal)
                            .padding(.vertical, 4)
                    }// Button add if
                    .padding(.top, 2)
                    
                    Spacer()
                }// HStack with button for edit filter
            }// Main VStack
            .padding(.vertical)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }// Main ScrollView
        .frame(width: self.filterModel.viewSize.width, height: self.filterModel.viewSize.height)
        .onDisappear
        {
            if filterModel.isShowMaxError
            {
                self.filterModel.viewSize.height -= 30
            }
            
            filterModel.isShowMaxError = false
        }
    }
    

    private func removeRecord(_ record: itemCondition)
    {
        withAnimation(Animation.easeInOut(duration: 0.25))
        {
            filterModel.removeRecord(item: record)
        }
        
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

    
    /*
    private func removeRecord(at record: String)
    {
        if self.filterModel.filteredRecords.firstIndex(of: record) != nil
        {
            withAnimation(Animation.easeOut(duration: 0.25))
            {
                self.filterModel.removeRecord(record)
            }

            if filterModel.isShowMaxError
            {
                withAnimation(Animation.easeOut(duration: 0.25))
                {
                    filterModel.isShowMaxError = false
                }
                self.filterModel.viewSize.height -= 30 * 2
            }
            else
            {
                self.filterModel.viewSize.height -= 30
            }
        }
    }// private func removeRecord(at record: String)
     */
}

struct FilterView_Previews: PreviewProvider
{
    static var previews: some View
    {
        FilterView(filterModel: FilterViewModel())
    }
}
 
