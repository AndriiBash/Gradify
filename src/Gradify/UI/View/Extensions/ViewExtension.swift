//
//  ViewExtension.swift
//  Gradify
//
//  Created by Андрiй on 31.01.2024.
//

import Foundation
import SwiftUI

extension View
{
    func cornerRadius(_ radius: CGFloat, corners: Corners) -> some View
    {
        clipShape(RoundedCornerShape(radius: radius, corners: corners))
    }
}// extension View

struct RoundedCornerShape: Shape
{
    var radius: CGFloat = .infinity
    var corners: Corners = .allCorners

    func path(in rect: CGRect) -> Path
    {
        var path = Path()

        if corners.contains(.topLeft)
        {
            path.move(to: CGPoint(x: rect.minX, y: rect.minY + radius))
            path.addArc(
                center: CGPoint(x: rect.minX + radius, y: rect.minY + radius),
                radius: radius,
                startAngle: .degrees(180),
                endAngle: .degrees(270),
                clockwise: false
            )
        }
        else
        {
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        }

        
        if corners.contains(.topRight)
        {
            path.addLine(to: CGPoint(x: rect.maxX - radius, y: rect.minY))
            path.addArc(
                center: CGPoint(x: rect.maxX - radius, y: rect.minY + radius),
                radius: radius,
                startAngle: .degrees(270),
                endAngle: .degrees(0),
                clockwise: false
            )
        }
        else
        {
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        }

        if corners.contains(.bottomRight)
        {
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - radius))
            path.addArc(
                center: CGPoint(x: rect.maxX - radius, y: rect.maxY - radius),
                radius: radius,
                startAngle: .degrees(0),
                endAngle: .degrees(90),
                clockwise: false
            )
        }
        else
        {
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        }

        if corners.contains(.bottomLeft)
        {
            path.addLine(to: CGPoint(x: rect.minX + radius, y: rect.maxY))
            path.addArc(
                center: CGPoint(x: rect.minX + radius, y: rect.maxY - radius),
                radius: radius,
                startAngle: .degrees(90),
                endAngle: .degrees(180),
                clockwise: false
            )
        }
        
        else
        {
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        }

        return path
    }
}// struct RoundedCornerShape: Shape

struct Corners: OptionSet
{
    let rawValue: Int

    static let topLeft = Corners(rawValue: 1 << 0)
    static let topRight = Corners(rawValue: 1 << 1)
    static let bottomRight = Corners(rawValue: 1 << 2)
    static let bottomLeft = Corners(rawValue: 1 << 3)

    static let allCorners: Corners = [.topLeft, .topRight, .bottomRight, .bottomLeft]
}// struct Corners: OptionSet
