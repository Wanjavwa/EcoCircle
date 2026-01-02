//
//  newView.swift
//  our mobile application
//
//  Created by Wanjavwa Nzobokela on 7/20/25.
//
import SwiftUI

// MARK: - CommunityView
struct CommunityView: View {
    @State private var navigateToHome = false
    @State private var navigateToLeaderboard = false
    @State private var navigateToEvents = false
    @State private var navigateToChallenges = false
    @State private var navigateToCollabCorner = false

    let backgroundColor = Color(red: 0.95, green: 0.93, blue: 0.86)
    let barColor = Color(red: 0.18, green: 0.56, blue: 0.27)

    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                VStack(spacing: 0) {
                    HStack {
                        Text("Community")
                            .font(.system(size: geo.size.width * 0.05, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.leading, 20)
                        Spacer()
                    }
                    .frame(height: geo.size.height * 0.07)
                    .background(barColor)

                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            Text("Jump into the circles below")
                                .font(.title)
                                .bold()
                                .foregroundColor(.black)
                                .padding(.top, 10)
                                .padding(.horizontal)

                            ZStack {
                                Image("community")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geo.size.width * 0.7)
                                    .cornerRadius(20)
                                    .shadow(radius: 6)

                                VStack {
                                    HStack {
                                        Spacer()
                                        Text("SHARE IDEAS")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundColor(barColor)
                                            .padding(.top, 10)
                                        Spacer()
                                    }
                                    Spacer()
                                }

                                VStack {
                                    Spacer()
                                    HStack {
                                        Spacer(minLength: 40)
                                        Text("TEAM UP")
                                            .font(.caption)
                                            .foregroundColor(barColor)
                                        Spacer()
                                        Text("MAKE AN IMPACT")
                                            .font(.caption)
                                            .foregroundColor(barColor)
                                        Spacer(minLength: 40)
                                    }
                                    .padding(.bottom, 40)
                                }

                                VStack {
                                    Spacer()
                                    Text("CHAT")
                                        .font(.caption)
                                        .foregroundColor(barColor)
                                        .padding(.bottom, 10)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal)

                            Text("Join our thriving sustainability community. Share your tips, track your challenges, and grow your impact.")
                                .font(.body)
                                .foregroundColor(.black)
                                .padding(.horizontal)

                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 24) {
                                Button(action: {
                                    navigateToCollabCorner = true
                                }) {
                                    CommunityButton(icon: "person.2.fill", label: "Collab Corner")
                                }
                                .buttonStyle(.plain)

                                Button(action: {
                                    navigateToChallenges = true
                                }) {
                                    CommunityButton(icon: "flag.fill", label: "Challenges")
                                }
                                .buttonStyle(.plain)

                                Button(action: {
                                    navigateToEvents = true
                                }) {
                                    CommunityButton(icon: "calendar", label: "Events")
                                }
                                .buttonStyle(.plain)

                                Button(action: {
                                    navigateToLeaderboard = true
                                }) {
                                    CommunityButton(icon: "list.number", label: "Leaderboard")
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(.horizontal)

                            VStack(alignment: .leading, spacing: 14) {
                                Text("WEEKLY TIPS")
                                    .font(.headline)
                                    .bold()
                                    .foregroundColor(.black)

                                VStack(alignment: .leading, spacing: 6) {
                                    Text("1. Scan Before You Buy:")
                                        .bold()
                                        .foregroundColor(.black)

                                    Text("Check a product’s climate impact with the app before purchasing. Small choices make a big difference.")
                                        .foregroundColor(.black)
                                }
                                .padding()
                                .background(Color.white.opacity(0.9))
                                .cornerRadius(12)
                                .shadow(radius: 4)

                                VStack(alignment: .leading, spacing: 6) {
                                    Text("2. Weekly Insight:")
                                        .bold()
                                        .foregroundColor(.black)

                                    Text("sdbfbweivfbwejiwjebfwiej")
                                        .foregroundColor(.black)
                                }
                                .padding()
                                .background(Color.white.opacity(0.9))
                                .cornerRadius(12)
                                .shadow(radius: 4)
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 30)
                        }
                        .frame(maxWidth: .infinity)
                        .background(backgroundColor)
                    }

                    Divider()

                    BottomTabBar {
                        navigateToHome = true
                    }
                    .frame(height: geo.size.height * 0.08)
                    .background(barColor)
                }
                .edgesIgnoringSafeArea(.bottom)
            }
            .navigationDestination(isPresented: $navigateToHome) {
                DashboardView()
            }
            .navigationDestination(isPresented: $navigateToLeaderboard) {
                LeaderboardView()
            }
            .navigationDestination(isPresented: $navigateToEvents) {
                EventsView()
            }
            .navigationDestination(isPresented: $navigateToChallenges) {
                ChallengesView()
            }
            .navigationDestination(isPresented: $navigateToCollabCorner) {
                CollabCornerView()
            }
        }
    }
}

// MARK: - CommunityButton
struct CommunityButton: View {
    let icon: String
    let label: String

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(.green)
                .padding()
                .background(Color.green.opacity(0.1))
                .clipShape(Circle())

            Text(label)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, minHeight: 120)
        .padding()
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}


// MARK: - BottomTabBar
struct BottomTabBar: View {
    let onHomeTap: () -> Void

    var body: some View {
        HStack {
            Spacer()
            TabButton(label: "Home", icon: "house", action: onHomeTap)
            Spacer()
            TabButton(label: "Scan", icon: "qrcode") {
                print("Go to Scan View")
            }
            Spacer()
            TabButton(label: "Dispose", icon: "trash") {
                print("Go to Dispose View")
            }
            Spacer()
        }
    }
}

// MARK: - TabButton
struct TabButton: View {
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
struct CommunityView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityView()
            .previewDevice("iPhone 15 Pro")
        CommunityView()
            .previewDevice("iPad Pro (12.9-inch) (6th generation)")
    }
}
