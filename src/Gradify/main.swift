//
//  main.swift
//  Gradify
//
//  Created by Андрiй on 18.12.2023.
//

import AppKit
import Firebase
import SwiftUI

final class GradifyApp
{
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init()
    {
        FirebaseApp.configure()
     
        let windowController = WindowController()

        windowController.setCurrentWindow()
        windowController.showWindow(nil)
        
        let app = NSApplication.shared
        let delegate = AppDelegate()
        app.delegate = delegate

        _ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)

    }
}

_ = GradifyApp()
