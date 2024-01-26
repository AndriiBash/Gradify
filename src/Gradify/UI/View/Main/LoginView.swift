//
//  AuthView.swift
//  Gradify
//
//  Created by Андрiй on 09.11.2023.
//

import SwiftUI

struct LoginView: View
{
    @ObservedObject var loginData: LoginModel
    var windowController: WindowController
    
    @State private var isRemberMe:          Bool = false
    @State private var forgetPassAlertShow: Bool = false
    //@State private var isHoverOnButton:     Bool = false
    @State private var isRegistration:      Bool = false
    @State private var startAnimate:        Bool = true
    
    var body: some View
    {
        HStack(spacing: 0)
        {
            VStack
            {
                Spacer()
                
                VStack
                {
                    Image(systemName: "icloud.and.arrow.down")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .foregroundColor(Color("CloudLoginView"))
                        .symbolEffect(.bounce.down, value: startAnimate)
                        .shadow(radius: 2)
                        .onAppear
                        {
                            animateIcon()
                        }
                }// VStack with hello photo
                
                Text(String(localized: "З поверненням!"))
                    .font(.title.bold())
                
                Spacer()
                
                Text(loginData.wrongAuth ? String(localized: "Помилка авторизації, невірний пароль або логін!") : " ")
                    .foregroundColor(Color.red)
                    .transition(.move(edge: .bottom))
                
                VStack(spacing: 16)
                {
                    VStack(spacing: 16)
                    {
                        TextField(String(localized: "Введіть логін"), text: $loginData.userName)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(.vertical, 8)
                            .padding(.horizontal, 8)
                            .autocorrectionDisabled()   // ?
                            .textContentType(.username)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(style: StrokeStyle(lineWidth: 1))
                                    .foregroundColor(loginData.wrongAuth ? Color.red.opacity(0.7) : Color.gray.opacity(0.7)))
                            //.keyboardShortcut("a", modifiers: .command)

                        SecureField(String(localized: "Введіть пароль"), text: $loginData.password)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(.vertical, 8)
                            .padding(.horizontal, 8)
                            .textContentType(.password)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(style: StrokeStyle(lineWidth: 1))
                                    .foregroundColor(loginData.wrongAuth ? Color.red.opacity(0.7) : Color.gray.opacity(0.7)))
                    }// VStack with Textfield
                    
                    HStack
                    {
                        Toggle(String(localized: "Запам'ятати мене"), isOn: $isRemberMe)
                        //.labelsHidden()
                        //.toggleStyle(CheckboxToggleStyle())
                        
                        Spacer()
                        
                        Button
                        {
                            //print("forget pass")
                            forgetPassAlertShow.toggle()
                        }
                        label:
                        {
                            Text(String(localized: "Забули пароль?"))
                                .foregroundColor(Color.blue)
                                .underline(true, color: Color.blue)
                                .onHover
                                { isHovered in
                                    changePointingHandCursor(shouldChangeCursor: isHovered)
                                }// change cursor when hover
                        }
                        .buttonStyle(PlainButtonStyle())
                        .alert(String(localized: "Забули пароль?"), isPresented: $forgetPassAlertShow)
                        {
                            TextField(String(localized: "Email-пошта"), text: $loginData.emailForReset)
                            
                            Button(String(localized: "Надіслати"))
                            {
                                Task
                                {
                                    await loginData.resetPassword()
                                    loginData.emailForReset = ""
                                }
                            }// button for send reset password email
                            .disabled(loginData.emailForReset.isEmpty ? true : false)
                            
                            Button(String(localized: "Скасувати"), role: .cancel) { } // cancel button
                        }
                        message:
                        {
                            Text(String(localized: "Введіть свою електронну адресу, і ми надішлемо вам інструкції щодо відновлення пароля."))
                        }// alert to reset password
                    }// HStack with remember me Toogle and button forget pass
                    
                    Button
                    {
                        Task
                        {
                            do
                            {
                                await loginData.loginUser()

                                if loginData.statusAuth
                                {
                                    windowController.setCurrentWindow(ofType: .main)
                                }
                            }
                        }

                    }
                    label:
                    {
                        Spacer()
                        
                        Text(String(localized: "Авторизуватись"))
                            .padding(.vertical, 6)
                        
                        Spacer()
                        
                        Image(systemName: "arrow.right")
                    }// Auth Button
                    .keyboardShortcut(.defaultAction)
                    .disabled(loginData.userName.isEmpty || loginData.password.isEmpty)
                    .onHover
                    { isHovered in
                        if !loginData.userName.isEmpty && !loginData.password.isEmpty
                        {
                            changePointingHandCursor(shouldChangeCursor: isHovered)
                        }
                    }// change cursor when hover

                    HStack
                    {
                        Text(String(localized: "Відсутній аккаунту?"))
                            .foregroundColor(Color.gray)
                        
                        Button
                        {
                            isRegistration.toggle()
                        }
                        label:
                        {
                            Text(String(localized: "Зареєструйтесь"))
                                .foregroundColor(Color.blue)
                                .underline(true, color: Color.blue)
                                .onHover
                                { isHovered in
                                    changePointingHandCursor(shouldChangeCursor: isHovered)
                                }// change cursor when hover
                        }
                        .buttonStyle(PlainButtonStyle())
                        .alert(isPresented: $isRegistration)
                        {
                            Alert(
                                title: Text(String(localized: "Реєстрація")),
                                message: Text(String(localized: "Дякуємо за вибір нашого сервісу! Для створення облікового запису та отримання повного доступу, будь ласка, звертайтеся до нашої служби підтримки за електронною адресою support@gradify.online. Ми завжди готові допомогти!")),
                                primaryButton: .default(Text(String(localized: "Написати")))
                                {
                                    if let mailURL = URL(string: "mailto:support@gradify.online")
                                    {
                                        NSWorkspace.shared.open(mailURL)
                                    }
                                },//Primary button

                                secondaryButton: .cancel(Text(String(localized: "Скасувати")))
                            )
                        }
                    }// Hstack for register user
                                        
                }//VStack with TextField login, pass and button auth
                .padding(.horizontal, 32)
                .padding(.bottom, 20)
        
                Spacer()
            }// VStack with TextField for login
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Spacer()
            
            VStack
            {
                Image("Image")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(100)
                    .padding(.leading, -140)
                    .shadow(radius: 14)
            }// VStack with photo
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("BackgroundRightLoginView"))
            
        }//Main HStack
        .ignoresSafeArea(.all, edges: .all)
        .frame(minWidth: 780, maxWidth: .infinity,
               minHeight: 560, maxHeight: .infinity)
        .background(Color("BackgroundLeftLoginView"))
        //.background(VisualEffectView())
        .overlay(
            ZStack
            {
                if loginData.isLoading
                {
                    LoadingScreen()
                }
            })
    }
        
    func animateIcon()
    {
        if !loginData.statusAuth
        {
            startAnimate.toggle()
            
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 5)
            {
                DispatchQueue.main.async
                {
                    animateIcon()
                }
            }
        }
    }// func animateIcon()
}


struct AuthView_Previews: PreviewProvider
{
    @State private static var loginData = LoginModel()
    @State private static var windowController = WindowController()

    static var previews: some View
    {
        LoginView(loginData: loginData, windowController: windowController)
    }
}

