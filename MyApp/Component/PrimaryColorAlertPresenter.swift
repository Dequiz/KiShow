import SwiftUI
import UIKit

struct PrimaryColorAlertPresenter: UIViewRepresentable {
    @Binding var isPresented: Bool

    let title: String
    let message: String
    let confirmTitle: String
    let cancelTitle: String
    let onConfirm: () -> Void
    let onCancel: () -> Void

    func makeUIView(context: Context) -> PrimaryColorAlertAnchor {
        PrimaryColorAlertAnchor()
    }

    func updateUIView(_ view: PrimaryColorAlertAnchor, context: Context) {
        let presentationBinding = $isPresented
        view.configure(
            isPresented: isPresented,
            title: title,
            message: message,
            confirmTitle: confirmTitle,
            cancelTitle: cancelTitle,
            dismiss: { presentationBinding.wrappedValue = false },
            onConfirm: onConfirm,
            onCancel: onCancel
        )
    }
}

final class PrimaryColorAlertAnchor: UIView {
    private var isPresented = false
    private var title = ""
    private var message = ""
    private var confirmTitle = ""
    private var cancelTitle = ""
    private var dismiss: (() -> Void)?
    private var onConfirm: (() -> Void)?
    private var onCancel: (() -> Void)?
    private var isPresenting = false
    private weak var alertController: UIAlertController?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        presentAlertIfNeeded()
    }

    func configure(
        isPresented: Bool,
        title: String,
        message: String,
        confirmTitle: String,
        cancelTitle: String,
        dismiss: @escaping () -> Void,
        onConfirm: @escaping () -> Void,
        onCancel: @escaping () -> Void
    ) {
        self.isPresented = isPresented
        self.title = title
        self.message = message
        self.confirmTitle = confirmTitle
        self.cancelTitle = cancelTitle
        self.dismiss = dismiss
        self.onConfirm = onConfirm
        self.onCancel = onCancel

        if isPresented {
            presentAlertIfNeeded()
        } else if let alertController {
            self.alertController = nil
            isPresenting = false
            alertController.dismiss(animated: true)
        }
    }

    private func presentAlertIfNeeded() {
        guard isPresented,
              !isPresenting,
              let rootViewController = window?.rootViewController else { return }

        let presenter = rootViewController.topPresentedViewController
        guard !(presenter is UIAlertController) else { return }

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.view.tintColor = .label

        let confirmAction = UIAlertAction(title: confirmTitle, style: .default) { [weak self] _ in
            self?.finish(with: self?.onConfirm)
        }
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { [weak self] _ in
            self?.finish(with: self?.onCancel)
        }

        alert.addAction(confirmAction)
        alert.addAction(cancelAction)

        isPresenting = true
        alertController = alert
        presenter.present(alert, animated: true)
    }

    private func finish(with action: (() -> Void)?) {
        isPresented = false
        isPresenting = false
        alertController = nil
        dismiss?()
        action?()
    }
}

private extension UIViewController {
    var topPresentedViewController: UIViewController {
        if let presentedViewController {
            return presentedViewController.topPresentedViewController
        }

        if let navigationController = self as? UINavigationController,
           let visibleViewController = navigationController.visibleViewController {
            return visibleViewController.topPresentedViewController
        }

        if let tabBarController = self as? UITabBarController,
           let selectedViewController = tabBarController.selectedViewController {
            return selectedViewController.topPresentedViewController
        }

        return self
    }
}
