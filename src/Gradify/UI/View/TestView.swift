//
//  TestView.swift
//  Gradify
//
//  Created by Андрiй on 13.01.2024.
//

import SwiftUI

struct TestView: View
{
    @ObservedObject private var readModel = ReadWriteModel()
    @State private var scaleLevel: Int = 0

    @State var gridLayout: [GridItem] = [ GridItem() ]

    private let adaptiveColumns = [ GridItem(.adaptive(minimum: 160)) ]
    
    @State private var isScrollViewOpen: Bool = false
    @State private var isAnimateButtonScrollview: Bool = false
    @State private var scrollViewHeight: CGFloat = 0
    
    var body: some View
    {
        ZStack
        {
            BlurBehindWindow().ignoresSafeArea()
            
            ScrollView
            {
                Button
                {
                    Task
                    {
                        do
                        {
                            await readModel.fetchStudentData()
                        }
                    }// Task
                }
                label:
                {
                    Text("Get data")
                        .padding(.vertical)
                }
                .padding(.vertical)
                
                VStack
                {
                    VStack(spacing: 0) // work's!!!
                    {
                        HStack
                        {
                            Text("GroupName")
                                .font(.title)
                                .fontWeight(.bold)
                                //.background(Color.red)
                            
                            Button
                            {
                                isAnimateButtonScrollview.toggle()
                                
                                withAnimation(Animation.easeInOut(duration: 0.2))
                                {
                                    self.isScrollViewOpen.toggle()
                                    
                                    scrollViewHeight = isScrollViewOpen ? 180 : 0
                                    
                                    
                                }
                            }
                            label:
                            {
                                Image(systemName: isAnimateButtonScrollview ? "chevron.down" : "chevron.right")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 15, height: 15, alignment: .center)
                                    //.background(Color.red)
                                //.padding(.top, 2)
                            }// button for hide or unhine card with info
                            .buttonStyle(PlainButtonStyle())
                            
                            Spacer()
                        }//HStack with group name
                        .padding(.horizontal, 20)
                        
                        //if isScrollViewOpen
                        //{
                        ScrollView(.horizontal, showsIndicators: false)
                        {
                            LazyHGrid(rows: adaptiveColumns, spacing: 20)
                            {
                                ForEach(readModel.students.indices, id: \.self)
                                { index in
                                    textViewRow(name: readModel.students[index].name, lastName: readModel.students[index].lastName)
                                        .scaleEffect(readModel.isLoadingFetchData ? 1 : 0)
                                    //.padding(4)
                                        .transition(.opacity)
                                }// ForEach
                            }// LazyHGrid
                            //.background(Color.red)
                            .padding(.horizontal, 17)
                        }// ScrollView
                        //.background(Color.green)
                        .frame(height: scrollViewHeight)
                        //}// if
                        
                        HStack
                        {
                            Text("NextGroupName")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Spacer()
                        }// HStack with name next Group
                        .padding(.horizontal, 20)
                        
                        
                        //.matchedGeometryEffect(id: "scrollView", in: .global(), isSource: isScrollViewOpen)
                        
                        
                    }// Test VStack
                    //.padding(.vertical, 6)
            
                }// main VStack
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }// main ScrollView
            //.background(Color("BackgroundLeftLoginView").opacity(0.35))
        }// main ZStack
        .navigationTitle("testName")
        
    }
}


struct textViewRow: View
{
    @State private var isHovered: Bool = false

    var name: String
    var lastName: String
    
    var body: some View
    {
        VStack
        {
            Spacer()
         
            Text("\(name)")
                .font(.title)
            Text("\(lastName)")
                .font(.subheadline)
            
            Spacer()
            
            VStack
            {
                Text("Test text in bottom")
            }
            .padding(.vertical, 6)
            .frame(maxWidth: .infinity)
            .background(Color.green)
            .cornerRadius(10, corners: [.bottomRight, .bottomLeft])
            .clipped()
        }// main vstack
        .foregroundColor(Color.white)
        .frame(width: 250, height: 150)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.thinMaterial)
                .shadow(radius: 8)
        )
        .padding(.leading, 4)
        .overlay( // edit info in row button
            
            HStack
            {

                Button
                {
                    //self.didTap = true
                }
                label:
                {
                    Image(systemName: "trash")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .foregroundColor(.white)
                }
                .frame(width: 25, height: 25)
                .cornerRadius(12)
                .opacity(isHovered ? 1.0 : 0.0) // Скрываем кнопку, если нет наведения
                //.animation(.easeInOut(duration: 0.2)) // Анимация появления/исчезания
                .buttonStyle(PressedEditCardButtonStyle())
                
                Button
                {
                    
                }
                label:
                {
                    Image(systemName: "pencil")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }// edit button
                .frame(width: 25, height: 25)
                .background(Color.yellow)
                .cornerRadius(12)
                .opacity(isHovered ? 1.0 : 0.0) // Скрываем кнопку, если нет наведения
                .buttonStyle(PlainButtonStyle())
                //.animation(.easeInOut(duration: 0.2)) // Анимация появления/исчезания

                
                Button
                {
                    
                }
                label:
                {
                    Image(systemName: "info")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 13, height: 13)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }// edit button
                .frame(width: 25, height: 25)
                .background(Color.green)
                .cornerRadius(12)
                .opacity(isHovered ? 1.0 : 0.0) // Скрываем кнопку, если нет наведения
                .buttonStyle(PlainButtonStyle())
                //.animation(.easeInOut(duration: 0.2)) // Анимация появления/исчезания

                
            }
            
            ,alignment: .topLeading)
        
        .onHover
        { hovering in
            withAnimation(Animation.easeInOut(duration: 0.2).delay(hovering ? 0.3 : 0))
            {
                self.isHovered = hovering
            }
        }

        

    }
}


struct PressedEditCardButtonStyle: ButtonStyle
{
    func makeBody(configuration: Self.Configuration) -> some View
    {
        configuration.label
            .padding()
            .background(configuration.isPressed ? Color.blue : Color.red)
            //.foregroundColor(.white)
            //.cornerRadius(10)
    }
}




#Preview
{
    TestView()
}


