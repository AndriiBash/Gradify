//
//  GradifyApp.swift
//  Gradify
//
//  Created by Андрiй on 25.10.2023.
//

import SwiftUI
import Firebase

@main
struct GradifyApp: App
{
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    //var screen = NSScreen.main?.visibleFrame
    //var windowController = WindowController()
    
    init()
    {
        FirebaseApp.configure()

        let windowController = WindowController()
        
        windowController.setStartWindow()
        windowController.showWindow(nil)
    }
    
    var body: some Scene
    {
        MenuBarExtra
        {
            Text("Hello Status Bar Menu!")
            Divider()
            Button("shoow window mian") { }
            
            Button("Quit")
            {
                NSApp.terminate(nil)
            }
        }
        label:
        {
            Image(systemName: "graduationcap.fill")
        }
        .commandsRemoved()
         
    }
    
}

