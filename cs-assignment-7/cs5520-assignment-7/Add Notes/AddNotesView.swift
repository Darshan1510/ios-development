//
//  AddNotesView.swift
//  WA7_Bilwal_7432
//
//  Created by Student on 10/28/25.
//

import UIKit

class AddNotesView: UIView {
    
    var contentWrapper: UIScrollView!
    var notesTextView: UITextView!
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        
        setupContentWrapper()
        setupNotesTextView()
        
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupContentWrapper() {
        contentWrapper = UIScrollView()
        contentWrapper.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentWrapper)
    }
    
    func setupNotesTextView() {
        notesTextView = UITextView()
        notesTextView.layer.cornerRadius = 8
        notesTextView.layer.borderWidth = 0.5
        notesTextView.layer.borderColor = UIColor.systemGray3.cgColor
        notesTextView.font = UIFont.systemFont(ofSize: 16)
//        notesTextView.isScrollEnabled = false
        notesTextView.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(notesTextView)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            contentWrapper.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            contentWrapper.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            contentWrapper.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor),
            contentWrapper.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor),

            notesTextView.topAnchor.constraint(equalTo: contentWrapper.topAnchor, constant: 16),
            notesTextView.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 8),
            notesTextView.trailingAnchor.constraint(equalTo: contentWrapper.trailingAnchor, constant: 8),
            notesTextView.widthAnchor.constraint(lessThanOrEqualTo: contentWrapper.widthAnchor),
            notesTextView.heightAnchor.constraint(equalToConstant: 600),
            notesTextView.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
        ])
    }
}
