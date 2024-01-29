
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
    var settingAppWindow: NSWindow
    private var tabbedWindows = [NSWindow]()

    
    // MARK: - Init
    init(window: NSWindow, aboutAppWindow: NSWindow, settingAppWindow: NSWindow, loginModel: LoginModel = LoginModel())
    {
        self.loginData = loginModel
        self.aboutAppWindow = aboutAppWindow
        self.settingAppWindow = settingAppWindow
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
    
    convenience init()  // NEED REFACTOR!!
    {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 300),
            styleMask: [.miniaturizable, .closable, .resizable, .titled],
            backing: .buffered, defer: false)
        
        window.isReleasedWhenClosed = true
        window.tabbingMode = .disallowed

        window.styleMask.update(with: .fullSizeContentView)
        window.center()
        
        let aboutAppWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 200),
            styleMask: [.closable, .titled],
            backing: .buffered, defer: false)
        
        aboutAppWindow.isReleasedWhenClosed = false
        aboutAppWindow.isMovableByWindowBackground = true
        aboutAppWindow.titlebarAppearsTransparent = true
        aboutAppWindow.standardWindowButton(.zoomButton)?.isHidden = true
        aboutAppWindow.standardWindowButton(.miniaturizeButton)?.isHidden = true
        aboutAppWindow.tabbingMode = .disallowed
        
        let aboutViewHostingController = NSHostingController(rootView: AboutAppView())
        aboutAppWindow.contentView = NSHostingView(rootView: aboutViewHostingController.rootView)
        
        aboutAppWindow.styleMask.update(with: .fullSizeContentView)
        aboutAppWindow.center()
                
        let settingAppWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 470, height: 200),
            styleMask: [.closable, .miniaturizable, .resizable, .titled],
            backing: .buffered, defer: false)
        
        settingAppWindow.isReleasedWhenClosed = false
        settingAppWindow.tabbingMode = .disallowed
        settingAppWindow.windowController?.window?.hidesOnDeactivate = true
        //settingAppWindow.titlebarAppearsTransparent = true
        //settingAppWindow.setContentSize(NSSize(width: 100, height: 400))

        let settingViewHostingController = NSHostingController(rootView: SettingView())
        settingAppWindow.contentView = NSHostingView(rootView: settingViewHostingController.rootView)

        settingAppWindow.styleMask.update(with: .fullSizeContentView)
        settingAppWindow.center()
        
        self.init(window: window, aboutAppWindow: aboutAppWindow, settingAppWindow: settingAppWindow)
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
        
        appMenuFirst.addItem(withTitle: String(localized: "Про Gradify"), action: #selector(showAboutAppPanelAction(_:)), keyEquivalent: "")
        appMenuFirst.addItem(.separator())
        appMenuFirst.addItem(withTitle: String(localized: "Параметри..."), action: #selector(showSettingAppAction(_:)), keyEquivalent: ",")
        appMenuFirst.addItem(.separator())
        appMenuFirst.addItem(withTitle: String(localized: "Сховати Gradify"), action: #selector(NSApplication.hide(_:)), keyEquivalent: "h")
        
        let menuItemHideAll = NSMenuItem()
        menuItemHideAll.title = String(localized: "Сховати решту")
        menuItemHideAll.action = #selector(NSApplication.hideOtherApplications(_:))
        menuItemHideAll.keyEquivalentModifierMask = [.option, .command]
        menuItemHideAll.keyEquivalent = "h"
        appMenuFirst.addItem(menuItemHideAll)
        
        appMenuFirst.addItem(withTitle: String(localized: "Показати всі"), action: #selector(NSApplication.unhideAllApplications(_:)), keyEquivalent: "")
        appMenuFirst.addItem(.separator())
        appMenuFirst.addItem(withTitle: String(localized: "Завершити Gradify"), action: #selector(NSApplication.terminate), keyEquivalent: "q")
        
        let secondMenuItem = NSMenuItem()
        mainMenu.addItem(secondMenuItem)
        
        let secondMenu = NSMenu()
        secondMenu.title = String(localized: "Файл")
        
        // !!!!
        secondMenuItem.submenu = secondMenu
        secondMenu.addItem(withTitle: "Test", action: #selector(NSApplication.showHelp(_:)), keyEquivalent: "")

        let thirdMenuItem = NSMenuItem()
        mainMenu.addItem(thirdMenuItem)
        
        let thirdMenu = NSMenu()
        
        thirdMenu.title = String(localized: "Редагування")
        thirdMenuItem.submenu = thirdMenu
            
        thirdMenu.addItem(withTitle: String(localized: "Відмінити"), action: Selector(("undo:")), keyEquivalent: "z")
        thirdMenu.addItem(withTitle: String(localized: "Повторити"), action: Selector(("redo:")), keyEquivalent: "Z")
        thirdMenu.addItem(.separator())
        thirdMenu.addItem(withTitle: String(localized: "Вирізати"), action: #selector(NSText.cut(_:)), keyEquivalent: "x")
        thirdMenu.addItem(withTitle: String(localized: "Скопіювати"), action: #selector(NSText.copy(_:)), keyEquivalent: "c")
        thirdMenu.addItem(withTitle: String(localized: "Вставити"), action: #selector(NSText.paste(_:)), keyEquivalent: "v")
        thirdMenu.addItem(withTitle: String(localized: "Видалити"), action: #selector(NSText.delete(_:)), keyEquivalent: "")
        thirdMenu.addItem(withTitle: String(localized: "Вибрати все"), action: #selector(NSText.selectAll(_:)), keyEquivalent: "a")
        thirdMenu.addItem(.separator())
        
        /// need fix :(
        //thirdMenu.addItem(withTitle: String(localized: "Автозаповнення"), action: #selector(NSText.selectAll(_:)), keyEquivalent: "a")
        //thirdMenu.addItem(withTitle: String(localized: "Почати диктування"), action: Selector("startDictation"), keyEquivalent: "a")
        
        let menuItemShowCharacterPalette = NSMenuItem()
        menuItemShowCharacterPalette.title = String(localized: "Емодзі та символи")
        menuItemShowCharacterPalette.action = #selector(NSApplication.shared.orderFrontCharacterPalette)
        menuItemShowCharacterPalette.keyEquivalent = "e"
        menuItemShowCharacterPalette.keyEquivalentModifierMask = [.function]
        thirdMenu.addItem(menuItemShowCharacterPalette)
        
        
        let fourthMenuItem = NSMenuItem()
        mainMenu.addItem(fourthMenuItem)
        
        let fourthMenu = NSMenu()
        fourthMenu.title = String(localized: "Перегляд")
        fourthMenuItem.submenu = fourthMenu
        
        fourthMenu.addItem(withTitle: String(localized: "Показати бічну панель"), action: #selector(NSSplitViewController.toggleSidebar(_:)), keyEquivalent: "S")
        fourthMenu.addItem(.separator())
        
        fourthMenu.addItem(withTitle: String(localized: "Показати панель вкладок"), action: #selector(window?.toggleTabBar(_:)), keyEquivalent: "T")
        fourthMenu.addItem(withTitle: String(localized: "Показати всі вкладки"), action: #selector(window?.toggleTabOverview(_:)), keyEquivalent: "")
        fourthMenu.addItem(.separator())
        
        window?.toggleTabBar(nil)
        
        let menuItemToggleInstrumentPanel = NSMenuItem()
        menuItemToggleInstrumentPanel.title = String(localized: "Сховати панель інструментів")
        menuItemToggleInstrumentPanel.action = #selector(window?.toggleToolbarShown(_:))
        menuItemToggleInstrumentPanel.keyEquivalentModifierMask = [.option, .command]
        menuItemToggleInstrumentPanel.keyEquivalent = "t"
        fourthMenu.addItem(menuItemToggleInstrumentPanel)

        let menuItemToggleFullScreen = NSMenuItem()
        menuItemToggleFullScreen.title = String(localized: "Увійти до повноекранного режиму")
        menuItemToggleFullScreen.action = #selector(window?.toggleFullScreen(_:))
        menuItemToggleFullScreen.keyEquivalentModifierMask = [.function]
        menuItemToggleFullScreen.keyEquivalent = "f"
        fourthMenu.addItem(menuItemToggleFullScreen)
        
        let fifthMenuItem = NSMenuItem()
        mainMenu.addItem(fifthMenuItem)
        
        let fifthMenu = NSMenu()
        fifthMenu.title = String(localized: "Вікно")
        fifthMenuItem.submenu = fifthMenu

        fifthMenu.addItem(withTitle: String(localized: "Згорнути"), action: #selector(minimizeAction(_:)), keyEquivalent: "m")
        fifthMenu.addItem(withTitle: String(localized: "Оптимізувати"), action: #selector(performZoomAction(_:)), keyEquivalent: "")
        // fifthMenu.addItem(withTitle: "Розмістити вікно ліворуч на екрані", action: #selector(window?.left(_:)), keyEquivalent: "")
        // fifthMenu.addItem(withTitle: "Розмістити вікно праворуч на екрані", action: #selector(performZoomAction(_:)), keyEquivalent: "")
        fifthMenu.addItem(.separator())
                
        let menuItemShowPreviousTab = NSMenuItem()
        menuItemShowPreviousTab.title = String(localized: "Показати попередню вкладку")
        menuItemShowPreviousTab.action = #selector(window?.selectPreviousTab(_:))
        menuItemShowPreviousTab.keyEquivalent = "\u{0009}"
        menuItemShowPreviousTab.keyEquivalentModifierMask = [.control, .shift]
        fifthMenu.addItem(menuItemShowPreviousTab)

        let menuItemShowNextTab = NSMenuItem()
        menuItemShowNextTab.title = String(localized: "Показати наступну вкладку")
        menuItemShowNextTab.action = #selector(window?.selectNextTab(_:))
        menuItemShowNextTab.keyEquivalent = "\u{0009}"
        menuItemShowNextTab.keyEquivalentModifierMask = [.control]
        fifthMenu.addItem(menuItemShowNextTab)

        fifthMenu.addItem(withTitle: String(localized: "Винести вкладку в нове вікно"), action: #selector(window?.moveTabToNewWindow(_:)), keyEquivalent: "")
        fifthMenu.addItem(withTitle: String(localized: "Обʼєднати всі вікна"), action: #selector(window?.mergeAllWindows(_:)), keyEquivalent: "")
        fifthMenu.addItem(.separator())
        fifthMenu.addItem(withTitle: String(localized: "Всі наперед"), action: #selector(window?.orderFront(_:)), keyEquivalent: "")
        
        let sixthMenuItem = NSMenuItem()
        mainMenu.addItem(sixthMenuItem)
        
        let sixthMenu = NSMenu()
        sixthMenu.title = String(localized: "Довідка")
        sixthMenuItem.submenu = sixthMenu

        sixthMenu.addItem(withTitle: String(localized: "Довідка Gradify"), action: #selector(NSApplication.showHelp(_:)), keyEquivalent: "")
        sixthMenu.addItem(.separator())
        sixthMenu.addItem(withTitle: String(localized: "Онлайн довідка"), action: #selector(NSApplication.showHelp(_:)), keyEquivalent: "")

    }// func initMenuBar()
    
    @objc func showSettingAppAction(_ sender: Any?)
    {
        self.settingAppWindow.makeKeyAndOrderFront(nil)
        self.aboutAppWindow.windowController?.showWindow(nil)
    }// func @objc func showSettingAppAction(_ sender: Any?)
    
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
        window?.tabbingMode = .preferred
        window?.center()
        
        useMiniWindow(status: false)
        useTranspertTitleBar(status: false)
        

        window?.styleMask.insert(.fullSizeContentView)

        //window?.backgroundColor = NSColor(Color.gray)
    }// func setMainWindow

    
    func setLoginWindow()
    {
        let hostingController = NSHostingController(rootView: LoginView(loginData: loginData, windowController: self))
        
        window?.contentView = NSHostingView(rootView: hostingController.rootView)
        window?.isMovableByWindowBackground = true
        window?.tabbingMode = .disallowed
        window?.center()
        
        useMiniWindow(status: false)
        useTranspertTitleBar(status: true)
    }// func setLoginWindow()

    func setStartWindow()
    {
        let hostingController = NSHostingController(rootView: StartView(windowController: self))
        
        window?.contentView = NSHostingView(rootView: hostingController.rootView)
        window?.isMovableByWindowBackground = true
        window?.tabbingMode = .disallowed
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

