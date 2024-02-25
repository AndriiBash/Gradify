//
//  ItemFilterViewModel.swift
//  Gradify
//
//  Created by Андрiй on 23.02.2024.
//

import SwiftUI

struct ItemFilterViewModel: View
{
    @State private var conditionList:       [String] = ["Оберіть умову",">", ">=", "==", "<", "<=", "!="]
    @State private var columnList:          [String] = ["Оберіть поле", "ds","dsg"]
    @State private var deleteIsClicker:     Bool = false
    
    @Binding var itemCondition:             itemCondition
    
    var onDelete:                           (() -> Void)? = nil
    
    var body: some View
    {
        HStack
        {
            Picker("", selection: $itemCondition.column)
            {
                ForEach(columnList, id: \.self)
                {
                    if $0 == "Оберіть поле"
                    {
                        Text($0)
                        Divider()
                    }
                    else
                    {
                        Text($0)
                    }
                }
            }// Picker for change colu,n
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .background(Color.clear)
            
            Picker("", selection: $itemCondition.condition)
            {
                ForEach(conditionList, id: \.self)
                {
                    if $0 == "Оберіть умову"
                    {
                        Text($0)
                        Divider()
                    }
                    else
                    {
                        Text($0)
                    }
                }
            }// Picker for change condition
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .background(Color.clear)
            
            TextField("Умова",text: $itemCondition.conditionText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .cornerRadius(4)

            
            Spacer()
            
            Button
            {
                deleteIsClicker = true
                onDelete?()
            }
            label:
            {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
            .disabled(deleteIsClicker)
            
        }//HStack
        .padding(.horizontal, 4)
    }
}

/*
#Preview
{
    ItemFilterViewModel()
}
*/
