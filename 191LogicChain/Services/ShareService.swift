import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI
import UIKit

struct ShareService {
    static func qrImage(from string: String, size: CGFloat = 200) -> UIImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        filter.message = Data(string.utf8)
        filter.correctionLevel = "M"
        guard let output = filter.outputImage else { return nil }
        let scaled = output.transformed(by: CGAffineTransform(scaleX: 10, y: 10))
        guard let cgImage = context.createCGImage(scaled, from: scaled.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }

    @MainActor
    static func chainCardImage(title: String, start: String, end: String, author: String) -> UIImage? {
        let view = VStack(spacing: 12) {
            Text("Word Chain Challenge")
                .font(.headline)
            Text(title)
                .font(.title2.bold())
            Text("\(start) → \(end)")
                .font(.title)
                .foregroundColor(.cyan)
            Text("By \(author)")
                .font(.caption)
        }
        .padding(24)
        .frame(width: 320)
        .background(Color(red: 0.05, green: 0.06, blue: 0.09))
        .foregroundColor(.white)

        let renderer = ImageRenderer(content: view)
        renderer.scale = UIScreen.main.scale
        return renderer.uiImage
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
