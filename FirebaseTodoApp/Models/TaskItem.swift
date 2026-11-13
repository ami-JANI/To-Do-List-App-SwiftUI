//
//  TaskItem.swift
//  FirebaseTodoApp
//

import Foundation
import FirebaseFirestore

// MARK: - Protocol (Lab 2)

/// Anything that can check whether its data is good enough to be saved.
protocol Validatable {
    var isValid: Bool { get }
}

// MARK: - Model

/// One to-do task. It is a struct (value type), just like SwiftUI views.
/// `Identifiable` lets us use it directly inside `List` / `ForEach`.
struct TaskItem: Identifiable, Validatable {

    // Type (static) properties: shared by every TaskItem
    static let collectionName = "tasks"
    static let maxTitleLength = 60

    // Stored properties
    let id: String
    var title: String
    var description: String
    var isDone: Bool
    var createdAt: Date

    // Computed property: true only when the title is not empty and not too long
    var isValid: Bool {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmed.isEmpty && trimmed.count <= TaskItem.maxTitleLength
    }

    // Computed property: a short preview of the description for the list row
    var shortDescription: String {
        if description.isEmpty {
            return "No description"
        }
        return description.count > 40 ? String(description.prefix(40)) + "..." : description
    }

    // Computed property: the SF Symbol name for the check box (ternary operator)
    var statusIcon: String {
        isDone ? "checkmark.circle.fill" : "circle"
    }

    init(id: String = UUID().uuidString,
         title: String,
         description: String = "",
         isDone: Bool = false,
         createdAt: Date = Date()) {
        self.id = id
        self.title = title
        self.description = description
        self.isDone = isDone
        self.createdAt = createdAt
    }

    /// Builds a TaskItem from a Firestore document.
    /// It is a *failable* initializer: it returns nil if the data is broken.
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()

        // guard + optional binding: without a title, this is not a valid task
        guard let title = data["title"] as? String else {
            return nil
        }

        self.id = document.documentID
        self.title = title
        // nil-coalescing (??): use a default value when the field is missing
        self.description = data["description"] as? String ?? ""
        self.isDone = data["isDone"] as? Bool ?? false
        // While a new task is still being saved, the server time stamp is nil,
        // so we fall back to the current date.
        self.createdAt = (data["createdAt"] as? Timestamp)?.dateValue() ?? Date()
    }

    /// The dictionary we save in Firestore.
    var firestoreData: [String: Any] {
        [
            "title": title,
            "description": description,
            "isDone": isDone
        ]
    }
}

// MARK: - Filter (enum + switch)

/// Which tasks the list should show.
enum TaskFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case pending = "Pending"
    case done = "Done"

    var id: String { rawValue }

    /// A switch must cover every case. No `break` is needed in Swift.
    func matches(_ task: TaskItem) -> Bool {
        switch self {
        case .all:
            return true
        case .pending:
            return !task.isDone
        case .done:
            return task.isDone
        }
    }
}
