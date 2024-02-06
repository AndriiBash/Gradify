//
//  AppKitFunc.swift
//  Gradify
//
//  Created by Андрiй on 05.02.2024.
//

import Foundation
import AppKit

public func copyInBuffer(text: String)
{
    let pasteboard = NSPasteboard.general
    pasteboard.clearContents()
    pasteboard.writeObjects([text as NSPasteboardWriting])
}// func copyInBuffer(text: String)


public func getWidthFromString(for text: String) -> CGFloat
{
    let font = NSFont.systemFont(ofSize: NSFont.systemFontSize)
    let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font]

    let size = (text as NSString).size(withAttributes: attributes)

    return ceil(size.width)
}// private func getWidth(for text: String) -> CGFloat


public func restartApp()
{
    // func work only in deploy application
    let url = URL(fileURLWithPath: Bundle.main.resourcePath!)
    let path = url.deletingLastPathComponent().deletingLastPathComponent().absoluteString
    let task = Process()
    task.launchPath = "/usr/bin/open"
    task.arguments = [path]
    task.launch()
            
    exit(0)
} // func restartApp
