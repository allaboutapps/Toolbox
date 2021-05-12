import SwiftUI

#if canImport(UIKit)
@available(iOS 13.0, macOS 10.15, *)
public extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
