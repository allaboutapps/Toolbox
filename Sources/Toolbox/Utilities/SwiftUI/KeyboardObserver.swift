#if canImport(UIKit)

import Combine
import SwiftUI
import UIKit

@available(iOS 13.0, macOS 10.15, *)
class KeyboardObserver: ObservableObject {
    /// Usage:
    /// For example you want to move button to top of the keyboard
    ///
    /// @ObservedObject private var keyboardObserver = KeyboardObserver()
    /// Button(action: {}, label: {})
    ///     .padding(.bottom, self.keyboardObserver)
    
    private var cancellable: AnyCancellable?
    
    @Published private(set) var keyboardHeight: CGFloat = 0
    
    let keyboardWillShow = NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillShowNotification)
        .compactMap { ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height }
    
    let keyboardWillHide = NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillHideNotification)
        .map { _ -> CGFloat in 0 }
    
    init() {
        cancellable = Publishers.Merge(keyboardWillShow, keyboardWillHide)
            .subscribe(on: RunLoop.main)
            .assign(to: \.keyboardHeight, on: self)
    }
}

#endif
