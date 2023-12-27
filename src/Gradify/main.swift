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
    init()
    {
        FirebaseApp.configure()

        let app = NSApplication.shared
        let delegate = AppDelegate()
        app.delegate = delegate

        _ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
    }
} // main class where start application

_ = GradifyApp()
