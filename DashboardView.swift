//
//  dashboardView.swift
//  our mobile application
//
//  Created by Wanjavwa Nzobokela on 7/20/25.
//
// LINE 144

import SwiftUI
import CoreHaptics

struct DashboardView: View {
    @State private var isMenuVisible = false
    @State private var selectedMenuItem: MenuItemType? = nil
    @State private var isShowingProfile = false
    @State private var engine: CHHapticEngine?
    @State private var isImpactLoading = true

    let plasticUsage: CGFloat = 0.7
    let co2Emissions: CGFloat = 0.5
    let ecoSwaps: CGFloat = 0.8
    let waterSaved: CGFloat = 0.6

    let creamBase = Color(red: 0.95, green: 0.93, blue: 0.86)
    let creamShadow = Color(red: 0.88, green: 0.87, blue: 0.79)

    var body: some View {
        GeometryReader { geo in
            NavigationStack {
                ZStack(alignment: .topTrailing) {
                    LinearGradient(
                        colors: [creamBase, creamBase.opacity(0.9)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()

                    ScrollView {
                        VStack(spacing: 20) {
                            // Top Bar (Fixed padding and alignment)
                            HStack {
                                Button(action: {
                                    triggerHaptic()
                                    isShowingProfile = true
                                }) {
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .frame(width: geo.size.width * 0.06, height: geo.size.width * 0.06)
                                        .foregroundColor(.black)
                                }

                                Text("Dashboard")
                                    .font(.system(size: geo.size.width * 0.07, weight: .bold))
                                    .foregroundColor(.black)
                                    .minimumScaleFactor(0.7)

                                Spacer()

                                Button(action: {
                                    withAnimation { isMenuVisible.toggle() }
                                }) {
                                    Image(systemName: "line.3.horizontal")
                                        .resizable()
                                        .frame(width: geo.size.width * 0.04, height: geo.size.width * 0.03)
                                        .foregroundColor(.black)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .background(Color(red: 0.18, green: 0.56, blue: 0.27))

                            // Impact Score Section
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Your Impact Score")
                                    .font(.headline)
                                    .foregroundColor(.black)

                                if isImpactLoading {
                                    VStack(spacing: 12) {
                                        ForEach(0..<4) { _ in
                                            RoundedRectangle(cornerRadius: 6)
                                                .fill(Color.gray.opacity(0.3))
                                                .frame(height: 16)
                                                .shimmer()
                                        }
                                    }
                                } else {
                                    VStack(spacing: 15) {
                                        ImpactBar(label: "Plastic Usage", value: plasticUsage, color: .orange)
                                        ImpactBar(label: "CO2 Emissions", value: co2Emissions, color: .red)
                                        ImpactBar(label: "Eco Swaps", value: ecoSwaps, color: .green)
                                        ImpactBar(label: "Monthly Average Points", value: waterSaved, color: .blue)
                                    }
                                }
                            }
                            .padding()
                            .background(creamBase.opacity(0.7))
                            .cornerRadius(12)
                            .shadow(color: creamShadow.opacity(0.4), radius: 6, x: 0, y: 3)
                            .padding(.horizontal)

                            // Quick Actions
                            ZStack {
                                ZStack {
                                    Image("MAPP")
                                        .resizable()
                                        .scaledToFill()
                                        .opacity(0.40)
                                        .blendMode(.multiply)
                                        .frame(height: geo.size.height * 0.70)
                                        .clipped()

                                    Image("recycle")
                                        .resizable()
                                        .scaledToFill()
                                        .opacity(1.00)
                                        .blendMode(.screen)
                                        .frame(height: geo.size.height * 0.70)
                                        .clipped()
                                }
                                .allowsHitTesting(false)
                                .frame(height: geo.size.height * 0.45)

                                VStack(spacing: geo.size.height * 0.025) {
                                    Text("Quick Actions")
                                        .font(.system(size: geo.size.width * 0.065, weight: .bold))
                                        .foregroundColor(Color(red: 0.18, green: 0.56, blue: 0.27))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.horizontal)
                                        .minimumScaleFactor(0.7)

                                    DashboardButton(icon: "trash", text: "Dispose Waste", destination: AnyView(DisposeView()), creamBase: creamBase, creamShadow: creamShadow, height: geo.size.height * 0.09)
                                    DashboardButton(icon: "person.3.fill", text: "Local Community", destination: AnyView(CommunityView()), creamBase: creamBase, creamShadow: creamShadow, height: geo.size.height * 0.09)
                                    DashboardButton(icon: "leaf", text: "Marketplace", destination: AnyView(GreenMarketView()), creamBase: creamBase, creamShadow: creamShadow, height: geo.size.height * 0.09)
                                    DashboardButton(icon: "qrcode.viewfinder", text: "Scan Product", destination: AnyView(ScanView()), creamBase: creamBase, creamShadow: creamShadow, height: geo.size.height * 0.09)
                                }
                                .padding(.horizontal)
                            }
                            .padding(.horizontal)
                           

                            Spacer()

                            // Chatbot
                            HStack {
                                Spacer()
                                Button(action: {}) {
                                    Image(systemName: "bubble.left.and.bubble.right.fill")
                                        .resizable()
                                        .frame(width: geo.size.width * 0.07, height: geo.size.width * 0.07)
                                        .padding()
                                        .background(Color.green)
                                        .clipShape(Circle())
                                        .foregroundColor(.white)
                                        .shadow(radius: 4)
                                }
                                .padding()
                            }
                            .frame(height: min(geo.size.height * 0.45, 400)) 
                        }
                        .offset(x: 5)   // <---- Shift entire content left so sandwich menu is visible
                    }

                    // Dropdown Menu
                    if isMenuVisible {
                        VStack(alignment: .leading, spacing: 12) {
                            menuLink(text: "Dispose", item: .dispose)
                            menuLink(text: "Community", item: .community)
                            menuLink(text: "Marketplace", item: .marketplace)
                            menuLink(text: "Scan Product", item: .scanProduct)
                            menuLink(text: "Library", item: .library)
                            menuLink(text: "Eco Spots", item: .ecoSpots)
                        }
                        .padding()
                        .background(creamBase.opacity(0.9))
                        .cornerRadius(10)
                        .shadow(color: creamShadow.opacity(0.3), radius: 6, x: 0, y: 3)
                        .padding(.horizontal)
                        .padding(.top, 70)
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }

                    // Navigation Links
                    NavigationLink(destination: ProfileView(), isActive: $isShowingProfile) {
                        EmptyView()
                    }
                    .hidden()

                    NavigationLink(destination: destinationView(for: selectedMenuItem ?? .home),
                                   tag: selectedMenuItem ?? .home,
                                   selection: $selectedMenuItem) {
                        EmptyView()
                    }
                    .hidden()
                }
                .onAppear {
                    prepareHaptics()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        withAnimation {
                            isImpactLoading = false
                        }
                    }
                }
            }
        }
    }

    // Haptics
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("Haptic error: \(error.localizedDescription)")
        }
    }

    func triggerHaptic() {
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [sharpness, intensity], relativeTime: 0)

        do {
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play haptic: \(error.localizedDescription)")
        }
    }

    // Dropdown Menu Link
    @ViewBuilder
    func menuLink(text: String, item: MenuItemType) -> some View {
        Button(action: {
            withAnimation {
                isMenuVisible = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                selectedMenuItem = nil
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    selectedMenuItem = item
                }
            }
        }) {
            Text(text)
                .foregroundColor(.black)
                .font(.headline)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .frame(maxWidth: 150, alignment: .leading)
        }
        .buttonStyle(PlainButtonStyle())
        .background(creamBase.opacity(0.9))
        .cornerRadius(5)
        .shadow(color: creamShadow.opacity(0.3), radius: 6, x: 0, y: 3)
    }

    @ViewBuilder
    func destinationView(for item: MenuItemType) -> some View {
        switch item {
        case .home: Text("Home View Placeholder")
        case .scanProduct: ScanView()
        case .dispose: DisposeView()
        case .community: CommunityView()
        case .marketplace: GreenMarketView()
        case .library: EcoSwapsLibraryView()
        case .ecoSpots: EcoSpotsView()
        }
    }
}

