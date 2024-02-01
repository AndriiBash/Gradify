//
//  MainMenuView.swift
//  Gradify
//
//  Created by Андрiй on 29.10.2023.
//

import SwiftUI

struct MainMenuView: View
{
    @State private var selection: String? = "Item1"
    @State private var searchText: String = ""
    @State private var columnVisibility = NavigationSplitViewVisibility.detailOnly

    @State var sideBarVisibility: NavigationSplitViewVisibility = .doubleColumn

    
    @State private var isShowTestWindow = false

    
    
    var body: some View
    {
        
        NavigationSplitView(columnVisibility: $columnVisibility)
        {
            ZStack
            {
                Color("BackgroundLeftLoginView").opacity(0.1).ignoresSafeArea()
                
                List
                {
                    Section("Test item")
                    {
                        NavigationLink(destination: GroupInfoView(), tag: "Item1", selection: $selection)
                        {
                            Label("Групи", systemImage: "person.3.fill")
                        }
                        
                        NavigationLink(destination: TempView(), tag: "Item2", selection: $selection)
                        {
                            Label("Item 2", systemImage: "square.fill")
                        }
                        
                        NavigationLink(destination:  ScrollView{Text("Item3").background(Color.red).frame(maxWidth: .infinity, maxHeight: .infinity)}, tag: "Item3", selection: $selection)
                        {
                            HStack
                            {
                                Image(systemName: "doc.fill")
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30, height: 30, alignment: .center)
                                
                                VStack
                                {
                                    Text("Title")
                                        .font(.body.bold())
                                    
                                    Text("Body")
                                        .font(.callout)
                                }
                            }//HStack test in SideBar
                            .padding(.horizontal, 4)
                        }
                        
                        NavigationLink(destination: ButtonViewModel(), tag: "AnimationButton", selection: $selection)
                        {
                            Label("Item 2", systemImage: "square.fill")
                        }
                        
                        
                    }// Section 1
                } // List
                .safeAreaInset(edge: .bottom)
                {
                    Button
                    {
                        print("test setting")
                        isShowTestWindow.toggle()
                    }
                    label:
                    {
                        Image(systemName: "gearshape.fill")
                        Text("Налаштування")
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
            Text("Go auth")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }//detail if no selected
        
        //.background(Color.red)
        //.toolbarBackground(Color.pink, for: .automatic)
        //.toolbarBackground(Color.red, for: .windowToolbar)
        .toolbar
        {
            Button
            {
                
            }
            label:
            {
                
            }// expand all list card in some view
            .help("Розгорнути усі списки")
            
            Button(action: {})
            {
                Text("TestButton")
                Image(systemName: "person")
            }
            .help("what does this button!!")
        }
        
        .searchable(text: $searchText, placement: .sidebar, prompt: "Пошук")
        .navigationTitle(selection ?? "Не обрано")
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
