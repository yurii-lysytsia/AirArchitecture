import UIKit

open class NiblessTableViewCell: UITableViewCell {
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    @available(*, unavailable, message: "Loading the cell from a nib is unsupported in favor of initializer dependency injection.")
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
