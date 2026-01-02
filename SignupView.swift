//
//  SignupView.swift
//  our mobile application
//
//  Created by Wanjavwa Nzobokela on 7/20/25.
//

import SwiftUI

struct SignupView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        ZStack {
            Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()

                HStack(alignment: .center, spacing: 16) {
                    Image("mangarbage")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 400)

                    Image("RRR")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 110)
                }

                VStack(spacing: 20) {
                    Text("Sign Up")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)

                    Group {
                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(.gray)
                            TextField("Name", text: $name)
                                .foregroundColor(.black)
                                .disableAutocorrection(true)
                        }

                        HStack {
                            Image(systemName: "envelope.fill")
                                .foregroundColor(.gray)
                            TextField("Email address", text: $email)
                                .foregroundColor(.black)
                                .disableAutocorrection(true)
                        }

                        HStack {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.gray)
                            SecureField("Password", text: $password)
                                .foregroundColor(.black)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 3)

                    // Normal NavigationLink (no value)
                    NavigationLink(destination: DashboardView()) {
                        Text("Create account")
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(30)
                            .shadow(radius: 3)
                    }

                    HStack {
                        Text("Already have an account?")
                            .foregroundColor(.gray)
                        Button("Sign In") {
                            print("Navigate to Sign In")
                        }
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    }
                    .font(.footnote)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(25)
                .padding(.horizontal)
                .shadow(radius: 5)

                Spacer()
            }
            .padding(.bottom, 20)
        }
        .background(Color(red: 0.95, green: 0.93, blue: 0.86))
    }
}

#Preview {
    SignupView()
}









