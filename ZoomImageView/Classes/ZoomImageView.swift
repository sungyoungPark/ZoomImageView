
import UIKit
import SnapKit

public class ZoomImageView : UIView {
    
    lazy var imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        
        imageView.backgroundColor = .green
        
        return imageView
    }()
    
    lazy var tapGesture : UITapGestureRecognizer = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapImageView))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        
        return tapGesture
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.imageView.addGestureRecognizer(tapGesture)
    }
    
    public convenience init(imageURL : String) {
        self.init()
        guard let imgURL = URL(string: imageURL) else { return }
        
        self.imageView.load(url: imgURL)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ZoomImageView {
    
    @objc private func tapImageView() {
        let zoomDetailVC = ZoomDetailViewController()
 
        let viewController = findViewController()
        zoomDetailVC.imageView.image = imageView.image
        zoomDetailVC.modalPresentationStyle = .fullScreen
        viewController?.present(zoomDetailVC, animated: true)
    }

}

extension UIImage {
     func resize(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale

        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        
        return renderImage
    }
}

extension UIImageView {
    fileprivate func load(url : URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if var image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image.resize(newWidth: self?.frame.width ?? .zero)
                    }
                }
            }
        }
    }
}

extension UIView {
    fileprivate func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}

