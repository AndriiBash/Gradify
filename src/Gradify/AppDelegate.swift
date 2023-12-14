//
//  AppDelegate.swift
//  Gradify
//
//  Created by Андрiй on 22.11.2023.
//

import Foundation
import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate
{
    //func applicationWillBecomeActive(_ notification: Notification)
    //{
    //    (notification.object as? NSApplication)?.windows.first?.makeKeyAndOrderFront(self)
    //}
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool
    {
        NSApp.windows.first?.makeKeyAndOrderFront(self)

        // Logic when the user clicks on an icon in the Dock
        // and the application is already active, but it has no open windows
        /*if !flag
        {
            if NSApp.isActive && (NSApp.windows.isEmpty || NSApp.windows.contains { !$0.isVisible })
            {
                // Logic when the window is active but not visible
                print("applicationShouldHandleReopen - Window is active but not visible")
                NSApp.windows.first?.makeKeyAndOrderFront(self)
            }
            else
            {
                // Otherwise, if the window is visible, just activate it
                NSApp.windows.first?.makeKeyAndOrderFront(self)
                print("applicationShouldHandleReopen")
            }
        }
         */

        return true
    }
    
}
