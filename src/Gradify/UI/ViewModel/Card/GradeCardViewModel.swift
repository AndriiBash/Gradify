//
//  GradeCardViewModel.swift
//  Gradify
//
//  Created by Андрiй on 13.03.2024.
//

import SwiftUI

struct GradeCardViewModel: View
{
    @State private var isHovered:           Bool = false

    @State private var showAboutGrade:      Bool = false
    @State private var showEditGrade:       Bool = false
    @State private var showDeleteGrade:     Bool = false
    
    @Binding var grade:                     Grade
    @Binding var isUpdateGrade:             Bool
    @ObservedObject var writeModel:         ReadWriteModel

    var body: some View
    {
        VStack
        {
            Spacer()
            
            HStack
            {
                Text("\(grade.recipient)")
                    .font(.title2)
            }// HStack with main info
            
            VStack
            {
                HStack
                {
                    Image(systemName: "rosette")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .foregroundColor(Color.blue)
                    
                    Text("\(grade.score)")
                        .font(.subheadline)
                    
                    Spacer()
                }// Hstack with contact number
                
                HStack
                {
                    Image(systemName: "calendar")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .foregroundColor(Color.blue)
                    
                    Text(dateFormatter.string(from: grade.dateGiven))
                        .font(.subheadline)

                    Spacer()
                }// Hstack with contact number
                
                HStack
                {
                    Image(systemName: "paperplane")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .foregroundColor(Color.blue)
                                        
                    Text("\(grade.grader)")
                        .font(.subheadline)
                    
                    Spacer()
                }// Hstack with residence address
            }// VStack with another info
            .padding(.horizontal, 6)
            .padding(.top, 4)
            
            Spacer()
        }// main vstack
        .foregroundColor(Color("MainTextForBlur"))
        .frame(width: 250, height: 150)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.thinMaterial)
                .shadow(radius: 8)
        )
        .padding(.leading, 4)
        .overlay( // button on card
            HStack
            {
                Button
                {
                    showDeleteGrade.toggle()
                }
                label:
                {
                    Image(systemName: "trash")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .foregroundColor(.white)
                }
                .buttonStyle(PressedDeleteButtonStyle())
                .frame(width: 25, height: 25)
                .cornerRadius(12)
                .opacity(isHovered ? 1.0 : 0.0)
                .shadow(radius: 6)
                
                Button
                {
                    showEditGrade.toggle()
                }
                label:
                {
                    Image(systemName: "pencil.line")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .foregroundColor(.white)
                }// edit button
                .buttonStyle(PressedEditButtonStyle())
                .frame(width: 25, height: 25)
                .cornerRadius(12)
                .opacity(isHovered ? 1.0 : 0.0)
                .shadow(radius: 6)
                
                Button
                {
                    showAboutGrade.toggle()
                }
                label:
                {
                    Image(systemName: "info")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .foregroundColor(.white)
                }// edit button
                .buttonStyle(PressedInfoButtonStyle())
                .frame(width: 25, height: 25)
                .cornerRadius(12)
                .opacity(isHovered ? 1.0 : 0.0)
                .shadow(radius: 6)
            }// HStack with buttons
                .padding(.top, -6)
                .zIndex(1)
            ,alignment: .topLeading)// end overlay
        .onHover
        { hovering in
            withAnimation(Animation.easeInOut(duration: 0.2).delay(hovering ? 0.2 : 0))
            {
                self.isHovered = hovering
            }
        }
        .sheet(isPresented: $showAboutGrade)
        {
            RowGradeView(isShowView: $showAboutGrade, isEditView: $showEditGrade, grade: grade)
        }
        .sheet(isPresented: $showEditGrade)
        {
            //EditGroupView(isShowView: $showAboutGroup, isEditView: $showEditGroup, isUpdateListGroup: $isUpdateGroup, group: $group, writeModel: writeModel)
        }
        .sheet(isPresented: $showDeleteGrade)
        {
            AcceptDeleteRowGrades(grade: $grade, isShowSelfView: $showEditGrade, isUpdateListGrades: $isUpdateGrade, writeModel: writeModel)
        }
    }
}
