//
//  RespectView.swift
//  Gradify
//
//  Created by Андрiй on 26.12.2023.
//

import SwiftUI

struct RespectView: View
{
    var body: some View
    {
        ScrollView // maybe get info from file, xz
        {
            VStack
            {
                Text(String(localized: "Подяка за внесок у розробку"))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                VStack(spacing: 5)
                {
                    Text(String(localized: "Северіна Ольга (ілюстраторка)"))
                }// VStack witn name support and role
                .padding(.top, 6)

            }// VStack with all info
            .padding(.horizontal)
            .padding(.vertical, 6)

        }// main scroll view
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview
{
    RespectView()
}
