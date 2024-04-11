//
//  RowGradeView.swift
//  Gradify
//
//  Created by Андрiй on 13.03.2024.
//

import SwiftUI

struct RowGradeView: View
{
    @State private var hoverOnSubject:              Bool = false
    @State private var hoverOnRecipient:            Bool = false
    @State private var hoverOnRecipientGroup:       Bool = false
    @State private var hoverOnGrader:               Bool = false
    @State private var hoverOnScore:                Bool = false
    @State private var hoverOnDateGiven:            Bool = false
    @State private var hoverOnGradeType:            Bool = false
    @State private var hoverOnRetakePossible:       Bool = false
    @State private var hoverOnComment:              Bool = false
    
    @State private var statusCopyString:            String  = "Скопіювати"
    @State private var maxWidthForButton:           CGFloat = .zero

    @Binding var isShowView:                        Bool
    @Binding var isEditView:                        Bool
    
    var grade:                                      Grade
    
    init(isShowView: Binding<Bool>, isEditView: Binding<Bool>, grade: Grade)
    {
        self._isShowView = isShowView
        self._isEditView = isEditView
        self.grade = grade
    }
    
    var body: some View
    {
        VStack
        {
            HStack(alignment: .center)
            {
                Spacer()
                
                Text("[\(grade.id)] \(grade.grader) : \(grade.score) (\(dateFormatter.string(from: grade.dateGiven)))")
                    .font(.system(size: 13))
                    .fontWeight(.bold)
                
                Spacer()
            }// HStack navigation panel
            .padding(.top, 8)
            
            Form
            {
                Section(header: Text("Головне"))
                {
                    HStack
                    {
                        Text("Предмет")
                        
                        Spacer()
                        
                        Text("\(grade.subject)")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(hoverOnSubject ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                        { isHovered in
                            hoverOnSubject.toggle()
                        }
                        .contextMenu
                        {
                            Button
                            {
                                copyInBuffer(text: grade.subject)
                            }
                            label:
                            {
                                Text("Скопіювати назву предмета")
                            }
                        }
                    }// HStack with subject grade
                    
                    HStack
                    {
                        Text("Група отримувача")
                        
                        Spacer()
                        
                        Text("\(grade.recipientGroup)")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(hoverOnRecipientGroup ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                            { isHovered in
                                changePointingHandCursor(shouldChangeCursor: isHovered)
                                hoverOnRecipientGroup.toggle()
                            }
                            .contextMenu
                            {
                                Button
                                {
                                    copyInBuffer(text: grade.recipientGroup)
                                }
                                label:
                                {
                                    Text("Скопіювати групу отримувача")
                                }
                            }
                    }// HStack with recipientGroup grade
                    
                    HStack
                    {
                        Text("Отримувач")
                        
                        Spacer()
                        
                        Text("\(grade.recipient)")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(hoverOnRecipient ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                        { isHovered in
                            changePointingHandCursor(shouldChangeCursor: isHovered)
                            hoverOnRecipient.toggle()
                        }
                        .contextMenu
                        {
                            Button
                            {
                                copyInBuffer(text: grade.recipient)
                            }
                            label:
                            {
                                Text("Скопіювати ПІБ отримувача")
                            }
                        }
                    }// HStack with recipient grade
                    
                    HStack
                    {
                        Text("Хто виставив")
                        
                        Spacer()
                        
                        Text("\(grade.grader)")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(hoverOnGrader ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                        { isHovered in
                            hoverOnGrader.toggle()
                        }
                        .contextMenu
                        {
                            Button
                            {
                                copyInBuffer(text: grade.grader)
                            }
                            label:
                            {
                                Text("Скопіювати ПІБ хто виставив оцінку")
                            }
                        }
                    }// HStack with grader grade
                    
                    HStack
                    {
                        Text("Оцінка")
                        
                        Spacer()
                        
                        Text("\(grade.score)")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(hoverOnScore ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                        { isHovered in
                            hoverOnScore.toggle()
                        }
                        .contextMenu
                        {
                            Button
                            {
                                copyInBuffer(text: String(grade.score))
                            }
                            label:
                            {
                                Text("Скопіювати оцінку")
                            }
                        }
                    }// HStack with score grade
                }// Section main
                
                Section(header: Text("Детальніше про оцінку"))
                {
                    HStack
                    {
                        Text("Дата виставлення")
                        
                        Spacer()
                        
                        Text("\(dateFormatter.string(from: grade.dateGiven))")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(hoverOnDateGiven ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                            { isHovered in
                                hoverOnDateGiven.toggle()
                            }
                            .contextMenu
                            {
                                Button
                                {
                                    copyInBuffer(text: dateFormatter.string(from: grade.dateGiven))
                                }
                                label:
                                {
                                    Text("Скопіювати дату виставлення")
                                }
                            }
                    }// HStack with score grade
                    
                    HStack
                    {
                        Text("Тип оцінки")
                        
                        Spacer()
                        
                        Text("\(grade.gradeType)")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(hoverOnGradeType ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                            { isHovered in
                                hoverOnGradeType.toggle()
                            }
                            .contextMenu
                            {
                                Button
                                {
                                    copyInBuffer(text: grade.gradeType)
                                }
                                label:
                                {
                                    Text("Скопіювати дату виставлення")
                                }
                            }
                    }// HStack with grade type
                    
                    HStack
                    {
                        Text("Можливість перескладання")
                        
                        Spacer()
                        
                        Text(grade.retakePossible ? "Можливо" : "Неможливо")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(hoverOnRetakePossible ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                            { isHovered in
                                hoverOnRetakePossible.toggle()
                            }
                            .contextMenu
                            {
                                Button
                                {
                                    copyInBuffer(text: grade.retakePossible ? "Можливо" : "Неможливо")
                                }
                                label:
                                {
                                    Text("Скопіювати статус можливості перескладання оцінки")
                                }
                            }
                    }// HStack with retake possible grade
                }// Section detail grade
                
                Section(header: Text("Додатково"))
                {
                    HStack
                    {
                        Text("Коментар")
                        
                        Spacer()
                        
                        Text(grade.comment)
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(hoverOnComment ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                            {isHovered in
                                hoverOnComment.toggle()
                            }
                            .contextMenu
                            {
                                Button
                                {
                                    copyInBuffer(text: grade.comment)
                                }
                                label:
                                {
                                    Text("Скопіювати коментарій до оцінки")
                                }
                            }
                    }// HStack with retake possible grade
                }// Section with comment
            }// Form
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .formStyle(.grouped)
            
            Spacer()
            Divider()
            
            HStack
            {
                Button
                {
                    isShowView = false
                    isEditView = true
                }
                label:
                {
                    Image(systemName: "square.and.pencil")
                }// button for edit row
                .padding(.trailing, 12)
                .help("Редагувати запис")
                .onHover
                { isHovered in
                    changePointingHandCursor(shouldChangeCursor: isHovered)
                }

                Spacer()
                                
                Button
                {
                    let allInfo = """
                            [\(grade.id)] \(grade.grader) : \(grade.score) (\(dateFormatter.string(from: grade.dateGiven)))
                            ===========================================
                            Предмет: \(grade.subject)
                            Група отримувача: \(grade.recipientGroup)
                            Отримувач: \(grade.recipient)
                            Хто виставив: \(grade.grader)
                            Оцінка: \(grade.score)
                            Дата виставлення: \(dateFormatter.string(from: grade.dateGiven))
                            Тип оцінки: \(grade.gradeType)
                            Можливість перескладання: \(grade.retakePossible ? "Можливо" : "Неможливо")
                            Коментар: \(grade.comment)
                            ===========================================\n
                            """

                    copyInBuffer(text: allInfo)
                    statusCopyString = "Скопійовано!"
                }
                label:
                {
                    Text("\(statusCopyString)")
                        .frame(minWidth: maxWidthForButton)
                }
                .onHover
                { isHovered in
                    changePointingHandCursor(shouldChangeCursor: isHovered)
                }// change cursor when hover
                .help("Скопіювати усю інформацію про оцінку")
                .padding(.horizontal, 12)
                
                Button
                {
                    isShowView = false
                    isShowView = false
                }
                label:
                {
                    Text("Готово")
                        .frame(minWidth: maxWidthForButton)
                }
                .onHover
                { isHovered in
                    changePointingHandCursor(shouldChangeCursor: isHovered)
                }// change cursor when hover
                .keyboardShortcut(.defaultAction)
            }// HStack with button's for manipulate form
            .padding(.vertical, 6)
            .padding(.bottom, 8)
            .padding(.horizontal, 22)
        }// main VStack
        .foregroundColor(Color("MainTextForBlur"))
        .frame(width: 400, height: 565)
        .onAppear
        {
            let buttonWidth = getWidthFromString(for: "Скопіювати")
            let doneButtonWidth = getWidthFromString(for: "Готово")

            maxWidthForButton = max(buttonWidth, doneButtonWidth)
        }
    }
}
