//
//  ItemFilterViewModel.swift
//  Gradify
//
//  Created by Андрiй on 23.02.2024.
//

import SwiftUI

enum colummFilterType: CaseIterable
{
    case student
    case group
    case teacher
    case department
    case subject
    case grades
    case faculty
    case specialization
    case specialty
    case educationalProgram
    case none
}


struct ItemFilterViewModel: View
{
    @State private var conditionList:       [String] = ["Оберіть умову",">", ">=", "==", "<", "<=", "!="]
    @State private var columnList:          [String] = []
    @State private var deleteIsClicker:     Bool = false
    
    @State var typeColumn:                  colummFilterType
    @Binding var itemCondition:             itemCondition
    @Binding var statusFilter:              Bool
    @Binding var isShowError:               Bool
    
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
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .strokeBorder(itemCondition.column == "Оберіть поле" ? Color.red : Color.clear, lineWidth: !isShowError ? 2 : 0)
                    .padding(.leading, 8)
            )
            .onChange(of: itemCondition.column)
            { _, _ in
                statusFilter = false
            }
            
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
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .strokeBorder(itemCondition.condition == "Оберіть умову" ? Color.red : Color.clear, lineWidth: !isShowError ? 2 : 0)
                    .padding(.leading, 8)
            )
            .onChange(of: itemCondition.condition)
            { _, _ in
                statusFilter = false
            }
            
            TextField("Умова",text: $itemCondition.conditionText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .cornerRadius(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .strokeBorder(itemCondition.conditionText.isEmpty ? Color.red : Color.clear, lineWidth: !isShowError ? 2 : 0)
                        //.padding(.leading, 8)
                )
                .onChange(of: itemCondition.conditionText)
                { _, _ in
                    statusFilter = false
                }
            
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
        .onChange(of: typeColumn)
        { _, newTypeColumn in
            updateColumnList(for: newTypeColumn)
        }
        .onAppear
        {
            updateColumnList(for: typeColumn)
        }
    }
    
    
    private func updateColumnList(for type: colummFilterType)
    {
        // for localized use in array String(localized: "")
        
        columnList = ["Оберіть поле"]
                      
        switch type
        {
        case .student:
            columnList += ["Прізвище", "Ім'я", "По батькові", "Дата народження", "Номер телефона", "Номер паспорту", "Адреса проживання", "Освітня програма", "Група"]
            
        case .group:
            columnList += ["Назва", "Староста", "Куратор", "Список студентів (тільки 1 за раз)" ,"Кафедра", "Освітня програма"]
            
        case .teacher:
            columnList += ["Прізвище", "Ім'я", "По батькові", "Дата народження", "Номер телефона", "Номер паспорту", "Адреса проживання", "Категорія", "Спеціалізація"]
            
        case .department:
            columnList += ["Назва", "Опис", "Спеціалізація", "Завідувач кафедри", "Зам завідувача кафедри", "Список викладачів (тільки 1 за раз)", "Аудиторія кафедри", "Рік заснування"]
            
        case .subject:
            columnList += ["Назва", "Тип", "Викладачі (тільки 1 за раз)", "Кафедра яка викладає", "Всього годин", "Кількість лекційних годин", "Кількість лабораторних годин", "Кількість семінарних годин", "Кількість годин на самостійні роботи", "Семестр в якому вивчається", "Семестровий контроль"]
            
        case .grades:
            columnList += ["Предмет", "Отримувач", "Хто виставив", "Оцінка", "Дата виставлення", "Тип оцінки", "Можливість перескладання", "Коментар"]
            
        case .faculty:
            columnList += ["Назва", "Декан", "Опис", "Кафедри (тільки 1 за раз)", "Спеціалізації (тільки 1 за раз)"]
            
        case .specialization:
            columnList += ["Назва", "Опис", "Галузь"]
            
        case .specialty:
            columnList += ["Назва", "Тривалість навчання", "Вартість навчання", "Предмети (тільки 1 за раз)", "Спеціалізація"]
            
        case .educationalProgram:
            columnList += ["Назва", "Рівень", "Тривалість", "Опис", "Спеціалізація (тільки 1 за раз)", "Спеціальність"]
            
        default:
            columnList = ["Оберіть поле", "nil"]
        }
    }
}

/*
#Preview
{
    ItemFilterViewModel()
}
*/
