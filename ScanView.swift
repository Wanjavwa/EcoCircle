//
//  ContentView 2.swift
//  our mobile application
//
//  Created by Wanjavwa Nzobokela on 7/20/25.
//
import SwiftUI
import UIKit
import AVFoundation

// MARK: - Models

enum EcoScoreGrade: String, Comparable {
    case a = "A"
    case b = "B"
    case c = "C"
    case d = "D"
    case e = "E"
    case unknown = "?"

    static func < (lhs: EcoScoreGrade, rhs: EcoScoreGrade) -> Bool {
        let order: [EcoScoreGrade] = [.a, .b, .c, .d, .e, .unknown]
        guard let lhsIndex = order.firstIndex(of: lhs),
              let rhsIndex = order.firstIndex(of: rhs) else { return false }
        return lhsIndex > rhsIndex
    }
}

struct ProductInfo {
    let barcode: String
    let name: String
    let imageURL: URL?
    let ecoscore: EcoScoreGrade
    let carbonFootprint: Int?
    let packagingInfo: String?
    let categories: [String]
}

// MARK: - Barcode Scanner

class CameraViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer!
    var onCodeScanned: ((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }

    func setupCamera() {
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device),
              captureSession.canAddInput(input) else { return }

        captureSession.addInput(input)

        let output = AVCaptureMetadataOutput()
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
            output.setMetadataObjectsDelegate(self, queue: .main)
            output.metadataObjectTypes = [.ean8, .ean13, .upce]
        }

        DispatchQueue.main.async {
            self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
            self.previewLayer.frame = self.view.layer.bounds
            self.previewLayer.videoGravity = .resizeAspectFill
            self.view.layer.addSublayer(self.previewLayer)
        }

        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        if let obj = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
           let code = obj.stringValue {
            captureSession.stopRunning()
            onCodeScanned?(code)
        }
    }
}

struct CameraView: UIViewControllerRepresentable {
    var onCodeScanned: (String) -> Void

    func makeUIViewController(context: Context) -> CameraViewController {
        let vc = CameraViewController()
        vc.onCodeScanned = onCodeScanned
        return vc
    }

    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}
}

// MARK: - Main Scan View

struct ScanView: View {
    @State private var scannedCode: String?
    @State private var product: ProductInfo?
    @State private var suggestions: [ProductInfo] = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Scan a Product")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)

