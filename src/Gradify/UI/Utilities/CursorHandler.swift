//
//  GlobalFunction.swift
//  Gradify
//
//  Created by Андрiй on 19.01.2024.
//

import Foundation
import SwiftUI

func changePointingHandCursor(shouldChangeCursor: Bool)
{
    DispatchQueue.main.async
    {
        if (shouldChangeCursor)
        {
            NSCursor.pointingHand.push()
        }
        else
        {
            NSCursor.pop()
        }
    }
}// func changePointingHandCursor(shouldChangeCursor: Bool)

