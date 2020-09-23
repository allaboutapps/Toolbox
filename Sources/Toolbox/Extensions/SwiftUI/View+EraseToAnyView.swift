
import SwiftUI

@available(iOS 13.0, *)
public extension View {
    /// Usage:
    /// instead of:
    ///  var body: some View {
    ///       List(items) { item -> AnyView in
    ///           if item.type == .image {
    ///              return AnyView(Image(systemName: item.value))
    ///          } else {
    ///              return AnyView(Text(item.value))
    ///          }
    ///      }
    ///  }
    ///
    ///
    /// use:
    /// var body: some View {
    ///        List(items) { item -> AnyView in
    ///            if item.type == .text {
    ///                return Text(item.value)
    ///                    .eraseToAnyView()
    ///            } else {
    ///                return Image(systemName: item.value)
    ///                    .eraseToAnyView()
    ///            }
    ///   }
    /// }

    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}
