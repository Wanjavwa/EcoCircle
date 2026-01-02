//
//  CollabCornerView.swift
//  our mobile application
//
//  Created by Wanjavwa Nzobokela on 7/29/25.
//

import SwiftUI

struct Forum: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let iconName: String
}

struct CollabCornerView: View {
    @Environment(\.dismiss) private var dismiss

    let backgroundColor = Color(red: 0.95, green: 0.93, blue: 0.86)
    let greenAccent = Color(red: 0.18, green: 0.56, blue: 0.27)

    @State private var forums: [Forum] = [
        Forum(name: "Plastic Busters", description: "A group dedicated to eliminating single-use plastics.", iconName: "trash.circle.fill"),
        Forum(name: "Intro to repurposed plastic artworks", description: "Learn creative ways to repurpose plastic to form beautiful creations.", iconName: "arrow.2.squarepath"),
        Forum(name: "Green Home Hacks", description: "Share eco-friendly home improvements.", iconName: "house.fill"),
        Forum(name: "Vegan for the Planet", description: "Discuss plant-based lifestyle for sustainability.", iconName: "leaf.fill")
    ]

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    .padding(.leading)

                    Spacer()

                    Text("Collab Corner")
                        .font(.headline.weight(.bold))
                        .foregroundColor(.white)

                    Spacer()
                    Spacer().frame(width: 44)
                }
                .frame(height: 48)
                .padding(.bottom, 6)
                .background(greenAccent)

                ScrollView {
                    VStack(alignment: .leading, spacing: geo.size.width > 600 ? 30 : 20) {
                        Text("Your Communities")
                            .font(.system(size: geo.size.width > 600 ? 36 : 28, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal)

                        ForEach(forums) { forum in
                            ForumCard(forum: forum, isLargeDevice: geo.size.width > 600)
                                .padding(.horizontal)
                        }

                        Button(action: {
                            print("Join new community")
                        }) {
                            Label("Join New Community", systemImage: "plus.circle.fill")
                                .font(.system(size: geo.size.width > 600 ? 22 : 18, weight: .semibold))
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(greenAccent)
                                .foregroundColor(.white)
                                .cornerRadius(14)
                                .shadow(color: greenAccent.opacity(0.3), radius: 6, x: 0, y: 3)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, geo.size.width > 600 ? 60 : 40)
                    }
                    .padding(.top, geo.size.width > 600 ? 30 : 20)
                }
                .background(backgroundColor)
            }
            .background(backgroundColor.ignoresSafeArea())
        }
    }
}

// MARK: - Forum Card View
struct ForumCard: View {
    let forum: Forum
    var isLargeDevice: Bool
    @State private var isHovered = false

    let greenAccent = Color(red: 0.18, green: 0.56, blue: 0.27)

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center, spacing: 16) {
                Image(systemName: forum.iconName)
                    .font(.system(size: isLargeDevice ? 48 : 36))
                    .foregroundColor(greenAccent)
                    .padding(isLargeDevice ? 18 : 12)
                    .background(greenAccent.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                VStack(alignment: .leading, spacing: 6) {
                    Text(forum.name)
                        .font(.system(size: isLargeDevice ? 22 : 18, weight: .bold))
                        .foregroundColor(.black)
                    Text(forum.description)
                        .font(.system(size: isLargeDevice ? 16 : 14))
                        .foregroundColor(Color(red: 0.25, green: 0.25, blue: 0.25))
                }

                Spacer()
            }

            HStack {
                Spacer()
                Button(action: {
                    print("Navigate to forum: \(forum.name)")
                }) {
                    Text("Open Forum")
                        .font(.system(size: isLargeDevice ? 16 : 14, weight: .semibold))
                        .padding(.horizontal, isLargeDevice ? 24 : 20)
                        .padding(.vertical, 10)
                        .background(greenAccent)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(color: greenAccent.opacity(0.3), radius: 4, x: 0, y: 2)
                }
            }
        }
        .padding()
        .background(isHovered ? Color.white.opacity(0.95) : Color.white)
        .cornerRadius(20)
        .shadow(color: greenAccent.opacity(0.15), radius: 8, x: 0, y: 5)
        .scaleEffect(isHovered ? 1.02 : 1)
        .animation(.easeInOut(duration: 0.2), value: isHovered)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

// MARK: - Preview
struct CollabCornerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CollabCornerView()
                .previewDevice("iPhone 15 Pro")

            CollabCornerView()
                .previewDevice("iPad Pro (12.9-inch) (6th generation)")
        }
    }
}



