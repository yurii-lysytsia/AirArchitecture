// Copyright © 2024 Yurii Lysytsia. All rights reserved.

import UIKit

open class NiblessControl: UIControl {
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable, message: "Loading the control from a nib is unsupported in favor of initializer dependency injection.")
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
