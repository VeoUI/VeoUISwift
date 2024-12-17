//
//  VeoImage.swift
//  VeoUI
//
//  Created by Yassine Lafryhi on 8/12/2024.
//

import SwiftUI

public struct VeoImage: View {
    let url: String
    var placeholder = "photo"
    var contentMode: ContentMode = .fill
    var cornerRadius: CGFloat = 8
    var showLoadingIndicator = true
    var tintColor: Color = .gray
    var maxWidth: CGFloat? = nil
    var maxHeight: CGFloat? = nil
    var minWidth: CGFloat? = nil
    var minHeight: CGFloat? = nil

    @State private var image: UIImage?
    @State private var isLoading = true
    @State private var hasError = false

    public var body: some View {
        ZStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
                    .frame(
                        minWidth: minWidth,
                        maxWidth: maxWidth,
                        minHeight: minHeight,
                        maxHeight: maxHeight)
                    .clipped()
                    .cornerRadius(cornerRadius)
                    .transition(.opacity)
            } else if hasError {
                errorView
            } else if isLoading {
                loadingView
            }
        }
        .onAppear {
            loadImage()
        }
    }

    private var loadingView: some View {
        ZStack {
            placeholderBackground

            if showLoadingIndicator {
                VeoLoader()
            }
        }
    }

    private var errorView: some View {
        ZStack {
            placeholderBackground

            VStack(spacing: 8) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.system(size: 24))
                    .foregroundColor(tintColor)

                Text("Failed to load image")
                    .font(VeoFont.caption1())
                    .foregroundColor(tintColor)

                Button("Retry") {
                    hasError = false
                    isLoading = true
                    loadImage()
                }
                .font(VeoFont.caption1())
                .foregroundColor(VeoUI.primaryColor)
            }
        }
    }

    private var placeholderBackground: some View {
        ZStack {
            Rectangle()
                .fill(Color.gray.opacity(0.1))
                .frame(
                    minWidth: minWidth,
                    maxWidth: maxWidth,
                    minHeight: minHeight,
                    maxHeight: maxHeight)

            Image(systemName: placeholder)
                .font(.system(size: 24))
                .foregroundColor(tintColor.opacity(0.3))
        }
        .cornerRadius(cornerRadius)
    }

    private func loadImage() {
        guard let imageUrl = URL(string: url) else {
            hasError = true
            isLoading = false
            return
        }

        URLSession.shared.dataTask(with: imageUrl) { data, _, _ in
            DispatchQueue.main.async {
                if let data = data, let loadedImage = UIImage(data: data) {
                    withAnimation {
                        image = loadedImage
                        isLoading = false
                    }
                } else {
                    hasError = true
                    isLoading = false
                }
            }
        }.resume()
    }
}

#Preview {
    FontLoader.loadFonts()

    VeoUI.configure(
        primaryColor: Color(hex: "#e74c3c"),
        primaryDarkColor: Color(hex: "#c0392b"),
        mainFont: "Rubik-Regular")

    struct VeoImagePreview: View {
        let validImageUrl = "https://picsum.photos/400/300"
        let invalidImageUrl = "https://invalid-url.com/image.jpg"

        var body: some View {
            ScrollView {
                VStack(spacing: 32) {
                    Group {
                        Text("Basic Image").font(.headline)
                        VeoImage(
                            url: validImageUrl,
                            maxWidth: 400,
                            maxHeight: 300)
                    }

                    Divider()

                    Group {
                        Text("Content Modes").font(.headline)
                        HStack(spacing: 16) {
                            VeoImage(
                                url: validImageUrl,
                                contentMode: .fill,
                                maxWidth: 150,
                                maxHeight: 150)

                            VeoImage(
                                url: validImageUrl,
                                contentMode: .fit,
                                maxWidth: 150,
                                maxHeight: 150)
                        }
                    }

                    Divider()

                    Group {
                        Text("Corner Radius").font(.headline)
                        HStack(spacing: 16) {
                            VeoImage(
                                url: validImageUrl,
                                cornerRadius: 0,
                                maxWidth: 100,
                                maxHeight: 100)

                            VeoImage(
                                url: validImageUrl,
                                cornerRadius: 16,
                                maxWidth: 100,
                                maxHeight: 100)

                            VeoImage(
                                url: validImageUrl,
                                cornerRadius: 50,
                                maxWidth: 100,
                                maxHeight: 100)
                        }
                    }

                    Divider()

                    Group {
                        Text("Error State").font(.headline)
                        VeoImage(
                            url: invalidImageUrl,
                            maxWidth: 300,
                            maxHeight: 200)
                    }

                    Divider()

                    Group {
                        Text("Custom Placeholder").font(.headline)
                        VeoImage(
                            url: validImageUrl,
                            placeholder: "person.circle.fill",
                            maxWidth: 300,
                            maxHeight: 200)
                    }

                    Divider()

                    Group {
                        Text("Common Use Cases").font(.headline)

                        VeoImage(
                            url: validImageUrl,
                            placeholder: "person.circle.fill",
                            cornerRadius: 50,
                            maxWidth: 100,
                            maxHeight: 100)

                        VeoImage(
                            url: validImageUrl,
                            contentMode: .fill,
                            cornerRadius: 12,
                            maxWidth: .infinity,
                            maxHeight: 200)

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 3), spacing: 16) {
                            ForEach(0 ..< 6) { _ in
                                VeoImage(
                                    url: validImageUrl,
                                    cornerRadius: 8,
                                    showLoadingIndicator: false,
                                    maxWidth: .infinity,
                                    maxHeight: 100)
                            }
                        }
                    }
                }
                .padding()
            }
        }
    }

    return VeoImagePreview()
}
