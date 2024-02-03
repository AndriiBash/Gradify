//
//  main.swift
//  Gradify
//
//  Created by Андрiй on 18.12.2023.
//

import AppKit

/*
 _____               _ _  __
|  __ \             | (_)/ _|
| |  \/_ __ __ _  __| |_| |_ _   _
| | __| '__/ _` |/ _` | |  _| | | |
| |_\ \ | | (_| | (_| | | | | |_| |
 \____/_|  \__,_|\__,_|_|_|  \__, |
                              __/ |
                             |___/
 
 gitHub: https://github.com/AndriiBash/Gradify
 author: Andrii Izbash (Andrii Bash)
 */

final class GradifyApp
{
    init()
    {
        let app = NSApplication.shared
        let delegate = AppDelegate()
        app.delegate = delegate

        _ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
    }
} // main class where start application

_ = GradifyApp()
