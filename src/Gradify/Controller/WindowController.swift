//
//  WindowController.swift
//  Gradify
//
//  Created by Андрiй on 11.12.2023.
//

import AppKit
import SwiftUI

class WindowController: NSWindowController//, NSWindowDelegate//, ObservableObject 
{
    var loginData: LoginModel

    init(window: NSWindow, loginModel: LoginModel = LoginModel())
    {
        self.loginData = loginModel
        super.init(window: window)
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init()
    {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 300),
            styleMask: [.miniaturizable, .closable, .resizable, .titled],
            backing: .buffered, defer: false)
        
        window.isReleasedWhenClosed = true

        //window.isMovableByWindowBackground = true   // move for click on bg
        window.styleMask.update(with: .fullSizeContentView)
        window.center()
        window.makeKey()
        
        //window.standardWindowButton(.closeButton)?.action = Selector("")
        
        self.init(window: window)
        
    }// func convenience init

    func setMainWindow()
    {
        let hostingController = NSHostingController(rootView: MainMenuView())
        
        window?.contentView = NSHostingView(rootView: hostingController.rootView)
        window?.center()

        useMiniWindow(status: false)
        useTranspertTitleBar(status: false)
    }// func setMainWindow
    
    func setLoginWindow()
    {
        let hostingController = NSHostingController(rootView: AuthView(loginData: loginData, windowController: self))
        
        //window?.contentView = nil
        window?.contentView = NSHostingView(rootView: hostingController.rootView)
        window?.center()
        
        useMiniWindow(status: false)
        useTranspertTitleBar(status: true)
    }// func setLoginWindow()

    func setStartWindow()
    {
        let hostingController = NSHostingController(rootView: StartView(windowController: self))
        
        window?.contentView = NSHostingView(rootView: hostingController.rootView)
        window?.center()

        useMiniWindow(status: true)
        useTranspertTitleBar(status: true)
    }// func setStartWindow()
        
    func setCurrentWindow()
    {
        // opens a specific window depending on what the user has been doing since the application started opening
        setStartWindow()
        
        //setStartWindow()
        //updateWindowContent()
        
    }// func setCurrentWindow()
    
   /*
    func updateWindowContent()
    {
        if let authView = window?.contentView as? NSHostingView<AuthView>
        {
            // Обновляем содержимое AuthView при изменении loginData
            loginData = authView.rootView.loginData
        }
    }
    */
    
    func useMiniWindow(status: Bool)
    {
        window?.standardWindowButton(.zoomButton)?.isHidden = status
        window?.standardWindowButton(.miniaturizeButton)?.isHidden = status
    }// func useMiniWindowStyle(status: Bool)

    func useTranspertTitleBar(status: Bool)
    {
        window?.titlebarAppearsTransparent = status
    }// func useTranspertTitleBar(status: Bool)
    
    func setTitleNameWindow(title: String)
    {
        window?.title = title
    }// func setTitleNameWindow(title: String)

    
    //func windowWillClose(_ notification: Notification)
    //{
    //   window?.windowController?.showWindow(nil)
        // Additional cleanup or actions when the window is closed.
    //}// func windowWillClose
   
}

