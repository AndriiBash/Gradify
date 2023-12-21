//
//  AppDelegate.swift
//  Gradify
//
//  Created by Андрiй on 22.11.2023.
//

import SwiftUI
import Foundation
import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate
{
    
    //func applicationWillBecomeActive(_ notification: Notification)
    //{
    //    (notification.object as? NSApplication)?.windows.first?.makeKeyAndOrderFront(self)
    //}
    var statusItem: NSStatusItem?
    var popOver = NSPopover()
    
    func applicationDidFinishLaunching(_ notification: Notification)
    {
        let menuView = PopOverView()
        
        popOver.behavior = .transient
        popOver.animates = true
        
        popOver.contentViewController = NSViewController()
        popOver.contentViewController?.view = NSHostingView(rootView: menuView)
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let menuButton = statusItem?.button
        {
            menuButton.image = NSImage(systemSymbolName: "graduationcap.fill", accessibilityDescription: nil)
            menuButton.action = #selector(MenuButtonToogle)
        }

    }// func applicationDidFinishLaunching(_ notification: Notification)
    
    @objc func MenuButtonToogle()
    {
        guard let button = statusItem?.button else { return }

        if popOver.isShown
        {
            popOver.performClose(nil)
        }
        else
        {
            popOver.show(relativeTo: button.bounds, of: button, preferredEdge: .maxY)
        }
    }// @obj func MenuButtonToogle()
    
    func applicationDidEnterBackground(_ notification: Notification)
    {
        popOver.performClose(nil)
    }// func applicationDidEnterBackground(_ notification: Notification)
    
    func applicationDidResignActive(_ notification: Notification)
    {
        popOver.performClose(nil)
    }// func applicationDidResignActive(_ notification: Notification)
    
    func applicationDidBecomeActive(_ notification: Notification)
    {
        popOver.performClose(nil)
    }// func applicationDidBecomeActive(_ notification: Notification)
    
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
    
    //func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool { // ANENTION!!!
    //        return false
    //    }
    
}
