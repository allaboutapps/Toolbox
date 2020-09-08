
import AVFoundation
import SwiftUI
import UIKit

@available(iOS 13.0, *)
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

    func alertPromptToAllowCameraAccessViaSetting() {
        let alert = UIAlertController(title: "Want to access your camera", message: "We need your camera to take pictures", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (_) -> Void in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        })

        let keyWindow = UIApplication.shared.windows.filter { $0.isKeyWindow }.first

        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }

            topController.present(alert, animated: true)
        }
    }

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
                alertPromptToAllowCameraAccessViaSetting()
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
