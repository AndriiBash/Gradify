//
//  AcceptDeleteRowTeacher.swift
//  Gradify
//
//  Created by Андрiй on 11.03.2024.
//

import SwiftUI

struct AcceptDeleteRowTeacher: View
{
    @Binding var teacher:               Teacher
    @Binding var isShowSelfView:        Bool
    @Binding var isUpdateListTeacher:   Bool
    @ObservedObject var writeModel:     ReadWriteModel

    var body: some View
    {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}
