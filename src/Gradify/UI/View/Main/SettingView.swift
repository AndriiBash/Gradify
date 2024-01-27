//
//  SettingView.swift
//  Gradify
//
//  Created by Андрiй on 05.01.2024.
//

import SwiftUI

enum Language: String, CaseIterable, Identifiable
{
    var id: Language { self }

    case uk = "Українська🇺🇦"
    case es = "Español🇪🇸"
    case de = "Deutsch🇩🇪"
    case fr = "Français🇫🇷"
    case en = "English🇬🇧"
} // enum list support Language

struct SettingView: View
{
    @State private var selectedLanguage: Language = getCurrentLanguage()// get current language
    @State private var showLanguageInfo: Bool = false
    //private let userSettings = UserDefaults.standard

    var body: some View
    {
        Form
        {
            Section(header: Text(String(localized: "Головні налаштування")).foregroundColor(.secondary).bold())
            {
                Picker(String(localized: "Мова застосунку"), selection: $selectedLanguage)
                {
                    ForEach(Language.allCases, id: \.self)
                    { language in
                        let localizedString = NSLocalizedString(language.rawValue, comment: "")
                        
                        Text("\(Text(language.rawValue)) — \(Text(String(localizedString)).foregroundColor(.secondary))")
                            .tag(language)
                    }
                }// Picker for change lanuage
                .onChange(of: selectedLanguage)
                { _, _ in // don't see new and old value
                    showLanguageInfo.toggle()
                }
                .sheet(isPresented: $showLanguageInfo)
                {
                    AcceptChangeLanguageView(showStatus: $showLanguageInfo, selectedLanguage: $selectedLanguage)
                }
                
                Text("Hello, World!") // just example
                Text("Hello, World!") // also too :)
                Text("Hello, World!") // also :)
                Text("Hello, World!") // just example
            }// main Section
        }// main Form
        .formStyle(.grouped)
        .frame(minWidth: 450, maxWidth: 450,
               minHeight: 350, maxHeight: .infinity)
    }
}

func getCurrentLanguage() -> Language
{
    var currentNameLanguage: Language
    
    switch "\(Locale.current.language.languageCode?.identifier ?? "nil")"
    {
    case "uk":
        currentNameLanguage = .uk
    case "es":
        currentNameLanguage = .es
    case "de":
        currentNameLanguage = .de
    case "fr":
        currentNameLanguage = .fr
    case "en":
        currentNameLanguage = .en
    default:
        currentNameLanguage = .en
        print("Error getting the correct language, default language is set to English")
    }
    
    return currentNameLanguage
}// func func getCurrentLanguage() -> Language


struct SettingView_Previews: PreviewProvider
{
    static var previews: some View
    {
        SettingView()
    }
}

