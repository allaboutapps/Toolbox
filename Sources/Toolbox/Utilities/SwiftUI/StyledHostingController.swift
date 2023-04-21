#if canImport(UIKit)

import Foundation
import SwiftUI
import UIKit

public class StyledHostingController<Content>: UIHostingController<Content> where Content: View {

    public var navigationBarStyle: NavigationBarStyle? {
        didSet {
            updateNavigationBarAppearance()
            setNeedsStatusBarAppearanceUpdate()
        }
    }

    @available(*, unavailable)
    @MainActor dynamic required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public init(rootView: Content) {
        super.init(rootView: rootView)
    }

    public convenience init(rootView: Content, navigationBarStyle: NavigationBarStyle) {
        self.init(rootView: rootView)
        self.navigationBarStyle = navigationBarStyle

        updateNavigationBarAppearance()
    }

    override public var preferredStatusBarStyle: UIStatusBarStyle {
        navigationBarStyle?.statusBarStyle ?? .default
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navigationBarStyle = navigationBarStyle {
            navigationController?.navigationBar.tintColor = navigationBarStyle.tintColor
        }
    }

    private func updateNavigationBarAppearance() {
        guard let appearance = navigationBarStyle?.toAppearance() else { return }
        
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        
        if #available(iOS 15.0, *) {
            navigationItem.compactScrollEdgeAppearance = appearance
        }
    }
}

public class StyledNavigationController: UINavigationController {
    
    override public var childForStatusBarStyle: UIViewController? {
        visibleViewController
    }
}

#endif
