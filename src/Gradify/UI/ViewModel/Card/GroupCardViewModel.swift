//
//  GroupCardViewModel.swift
//  Gradify
//
//  Created by Андрiй on 11.03.2024.
//

import SwiftUI

struct GroupCardViewModel: View
{
    @State private var isHovered:           Bool = false

    @State private var showAboutGroup:      Bool = false
    @State private var showEditGroup:       Bool = false
    @State private var showDeleteGroup:     Bool = false
    
    @Binding var group:                     Group
    @Binding var isUpdateGroup:             Bool
    @ObservedObject var writeModel:         ReadWriteModel
    
    var body: some View
    {
        VStack
        {
            Spacer()
            
            HStack
            {
                Text("\(group.name)")
                    .font(.title2)
            }// HStack with main info
            
            VStack
            {
                HStack
                {
                    Image(systemName: "person.bust.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .foregroundColor(Color.blue)
                    
                    Text("\(group.curator)")
                        .font(.subheadline)
                    
                    Spacer()
                }// Hstack with group curator
                
                HStack
                {
                    Image(systemName: "laurel.leading")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .foregroundColor(Color.blue)
                    
                    Text("\(group.groupLeader)")
                        .font(.subheadline)
                    
                    Spacer()
                }// Hstack with group leader
                
                HStack
                {
                    Image(systemName: "book.and.wrench.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .foregroundColor(Color.blue)
                    
                    Text("\(group.educationProgram)")
                        .font(.subheadline)
                    
                    Spacer()
                }// Hstack with group educationProgram
                
                
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
                    showDeleteGroup.toggle()
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
                    showEditGroup.toggle()
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
                    showAboutGroup.toggle()
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
        .sheet(isPresented: $showAboutGroup)
        {
            RowGroupView(isShowView: $showAboutGroup, isEditView: $showEditGroup, group: group, readModel: writeModel)
        }
        .sheet(isPresented: $showEditGroup)
        {
            EditGroupView(isShowView: $showAboutGroup, isEditView: $showEditGroup, isUpdateListGroup: $isUpdateGroup, group: $group, writeModel: writeModel)
        }
        .sheet(isPresented: $showDeleteGroup)
        {
            AcceptDeleteRowGroup(group: $group, isShowSelfView: $showDeleteGroup, isUpdateListGroup: $isUpdateGroup, writeModel: writeModel)
        }
    }// body
}
