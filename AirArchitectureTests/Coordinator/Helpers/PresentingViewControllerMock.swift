//  Copyright © 2021 Yurii Lysytsia. All rights reserved.

import UIKit

final class PresentingViewControllerMock: UIViewController {
    
    // MARK: - Public Properties
    
    override var presentedViewController: UIViewController? {
        return _presentedViewController
    }
    
    // MARK: - Private Properties
    
    private var _presentedViewController: UIViewController?
    
    // MARK: - Methods
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        _presentedViewController = viewControllerToPresent
        completion?()
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        _presentedViewController = nil
        completion?()
    }
    
}
