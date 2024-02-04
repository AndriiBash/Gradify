//
//  AppDelegate.swift
//  Gradify
//
//  Created by Андрiй on 22.11.2023.
//

import SwiftUI
import Firebase
import Foundation
import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate
{
    var statusItem: NSStatusItem?
    let popOver = NSPopover()
    
    var windowController: WindowController!
    var eventMonitor: EventMonitorController?
    
    // MARK: - Funcation's
    func applicationDidFinishLaunching(_ notification: Notification)
    {
        FirebaseApp.configure()

        windowController = WindowController()
        windowController.setCurrentWindow(ofType: .main) //.login
        windowController.showWindow(nil)
        
        
        // set popOver menu in right part menuBar
        let menuView = PopOverView()
                
        popOver.behavior = .transient
        popOver.animates = true
        
        popOver.contentViewController = NSViewController()
        popOver.contentViewController?.view = NSHostingView(rootView: menuView)
                
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
                
        if let menuButton = statusItem?.button
        {
            menuButton.image = NSImage(systemSymbolName: "graduationcap.fill", accessibilityDescription: nil)
            menuButton.action = #selector(togglePopover(_:))
        }
        
        eventMonitor = EventMonitorController(mask: [.leftMouseDown, .rightMouseDown])
        { [weak self] event in
            if let strongSelf = self, strongSelf.popOver.isShown
            {
                strongSelf.closePopover(sender: event)
            }
        }
    }// func applicationDidFinishLaunching(_ notification: Notification)
    
    @objc func togglePopover(_ sender: Any?)
    {
        if popOver.isShown
        {
            closePopover(sender: sender)
        }
        else
        {
            showPopover(sender: sender)
        }
    }// @objc func togglePopover(_ sender: Any?)

    func showPopover(sender: Any?)
    {
        if let button = statusItem?.button
        {
            popOver.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
        eventMonitor?.start()
    }// func showPopover(sender: Any?)
    
    func closePopover(sender: Any?)
    {
        popOver.performClose(sender)
        eventMonitor?.stop()
    }// func closePopover(sender: Any?)
    
    @IBAction func newWindowForTab(_ sender: Any?)
    {
        windowController.addNewTab()
    } // @IBAction func newWindowForTab(_ sender: Any?)
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool
    {
        NSApp.windows.first?.makeKeyAndOrderFront(self)
        return true
    } // func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool
        
}
