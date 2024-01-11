//
//  AcceptChangeLanguage.swift
//  Gradify
//
//  Created by Андрiй on 09.01.2024.
//

import SwiftUI

struct AcceptChangeLanguage: View
{
    @Binding var showStatus: Bool
    @Binding var selectedLanguage: Language
    
    var body: some View
    {
        VStack
        {
            Spacer()
            
            ZStack
            {
                Color.blue
                    .cornerRadius(12)
                
                Image(systemName: "globe")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    //.frame(width: 80, height: 80, alignment: .center)
                    .foregroundColor(Color.white)
                    .shadow(radius: 8)
                    .padding(12)
            }// ZStack with image
            .frame(width: 65, height: 65, alignment: .center)
            .padding(.vertical, 6)

            Spacer()
            
            VStack(spacing: 12)
            {
                Text(String(localized: "Основну мову застосунку зміненно. Перезапустити застосунок зараз?"))
                    .fontWeight(.bold)
                
                Text(String(localized: "Застосунок не зможе використовувати нову мову до перезапуску."))
                    .font(.system(size: 12))
                
                VStack(spacing: 6)
                {
                    Button
                    {
                        UserDefaults.standard.set(["\(selectedLanguage)"], forKey: "AppleLanguages")
                        restartApp()
                    }
                    label:
                    {
                        Text(String(localized: "Перезапустити"))
                            .frame(width: 260)
                            .padding(.vertical, 4)
                            .foregroundColor(Color.red)
                            //.padding(.vertical, 3)
                    }// Button restart app
                    
                    Button
                    {
                        UserDefaults.standard.set(["\(selectedLanguage)"], forKey: "AppleLanguages")
                        showStatus = false;
                    }
                    label:
                    {
                        Text(String(localized: "Не перезапускати"))
                            .padding(.vertical, 4)
                            .frame(width: 260)
                    }// button cansel restart
                }// VStack with button
                .padding(.top, 6)
            }// VStack with info about restart app
            .multilineTextAlignment(.center)
            .padding(.horizontal)
            
            Spacer()
        }// main VStack
        .frame(width: 290, height: 270)
        .padding()
    }
    
    func restartApp()
    {
        // func work only in deploy application
        //print(path)
        
        let url = URL(fileURLWithPath: Bundle.main.resourcePath!)
        let path = url.deletingLastPathComponent().deletingLastPathComponent().absoluteString
        let task = Process()
        task.launchPath = "/usr/bin/open"
        task.arguments = [path]
        task.launch()
                
        exit(0)
    } // func restartApp
}

/* bruh not working
struct AcceptChangeLanguage_Previews: PreviewProvider
{
    @State private var closeStatus = false
        
    static var previews: some View
    {
        AcceptChangeLanguage(closeStatus: $closeStatus)
    }
}
*/

