//
//  LibraryView.swift
//  our mobile application
//
//  Created by Wanjavwa Nzobokela on 7/29/25.
//

import SwiftUI

// MARK: - EcoSwap Data Model
struct EcoSwap: Identifiable {
    let id = UUID()
    let category: String
    let oldItemName: String
    let newItemName: String
    let oldItemImageName: String
    let newItemImageName: String
    let whySwapText: String
}

// MARK: - Main View
struct EcoSwapsLibraryView: View {
    @Environment(\.dismiss) private var dismiss

    let ecoSwaps: [EcoSwap] = [
        EcoSwap(category: "Home & Kitchen", oldItemName: "Plastic Wrap", newItemName: "Beeswax Wrap", oldItemImageName: "first1", newItemImageName: "too1", whySwapText: "Plastic wrap contributes significantly to landfill waste and can leach chemicals into food. Beeswax wraps are reusable, biodegradable, and naturally antibacterial, making them a sustainable alternative for food storage."),
        EcoSwap(category: "Personal Care Products", oldItemName: "Plastic Toothbrush", newItemName: "Bamboo Toothbrush", oldItemImageName: "first2", newItemImageName: "too2", whySwapText: "Billions of plastic toothbrushes end up in landfills every year. Bamboo toothbrushes are biodegradable and a great way to reduce your plastic footprint in daily hygiene."),
        EcoSwap(category: "On The Go / Lifestyle", oldItemName: "Disposable Cups", newItemName: "Reusable Travel Cup", oldItemImageName: "first3", newItemImageName: "too3", whySwapText: "Disposable coffee cups often have plastic linings, making them difficult to recycle. A reusable cup cuts down on waste and may save you money at coffee shops.")
    ]

    @State private var showingWhySwapSheet = false
    @State private var selectedEcoSwap: EcoSwap?

    // Grocery list logic
    @State private var groceryList: String = ""
    @State private var showingGroceryPrompt = false
    @State private var showSwaps = false
    @State private var showListOnly = false

    let greenShade = Color(red: 0.18, green: 0.56, blue: 0.27)
    let backgroundShade = Color(red: 0.95, green: 0.93, blue: 0.86)

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack(alignment: .leading, spacing: 30) {
                        // Header
                        HStack {
                            Button(action: { dismiss() }) {
                                Image(systemName: "chevron.left")
                                    .font(.title2)
                                    .foregroundColor(greenShade)
                                    .padding(6)
                                    .background(.white)
                                    .clipShape(Circle())
                                    .shadow(radius: 2)
                            }

                            Spacer()

                            VStack(spacing: 4) {
                                Text("EcoSwap Library")
                                    .font(.largeTitle.bold())
                                    .foregroundColor(greenShade)
                                Text("Small changes, big impact.")
                                    .font(.subheadline)
                                    .foregroundColor(greenShade.opacity(0.7))
                            }

                            Spacer()

                            Button(action: {}) {
                                Image(systemName: "line.horizontal.3")
                                    .font(.title2)
                                    .foregroundColor(greenShade)
                                    .padding(8)
                                    .background(.white)
                                    .clipShape(Circle())
                                    .shadow(radius: 2)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top)

                        // Categories + Cards
                        ForEach(uniqueCategories, id: \.self) { category in
                            VStack(alignment: .leading, spacing: 16) {
                                Text(category)
                                    .font(.title2.weight(.semibold))
                                    .foregroundColor(greenShade)
                                    .padding(.horizontal)

                                if geometry.size.width > 700 {
                                    // iPad: Grid layout
                                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 24) {
                                        ForEach(ecoSwaps(for: category)) { swap in
                                            EcoSwapCard(ecoSwap: swap) {
                                                selectedEcoSwap = swap
                                                showingWhySwapSheet = true
                                            }
                                            .frame(maxWidth: .infinity)
                                            .shadow(color: greenShade.opacity(0.15), radius: 8, x: 0, y: 4)
                                        }
                                    }
                                    .padding(.horizontal)
                                } else {
                                    // iPhone: Horizontal scroll
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 20) {
                                            ForEach(ecoSwaps(for: category)) { swap in
                                                EcoSwapCard(ecoSwap: swap) {
                                                    selectedEcoSwap = swap
                                                    showingWhySwapSheet = true
                                                }
                                                .frame(width: 280)
                                                .shadow(color: greenShade.opacity(0.15), radius: 8, x: 0, y: 4)
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                            }
                        }

                        // Grocery List Section
                        // Grocery List Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("My Eco Grocery List")
                                .font(.title2.weight(.semibold))
                                .foregroundColor(greenShade)
                                .padding(.horizontal)

                            TextEditor(text: $groceryList)
                                .foregroundColor(.black) // text color
                                .frame(height: 120)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: .gray.opacity(0.1), radius: 5, x: 0, y: 2)
                                .padding(.horizontal)
                                .scrollContentBackground(.hidden)  // This hides the default black background

                            Button(action: {
                                showingGroceryPrompt = true
                            }) {
                                Text("Submit List")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(greenShade)
                                    .cornerRadius(10)
                                    .shadow(radius: 4)
                            }
                            .padding(.horizontal)
                        }
                        .padding(.top)

                        .padding(.top)
                    }
                    .padding(.bottom, 40)
                }
                .background(backgroundShade.ignoresSafeArea())
                .sheet(isPresented: $showingWhySwapSheet) {
                    if let swap = selectedEcoSwap {
                        EcoSwapDetailView(ecoSwap: swap)
                    }
                }
                .alert("Buy your eco grocery list on EcoCircle's Marketplace?", isPresented: $showingGroceryPrompt) {
                    Button("Yes") {
                        showSwaps = true
                    }
                    Button("No, just show my eco grocery list") {
                        showListOnly = true
                    }
                } message: {
                    Text("You can earn 200 points if you shop your grocery list from the EcoCircle Marketplace.")
                }
                .sheet(isPresented: $showSwaps) {
                    Text("🔄 Here are your Eco Grocery Swaps!")
                        .font(.title2)
                        .padding()
                }
                .sheet(isPresented: $showListOnly) {
                    VStack(alignment: .leading) {
                        Text("📝 Your Grocery List")
                            .font(.title2.bold())
                            .padding(.bottom, 8)
                        ScrollView {
                            Text(groceryList)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(radius: 3)
                        }
                        .padding()
                        Spacer()
                    }
                    .padding()
                    .background(backgroundShade.ignoresSafeArea())
                }
                .navigationBarHidden(true)
            }
        }
    }

    private var uniqueCategories: [String] {
        Array(Set(ecoSwaps.map { $0.category })).sorted()
    }

    private func ecoSwaps(for category: String) -> [EcoSwap] {
        ecoSwaps.filter { $0.category == category }
    }
}

