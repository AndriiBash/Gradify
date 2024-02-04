//
//  StudentListView.swift
//  Gradify
//
//  Created by Андрiй on 03.02.2024.
//

import SwiftUI
import FirebaseAuth

struct StudentListView: View
{
    @Binding var studentList: StudentGroup // Change type to StudentGroup
    @Binding var isExpandList: Bool
    
    @State private var isScrollViewOpen: Bool = false
    @State private var isAnimateButtonScrollview: Bool = false
    @State private var scrollViewHeight: CGFloat = 0
    
    private let adaptiveColumns = [GridItem(.adaptive(minimum: 160))]
    
    var body: some View
    {
        HStack
        {
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
                HStack
                {
                    Text(studentList.name)
                        .foregroundColor(Color("MainTextForBlur"))
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Image(systemName: isAnimateButtonScrollview ? "chevron.down" : "chevron.right")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15, alignment: .center)
                        .foregroundColor(Color("MainTextForBlur"))
                }//Hstack button label
                .background(Color.clear)
                .contentShape(Rectangle())
            }// button for hide or unhine card with info
            .buttonStyle(PlainButtonStyle())

            Spacer()
        }//Button for expand list group student's
        .padding(.horizontal, 20)
        .onChange(of: isExpandList)
        { _,newValue in
            isAnimateButtonScrollview = newValue
            isScrollViewOpen = newValue
            
            withAnimation(Animation.easeInOut(duration: 0.2)) {
                scrollViewHeight = newValue ? 190 : 0
            }
        }
        
        ScrollView(.horizontal, showsIndicators: false)
        {
            LazyHGrid(rows: adaptiveColumns, spacing: 20)
            {
                ForEach(studentList.students)
                { student in
                    StudentCardViewModel(name: student.name, lastName: student.lastName, group: student.group)
                        .transition(.opacity)
                }
            }
            .padding(.horizontal, 17)
        }
        .frame(height: scrollViewHeight)
        
    }
}



struct StudentListView_Previews: PreviewProvider
{
    @State private static var listGroup = StudentGroup(name: "Some Group", students: [Student]())
    @State private static var isExapndAllList: Bool = false
    
    static var previews: some View
    {
        StudentListView(studentList: $listGroup, isExpandList: $isExapndAllList)
    }
}
