import SwiftUI

// see https://swiftwithmajid.com/2021/01/27/lazy-navigation-in-swiftui/

@available(iOS 13.0, macOS 10.15, *)
public extension NavigationLink where Label == EmptyView {
    init?<Value>(_ binding: Binding<Value?>, @ViewBuilder destination: (Value) -> Destination) {
        guard let value = binding.wrappedValue else {
            return nil
        }

        let isActive = Binding(
            get: { true },
            set: { newValue in if !newValue { binding.wrappedValue = nil } }
        )

        self.init(destination: destination(value), isActive: isActive, label: EmptyView.init)
    }
}

@available(iOS 13.0, macOS 10.15, *)
public extension View {
    @ViewBuilder
    func navigate<Value, Destination: View>(using binding: Binding<Value?>, @ViewBuilder destination: (Value) -> Destination) -> some View {
        background(NavigationLink(binding, destination: destination))
    }
}
