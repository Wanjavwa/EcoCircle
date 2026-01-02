//
//  newview.swift
//  our mobile application
//
//  Created by Wanjavwa Nzobokela on 7/29/25.
//

import SwiftUI

struct GreenMarketView: View {
    let products: [MarketItem] = [
        MarketItem(name: "Rec-Vest", price: "$20", imageName: "pic1"),
        MarketItem(name: "Decor", price: "$12", imageName: "pic2"),
        MarketItem(name: "Jeans", price: "$10", imageName: "pic3"),
        MarketItem(name: "Tote-Bag", price: "$14", imageName: "pic4"),
        MarketItem(name: "ClayPot", price: "$20", imageName: "pic5"),
        MarketItem(name: "Glass Vase", price: "$12", imageName: "pic6"),
        MarketItem(name: "Necklace", price: "$15", imageName: "pic7"),
        MarketItem(name: "Telephone", price: "$8", imageName: "pic8"),
        MarketItem(name: "Glass Jar", price: "$10", imageName: "pic9"),
        MarketItem(name: "Painting", price: "$10", imageName: "pic10"),
        MarketItem(name: "BasketBag", price: "$15", imageName: "pic11"),
        MarketItem(name: "Brush-Holder", price: "$8", imageName: "pic12")
    ]

    let columns = [
        GridItem(.flexible()), GridItem(.flexible())
    ] // two columns for better item sizing

    let backgroundColor = Color(red: 0.95, green: 0.93, blue: 0.86)
    let barColor = Color(red: 0.18, green: 0.56, blue: 0.27)
    let greenAccent = Color(red: 0.22, green: 0.6, blue: 0.3)

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("The Green Market")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.white)

                Spacer()

                Image(systemName: "line.3.horizontal")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(10)
                    .background(greenAccent.opacity(0.7))
                    .clipShape(Circle())
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(barColor)
            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)

            // Subheading + Categories
            VStack(alignment: .leading, spacing: 8) {
                Text("Discover and support upcyclers making waste beautiful.")
                    .font(.subheadline)
                    .foregroundColor(.black.opacity(0.85))
                    .padding(.horizontal)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(["All", "Home Decor", "Handmade", "Upcycled Glass", "Fashion"], id: \.self) { category in
                            Text(category)
                                .font(.footnote.weight(.semibold))
                                .padding(.vertical, 6)
                                .padding(.horizontal, 14)
                                .background(greenAccent.opacity(0.15))
                                .foregroundColor(greenAccent)
                                .clipShape(Capsule())
                                .shadow(color: greenAccent.opacity(0.2), radius: 2, x: 0, y: 1)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical, 10)

            // Product Grid
            ScrollView {
                LazyVGrid(columns: columns, spacing: 24) {
                    ForEach(products) { item in
                        VStack(spacing: 10) {
                            Image(item.imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 160)
                                .frame(maxWidth: .infinity)
                                .clipped()
                                .cornerRadius(16)
                                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 5)

                            VStack(alignment: .leading, spacing: 6) {
                                Text(item.name)
                                    .font(.headline)
                                    .foregroundColor(.black)

                                Text(item.price)
                                    .font(.subheadline.weight(.bold))
                                    .foregroundColor(greenAccent)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 8)
                            .padding(.bottom, 8)
                        }
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 3)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 6)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            // Add your tap action here if you want
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 80)
            }

            // Bottom Bar
            HStack {
                BottomTabItem(icon: "house.fill", label: "Home")
                Spacer()
                BottomTabItem(icon: "qrcode", label: "Scan")
                Spacer()
                BottomTabItem(icon: "trash.fill", label: "Dispose")
                Spacer()
                BottomTabItem(icon: "person.3.fill", label: "Community")
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 14)
            .background(barColor)
            .foregroundColor(.white)
            .font(.caption)
            .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: -3)
        }
        .background(backgroundColor.ignoresSafeArea())
    }
}

struct BottomTabItem: View {
    let icon: String
    let label: String

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 20))
            Text(label)
        }
        .frame(maxWidth: .infinity)
    }
}

struct MarketItem: Identifiable {
    let id = UUID()
    let name: String
    let price: String
    let imageName: String
}

