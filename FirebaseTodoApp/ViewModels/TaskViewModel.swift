//
//  TaskViewModel.swift
//  FirebaseTodoApp
//
//  All Firestore work (Create, Read, Update, Delete) happens here.
//  Data path:  users/{userId}/tasks/{taskId}
//

import Foundation
import FirebaseFirestore

/// Firestore delivers snapshot listener events and completion handlers
/// on the main thread, so we can update @Published properties directly.
final class TaskViewModel: ObservableObject {

    @Published var tasks: [TaskItem] = []
    @Published var errorMessage: String?

    // lazy property: Firestore is only created the first time we use it
    private lazy var db = Firestore.firestore()

    private var listener: ListenerRegistration?
    private var userId: String?

    // MARK: - READ (live updates)

    /// Starts listening to this user's tasks. Every add / edit / delete
    /// (even from another device) updates `tasks` automatically.
    func startListening(userId: String) {
        // Already listening to this user? Then do nothing.
        if self.userId == userId && listener != nil { return }

        stopListening()
        self.userId = userId

        listener = tasksCollection(for: userId)
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self else { return }

                if let error {
                    self.errorMessage = error.localizedDescription
                    return
                }
                guard let documents = snapshot?.documents else { return }

                // compactMap drops the documents that could not be read (nil)
                self.tasks = documents.compactMap { TaskItem(document: $0) }
            }
    }

    func stopListening() {
        listener?.remove()
        listener = nil
        userId = nil
        tasks = []
    }

    // MARK: - CREATE

    func addTask(title: String, description: String) {
        guard let userId else { return }

        let newTask = TaskItem(title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                               description: description)
        guard newTask.isValid else {
            errorMessage = "Title cannot be empty."
            return
        }

        var data = newTask.firestoreData
        data["createdAt"] = FieldValue.serverTimestamp()

        tasksCollection(for: userId).addDocument(data: data) { [weak self] error in
            self?.show(error)
        }
    }

    // MARK: - UPDATE

    func updateTask(_ task: TaskItem) {
        guard let userId, task.isValid else { return }

        tasksCollection(for: userId)
            .document(task.id)
            .updateData(task.firestoreData) { [weak self] error in
                self?.show(error)
            }
    }

    func toggleDone(_ task: TaskItem) {
        var changed = task          // a copy, because TaskItem is a struct (value type)
        changed.isDone.toggle()
        updateTask(changed)
    }

    // MARK: - DELETE

    func deleteTask(_ task: TaskItem) {
        guard let userId else { return }

        tasksCollection(for: userId)
            .document(task.id)
            .delete { [weak self] error in
                self?.show(error)
            }
    }

    /// Used by swipe-to-delete in the List.
    func deleteTasks(at offsets: IndexSet, from list: [TaskItem]) {
        for index in offsets {
            deleteTask(list[index])
        }
    }

    // MARK: - Helpers

    /// Returns a tuple with the total and the completed task counts.
    func taskCounts() -> (total: Int, done: Int) {
        var doneCount = 0
        for task in tasks where task.isDone {
            doneCount += 1
        }
        return (tasks.count, doneCount)
    }

    func filteredTasks(_ filter: TaskFilter) -> [TaskItem] {
        tasks.filter { filter.matches($0) }
    }

    /// Finds the newest copy of a task (used by the detail screen).
    func task(withId id: String) -> TaskItem? {
        tasks.first { $0.id == id }
    }

    private func tasksCollection(for userId: String) -> CollectionReference {
        db.collection("users").document(userId).collection(TaskItem.collectionName)
    }

    private func show(_ error: Error?) {
        if let error {
            errorMessage = error.localizedDescription
        }
    }
}
