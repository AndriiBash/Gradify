//
//  LoginView.swift
//  Gradify
//
//  Created by Андрiй on 29.10.2023.
//

import SwiftUI

struct StartView: View
{
    @State private var animateStatus: Bool = true
    var windowController: WindowController
    
    var body: some View
    {
        VStack
        {
            Image(systemName: "graduationcap.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100, alignment: .center)
                .foregroundColor(Color.gray)
            
            Text("Зустрічайте")
            Text("Gradify")
                .foregroundColor(.blue)
            
            VStack(spacing: 25)
            {
                RowInfoViewModel(isAnimated: $animateStatus, imageName: "opticaldiscdrive.fill", mainText: "Ефективний облік даних", bodyText: "Gradify забезпечує ефективний облік та збереження інформації про студентів")

                RowInfoViewModel(isAnimated: $animateStatus, imageName: "speedometer", mainText: "Швидкий доступ до інформації", bodyText: "Зручний та швидкий доступ до важливих даних про студентів")

                RowInfoViewModel(isAnimated: $animateStatus, imageName: "gearshape.2", mainText: "Оптимізація роботи", bodyText: "Оптимізує роботу та допомагає організувати інформацію для зручного доступу")

            }//VStack with info
            .padding(.top, 40)
            .padding(.horizontal, 12)
            
            Spacer()
            
            Button
            {
                // go to auth
                animateStatus = false
                windowController.setLoginWindow()
            }
            label:
            {
                Text("Далі")
                    .padding(.vertical, 6)
                    .padding(.horizontal, 34)
                    .font(.body)
            }// Button go to mainWindow or auth
            .keyboardShortcut(.defaultAction)
            .shadow(radius: 8)
            .padding()
        }// VStack
        .padding(.top, 12)
        .frame(minWidth: 390, maxWidth: 390,
               minHeight: 600, maxHeight: 600)
        .font(.largeTitle.bold())
        .background(Color("BackgroundLeftLoginView"))
        //.ignoresSafeArea(.all, edges: .all)
        .navigationTitle("")
    }
}

struct StartView_Previews: PreviewProvider
{
    @State private static var windowController = WindowController()

    static var previews: some View
    {
        StartView(windowController: windowController)
    }
}

