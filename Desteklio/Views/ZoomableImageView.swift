import SwiftUI

struct ZoomableImageView: View {
    let imageURL: String
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    
    var body: some View {
        GeometryReader { geometry in
            CachedAsyncImage(url: imageURL, contentMode: .fit)
                .scaleEffect(scale)
                .offset(offset)
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            let delta = value / lastScale
                            lastScale = value
                            scale = min(max(scale * delta, 1), 4)
                        }
                        .onEnded { _ in
                            lastScale = 1.0
                        }
                        .simultaneously(with: DragGesture()
                            .onChanged { value in
                                offset = CGSize(
                                    width: lastOffset.width + value.translation.width,
                                    height: lastOffset.height + value.translation.height
                                )
                            }
                            .onEnded { _ in
                                lastOffset = offset
                            })
                )
                .onTapGesture(count: 2) {
                    withAnimation {
                        scale = scale > 1 ? 1 : 2
                        offset = .zero
                        lastOffset = .zero
                    }
                }
        }
    }
}

#Preview {
    ZoomableImageView(imageURL: "https://example.com/image.jpg")
} 