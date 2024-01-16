//
//  User.swift
//  Gradify
//
//  Created by Андрiй on 13.01.2024.
//

import Foundation
import SwiftUI

/// need add in firebase

struct User: Identifiable
{
    var id: String = UUID().uuidString
    var _id: Int
    var name: String
    var lastName: String
}

