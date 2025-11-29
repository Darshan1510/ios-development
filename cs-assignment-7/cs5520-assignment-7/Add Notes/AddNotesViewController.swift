import UIKit

class AddNotesViewController: UIViewController {

    let addNotesScreenView = AddNotesView()

    override func loadView() {
        view = addNotesScreenView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Note"

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(onButtonSubmit))
    }

    @objc func onButtonSubmit() {
        guard let text = addNotesScreenView.notesTextView.text, !text.isEmpty else {
            showAlert(title: "Error", message: "Note cannot be empty")
            return
        }
        print("Saving note:", text)

        Task {
            if let _ = await NotesService().addNote(text: text) {
                await MainActor.run {
                    NotificationCenter.default.post(name: Notification.Name("NoteSaved"), object: nil)
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                await MainActor.run {
                    self.showAlert(
                        title: "Failed to save note",
                        message: "Please try again."
                    )
                }
            }
        }
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