// MARK: - EcoSwap Card
struct EcoSwapCard: View {
    let ecoSwap: EcoSwap
    let whySwapAction: () -> Void

    @State private var isPressed = false

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                VStack {
                    Image(ecoSwap.oldItemImageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipped()
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)

                    Text(ecoSwap.oldItemName)
                        .font(.caption.weight(.medium))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                }

                Image(systemName: "arrow.right")
                    .font(.title3)
                    .foregroundColor(Color(red: 0.18, green: 0.56, blue: 0.27))
                    .padding(.top, 30)

                VStack {
                    Image(ecoSwap.newItemImageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipped()
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)

                    Text(ecoSwap.newItemName)
                        .font(.caption.weight(.medium))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.title3)
                    .foregroundColor(.gray.opacity(0.5))
                    .padding(.top, 30)
            }

            Button(action: whySwapAction) {
                Text("Why Swap?")
                    .font(.footnote.weight(.semibold))
                    .foregroundColor(Color(red: 0.18, green: 0.56, blue: 0.27))
                    .padding(.vertical, 8)
                    .padding(.horizontal, 20)
                    .background(
                        Capsule()
                            .stroke(Color(red: 0.18, green: 0.56, blue: 0.27), lineWidth: 1.5)
                    )
            }
            .buttonStyle(PlainButtonStyle())
            .scaleEffect(isPressed ? 0.96 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isPressed)
            .onLongPressGesture(minimumDuration: 0.1, pressing: { pressing in
                withAnimation {
                    isPressed = pressing
                }
            }, perform: {})
        }
        .padding()
        .background(Color.white)
        .cornerRadius(18)
    }
}

// MARK: - Detail Sheet View
struct EcoSwapDetailView: View {
    let ecoSwap: EcoSwap

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Why Swap \(ecoSwap.oldItemName) for \(ecoSwap.newItemName)?")
                    .font(.title2.bold())
                    .foregroundColor(Color(red: 0.18, green: 0.56, blue: 0.27))

                Text(ecoSwap.whySwapText)
                    .font(.body)
                    .foregroundColor(.secondary)

                Spacer()
            }
            .padding()
        }
        .background(Color(.systemBackground))
    }
}

// MARK: - Preview
struct EcoSwapsLibraryView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EcoSwapsLibraryView()
                .previewDevice("iPhone 15 Pro")
            EcoSwapsLibraryView()
                .previewDevice("iPad Pro (12.9-inch) (6th generation)")
        }
    }
}

