//
//  MainMenuView.swift
//  Gradify
//
//  Created by Андрiй on 29.10.2023.
//

import SwiftUI

struct MainMenuView: View
{
    @State private var expandAllList:   Bool = false
    @State var sideBarVisibility:       NavigationSplitViewVisibility = .doubleColumn

    @State private var columnVisibility = NavigationSplitViewVisibility.detailOnly
    
    var body: some View
    {
        NavigationSplitView(columnVisibility: $columnVisibility)
        {
            ZStack
            {
                Color("BackgroundLeftLoginView").opacity(0.1).ignoresSafeArea()
                
                List
                {
                    Section("Студенство")
                    {
                        NavigationLink
                        {
                            StudentInfoView()
                        }
                        label:
                        {
                            Label("Студенти", systemImage: "graduationcap")
                        }// NavigationLink with student's
                        
                        NavigationLink
                        {
                            GroupInfoView()
                        }
                        label:
                        {
                            Label("Групи", systemImage: "person.3.fill")
                        }// NavigationLink with groups
                    }// Section 1
                    
                    
                    Section("Навчання")
                    {
                        NavigationLink
                        {
                            GradeInfoView()
                        }
                        label:
                        {
                            Label("Оцінки", systemImage: "list.star")
                        }// NavigationLink with grades

                        NavigationLink
                        {
                            SubjectInfoView()
                        }
                        label:
                        {
                            Label("Предмети", systemImage: "book.pages")
                        }// NavigationLink with subjects
                    }// Section about learning and teaching
                    
                    
                    Section("Наукові відділи")
                    {
                        NavigationLink
                        {
                            TeacherInfoView()
                        }
                        label:
                        {
                            Label("Викладачі", systemImage: "person")
                        }// NavigationLink with teacher's
                        
                        NavigationLink
                        {
                            DepartamentInfoView()
                        }
                        label:
                        {
                            Label("Кафедра", systemImage: "globe.desk")
                        }// NavigationLink with chair's

                        NavigationLink
                        {
                            FacultyInfoView()
                        }
                        label:
                        {
                            Label("Факультет", systemImage: "building.columns.fill")
                        }// NavigationLink with faculty's

                    }// Section with about teacher's and departament
                    
                    
                    Section("Спеціалізації")
                    {
                        NavigationLink
                        {
                            SpecializationInfoView()
                        }
                        label:
                        {
                            Label("Спеціалізація", systemImage: "doc.text.magnifyingglass")
                        }// NavigationLink with Specialization
                        
                        NavigationLink
                        {
                            SpecialtyInfoView()
                        }
                        label:
                        {
                            Label("Спеціальність", systemImage: "hammer.fill")
                        }// NavigationLink with Specialty
                        
                        NavigationLink
                        {
                            EducationalProgramInfoView()
                        }
                        label:
                        {
                            Label("Освітня програма", systemImage: "book.and.wrench.fill")
                        }// NavigationLink with Specialty
                    }// Section with specialization and teach programm
                } // List with section
                /*
                .safeAreaInset(edge: .bottom)
                {
                    Button
                    {
                        print("test setting")
                        //isShowTestWindow.toggle()
                    }
                    label:
                    {
                        Image(systemName: "photo.circle.fill")
                        Text("ПІ юзера з аватаркою зліва")
                    }
                    //.keyboardShortcut(.defaultAction)
                    .padding(.bottom)
                    .buttonStyle(.borderless)
                    .foregroundColor(.accentColor)
                } // safeArea isert
                 */
            }// ZStack
        } // NavigationSplitView(columnVisibility: $columnVisibility)
        detail:
        {
            StartMainView()
        }//detail if no selected         
    }
}

#Preview
{
    MainMenuView()
}
