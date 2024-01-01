
//  WindowController.swift
//  Gradify
//
//  Created by Андрiй on 11.12.2023.
//

import AppKit
import SwiftUI
import Cocoa

enum WindowType: CaseIterable
{
    case main
    case login
    case start
    case empty // just example
}// enum WindowType

class WindowController: NSWindowController, NSWindowDelegate, ObservableObject, Identifiable
{
    var loginData: LoginModel
    var aboutAppWindow: NSWindow
    private var tabbedWindows = [NSWindow]()

    // MARK: - Init
    init(window: NSWindow, aboutAppWindow: NSWindow, loginModel: LoginModel = LoginModel())
    {
        self.loginData = loginModel
        self.aboutAppWindow = aboutAppWindow
        super.init(window: window)
        window.delegate = self
    }// init
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }// required init
    
    override func windowDidLoad()
    {
        super.windowDidLoad()
        self.window?.delegate = self
    } // override func windowDidLoad()
    
    convenience init()  // NEED REFACTOR!!!!
    {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 300),
            styleMask: [.miniaturizable, .closable, .resizable, .titled],
            backing: .buffered, defer: false)
        
        window.isReleasedWhenClosed = true

        window.styleMask.update(with: .fullSizeContentView)
        window.center()
        
        let aboutAppWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 470, height: 200),
            styleMask: [.closable, .titled],
            backing: .buffered, defer: false)
        
        aboutAppWindow.isReleasedWhenClosed = false
        aboutAppWindow.isMovableByWindowBackground = true
        aboutAppWindow.titlebarAppearsTransparent = true
        aboutAppWindow.standardWindowButton(.zoomButton)?.isHidden = true
        aboutAppWindow.standardWindowButton(.miniaturizeButton)?.isHidden = true
 
        let hostingController = NSHostingController(rootView: AboutAppView())
        aboutAppWindow.contentView = NSHostingView(rootView: hostingController.rootView)
        
        aboutAppWindow.styleMask.update(with: .fullSizeContentView)
        aboutAppWindow.center()
        
        self.init(window: window, aboutAppWindow: aboutAppWindow)
        self.initMenuBar()
        
        window.delegate = self
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
        
        appMenuFirst.addItem(withTitle: "Показати всі", action: #selector(NSApplication.unhideAllApplications(_:)), keyEquivalent: "")
        appMenuFirst.addItem(.separator())
        appMenuFirst.addItem(withTitle: "Завершити Gradify", action: #selector(NSApplication.terminate), keyEquivalent: "q")
        
        let secondMenuItem = NSMenuItem()
        mainMenu.addItem(secondMenuItem)
        
        let secondMenu = NSMenu()
        secondMenu.title = "Файл"
        
        secondMenuItem.submenu = secondMenu
        secondMenu.addItem(withTitle: "Test", action: #selector(NSApplication.showHelp(_:)), keyEquivalent: "")

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
                
        let fourthMenuItem = NSMenuItem()
        mainMenu.addItem(fourthMenuItem)
        
        let fourthMenu = NSMenu()
        fourthMenu.title = "Перегляд"
        fourthMenuItem.submenu = fourthMenu
        
        fourthMenu.addItem(withTitle: "Показати бічну панель", action: #selector(NSSplitViewController.toggleSidebar(_:)), keyEquivalent: "S")
        fourthMenu.addItem(.separator())
        
        let menuItemToggleInstrumentPanel = NSMenuItem()
        menuItemToggleInstrumentPanel.title = "Сховати панель інструментів"
        menuItemToggleInstrumentPanel.action = #selector(window?.toggleToolbarShown(_:))
        menuItemToggleInstrumentPanel.keyEquivalentModifierMask = [.option, .command]
        menuItemToggleInstrumentPanel.keyEquivalent = "t"
        fourthMenu.addItem(menuItemToggleInstrumentPanel)

        let menuItemToggleFullScreen = NSMenuItem()
        menuItemToggleFullScreen.title = "Увійти до повноекранного режиму"
        menuItemToggleFullScreen.action = #selector(window?.toggleFullScreen(_:))
        menuItemToggleFullScreen.keyEquivalentModifierMask = [.function]
        menuItemToggleFullScreen.keyEquivalent = "f"
        fourthMenu.addItem(menuItemToggleFullScreen)
        
        let fifthMenuItem = NSMenuItem()
        mainMenu.addItem(fifthMenuItem)
        
        let fifthMenu = NSMenu()
        fifthMenu.title = "Вікно"
        fifthMenuItem.submenu = fifthMenu

        
                                
        fifthMenu.addItem(withTitle: "Згорнути", action: #selector(minimizeAction(_:)), keyEquivalent: "m")
        fifthMenu.addItem(withTitle: "Оптимізувати", action: #selector(performZoomAction(_:)), keyEquivalent: "")
        // fifthMenu.addItem(withTitle: "Розмістити вікно ліворуч на екрані", action: #selector(window?.left(_:)), keyEquivalent: "")
        // fifthMenu.addItem(withTitle: "Розмістити вікно праворуч на екрані", action: #selector(performZoomAction(_:)), keyEquivalent: "")
        
        
        
        fifthMenu.addItem(.separator())
        fifthMenu.addItem(withTitle: "Показати панель вкладок", action: #selector(window?.toggleTabBar(_:)), keyEquivalent: "S")
        fifthMenu.addItem(withTitle: "Показати всі вкладки", action: #selector(window?.toggleTabOverview(_:)), keyEquivalent: "\\")
        fifthMenu.addItem(.separator())
                
        let menuItemShowPreviousTab = NSMenuItem()
        menuItemShowPreviousTab.title = "Показати попередню вкладку"
        menuItemShowPreviousTab.action = #selector(window?.selectPreviousTab(_:))
        menuItemShowPreviousTab.keyEquivalentModifierMask = [.control, .shift]
        menuItemShowPreviousTab.keyEquivalent = "\u{0009}"
        fifthMenu.addItem(menuItemShowPreviousTab)

        let menuItemShowNextTab = NSMenuItem()
        menuItemShowNextTab.title = "Показати наступну вкладку"
        menuItemShowNextTab.action = #selector(window?.selectNextTab(_:))
        menuItemShowNextTab.keyEquivalentModifierMask = [.control]
        menuItemShowNextTab.keyEquivalent = "\u{0009}"
        fifthMenu.addItem(menuItemShowNextTab)

        fifthMenu.addItem(withTitle: "Винести вкладку в нове вікно", action: #selector(window?.moveTabToNewWindow(_:)), keyEquivalent: "")
        fifthMenu.addItem(withTitle: "Обʼєднати всі вікна", action: #selector(window?.mergeAllWindows(_:)), keyEquivalent: "")
        fifthMenu.addItem(.separator())
        fifthMenu.addItem(withTitle: "Всі наперед", action: #selector(window?.orderFront(_:)), keyEquivalent: "")
        
        let sixthMenuItem = NSMenuItem()
        mainMenu.addItem(sixthMenuItem)
        
        let sixthMenu = NSMenu()
        sixthMenu.title = "Довідка"
        sixthMenuItem.submenu = sixthMenu
        
        sixthMenu.addItem(withTitle: "Довідка Gradify", action: #selector(NSApplication.showHelp(_:)), keyEquivalent: "")
        sixthMenu.addItem(.separator())
        sixthMenu.addItem(withTitle: "Онлайн довідка", action: #selector(NSApplication.showHelp(_:)), keyEquivalent: "")

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
    }// @objc func minimizeAction(_ sender: Any?)

    @objc func tileFullScreen(_ sender: Any?)
    {
        if let activeWindow = NSApplication.shared.keyWindow
        {
            activeWindow.toggleFullScreen(nil)
        }
    }// @objc func tileFullScreen(_ sender: Any?)
    
    @IBAction override func newWindowForTab(_ sender: Any?)
    {
        addNewTab()
    }// @IBAction override func newWindowForTab(_ sender: Any?)
    
    func addNewTab()
    {
            let newWindow = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 500, height: 300),
                styleMask: [.miniaturizable, .closable, .resizable, .titled],
                backing: .buffered, defer: false)

            let hostingController = NSHostingController(rootView: MainMenuView())

            newWindow.styleMask.update(with: .fullSizeContentView)
            newWindow.contentView = NSHostingView(rootView: hostingController.rootView)

            self.tabbedWindows.append(newWindow)
            self.window?.addTabbedWindow(newWindow, ordered: .above)
            newWindow.makeKeyAndOrderFront(nil)
    }// func addNewTab()
    
    func windowWillClose(_ notification: Notification)
    {
        guard let closedWindow = notification.object as? NSWindow
        else
        {
            return
        }

        if closedWindow != self.window
        {
            if let index = self.tabbedWindows.firstIndex(where: { $0 === closedWindow })
            {
                self.tabbedWindows.remove(at: index)
            }
        }

        /*
        if closedWindow === self.window
        {
            // if close main window
            //NSApplication.shared.terminate(self)
        }
        else
        {
            removeTabbedWindow(closedWindow)
        } */
    }// func windowWillClose(_ notification: Notification)
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setter window (views)
    
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
        let hostingController = NSHostingController(rootView: LoginView(loginData: loginData, windowController: self))
        
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
        
    func setCurrentWindow(ofType type: WindowType)
    {
        switch type
        {
        case .main:
            return setMainWindow()
        case .login:
            return setLoginWindow()
        case .start:
            return setStartWindow()
        default:
            return setStartWindow()
        }
    }// func setCurrentWindow()
    
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
}

