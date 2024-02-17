// Copyright © 2024 Yurii Lysytsia. All rights reserved.

import UIKit

open class NiblessScrollView: UIScrollView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable, message: "Loading the scroll view from a nib is unsupported in favor of initializer dependency injection.")
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