enum MenuItemType: String, Identifiable {
    var id: String { rawValue }
    case home, scanProduct, dispose, community, marketplace, library, ecoSpots
}

struct ImpactBar: View {
    var label: String
    var value: CGFloat
    var color: Color

    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.black)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .frame(height: 10)
                        .foregroundColor(Color(red: 0.95, green: 0.93, blue: 0.86).opacity(0.5))

                    RoundedRectangle(cornerRadius: 4)
                        .frame(width: geo.size.width * value, height: 10)
                        .foregroundColor(color)
                        .animation(.easeOut(duration: 1.2), value: value)
                }
            }
            .frame(height: 10)
        }
    }
}

struct DashboardButton: View {
    var icon: String
    var text: String
    var destination: AnyView?
    let creamBase: Color
    let creamShadow: Color
    var height: CGFloat = 60

    var body: some View {
        Group {
            if let destination = destination {
                NavigationLink(destination: destination) {
                    buttonContent
                }
            } else {
                Button(action: {}) {
                    buttonContent
                }
            }
        }
        .frame(height: height)
        .background(creamBase.opacity(0.7))
        .cornerRadius(12)
        .shadow(color: creamShadow.opacity(0.3), radius: 4, x: 0, y: 2)
    }

    var buttonContent: some View {
        HStack {
            Image(systemName: icon)
                .resizable()
                .frame(width: height * 0.5, height: height * 0.5)
                .foregroundColor(.black)

            Text(text)
                .font(.headline)
                .foregroundColor(.black)

            Spacer()
        }
        .padding(.horizontal)
    }
}

extension View {
    func shimmer() -> some View {
        self
            .redacted(reason: .placeholder)
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [Color.clear, Color.white.opacity(0.6), Color.clear]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .rotationEffect(.degrees(30))
                .offset(x: -200)
                .mask(self)
                .animation(Animation.linear(duration: 1.2).repeatForever(autoreverses: false), value: UUID())
            )
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DashboardView()
                .previewDevice("iPhone 15 Pro")
            
            DashboardView()
                .previewDevice("iPad Pro (12.9-inch) (6th generation)")
            
            
            
            
        }
    }
}



// MARK: - MenuItemType Enum



