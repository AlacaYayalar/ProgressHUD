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
        
        return image.rotated(by: 90)
    }
}

extension UIImage {
    func rotated(by degrees: CGFloat) -> UIImage? {
        let radians = degrees * .pi / 180

        // Calculate the rotated image size
        var newSize = CGRect(origin: .zero, size: self.size)
            .applying(CGAffineTransform(rotationAngle: radians))
            .integral.size

        // Ensure scale is preserved
        newSize.width = max(newSize.width, 1)
        newSize.height = max(newSize.height, 1)

        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        // Move origin to center
        context.translateBy(x: newSize.width / 2, y: newSize.height / 2)
        context.rotate(by: radians)

        // Draw the image centered
        self.draw(in: CGRect(
            x: -self.size.width / 2,
            y: -self.size.height / 2,
            width: self.size.width,
            height: self.size.height)
        )

        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return rotatedImage
    }
}

