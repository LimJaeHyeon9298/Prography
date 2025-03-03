//
//  ImageCache.swift
//  Prography_assignment
//
//  Created by 임재현 on 3/2/25.
//

import SwiftUI
import Combine

actor ImageCache {
    static let shared = ImageCache()
    private var cache: [URL: Image] = [:]
    
    func image(for url: URL) -> Image? {
        return cache[url]
    }
    
    func insert(_ image: Image, for url: URL) {
        cache[url] = image
    }
}

class ImageLoader: ObservableObject {
    @Published var image: Image?
    @Published var isLoading = false
    @Published var error: Error?
    
    private var cancellable: AnyCancellable?
    private let url: URL
    private let targetSize: CGSize?
    
    init(url: URL, targetSize: CGSize? = nil) {
        self.url = url
        self.targetSize = targetSize
    }
    
    func load() {
        Task {
            if let cachedImage = await ImageCache.shared.image(for: url) {
                await MainActor.run {
                    self.image = cachedImage
                    return
                }
            }
            
            await MainActor.run {
                self.isLoading = true  
            }
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let uiImage = UIImage(data: data) {
                    let resizedImage = await downSample(image: uiImage)
                    let finalImage = Image(uiImage: resizedImage)
                    
                    await ImageCache.shared.insert(finalImage, for: url)
                    
                    await MainActor.run {
                        self.image = finalImage
                        self.isLoading = false
                    }
                }
            } catch {
                await MainActor.run {
                    self.error = error
                    self.isLoading = false
                }
            }
        }
    }
    
    func cancel() {
        cancellable?.cancel()
    }
    
    private func downSample(image: UIImage) async -> UIImage {
        guard let targetSize = targetSize else { return image }
        
        let imageSize = image.size
        let scale = min(targetSize.width / imageSize.width, targetSize.height / imageSize.height)
        
        if scale >= 1.0 { return image }
        
        let scaledSize = CGSize(width: imageSize.width * scale, height: imageSize.height * scale)
        let renderer = UIGraphicsImageRenderer(size: scaledSize)
        
        let scaledImage = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: scaledSize))
        }
        
        return scaledImage
    }
}

struct CachedAsyncImage: View {
    @StateObject private var loader: ImageLoader
    private let placeholder: AnyView
    
    init(url: URL?, targetSize: CGSize? = nil, @ViewBuilder placeholder: @escaping () -> some View) {
        self.placeholder = AnyView(placeholder())
        _loader = StateObject(wrappedValue: ImageLoader(url: url ?? URL(string: "https://placeholder.com")!, targetSize: targetSize))
    }
    
    var body: some View {
        content
            .onAppear(perform: loader.load)
            .onDisappear(perform: loader.cancel)
    }
    
    @ViewBuilder private var content: some View {
        if let image = loader.image {
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } else if loader.isLoading {
            placeholder
        } else {
            placeholder
        }
    }
}
