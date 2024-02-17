import UIKit

open class NiblessCollectionViewCell: UICollectionViewCell {
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable, message: "Loading the cell from a nib is unsupported in favor of initializer dependency injection.")
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
