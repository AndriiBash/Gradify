//
//  GroupInfoView.swift
//  Gradify
//
//  Created by Андрiй on 01.02.2024.
//

import SwiftUI

struct GroupInfoView: View
{
    @ObservedObject private var readModel = ReadModel()
    
    @State private var isScrollViewOpen: Bool = false
    @State private var isAnimateButtonScrollview: Bool = false
    @State private var scrollViewHeight: CGFloat = 0

    private let adaptiveColumns = [ GridItem(.adaptive(minimum: 160)) ]
    
    var body: some View
    {
        ZStack
        {
            BlurBehindWindow().ignoresSafeArea()
            
            ScrollView
            {
                
                // temp!!!!
                Button
                {
                    Task
                    {
                        do
                        {
                            await readModel.fetchData()
                        }
                    }// Task
                }
                label:
                {
                    Text("Get data")
                        .padding(.vertical)
                }
                .padding(.vertical)
                
                
                
                
                VStack(spacing: 0)
                {
                    HStack
                    {
                        Text("GroupName")
                            .foregroundColor(Color("MainTextForBlur"))
                            .font(.title)
                            .fontWeight(.bold)
                            
                        Button
                        {
                            isAnimateButtonScrollview.toggle()
                            
                            withAnimation(Animation.easeInOut(duration: 0.2))
                            {
                                self.isScrollViewOpen.toggle()
                                
                                scrollViewHeight = isScrollViewOpen ? 190 : 0
                            }
                        }
                        label:
                        {
                            Image(systemName: isAnimateButtonScrollview ? "chevron.down" : "chevron.right")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 15, height: 15, alignment: .center)
                                .foregroundColor(Color("MainTextForBlur"))
                            }// button for hide or unhine card with info
                            .buttonStyle(PlainButtonStyle())
                            
                            Spacer()
                        }//HStack with group name
                        .padding(.horizontal, 20)
                        
                        ScrollView(.horizontal, showsIndicators: false)
                        {
                            LazyHGrid(rows: adaptiveColumns, spacing: 20)
                            {
                                ForEach(readModel.users.indices, id: \.self)
                                { index in
                                    GroupViewModel(name: readModel.users[index].name, lastName: readModel.users[index].lastName)
                                        .scaleEffect(readModel.fetchDataStatus ? 1 : 0)
                                        .transition(.opacity)
                                }// ForEach
                            }// LazyHGrid
                            .padding(.horizontal, 17)
                        }// ScrollView
                        //.background(Color.green)
                        .frame(height: scrollViewHeight)
                        
                        HStack
                        {
                            Text("NextGroupName")
                                .foregroundColor(Color("MainTextForBlur"))
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Spacer()
                        }// HStack with name next Group
                        .padding(.horizontal, 20)
                }// main VStack
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }// ScrollView with all info
        }// main ZStack
        .navigationTitle("Групи")
        
    }// body
}// struct GroupInfoView: View

#Preview
{
    GroupInfoView()
}
