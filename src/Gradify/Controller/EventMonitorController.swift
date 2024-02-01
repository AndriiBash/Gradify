//
//  EventMonitorController.swift
//  Gradify
//
//  Created by Андрiй on 29.01.2024.
//

import Foundation
import Cocoa
import AppKit

public class EventMonitorController
{
    private var monitor: Any?
    private let mask: NSEvent.EventTypeMask
    private let handler: (NSEvent?) -> Void
    
    public init(mask: NSEvent.EventTypeMask, handler: @escaping (NSEvent?) -> Void)
    {
        self.mask = mask
        self.handler = handler
    }
    
    deinit
    {
        stop()
    }
    
    public func start()
    {
        monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler)
    }
    
    public func stop()
    {
        if monitor != nil
        {
            NSEvent.removeMonitor(monitor!)
            monitor = nil
        }
    }
}// public class EventMonitorController
