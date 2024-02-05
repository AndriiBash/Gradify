//
//  AppKitFunc.swift
//  Gradify
//
//  Created by Андрiй on 05.02.2024.
//

import Foundation
import AppKit

func copyInBuffer(text: String)
{
    let pasteboard = NSPasteboard.general
    pasteboard.clearContents()
    pasteboard.writeObjects([text as NSPasteboardWriting])
}// func copyInBuffer(text: String)

