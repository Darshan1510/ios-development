import UIKit

class LoginViewController: UIViewController {

    override func loadView() {
        self.view = LoginView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Wire up buttons AFTER the view is set.
        if let loginView = self.view as? LoginView {
            loginView.loginButton.addTarget(self, action: #selector(loginButtonTapped(_:)), for: .touchUpInside)
            loginView.signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        }
    }

    @objc func loginButtonTapped(_ sender: Any) {
        guard let loginView = self.view as? LoginView,
              let email = loginView.userEmailField.text, !email.isEmpty,
              let password = loginView.userPasswordField.text, !password.isEmpty else {
            showAlert(message: "Please enter email and password.")
            return
        }
        print("hello")
        Task {
            let success = await AuthService().login(email: email, password: password)
            DispatchQueue.main.async {
                if success, let token = TokenManager.shared.getToken() {
                    print(token)
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
                    self.showAlert(message: "Login failed. Please check your credentials.")
                }
            }
        }
    }

    @objc func signUpButtonTapped() {
        let registerVC = RegisterViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Login Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
