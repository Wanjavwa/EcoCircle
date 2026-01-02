//
//  DisposeView.swift
//  our mobile application
//
//  Created by Wanjavwa Nzobokela on 7/25/25.
//

import SwiftUI

struct DisposeView: View {
    @State private var selectedWasteType = "Select Waste Type"
    @State private var amount = ""
    @State private var selectedUnit = "Kg"

    @State private var showCollectionCenters = false
    @State private var showRewardPopup = false

    let wasteTypes = ["Plastic", "Paper", "Metal", "Glass", "E-Waste", "Other"]
    let units = ["Kg", "Lbs"]

    let greenAccent = Color(red: 0.18, green: 0.56, blue: 0.27)
    let creamBase = Color(red: 0.95, green: 0.93, blue: 0.86)

    var canSubmit: Bool {
        selectedWasteType != "Select Waste Type" && !amount.isEmpty
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ScrollView {
                    VStack(spacing: 25) {
                        // Top Bar
                        HStack {
                            Text("Dispose")
                                .font(.system(size: geo.size.width * 0.07, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.leading, 16)

                            Spacer()

                            Image(systemName: "line.3.horizontal")
                                .resizable()
                                .frame(width: geo.size.width * 0.06, height: geo.size.width * 0.045)
                                .foregroundColor(.white)
                                .padding(.trailing, 16)
                        }
                        .frame(height: geo.size.height * 0.1)
                        .background(greenAccent)
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)

                        // Main Illustration
                        Image("dispose")
                            .resizable()
                            .scaledToFit()
                            .frame(height: geo.size.height * 0.3)
                            .shadow(radius: 8)
                            .padding(.horizontal, geo.size.width * 0.15)
                            .padding(.top, 10)

                        // Waste Type Picker
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Select Waste Type")
                                .font(.headline)
                                .foregroundColor(greenAccent)

                            Menu {
                                ForEach(wasteTypes, id: \.self) { type in
                                    Button(action: { selectedWasteType = type }) {
                                        Text(type)
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedWasteType)
                                        .foregroundColor(selectedWasteType == "Select Waste Type" ? .gray : .black)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(greenAccent)
                                }
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 15).stroke(greenAccent, lineWidth: 2))
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(15)
                                .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 3)
                            }
                        }
                        .padding(.horizontal, geo.size.width * 0.08)

                        // Amount Field + Unit Picker
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Enter Amount")
                                .font(.headline)
                                .foregroundColor(greenAccent)

                            HStack(spacing: 15) {
                                TextField("Enter Amount", text: $amount)
                                    .keyboardType(.decimalPad)
                                    .foregroundColor(.black) // <-- Add this line
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 15).stroke(greenAccent, lineWidth: 2))
                                    .background(Color.white.opacity(0.8))
                                    .cornerRadius(15)
                                    .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 3)


                                Menu {
                                    ForEach(units, id: \.self) { unit in
                                        Button(action: { selectedUnit = unit }) {
                                            Text(unit)
                                        }
                                    }
                                } label: {
                                    Text(selectedUnit)
                                        .foregroundColor(.black)
                                        .frame(width: geo.size.width * 0.15)
                                        .padding()
                                        .background(RoundedRectangle(cornerRadius: 15).stroke(greenAccent, lineWidth: 2))
                                        .background(Color.white.opacity(0.8))
                                        .cornerRadius(15)
                                        .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 3)
                                }
                            }
                        }
                        .padding(.horizontal, geo.size.width * 0.08)

                        // Submit Button
                        Button(action: {
                            if canSubmit {
                                withAnimation {
                                    showCollectionCenters = true
                                }
                                print("Submitted \(amount) \(selectedUnit) of \(selectedWasteType)")
                            }
                        }) {
                            Text("Submit")
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(canSubmit ? greenAccent : greenAccent.opacity(0.5))
                                .cornerRadius(20)
                                .shadow(color: greenAccent.opacity(0.5), radius: 8, x: 0, y: 4)
                        }
                        .padding(.horizontal, geo.size.width * 0.08)
                        .padding(.top, 10)
                        .disabled(!canSubmit)

                        Spacer(minLength: 20)
                    }
                    .padding(.vertical)
                    .background(creamBase.ignoresSafeArea())
                    .frame(minHeight: geo.size.height)
                }

                // Overlay Panel for Collection Centers
                if showCollectionCenters {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .transition(.opacity)
                        .zIndex(1)

                    VStack(spacing: 20) {
                        VStack(spacing: 16) {
                            CollectionCenterCard(
                                name: "EcoCircle Centre",
                                address: "122 Ali Street",
                                distance: "0.5 mile",
                                closingTime: "Closes at 5pm",
                                greenAccent: greenAccent
                            )

                            CollectionCenterCard(
                                name: "EcoCircle Centre",
                                address: "356 Oak Ave",
                                distance: "0.9 mile",
                                closingTime: "Closes at 6pm",
                                greenAccent: greenAccent
                            )
                        }

                        Button(action: {
                            // On Log Waste tapped:
                            withAnimation {
                                showCollectionCenters = false
                            }

                            // Show reward popup shortly after overlay disappears
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                withAnimation {
                                    showRewardPopup = true
                                }
                            }
                        }) {
                            Text("Log Waste")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(greenAccent)
                                .cornerRadius(20)
                                .shadow(color: greenAccent.opacity(0.6), radius: 10, x: 0, y: 5)
                        }
                    }
                    .padding()
                    .background(creamBase)
                    .cornerRadius(20)
                    .padding(.horizontal, 30)
                    .shadow(radius: 15)
                    .zIndex(2)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                // Reward Popup
                if showRewardPopup {
                    Color.black.opacity(0.25)
                        .ignoresSafeArea()
                        .transition(.opacity)
                        .zIndex(3)
                        .onTapGesture {
                            // Tap outside to dismiss popup as well
                            withAnimation {
                                showRewardPopup = false
                            }
                        }

                    VStack(spacing: 16) {
                        Text("You could earn")
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundColor(.black)

                        Text("$10")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(greenAccent)

                        Text("And")
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundColor(.black)

                        Text("100 points")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(greenAccent)

                        Text("to use on the EcoCircle marketplace")
                            .font(.headline)
                            .foregroundColor(.black)

                        Text("Products will be inspected upon arrival therefore incentives may change")
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.top, 4)

                        Button(action: {
                            withAnimation {
                                showRewardPopup = false
                            }
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 32))
                                .foregroundColor(greenAccent)
                                .padding(.top, 12)
                        }
                    }
                    .padding(30)
                    .background(creamBase)
                    .cornerRadius(25)
                    .shadow(radius: 20)
                    .padding(.horizontal, 40)
                    .scaleEffect(showRewardPopup ? 1 : 0.8)
                    .opacity(showRewardPopup ? 1 : 0)
                    .zIndex(4)
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .animation(.easeInOut, value: showCollectionCenters)
            .animation(.easeInOut, value: showRewardPopup)
        }
    }
}

struct CollectionCenterCard: View {
    let name: String
    let address: String
    let distance: String
    let closingTime: String
    let greenAccent: Color

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(name)
                    .font(.headline)
                    .foregroundColor(.black)
                Text(address)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("\(distance) • \(closingTime)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            Button(action: {
                print("Get Directions tapped for \(name)")
            }) {
                HStack(spacing: 4) {
                    Image(systemName: "location.fill")
                        .foregroundColor(greenAccent)
                    Text("Get Directions")
                        .font(.subheadline)
                        .foregroundColor(greenAccent)
                }
                .padding(8)
                .background(greenAccent.opacity(0.15))
                .cornerRadius(12)
                .shadow(color: greenAccent.opacity(0.3), radius: 3, x: 0, y: 2)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
    }
}





