//
//  EventsView.swift
//  our mobile application
//
//  Created by Wanjavwa Nzobokela on 7/29/25.
//

import SwiftUI

// MARK: - Event Model
struct EcoEvent: Identifiable {
    let id = UUID()
    let title: String
    let date: Date
}

// MARK: - EventsView
struct EventsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var events: [EcoEvent] = [
        EcoEvent(title: "Community Cleanup", date: Date()),
        EcoEvent(title: "Zero Waste Workshop", date: Calendar.current.date(byAdding: .day, value: 3, to: Date())!)
    ]

    @State private var newTitle: String = ""
    @State private var newDate: Date = Date()

    let backgroundColor = Color(red: 0.95, green: 0.93, blue: 0.86)
    let greenAccent = Color(red: 0.18, green: 0.56, blue: 0.27)

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

                    Text("Events")
                        .font(.system(size: geo.size.width * 0.05, weight: .bold))
                        .foregroundColor(.white)

                    Spacer()

                    Spacer().frame(width: 30)
                }
                .frame(height: geo.size.height * 0.07)
                .background(greenAccent)

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        Text("Upcoming Eco Events")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.black)
                            .padding(.top)
                            .padding(.horizontal)

                        ForEach(events.sorted { $0.date < $1.date }) { event in
                            EventRow(event: event)
                                .padding(.horizontal)
                        }

                        Divider().padding()

                        VStack(spacing: 16) {
                            Text("Log a New Event")
                                .font(.headline)
                                .foregroundColor(.black)

                            TextField("Event Title", text: $newTitle)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .foregroundColor(.black)

                            DatePicker("Select Date", selection: $newDate, displayedComponents: [.date])
                                .datePickerStyle(.compact)
                                .foregroundColor(.black)

                            Button(action: {
                                let newEvent = EcoEvent(title: newTitle, date: newDate)
                                events.append(newEvent)
                                newTitle = ""
                                newDate = Date()
                            }) {
                                Text("Add Event")
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(greenAccent)
                                    .cornerRadius(12)
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.95))
                        .cornerRadius(16)
                        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 3)
                        .padding(.horizontal)
                        .padding(.bottom, 40)
                    }
                }
                .background(backgroundColor.ignoresSafeArea())
            }
        }
    }
}

// MARK: - EventRow
struct EventRow: View {
    let event: EcoEvent
    let green = Color(red: 0.2, green: 0.55, blue: 0.3)

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(event.title)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(event.date, style: .date)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
            Spacer()
            Image(systemName: "calendar")
                .foregroundColor(.white)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(green.opacity(0.9))
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
        )
    }
}

// MARK: - Preview
struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EventsView()
                .previewDevice("iPhone 15 Pro")
            EventsView()
                .previewDevice("iPad Pro (11-inch) (4th generation)")
        }
    }
}
