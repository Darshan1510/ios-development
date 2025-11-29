import UIKit

class NotesDetailView: UIView {
    
    var contentWrapper: UIScrollView!
    var notesLabel: UILabel!
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        
        setupContentWrapper()
        setupNotesLabel()
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup ScrollView
    private func setupContentWrapper() {
        contentWrapper = UIScrollView()
        contentWrapper.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.alwaysBounceVertical = true // allows smooth scrolling even for short content
        self.addSubview(contentWrapper)
    }
    
    // MARK: - Setup Notes Label
    private func setupNotesLabel() {
        notesLabel = UILabel()
        notesLabel.text = "Notes: "
        notesLabel.numberOfLines = 0
        notesLabel.lineBreakMode = .byWordWrapping
        notesLabel.font = UIFont.preferredFont(forTextStyle: .body)
        notesLabel.adjustsFontForContentSizeCategory = true // supports dynamic type
        notesLabel.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(notesLabel)
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Scroll view fills safe area
            contentWrapper.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            contentWrapper.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            contentWrapper.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            contentWrapper.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            
            // Label inside scroll view
            notesLabel.topAnchor.constraint(equalTo: contentWrapper.contentLayoutGuide.topAnchor, constant: 16),
            notesLabel.leadingAnchor.constraint(equalTo: contentWrapper.contentLayoutGuide.leadingAnchor, constant: 16),
            notesLabel.trailingAnchor.constraint(equalTo: contentWrapper.contentLayoutGuide.trailingAnchor, constant: 16),
            notesLabel.bottomAnchor.constraint(equalTo: contentWrapper.contentLayoutGuide.bottomAnchor, constant: -16),
            
            // Make label width equal to scroll view width minus padding
            notesLabel.widthAnchor.constraint(equalTo: contentWrapper.frameLayoutGuide.widthAnchor, constant: -32)
        ])
    }
    
    // MARK: - Public method to update text
    func updateNoteText(_ text: String) {
        notesLabel.text = text
    }
}
