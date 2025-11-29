//
//  UserProfileView.swift
//  cs5520-assignment-7
//
//  Created by Darshan Shah on 10/29/25.
//

import UIKit

class UserProfileScreenView: UIView {
    
    let nameLabel = UILabel()
    let emailLabel = UILabel()
    let logoutButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        initConstraints()
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        
        // Name Label
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        nameLabel.textAlignment = .center
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameLabel)
        
        // Email Label
        emailLabel.font = UIFont.systemFont(ofSize: 16)
        emailLabel.textColor = .secondaryLabel
        emailLabel.textAlignment = .center
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(emailLabel)
        
        // Logout Button
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.tintColor = .systemRed
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(logoutButton)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            // Name label at top center
            nameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 80),
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            // Email label below name label
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12),
            emailLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            // Logout button below email label
            logoutButton.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 30),
            logoutButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            logoutButton.widthAnchor.constraint(equalToConstant: 140)
        ])
    }
}

