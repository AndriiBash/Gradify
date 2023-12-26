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
            Text("Подяка за внесок у розробку")
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 5)
            {
                Text("Северіна Ольга (ілюстраторка)")
            }// VStack witn name support and role
            .padding(.top, 6)

        }// main scroll view
        .padding()
    }
}

#Preview
{
    RespectView()
}
