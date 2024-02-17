// Copyright © 2024 Yurii Lysytsia. All rights reserved.

import UIKit

open class NiblessTableViewHeaderFooterView: UITableViewHeaderFooterView {
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    
    @available(*, unavailable, message: "Loading the view from a nib is unsupported in favor of initializer dependency injection.")
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
