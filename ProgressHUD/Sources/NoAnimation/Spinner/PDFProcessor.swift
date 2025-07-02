import Kingfisher
import PDFKit
import UIKit

public struct PDFProcessor: ImageProcessor {
    public let identifier = "com.yourapp.PDFProcessor"
    
    public init() {}
    
    public func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        switch item {
        case .image:
            // Already an image, return as-is
            return nil
        case .data(let data):
            guard let pdfDocument = PDFDocument(data: data),
                  let page = pdfDocument.page(at: 0) else {
                return nil
            }
            
            //            let pageRect = page.bounds(for: .mediaBox)
            let pageRect = page.bounds(for: .cropBox)
            let scale: CGFloat = UIScreen.main.scale
            let size = CGSize(width: pageRect.width * scale, height: pageRect.height * scale)

            let renderer = UIGraphicsImageRenderer(size: size)
            let image = renderer.image { ctx in
                ctx.cgContext.setFillColor(UIColor.clear.cgColor)
                ctx.cgContext.fill(CGRect(origin: .zero, size: size))
                
                ctx.cgContext.saveGState()
                
                ctx.cgContext.scaleBy(x: scale, y: scale)
                
                let angle = CGFloat(page.rotation) * .pi / 180
                ctx.cgContext.translateBy(x: pageRect.width / 2, y: pageRect.height / 2)
                ctx.cgContext.rotate(by: angle)
                ctx.cgContext.translateBy(x: -pageRect.width / 2, y: -pageRect.height / 2)
                
                page.draw(with: .cropBox, to: ctx.cgContext)
                
                ctx.cgContext.restoreGState()
            }
            
            return image
        }
    }
}
