import Kingfisher
import PDFKit
import UIKit

struct PDFProcessor: ImageProcessor {
    let identifier = "com.yourapp.PDFProcessor"

    func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> UIImage? {
        guard case .data(let data) = item else {
            return nil
        }

        guard let document = PDFDocument(data: data),
              let page = document.page(at: 0) else {
            return nil
        }

        // Set desired thumbnail size
        let targetSize = CGSize(width: 300, height: 300) // or imageView.bounds.size if dynamic
        let image = page.thumbnail(of: targetSize, for: .cropBox)
        return image
    }
}

