//
//  AcceptDeleteRowSubject.swift
//  Gradify
//
//  Created by Андрiй on 11.03.2024.
//

import SwiftUI

struct AcceptDeleteRowSubject: View
{
    @Binding var subject:               Subject
    @Binding var isShowSelfView:        Bool
    @Binding var isUpdateListSubject:   Bool
    @ObservedObject var writeModel:     ReadWriteModel

    var body: some View
    {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}
