//
//  RowGroupView.swift
//  Gradify
//
//  Created by Андрiй on 11.03.2024.
//

import SwiftUI

struct RowGroupView: View
{
    @State private var hoverOnName:                 Bool = false
    @State private var hoverOnCurator:              Bool = false
    @State private var hoverOnLeader:               Bool = false
    @State private var hoverOnDepartmentName:       Bool = false
    @State private var hoverOnEducationProgram:     Bool = false
    @State private var hoverOnStudent:              [Bool] = []
    
    @State private var statusCopyString:        String  = "Скопіювати"
    @State private var maxWidthForButton:       CGFloat = .zero

    @Binding var isShowView: Bool
    @Binding var isEditView: Bool
    
    var group: Group
    
    var body: some View
    {
        VStack
        {
            HStack(alignment: .center)
            {
                Spacer()

                Text("[\(group.id)] \(group.name)")
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
                        
                        Text("\(group.name)")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(hoverOnName ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                            {isHovered in
                                changePointingHandCursor(shouldChangeCursor: isHovered)
                                hoverOnName.toggle()
                            }
                            .contextMenu()
                            {
                                Button
                                {
                                    copyInBuffer(text: group.name)
                                }
                                label:
                                {
                                    Text("Скопіювати назву")
                                }
                            }
                    }// HStack with name group
                    
                    HStack
                    {
                        Text("Куратор")
                        
                        Spacer()
                        
                        Text("\(group.curator)")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(hoverOnCurator ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                            {isHovered in
                                changePointingHandCursor(shouldChangeCursor: isHovered)
                                hoverOnCurator.toggle()
                            }
                            .contextMenu()
                            {
                                Button
                                {
                                    copyInBuffer(text: group.curator)
                                }
                                label:
                                {
                                    Text("Скопіювати ПІБ куратора")
                                }
                            }
                    }// Hstack with curator name
                    
                    HStack
                    {
                        Text("Староста")
                        
                        Spacer()
                        
                        Text("\(group.groupLeader)")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(hoverOnLeader ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                            {isHovered in
                                changePointingHandCursor(shouldChangeCursor: isHovered)
                                hoverOnLeader.toggle()
                            }
                            .contextMenu()
                            {
                                Button
                                {
                                    copyInBuffer(text: group.groupLeader)
                                }
                                label:
                                {
                                    Text("Скопіювати ПІБ старости")
                                }
                            }
                    }// Hstack with groupLeader name
                    
                    HStack
                    {
                        Text("Кафедра")
                        
                        Spacer()
                        
                        Text("\(group.departmentName)")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(hoverOnDepartmentName ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                            {isHovered in
                                changePointingHandCursor(shouldChangeCursor: isHovered)
                                hoverOnDepartmentName.toggle()
                            }
                            .contextMenu()
                            {
                                Button
                                {
                                    copyInBuffer(text: group.departmentName)
                                }
                                label:
                                {
                                    Text("Скопіювати назву кафедри")
                                }
                            }
                    }// Hstack with contact number student

                    HStack
                    {
                        Text("Освітня програма")
                        
                        Spacer()
                        
                        Text("\(group.educationProgram)")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(hoverOnEducationProgram ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                            {isHovered in
                                changePointingHandCursor(shouldChangeCursor: isHovered)
                                hoverOnEducationProgram.toggle()
                            }
                            .contextMenu()
                            {
                                Button
                                {
                                    copyInBuffer(text: group.educationProgram)
                                }
                                label:
                                {
                                    Text("Скопіювати назву освітньої програми")
                                }
                            }
                    }// Hstack with education program
                }// Section with main info
                
                Section(header: Text("Студенти"))
                {
                    Text("")
                    

                       
                    ForEach(group.studentList.indices, id: \.self)
                    { index in
                        HStack
                        {
                            Text("Студент № \(index)")
                            
                            Spacer()
                            
                            Text("\(group.studentList[index])")
                                .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                                .padding(.horizontal)
                                .padding(.vertical, 1)
                                .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(hoverOnStudent.indices.contains(index) && hoverOnStudent[index] ? Color.gray.opacity(0.2) : Color.clear)
                                )
                                .onHover { isHovered in
                                    changePointingHandCursor(shouldChangeCursor: isHovered)
                                    if isHovered {
                                        if !hoverOnStudent.indices.contains(index) {
                                            hoverOnStudent.append(false)
                                        }
                                    }
                                    hoverOnStudent[index].toggle()
                                }
                                .contextMenu()
                                {
                                    Button
                                    {
                                        copyInBuffer(text: group.studentList[index])
                                    }
                                    label:
                                    {
                                        Text("Скопіювати ПІБ студента")
                                    }
                            }
                        }
                    }// ForEach with student's in group
                }// Section with additional info about student's in group
            }// Form with info
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
                        //.resizable()
                        //.aspectRatio(contentMode: .fit)
                        //.frame(width: 20, height: 20)
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
                    var allInfo = """
                            [\(group.id)] \(group.name)
                            ===========================================
                            Назва: \(group.name)
                            Куратор: \(group.curator)
                            Староста: \(group.groupLeader)
                            Кафедра: \(group.departmentName)
                            Освітня програма: \(group.educationProgram)
                            ===========================================
                            """
                    
                    if !group.studentList.isEmpty
                    {
                        for index in group.studentList.indices
                        {
                            allInfo += "Студент № \(index)" + "\(group.studentList[index])"
                        }
                        
                        allInfo += "==========================================="
                    }
                    
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
                .help("Скопіювати усю інформацію студента")
                .padding(.horizontal, 12)
                
                Button
                {
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
        .frame(width: 400, height: 565)
        .onAppear
        {
            let buttonWidth = getWidthFromString(for: "Скопіювати")
            let doneButtonWidth = getWidthFromString(for: "Готово")

            maxWidthForButton = max(buttonWidth, doneButtonWidth)
        }
    }
}

/*
#Preview
{
    RowGroupView()
}
*/