                ZStack {
                    CameraView { code in
                        scannedCode = code
                        print("Scanned barcode: \(code)")
                        fetchProductData(barcode: code)
                    }
                    .frame(height: 280)
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.green, lineWidth: 2))

                    if isLoading {
                        ProgressView("Loading…")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.black.opacity(0.4))
                            .cornerRadius(12)
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal)

                if let p = product {
                    resultView(p)
                } else if let err = errorMessage {
                    Text("Error: \(err)")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                }

                if !suggestions.isEmpty {
                    SuggestionView(suggestions: suggestions)
                } else if product != nil {
                    Text("No better alternatives found.")
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                }
            }
        }
        .navigationTitle("Scan Product")
    }

    // MARK: - Fetch product data

    func fetchProductData(barcode: String) {
        isLoading = true
        errorMessage = nil
        product = nil
        suggestions = []

        let url = URL(string: "https://world.openfoodfacts.org/api/v0/product/\(barcode).json")!

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data,
                  let resp = try? JSONDecoder().decode(OpenFoodResponse.self, from: data),
                  resp.status == 1,
                  let prod = resp.product else {
                DispatchQueue.main.async {
                    self.errorMessage = "Product not found or data unavailable."
                    self.isLoading = false
                }
                return
            }

            let name = prod.product_name ?? "Unknown"
            let imgURL = prod.image_url.flatMap(URL.init)
            let ecoscoreRaw = prod.ecoscore_grade?.uppercased() ?? "?"
            let ecoscore = EcoScoreGrade(rawValue: ecoscoreRaw) ?? .unknown
            let carbonG = prod.carbon_footprint_100g
            let packaging = prod.packaging
            let categories = prod.categories_tags ?? []

            print("Scanned product name: \(name)")
            print("Eco-score: \(ecoscore.rawValue)")
            print("Categories: \(categories)")

            DispatchQueue.main.async {
                self.product = ProductInfo(
                    barcode: barcode,
                    name: name,
                    imageURL: imgURL,
                    ecoscore: ecoscore,
                    carbonFootprint: carbonG,
                    packagingInfo: packaging,
                    categories: categories
                )
                self.isLoading = false

                // Trigger suggestions if ecoscore is C or worse (C, D, E)
                if ecoscore <= .c, let firstCategory = categories.first {
                    print("Fetching suggestions for category: \(firstCategory)")
                    fetchSuggestions(category: firstCategory)
                } else {
                    print("No suggestions needed; ecoscore is better than C")
                    self.suggestions = []
                }
            }

        }.resume()
    }

    // MARK: - Fetch suggestions for better products

    func fetchSuggestions(category: String) {
        let components = category.split(separator: ":")
        guard components.count == 2 else {
            print("Category tag format unexpected: \(category)")
            return
        }
        let categorySlug = String(components[1])
        let categoryEncoded = categorySlug.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? categorySlug

        let urlStr = "https://world.openfoodfacts.org/category/\(categoryEncoded).json?fields=product_name,code,ecoscore_grade,image_url&page_size=20"
        guard let url = URL(string: urlStr) else {
            print("Invalid URL for category: \(categoryEncoded)")
            return
        }

        print("Requesting suggestions from URL: \(urlStr)")

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Suggestion fetch error: \(error)")
                return
            }

            guard let data = data,
                  let resp = try? JSONDecoder().decode(CategorySearchResponse.self, from: data) else {
                print("Failed to decode suggestions response")
                return
            }

            // Debug print all ecoscore grades received
            let ecoscores = resp.products.map { $0.ecoscore_grade?.uppercased() ?? "?" }
            print("All products ecoscores fetched: \(ecoscores)")

            let filtered = resp.products.filter {
                if let ecoRaw = $0.ecoscore_grade?.uppercased(),
                   let eco = EcoScoreGrade(rawValue: ecoRaw),
                   eco <= .c,
                   let name = $0.product_name, !name.isEmpty {
                    return true
                }
                return false
            }

            print("Filtered suggestions count: \(filtered.count)")

            let suggestions = filtered.map {
                ProductInfo(
                    barcode: $0.code,
                    name: $0.product_name ?? "Unknown",
                    imageURL: $0.image_url.flatMap(URL.init),
                    ecoscore: EcoScoreGrade(rawValue: $0.ecoscore_grade?.uppercased() ?? "?") ?? .unknown,
                    carbonFootprint: nil,
                    packagingInfo: nil,
                    categories: []
                )
            }

            DispatchQueue.main.async {
                self.suggestions = suggestions
                if suggestions.isEmpty {
                    print("No suitable suggestions found for category \(categorySlug)")
                } else {
                    print("Suggestions updated, count: \(suggestions.count)")
                }
            }
        }.resume()
    }

    // MARK: - UI Views

    @ViewBuilder
    func resultView(_ p: ProductInfo) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            if let url = p.imageURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 150, height: 150)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 150, maxHeight: 150)
                            .cornerRadius(10)
                    case .failure:
                        Color.gray.frame(width: 150, height: 150)
                    @unknown default:
                        EmptyView()
                    }
                }
            }

            Text(p.name).font(.title2).bold()

            Text("Eco-Score: \(p.ecoscore.rawValue)")
                .font(.headline)
                .foregroundColor(.green)

            if let co2 = p.carbonFootprint {
                Text("Carbon Footprint: \(co2)g CO₂ per 100g")
                    .font(.subheadline)
            } else {
                Text("Carbon Footprint: Unavailable")
                    .font(.subheadline)
            }

            if let pkg = p.packagingInfo, !pkg.isEmpty {
                Text("Packaging: \(pkg)")
                    .font(.subheadline)
            } else {
                Text("Packaging Info: Unavailable")
                    .font(.subheadline)
            }

            Link("View Full CO₂ & Packaging Info on Web",
                 destination: URL(string: "https://world.openfoodfacts.org/product/\(p.barcode)")!)
                .font(.subheadline)
                .foregroundColor(.blue)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct SuggestionView: View {
    let suggestions: [ProductInfo]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Better alternatives:")
                .font(.headline)
                .padding(.bottom, 4)

            ForEach(suggestions, id: \.barcode) { product in
                HStack(spacing: 12) {
                    if let url = product.imageURL {
                        AsyncImage(url: url) { image in
                            image.resizable()
                                .frame(width: 50, height: 50)
                                .cornerRadius(6)
                        } placeholder: {
                            Color.gray.frame(width: 50, height: 50)
                        }
                    }
                    VStack(alignment: .leading) {
                        Text(product.name)
                            .font(.subheadline)
                            .lineLimit(2)
                        Text("Eco-Score: \(product.ecoscore.rawValue)")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .padding()
        .background(Color(.systemGray5))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

// MARK: - API Models

struct OpenFoodResponse: Codable {
    struct Product: Codable {
        let product_name: String?
        let ecoscore_grade: String?
        let image_url: String?
        let carbon_footprint_100g: Int?
        let packaging: String?
        let categories_tags: [String]?
    }
    let status: Int
    let product: Product?
}

struct CategorySearchResponse: Codable {
    struct Product: Codable {
        let product_name: String?
        let code: String
        let ecoscore_grade: String?
        let image_url: String?
    }
    let products: [Product]
}



















