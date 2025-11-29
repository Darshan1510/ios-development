import UIKit

class NotesDetailViewController: UIViewController {
    var note: Notes
    private let notesDetailView = NotesDetailView()

    init(note: Notes) {
        self.note = note
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = notesDetailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Note Detail"
        view.backgroundColor = .systemBackground

        // Set note text
        notesDetailView.updateNoteText(note.text ?? "")

        // Add delete button to navigation bar
        let deleteButton = UIBarButtonItem(
            image: UIImage(systemName: "trash"),
            style: .plain,
            target: self,
            action: #selector(deleteButtonTapped)
        )
        deleteButton.tintColor = .systemRed
        navigationItem.rightBarButtonItem = deleteButton
    }

    @objc private func deleteButtonTapped() {
        // Show confirmation alert
        let alert = UIAlertController(
            title: "Delete Note",
            message: "Are you sure you want to delete this note?",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.deleteNote()
        }))

        present(alert, animated: true)
    }

    private func deleteNote() {
        guard let noteId = note._id else { return }

        Task {
            let success = await NotesService().deleteNote(noteId: noteId)

            await MainActor.run {
                if success {
                    NotificationCenter.default.post(name: Notification.Name("NoteSaved"), object: nil)
                    self.navigationController?.popViewController(animated: true)
                } else {
                    let alert = UIAlertController(
                        title: "Error",
                        message: "Failed to delete note.",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
    }
}
