//
//  WindowController.swift
//  Gradify
//
//  Created by Андрiй on 11.12.2023.
//

import AppKit
import SwiftUI
import Cocoa

class WindowController: NSWindowController, ObservableObject, Identifiable//, NSWindowDelegate//, ObservableObject
{
    var loginData: LoginModel
    var aboutAppWindow: NSWindow

    init(window: NSWindow, aboutAppWindow: NSWindow, loginModel: LoginModel = LoginModel())
    {
        self.loginData = loginModel
        self.aboutAppWindow = aboutAppWindow
        super.init(window: window)
    }// init
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }// required init
    
    convenience init()  // NEED REFACTOR!!!!
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
        
        let aboutAppWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 470, height: 200),
            styleMask: [.closable, .titled],
            backing: .buffered, defer: false)
        
        aboutAppWindow.isReleasedWhenClosed = false
        aboutAppWindow.isMovableByWindowBackground = true
        aboutAppWindow.titlebarAppearsTransparent = true
        aboutAppWindow.standardWindowButton(.zoomButton)?.isHidden = true
        aboutAppWindow.standardWindowButton(.miniaturizeButton)?.isHidden = true
        //aboutAppWindow.isMovableByWindowBackground = true
        
        let hostingController = NSHostingController(rootView: AboutAppView())
        aboutAppWindow.contentView = NSHostingView(rootView: hostingController.rootView)
        
        aboutAppWindow.styleMask.update(with: .fullSizeContentView)
        aboutAppWindow.center()
        
        self.init(window: window, aboutAppWindow: aboutAppWindow)
        self.initMenuBar()
    }// func convenience init
    
    /*
    func initAboutWindow() -> NSWindow
    {
        return NSWindow()
    }
     */
    
    func initMenuBar()
    {
        let mainMenu = NSMenu()
        NSApp.mainMenu = mainMenu
        
        let appMenuItem = NSMenuItem()
        mainMenu.addItem(appMenuItem)
        
        let appMenuFirst = NSMenu()
        appMenuItem.submenu = appMenuFirst
        
        appMenuFirst.addItem(withTitle: "Про Gradify", action: #selector(showAboutAppPanelAction(_:)), keyEquivalent: "")
        appMenuFirst.addItem(.separator())
        appMenuFirst.addItem(withTitle: "Параметри", action: #selector(NSApplication.terminate), keyEquivalent: ",") // !!!
        appMenuFirst.addItem(.separator())
        appMenuFirst.addItem(withTitle: "Сховати Gradify", action: #selector(NSApplication.hide(_:)), keyEquivalent: "h")
        
        let menuItemHideAll = NSMenuItem()
        menuItemHideAll.title = "Сховати решту"
        menuItemHideAll.action = #selector(NSApplication.hideOtherApplications(_:))
        menuItemHideAll.keyEquivalentModifierMask = [.option, .command]
        menuItemHideAll.keyEquivalent = "h"
        appMenuFirst.addItem(menuItemHideAll)
        //menuItem.keyEquivalentModifierMask
        
        appMenuFirst.addItem(withTitle: "Показати всі", action: #selector(NSApplication.unhideAllApplications(_:)), keyEquivalent: "")
        appMenuFirst.addItem(.separator())
        appMenuFirst.addItem(withTitle: "Завершити Gradify", action: #selector(NSApplication.terminate), keyEquivalent: "q")
        
        
        let secondMenuItem = NSMenuItem()
        mainMenu.addItem(secondMenuItem)
        
        let secondMenu = NSMenu()
        secondMenu.title = "Файл"
        
        secondMenuItem.submenu = secondMenu
        secondMenu.addItem(withTitle: "Test", action: #selector(NSApplication.showHelp(_:)), keyEquivalent: "")

        // second menu
        let thirdMenuItem = NSMenuItem()
        mainMenu.addItem(thirdMenuItem)
        
        let thirdMenu = NSMenu()
        thirdMenu.title = "Редагування"
        
        thirdMenuItem.submenu = thirdMenu
        
        thirdMenu.addItem(withTitle: "Відмінити", action: Selector(("undo:")), keyEquivalent: "z")
        thirdMenu.addItem(withTitle: "Повторити", action: Selector(("redo:")), keyEquivalent: "Z")
        thirdMenu.addItem(.separator())
        thirdMenu.addItem(withTitle: "Вирізати", action: #selector(NSText.cut(_:)), keyEquivalent: "x")
        thirdMenu.addItem(withTitle: "Скопіювати", action: #selector(NSText.copy(_:)), keyEquivalent: "c")
        thirdMenu.addItem(withTitle: "Вставити", action: #selector(NSText.paste(_:)), keyEquivalent: "v")
        thirdMenu.addItem(withTitle: "Видалити", action: #selector(NSText.delete(_:)), keyEquivalent: "")
        thirdMenu.addItem(withTitle: "Вибрати все", action: #selector(NSText.selectAll(_:)), keyEquivalent: "a")
        thirdMenu.addItem(.separator())
        
        // this work don't use this
        //thirdMenu.addItem(withTitle: "Автозаповнення", action: #selector(NSApplication.copy), keyEquivalent: "") // !
        //thirdMenu.addItem(withTitle: "Почати диктування", action: #selector(NSApplication.copy), keyEquivalent: "") // !
        //thirdMenu.addItem(withTitle: "Емодзі та символи", action: #selector(NSApplication.copy), keyEquivalent: "") // !

        //!!!!
        //secondMenuItem.title = "Файл"
        
        let fourthMenuItem = NSMenuItem()
        mainMenu.addItem(fourthMenuItem)
        
        let fourthMenu = NSMenu()
        fourthMenu.title = "Вікно"
        fourthMenuItem.submenu = fourthMenu
        
        //NSApplication.miniaturizeAll(nil)
        //NSApp.windows.first?.isAccessibilityMinimized()
        
        // performZoom
        //NSApplication.shared.windows.
        
        //self.window?.performZoom(_:)
        
                                
        fourthMenu.addItem(withTitle: "Згорнути", action: #selector(minimizeAction(_:)), keyEquivalent: "m")
        fourthMenu.addItem(withTitle: "Оптимізувати", action: #selector(performZoomAction(_:)), keyEquivalent: "")
        
        // need fix down commands!!
        
        fourthMenu.addItem(withTitle: "Розмістити вікно ліворуч на екрані", action: #selector(NSApplication.showHelp(_:)), keyEquivalent: "")
        fourthMenu.addItem(withTitle: "Розмістити вікно праворуч на екрані", action: #selector(NSApplication.showHelp(_:)), keyEquivalent: "")
        fourthMenu.addItem(withTitle: "Замінити суміжне вікно", action: #selector(NSApplication.showHelp(_:)), keyEquivalent: "")
        fourthMenu.addItem(.separator())
        fourthMenu.addItem(withTitle: "Вилучити вікно з вибору", action: #selector(NSApplication.showHelp(_:)), keyEquivalent: "")
        fourthMenu.addItem(withTitle: "Наступне вікно", action: #selector(NSApplication.showHelp(_:)), keyEquivalent: "")
        fourthMenu.addItem(withTitle: "Показати вікно перебігу", action: #selector(NSApplication.showHelp(_:)), keyEquivalent: "")
        fourthMenu.addItem(.separator())
        fourthMenu.addItem(withTitle: "Показати попередню вкладку", action: #selector(NSApplication.showHelp(_:)), keyEquivalent: "")
        fourthMenu.addItem(withTitle: "Показати наступну вкладку", action: #selector(NSApplication.showHelp(_:)), keyEquivalent: "")
        fourthMenu.addItem(withTitle: "Винести вкладку в нове вікно", action: #selector(NSApplication.showHelp(_:)), keyEquivalent: "")
        fourthMenu.addItem(withTitle: "Обʼєднати всі вікна", action: #selector(NSApplication.showHelp(_:)), keyEquivalent: "")
        fourthMenu.addItem(.separator())
        fourthMenu.addItem(withTitle: "Всі наперед", action: #selector(NSApplication.showHelp(_:)), keyEquivalent: "")



        
        let fifthMenuItem = NSMenuItem()
        mainMenu.addItem(fifthMenuItem)
        
        let fifthMenu = NSMenu()
        fifthMenu.title = "Довідка"
        fifthMenuItem.submenu = fifthMenu
        
        fifthMenu.addItem(withTitle: "Довідка Gradify", action: #selector(NSApplication.showHelp(_:)), keyEquivalent: "")
        fifthMenu.addItem(.separator())
        fifthMenu.addItem(withTitle: "Онлайн довідка", action: #selector(NSApplication.showHelp(_:)), keyEquivalent: "")

    }// func initMenuBar()

    @objc func showAboutAppPanelAction(_ sender: Any?)
    {
        self.aboutAppWindow.makeKeyAndOrderFront(nil)
        self.aboutAppWindow.windowController?.showWindow(nil)
    }// @objc func showAboutAppPanelAction(_ sender: Any?)
    
    @objc func performZoomAction(_ sender: Any?)
    {
        if let activeWindow = NSApplication.shared.keyWindow
        {
            activeWindow.performZoom(nil)
        }
    }// @objc func performZoomAction(_ sender: Any?)

    @objc func minimizeAction(_ sender: Any?)
    {
        if let activeWindow = NSApplication.shared.keyWindow
        {
            activeWindow.miniaturize(nil)
        }
    }

    @objc func tileFullScreen(_ sender: Any?)
    {
        if let activeWindow = NSApplication.shared.keyWindow
        {
            activeWindow.toggleFullScreen(nil)
        }
    }
    
    
    
    func setMainWindow()
    {
        let hostingController = NSHostingController(rootView: MainMenuView())
        
        window?.contentView = NSHostingView(rootView: hostingController.rootView)
        window?.isMovableByWindowBackground = false
        window?.center()
        
        useMiniWindow(status: false)
        useTranspertTitleBar(status: false)
    }// func setMainWindow

    
    func setLoginWindow()
    {
        let hostingController = NSHostingController(rootView: AuthView(loginData: loginData, windowController: self))
        
        window?.contentView = NSHostingView(rootView: hostingController.rootView)
        window?.isMovableByWindowBackground = true
        window?.center()
        
        useMiniWindow(status: false)
        useTranspertTitleBar(status: true)
    }// func setLoginWindow()

    func setStartWindow()
    {
        let hostingController = NSHostingController(rootView: StartView(windowController: self))
        
        window?.contentView = NSHostingView(rootView: hostingController.rootView)
        window?.isMovableByWindowBackground = true
        window?.center()

        useMiniWindow(status: true)
        useTranspertTitleBar(status: true)
    }// func setStartWindow()
        
    func setCurrentWindow()
    {
        // opens a specific window depending on what the user has been doing since the application started opening
        setStartWindow()
        //setLoginWindow()
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

