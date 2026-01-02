//
//  ChallengesView.swift
//  our mobile application
//
//  Created by Wanjavwa Nzobokela on 7/29/25.
//

import SwiftUI

// MARK: - Challenge Data Model
struct Challenge: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let pointsReward: Int
    let iconName: String
    var isCompleted: Bool = false
}

// MARK: - Challenges View
struct ChallengesView: View {
    @State private var challenges: [Challenge] = [
        Challenge(title: "Zero Waste Week", description: "Avoid single-use plastics for a full week.", pointsReward: 150, iconName: "leaf.fill"),
        Challenge(title: "Bike to Work", description: "Replace your commute with biking at least 3 times.", pointsReward: 100, iconName: "bicycle"),
        Challenge(title: "Meatless Monday", description: "Go vegetarian every Monday this month.", pointsReward: 80, iconName: "carrot.fill"),
        Challenge(title: "Recycle Right", description: "Properly sort and recycle your household waste.", pointsReward: 60, iconName: "trash.fill"),
        Challenge(title: "Plant a Tree", description: "Plant and care for a tree in your community.", pointsReward: 200, iconName: "tree.fill")
    ]

    let backgroundColor = Color(red: 0.95, green: 0.93, blue: 0.86)
    let greenAccent = Color(red: 0.18, green: 0.56, blue: 0.27)

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Top Bar
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(.leading, 16)
                    }

                    Spacer()

                    Text("Challenges")
                        .font(.headline.bold())
                        .foregroundColor(.black)

                    Spacer()

                    Spacer()
                        .frame(width: 44)
                }
                .frame(height: 44)
                .background(greenAccent)
                .padding(.bottom, 8)

                ScrollView {
                    VStack(spacing: 24) {
                        Text("Eco Challenges")
                            .font(.largeTitle.bold())
                            .foregroundColor(.black)
                            .padding(.horizontal)

                        ForEach(challenges.indices, id: \.self) { index in
                            ChallengeCard(challenge: $challenges[index])
                                .padding(.horizontal)
                        }

                        Spacer(minLength: 40)
                    }
                    .background(backgroundColor.ignoresSafeArea())
                }

                BottomTabBarChallenges {
                    dismiss()
                }
                .frame(height: 60)
                .background(greenAccent)
            }
            .ignoresSafeArea(edges: .bottom)
            .background(backgroundColor)
            .preferredColorScheme(.light) // Ensure light mode
        }
    }
}

// MARK: - Challenge Card
struct ChallengeCard: View {
    @Binding var challenge: Challenge
    @State private var isPressed = false

    let greenAccent = Color(red: 0.18, green: 0.56, blue: 0.27)

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                Image(systemName: challenge.iconName)
                    .font(.system(size: 40))
                    .foregroundColor(greenAccent)
                    .padding(10)
                    .background(greenAccent.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                VStack(alignment: .leading, spacing: 4) {
                    Text(challenge.title)
                        .font(.headline.bold())
                        .foregroundColor(.black)

                    Text(challenge.description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(3)
                }

                Spacer()
            }

            HStack {
                Text("Reward: \(challenge.pointsReward) points")
                    .font(.subheadline.bold())
                    .foregroundColor(greenAccent)

                Spacer()

                Button(action: {
                    withAnimation {
                        challenge.isCompleted.toggle()
                    }
                }) {
                    Text(challenge.isCompleted ? "Completed ✓" : "Join")
                        .fontWeight(.semibold)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 20)
                        .background(challenge.isCompleted ? greenAccent.opacity(0.3) : greenAccent)
                        .foregroundColor(challenge.isCompleted ? greenAccent : .white)
                        .clipShape(Capsule())
                        .shadow(color: greenAccent.opacity(0.4), radius: 5, x: 0, y: 3)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: greenAccent.opacity(0.2), radius: 10, x: 0, y: 5)
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isPressed)
        .onLongPressGesture(minimumDuration: 0.1, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}

// MARK: - Bottom Tab Bar
struct BottomTabBarChallenges: View {
    let onHomeTap: () -> Void

    var body: some View {
        HStack {
            Spacer()
            TabButtonChallenges(label: "Home", icon: "house", action: onHomeTap)
            Spacer()
            TabButtonChallenges(label: "Scan", icon: "qrcode") {
                print("Go to Scan View")
            }
            Spacer()
            TabButtonChallenges(label: "Dispose", icon: "trash") {
                print("Go to Dispose View")
            }
            Spacer()
        }
    }
}

struct TabButtonChallenges: View {
    let label: String
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                Text(label)
                    .font(.caption)
                    .foregroundColor(.white)
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview
struct ChallengesView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengesView()
            .previewDevice("iPhone 15 Pro")
        ChallengesView()
            .previewDevice("iPad Pro (12.9-inch) (6th generation)")
    }
}


