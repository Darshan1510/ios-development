//
//  ViewController.swift
//  cs5520-assignment-7
//
//  Created by Darshan Shah on 10/28/25.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var notes: [Notes] = []
    private let tableView = UITableView()
    private let noteService = NotesService()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Notes"
        view.backgroundColor = .systemBackground

        checkAuthentication()
    }

    // MARK: - Authentication Check
    private func checkAuthentication() {
        if let _ = TokenManager.shared.getToken() {
            setupTableView()
            setupNavigationBar()
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(refreshNotes),
                name: Notification.Name("NoteSaved"),
                object: nil
            )
            fetchNotes()
        } else {
            redirectToLogin()
        }
    }

    // MARK: - UI Setup
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NoteCell")
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(tableView)
    }

    private func setupNavigationBar() {
        // Add Note button (Right)
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNoteTapped)
        )

        // Profile button (Left)
        let profileButton = UIBarButtonItem(
            image: UIImage(systemName: "person.circle"),
            style: .plain,
            target: self,
            action: #selector(profileButtonTapped)
        )
        navigationItem.leftBarButtonItem = profileButton
    }

    // MARK: - Actions
    @objc private func addNoteTapped() {
        let addNoteVC = AddNotesViewController()
        navigationController?.pushViewController(addNoteVC, animated: true)
    }

    @objc private func profileButtonTapped() {
        let profileVC = UserProfileViewController()
        navigationController?.pushViewController(profileVC, animated: true)
    }

    @objc private func refreshNotes() {
        fetchNotes()
    }

    // MARK: - Fetch Notes
    private func fetchNotes() {
        Task {
            guard let fetchedNotes = await noteService.getAllNotes() else {
                print("Error fetching notes: Failed to load or decode data")
                return
            }
            DispatchQueue.main.async {
                self.notes = fetchedNotes
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Navigation
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if TokenManager.shared.getToken() == nil {
            redirectToLogin()
        } else {
            fetchNotes()
        }
    }

    private func redirectToLogin() {
        DispatchQueue.main.async {
            let loginVC = LoginViewController()
            let navController = UINavigationController(rootViewController: loginVC)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true)
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        let note = notes[indexPath.row]
        cell.textLabel?.text = note.text ?? ""
        cell.textLabel?.numberOfLines = 0
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = notes[indexPath.row]
        let detailVC = NotesDetailViewController(note: note)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
