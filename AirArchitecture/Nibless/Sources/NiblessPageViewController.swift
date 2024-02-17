import UIKit

open class NiblessPageViewController: UIPageViewController {
    public override init(
        transitionStyle style: UIPageViewController.TransitionStyle,
        navigationOrientation: UIPageViewController.NavigationOrientation,
        options: [UIPageViewController.OptionsKey: Any]? = nil
    ) {
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: options)
    }
    
    @available(*, unavailable, message: "Loading the navigation controller from a nib is unsupported in favor of initializer dependency injection.")
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
