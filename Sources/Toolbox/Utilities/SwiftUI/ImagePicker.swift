
import AVFoundation
import SwiftUI
import UIKit

@available(iOS 13.0, *)
/// SwiftUI 1.0 && iOS13
struct ImagePicker: UIViewControllerRepresentable {
    class PickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let editedImage = info[.editedImage] as? UIImage {
                parent.image = editedImage
            }

            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    @Binding var image: UIImage?
    @Binding var sourceType: UIImagePickerController.SourceType

    @SwiftUI .Environment(\.presentationMode) var presentationMode

    let picker = UIImagePickerController()

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        picker.allowsEditing = true

        if sourceType == .camera {
            switch authStatus {
            case .authorized:
                return picker
            case .denied, .restricted:
                // You can implement here a UIAlertController to try again or to ask to go to the settings and enable it from there
                print("Denied or restricted")
            default:
                // Not determined fill fall here - after first use, when is't neither authorized, nor denied
                // we try to use camera, because system will ask itself for camera permissions
                return picker
            }
        }
        return picker
    }

    private func test() -> UIImagePickerController {
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {}

    func makeCoordinator() -> PickerCoordinator {
        PickerCoordinator(self)
    }
}
