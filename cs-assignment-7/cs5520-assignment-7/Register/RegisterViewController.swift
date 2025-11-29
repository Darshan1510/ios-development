import UIKit

class RegisterViewController: UIViewController {

    override func loadView() {
        self.view = RegisterView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Register"
        // Wire up buttons
        if let registerView = self.view as? RegisterView {
            registerView.signUpButton.addTarget(self, action: #selector(registerButtonTapped(_:)), for: .touchUpInside)
            registerView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        }
    }

    @objc func registerButtonTapped(_ sender: Any) {
        guard let registerView = self.view as? RegisterView,
              let name = registerView.userNameField.text, !name.isEmpty,
              let email = registerView.userEmailField.text, !email.isEmpty,
              let password = registerView.userPasswordField.text, !password.isEmpty,
              let confirmPassword = registerView.userConfirmPasswordField.text, !confirmPassword.isEmpty else {
            showAlert(message: "Please fill all fields.")
            return
        }

        guard password == confirmPassword else {
            showAlert(message: "Passwords do not match.")
            return
        }

        Task {
            let success = await AuthService().register(name: name, email: email, password: password)
            DispatchQueue.main.async {
                if success, let token = TokenManager.shared.getToken() {
                    UserDefaults.standard.set(token, forKey: "sessionToken")
                    UserDefaults.standard.synchronize()

                    let notesListVC = ViewController()
                    if let navController = self.navigationController {
                        navController.pushViewController(notesListVC, animated: true)
                    } else {
                        let nav = UINavigationController(rootViewController: notesListVC)
                        self.view.window?.rootViewController = nav
                    }
                } else {
                    self.showAlert(message: "Registration failed or user already exists.")
                }
            }
        }
    }

    @objc func loginButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Registration Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
