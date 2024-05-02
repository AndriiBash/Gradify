//
//  RowSpecializationView.swift
//  Gradify
//
//  Created by Андрiй on 14.03.2024.
//

import SwiftUI

struct RowSpecializationView: View
{
    @State private var hoverOnName:             Bool = false
    @State private var hoverOndescription:      Bool = false
    @State private var hoverOnField:            Bool = false
    
    @State private var statusCopyString:        String  = "Скопіювати"
    @State private var maxWidthForButton:       CGFloat = .zero

    @Binding var isShowView:                    Bool
    @Binding var isEditView:                    Bool
    
    var specialization:                         Specialization

    var body: some View
    {
        VStack
        {
            HStack(alignment: .center)
            {
                Spacer()
                
                Text("[\(specialization.id)] \(specialization.name)")
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
                        Text("Назва")
                        
                        Spacer()
                        
                        Text("\(specialization.name)")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(hoverOnName ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                        { isHovered in
                            hoverOnName.toggle()
                        }
                        .contextMenu
                        {
                            Button
                            {
                                copyInBuffer(text: specialization.name)
                            }
                            label:
                            {
                                Text("Скопіювати назву")
                            }
                        }
                    }// HStack with name specialization
                    
                    HStack
                    {
                        Text("Галузь")
                        
                        Spacer()
                        
                        Text("\(specialization.field)")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(hoverOnField ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                            { isHovered in
                                hoverOnField.toggle()
                            }
                            .contextMenu
                            {
                                Button
                                {
                                    copyInBuffer(text: specialization.field)
                                }
                                label:
                                {
                                    Text("Скопіювати галузь спеціалізації")
                                }
                            }
                    }// Hstack with field specialization
                }// Main Section
                
                Section(header: Text("Інше"))
                {
                    HStack
                    {
                        Text("Детальніше")
                        
                        Spacer()
                        
                        Text("\(specialization.description)")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(hoverOndescription ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                            { isHovered in
                                hoverOndescription.toggle()
                            }
                            .contextMenu
                            {
                                Button
                                {
                                    copyInBuffer(text: specialization.description)
                                }
                                label:
                                {
                                    Text("Скопіювати детальну інформацію про спеціалізацію")
                                }
                            }
                    }// Hstack with description specialization
                }
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
                            [\(specialization.id)] \(specialization.name)
                            ===========================================
                            Назва: \(specialization.name)
                            Галузь: \(specialization.field)
                            Детальніше: \(specialization.description)
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
                .help("Скопіювати усю інформацію спеціалізації")
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
        }// Main VStack
        .foregroundColor(Color("MainTextForBlur"))
        .frame(width: 400, height: 350)
        .onAppear
        {
            let buttonWidth = getWidthFromString(for: "Скопіювати")
            let doneButtonWidth = getWidthFromString(for: "Готово")

            maxWidthForButton = max(buttonWidth, doneButtonWidth)
        }
    }
}
