//
//  ProfileView.swift
//  our mobile application
//
//  Created by Wanjavwa Nzobokela on 7/29/25.
//

import SwiftUI

struct ProfileView: View {
    let backgroundColor = Color(red: 0.95, green: 0.93, blue: 0.86)
    let greenAccent = Color(red: 0.18, green: 0.56, blue: 0.27)

    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack(spacing: 30) {
                    
                    // MARK: - Header (Green Top)
                    VStack(spacing: 10) {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: geo.size.width > 600 ? 100 : 80, height: geo.size.width > 600 ? 100 : 80)
                            .foregroundColor(.white)
                            .shadow(radius: 5)

                        Text("Hey, Chibela!")
                            .font(.system(size: geo.size.width > 600 ? 32 : 24, weight: .bold))
                            .foregroundColor(.white)

                        HStack(spacing: 4) {
                            Image(systemName: "leaf.fill")
                                .foregroundColor(.white)
                            Text("Eco Warrior")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.9))
                        }
                    }
                    .padding(.vertical, 30)
                    .frame(maxWidth: .infinity)
                    .background(greenAccent)
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))

                    // MARK: - Stats Section
                    HStack(spacing: 16) {
                        statBox(icon: "arrow.left.arrow.right", value: "5", label: "Items Swapped", isLarge: geo.size.width > 600)
                        statBox(icon: "cloud", value: "6 Kg", label: "CO₂ Saved", isLarge: geo.size.width > 600)
                        statBox(icon: "trash.fill", value: "8 Kg", label: "Waste Disposed", isLarge: geo.size.width > 600)
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)

                    // MARK: - Profile Options
                    VStack(spacing: 15) {
                        profileOption(icon: "pencil", label: "Edit Profile")
                        profileOption(icon: "gearshape", label: "Settings")
                        profileOption(icon: "flag", label: "My Goals")
                        profileOption(icon: "bag", label: "Marketplace Orders")
                        profileOption(icon: "creditcard", label: "Payment Method")
                        profileOption(icon: "trash", label: "Disposal Log")
                        profileOption(icon: "person.crop.rectangle", label: "Contact Us")
                        profileOption(icon: "rectangle.portrait.and.arrow.right", label: "Log Out", isDestructive: true)
                    }
                    .padding(.horizontal)

                    // MARK: - Bottom Green Footer
                    Spacer(minLength: 40)

                    RoundedRectangle(cornerRadius: 0)
                        .fill(greenAccent)
                        .frame(height: 60)
                        .overlay(
                            Text("Thank you for making a difference 🌍")
                                .font(.footnote)
                                .foregroundColor(.white)
                        )
                }
                .frame(minHeight: geo.size.height)
                .padding(.bottom)
                .background(backgroundColor)
            }
        }
    }

    // MARK: - Components

    func statBox(icon: String, value: String, label: String, isLarge: Bool) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: isLarge ? 28 : 22))
                .foregroundColor(greenAccent)

            Text(value)
                .font(.system(size: isLarge ? 22 : 18, weight: .semibold))
                .foregroundColor(.primary)

            Text(label)
                .font(.system(size: isLarge ? 14 : 12))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: greenAccent.opacity(0.1), radius: 5, x: 0, y: 3)
    }

    func profileOption(icon: String, label: String, isDestructive: Bool = false) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .foregroundColor(isDestructive ? .red : greenAccent)

            Text(label)
                .foregroundColor(isDestructive ? .red : .black)
                .fontWeight(.medium)

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: greenAccent.opacity(0.06), radius: 3, x: 0, y: 2)
        .hoverEffect(.highlight)
    }
}

// MARK: - Preview

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ProfileView()
                .previewDevice("iPhone 15 Pro")

            ProfileView()
                .previewDevice("iPad Pro (12.9-inch) (6th generation)")
        }
    }
}



