#if canImport(UIKit)

import Combine
import UIKit

@available(iOS 13.0, macOS 10.15, *)
open class Keyboard {
    public struct Info {
        public let keyboardBeginFrame: CGRect
        public let keyboardEndFrame: CGRect
        public let animationDuration: TimeInterval
        public let animationOptions: UIView.AnimationOptions
         
        public var keyboardHeight: CGFloat {
            return keyboardEndFrame.height
        }
    }
    
    public static let shared = Keyboard()
    
    private(set) var isShown: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    @Published public var info = Info(keyboardBeginFrame: .zero, keyboardEndFrame: .zero, animationDuration: 0.0, animationOptions: [])
    
    private init() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification, object: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notification in
                self?.isShown = true
                self?.updateInfoWithNotification(notification)
            }.store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification, object: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notification in
                self?.isShown = true
                self?.updateInfoWithNotification(notification, height: 0)
            }.store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification, object: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notification in
                if self?.isShown == true {
                    self?.updateInfoWithNotification(notification)
                }
            }.store(in: &cancellables)
    }
    
    private func updateInfoWithNotification(_ notification: Notification, height: CGFloat? = nil) {
        let userInfo = notification.userInfo!
        
        let animationDuration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.3
        let animationOptions = UIView.AnimationOptions(rawValue: UInt((userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
        let keyboardBeginFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let keyboardEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let adjustedKeyboardEndFrame: CGRect
        
        if let height = height {
            adjustedKeyboardEndFrame = CGRect(origin: keyboardEndFrame.origin, size: CGSize(width: keyboardEndFrame.width, height: height))
        } else {
            adjustedKeyboardEndFrame = keyboardEndFrame
        }
        
        info = Info(keyboardBeginFrame: keyboardBeginFrame, keyboardEndFrame: adjustedKeyboardEndFrame, animationDuration: animationDuration, animationOptions: animationOptions)
    }
}

// MARK: - UIViewController

@available(iOS 13.0, macOS 10.15, *)
public extension UIViewController {
    func updateSafeAreaInsets(keyboardInfo: Keyboard.Info, keyboardFrame: CGRect? = nil, animated: Bool) {
        let keyboardFrameInView = view.convert(keyboardFrame ?? keyboardInfo.keyboardEndFrame, from: nil)
        let safeAreaFrame = view.safeAreaLayoutGuide.layoutFrame.insetBy(dx: 0, dy: -additionalSafeAreaInsets.bottom)
        let intersection = safeAreaFrame.intersection(keyboardFrameInView)
        
        if additionalSafeAreaInsets.bottom == intersection.height || (keyboardFrameInView.height > 0 && intersection.height == 0) {
            return
        }
        
        if additionalSafeAreaInsets.bottom == intersection.height {
            return
        }
        
        if animated {
            UIView.animate(withDuration: keyboardInfo.animationDuration, delay: 0.0, options: keyboardInfo.animationOptions, animations: {
                self.additionalSafeAreaInsets.bottom = intersection.height
                self.view.layoutIfNeeded()
            })
        } else {
            additionalSafeAreaInsets.bottom = intersection.height
            view.layoutIfNeeded()
        }
    }
    
    func hideKeyboardOnTap() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        recognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(recognizer)
    }
    
    @objc func dismissKeyboard() {
        // Needs to be executed in the next run loop so that buttons have enough time to register being touched
        // before the keyboard disappears.
        DispatchQueue.main.async { [weak self] in
            self?.view.endEditing(true)
        }
    }
}

#endif
