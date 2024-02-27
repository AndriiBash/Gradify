//
//  FilterViewModel.swift
//  Gradify
//
//  Created by Андрiй on 23.02.2024.
//

import SwiftUI


struct itemCondition: Identifiable//, Equatable//, Hashable
{
    var id:             UUID
    var column:         String
    var condition:      String
    var conditionText:  String
    
    init(id: UUID = UUID(), column: String, condition: String, conditionText: String)
    {
        self.id = id
        self.column = column
        self.condition = condition
        self.conditionText = conditionText
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool
    {
        lhs.id == rhs.id
    }
}


class FilterViewModel: ObservableObject
{
    @Published var isShow:              Bool
    @Published var viewSize:            CGSize
    @Published var itemConditionList:   [itemCondition]
    
    init()
    {
        self.isShow = false
        self.viewSize = CGSize(width: 450, height: 60)
        self.itemConditionList = []
    }// init
    
    func addRecord(record: itemCondition)
    {
        itemConditionList.append(record)
    }// func addRecord(record: String)
        
    func removeRecord(item: itemCondition)
    {
        // debug
        //print("Try delete record with id : \(item.id)")
        
        if let index = itemConditionList.firstIndex(where: { $0.id == item.id })
        {
            itemConditionList.remove(at: index)
        }
    }// func removeRecord(item: itemCondition)
}
