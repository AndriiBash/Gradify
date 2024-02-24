//
//  MainMenuView.swift
//  Gradify
//
//  Created by Андрiй on 29.10.2023.
//

import SwiftUI

struct MainMenuView: View
{
    // Temp trash
    @State private var searchText: String = ""
    @State private var expandAllList: Bool = false
    @State var sideBarVisibility: NavigationSplitViewVisibility = .doubleColumn
    @State private var isShowTestWindow = false

    // Current, and used element
    @State var filterModels:                        [FilterViewModel] = Array(repeating: FilterViewModel(), count: 10)
    @State private var columnVisibility             = NavigationSplitViewVisibility.detailOnly
    
    
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
                            StudentInfoView(filterModel: filterModels[0])
                        }
                        label:
                        {
                            Label("Студенти", systemImage: "graduationcap")
                        }// NavigationLink with student's
                        
                        NavigationLink
                        {
                            EmptyView()
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
                            EmptyView()
                        }
                        label:
                        {
                            Label("Оцінки", systemImage: "list.star")
                        }// NavigationLink with grades

                        NavigationLink
                        {
                            EmptyView()
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
                            EmptyView()
                        }
                        label:
                        {
                            Label("Викладачі", systemImage: "person")
                        }// NavigationLink with teacher's
                        
                        NavigationLink
                        {
                            EmptyView()
                        }
                        label:
                        {
                            Label("Кафедра", systemImage: "globe.desk")
                        }// NavigationLink with chair's

                        NavigationLink
                        {
                            EmptyView()
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
                            EmptyView()
                        }
                        label:
                        {
                            Label("Спеціалізація", systemImage: "doc.text.magnifyingglass")
                        }// NavigationLink with Specialization
                        
                        NavigationLink
                        {
                            EmptyView()
                        }
                        label:
                        {
                            Label("Спеціальність", systemImage: "hammer.fill")
                        }// NavigationLink with Specialty
                        
                        NavigationLink
                        {
                            EmptyView()
                        }
                        label:
                        {
                            Label("Освітня програма", systemImage: "book.and.wrench.fill")
                        }// NavigationLink with Specialty
                    }// Section with specialization and teach programm
                } // List with section
                .safeAreaInset(edge: .bottom)
                {
                    Button
                    {
                        print("test setting")
                        isShowTestWindow.toggle()
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
                } // button auth for test
            }// ZStack
        } // NavigationSplitView(columnVisibility: $columnVisibility)
        detail:
        {
            VStack
            {
                Text("Go auth")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("startView")
        }//detail if no selected
        
        //.background(Color.red)
        //.toolbarBackground(Color.pink, for: .automatic)
        //.toolbarBackground(Color.red, for: .windowToolbar)
        .searchable(text: $searchText, placement: .sidebar, prompt: "Пошук")
        .sheet(isPresented: $isShowTestWindow)
        {
            ButtonViewModel()
        }
        
        //.sheet(item: $isShowTestWindow, content: ButtonView())
        //.frame(minWidth: 550)
         
    }
}

#Preview
{
    MainMenuView()
}
