import UIKit

open class NiblessCollectionReusableView: UICollectionReusableView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable, message: "Loading the view from a nib is unsupported in favor of initializer dependency injection.")
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
