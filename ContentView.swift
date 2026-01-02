//
//  ContentView 4.swift
//  our mobile application
//
//  Created by Wanjavwa Nzobokela on 7/20/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            WelcomeView()
        }
    }
}

struct WelcomeView: View {
    var body: some View {
       
        ZStack(alignment: .bottom) {

            VStack(spacing: 16) {
                Spacer(minLength: 40)

                // Logo and Title
                VStack(spacing: 8) {
                    Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 93, height: 95)
                    .background(
                    Image("ClimatePic")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 93, height: 95)
                    .clipped()
                    )

                    Text("Welcome to\nEcoCircle")
                    .font(
                    Font.custom("SF Pro Rounded", size: 48)
                    .weight(.bold)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.21, green: 0.4, blue: 0.21))
                        

                    Text("Turning Waste Into Rippling Opportunities and Impact")
                    .font(
                    Font.custom("SF Pro Rounded", size: 24)
                    .weight(.medium)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                }

                Spacer()

               Image("MAPP")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 20)
                    .padding(.bottom, -40)
            }

            // Recycle background image
            Rectangle()
            .foregroundColor(.clear)
            .frame(width: 389, height: 626)
            .background(
            Image("recycle")
            .resizable()
            .aspectRatio(contentMode: .fit)
            )
            .opacity(0.12)

            // Navigation Button
            VStack {
                Spacer()
                NavigationLink(destination: SignupView()) {
                    HStack {
                        Text("Get Started")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)

                        Image(systemName: "chevron.right")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(30)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 3)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 50)
            }
         
        }
        .background(Color(red: 0.95, green: 0.93, blue: 0.86))
    }
        
}

