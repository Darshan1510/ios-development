//
//  UserProfileController.swift
//  cs5520-assignment-7
//
//  Created by Darshan Shah on 10/29/25.
//

import UIKit

class UserProfileViewController: UIViewController {
    private let authService = AuthService()
    private let profileView = UserProfileScreenView()

    override func loadView() {
        view = profileView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        setupActions()
        fetchProfile()
    }

    private func setupActions() {
        profileView.logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
    }

    private func fetchProfile() {
        Task {
            if let profile = await authService.getProfile() {
                await MainActor.run {
                    profileView.nameLabel.text = profile.name
                    profileView.emailLabel.text = profile.email
                }
            } else {
                await MainActor.run {
                    profileView.nameLabel.text = "Unable to load profile"
                    profileView.emailLabel.text = ""
                }
            }
        }
    }

    @objc private func logoutTapped() {
        Task {
            let success = await authService.logout()
            if success {
                await MainActor.run {
                    let loginVC = LoginViewController()
                    let navController = UINavigationController(rootViewController: loginVC)
                    navController.modalPresentationStyle = .fullScreen
                    self.present(navController, animated: true)
                }
            } else {
                await MainActor.run {
                    let alert = UIAlertController(title: "Error", message: "Logout failed. Please try again.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
    }
}
