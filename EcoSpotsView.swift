//
//  EcoSpotsView.swift
//  our mobile application
//
//  Created by Wanjavwa Nzobokela on 7/28/25.
//
import SwiftUI
import MapKit
import CoreLocation

// MARK: - Location Manager

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var errorMessage: String?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.first else { return }
        DispatchQueue.main.async {
            self.userLocation = loc.coordinate
            self.errorMessage = nil
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.errorMessage = "Location error: \(error.localizedDescription)"
        }
    }
}

// MARK: - Search Result Model

struct SearchResult: Identifiable {
    let id = UUID()
    let mapItem: MKMapItem
}

// MARK: - EcoSpotsView

struct EcoSpotsView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var searchResults: [SearchResult] = []
    @State private var searchText: String = ""

    var body: some View {
        VStack {
            if let error = locationManager.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            }

            TextField("Search eco spots (e.g. \"farmers market\")", text: $searchText, onCommit: {
                performSearch()
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal)

            Map(position: $cameraPosition) {
                if let user = locationManager.userLocation {
                    Annotation("You", coordinate: user) {
                        Circle().fill(Color.blue).frame(width: 12, height: 12)
                    }
                }

                ForEach(searchResults) { result in
                    Marker(result.mapItem.name ?? "", coordinate: result.mapItem.placemark.coordinate)
                }
            }
            .onAppear {
                if let loc = locationManager.userLocation {
                    cameraPosition = .region(MKCoordinateRegion(center: loc, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)))
                }
            }
            .frame(height: 400)
            .padding()

            List(searchResults) { result in
                VStack(alignment: .leading) {
                    Text(result.mapItem.name ?? "Unknown")
                        .font(.headline)
                    Text(result.mapItem.placemark.title ?? "")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .onTapGesture {
                    let coord = result.mapItem.placemark.coordinate
                    cameraPosition = .region(MKCoordinateRegion(center: coord, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
                }
            }
        }
        .navigationTitle("Search Eco Spots")
    }

    private func performSearch() {
        guard let user = locationManager.userLocation, !searchText.isEmpty else { return }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = MKCoordinateRegion(center: user, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        request.resultTypes = .pointOfInterest

        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let items = response?.mapItems, error == nil else {
                locationManager.errorMessage = "Search failed: \(error?.localizedDescription ?? "unknown")"
                return
            }
            DispatchQueue.main.async {
                self.searchResults = items.map { SearchResult(mapItem: $0) }
                if let bounding = response?.boundingRegion {
                    cameraPosition = .region(bounding)
                }
            }
        }
    }
}










