//
//  LeaderboardView.swift
//  our mobile application
//
//  Created by Wanjavwa Nzobokela on 7/29/25.
//

import SwiftUI

// MARK: - LeaderboardEntry
struct LeaderboardEntry: Identifiable, Equatable {
    let id = UUID()
    let rank: Int
    let name: String
    let points: Int
    let backgroundColor: Color
}

// MARK: - LeaderboardView
struct LeaderboardView: View {
    @Environment(\.dismiss) private var dismiss

    // Helper function to assign background color by rank
    func backgroundColor(for rank: Int) -> Color {
        switch rank {
        case 1...3:
            return Color(red: 0.75, green: 0.63, blue: 0.05)      // Gold
        case 4...6:
            return Color(red: 0.65, green: 0.65, blue: 0.65)  // Silver
        default:
            return Color(red: 0.60, green: 0.40, blue: 0.10)  // Bronze
        }
    }

    @State private var leaderboardData: [LeaderboardEntry] = [
        LeaderboardEntry(rank: 1, name: "Ava Thompson", points: 1230, backgroundColor: Color(red: 0.75, green: 0.63, blue: 0.05)),
        LeaderboardEntry(rank: 2, name: "Husniya Boyeva", points: 1095, backgroundColor: Color(red: 0.75, green: 0.63, blue: 0.05)),
        LeaderboardEntry(rank: 3, name: "Noah Kim", points: 980, backgroundColor: Color(red: 0.75, green: 0.63, blue: 0.05)),
        LeaderboardEntry(rank: 4, name: "Zoe Chen", points: 870, backgroundColor: Color(red: 0.65, green: 0.65, blue: 0.65)),
        LeaderboardEntry(rank: 5, name: "Eusebe Nsanzimana", points: 810, backgroundColor: Color(red: 0.65, green: 0.65, blue: 0.65)),
        LeaderboardEntry(rank: 6, name: "Wanjavwa Nzobokela", points: 790, backgroundColor: Color(red: 0.65, green: 0.65, blue: 0.65)),
        LeaderboardEntry(rank: 7, name: "Liam Patel", points: 750, backgroundColor: Color(red: 0.60, green: 0.40, blue: 0.10)),
        LeaderboardEntry(rank: 8, name: "Noah Kim", points: 650, backgroundColor: Color(red: 0.60, green: 0.40, blue: 0.10)),
        LeaderboardEntry(rank: 9, name: "Zoe Chen", points: 400, backgroundColor: Color(red: 0.60, green: 0.40, blue: 0.10)),
        LeaderboardEntry(rank: 10, name: "Chibela Changwe", points: 250, backgroundColor: Color(red: 0.60, green: 0.40, blue: 0.10)
)
    ]

    let backgroundColor = Color(red: 0.95, green: 0.93, blue: 0.86)

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                // Top Bar
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                    .padding(.leading, 16)

                    Spacer()

                    Text("Leaderboard")
                        .font(.system(size: geo.size.width * 0.05, weight: .bold))
                        .foregroundColor(.white)

                    Spacer()

                    Spacer().frame(width: 30) // For visual symmetry
                }
                .frame(height: geo.size.height * 0.07)
                .background(Color(red: 0.18, green: 0.56, blue: 0.27)) // Keep green bar on top

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        Text("Eco Warriors of the Week")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.black)
                            .padding(.top, 20)
                            .padding(.horizontal)

                        ForEach(leaderboardData) { entry in
                            LeaderboardRow(entry: entry)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.bottom, 40)
                }
                .background(backgroundColor.ignoresSafeArea())
            }
        }
    }
}

// MARK: - LeaderboardRow
struct LeaderboardRow: View {
    let entry: LeaderboardEntry
    @State private var isHovered = false

    var body: some View {
        HStack {
            Text("#\(entry.rank)")
                .font(.title3)
                .bold()
                .foregroundColor(.white)
                .frame(width: 50)

            VStack(alignment: .leading) {
                Text(entry.name)
                    .font(.headline)
                    .foregroundColor(.white)
                Text("\(entry.points) points")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }

            Spacer()

            Image(systemName: "leaf.fill")
                .foregroundColor(.white)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(entry.backgroundColor.opacity(isHovered ? 0.9 : 0.8))
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
        )
        .scaleEffect(isHovered ? 1.02 : 1.0)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovered = hovering
            }
        }
        .animation(.easeInOut(duration: 0.25), value: isHovered)
    }
}

// MARK: - Preview
struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LeaderboardView()
                .previewDevice("iPhone 15 Pro")
            LeaderboardView()
                .previewDevice("iPad Pro (11-inch) (4th generation)")
        }
    }
}


