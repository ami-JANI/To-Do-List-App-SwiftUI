//
//  TaskFormView.swift
//  FirebaseTodoApp
//
//  The same form is used to ADD a new task and to EDIT an existing one.
//

import SwiftUI

struct TaskFormView: View {
    // nil = "add" mode, a value = "edit" mode
    let task: TaskItem?
    let onSave: (String, String) -> Void

    @Environment(\.dismiss) private var dismiss

    @State private var title: String
    @State private var description: String

    init(task: TaskItem? = nil, onSave: @escaping (String, String) -> Void) {
        self.task = task
        self.onSave = onSave
        // ?? gives an empty string when we are adding a new task
        _title = State(initialValue: task?.title ?? "")
        _description = State(initialValue: task?.description ?? "")
    }

    // Computed properties
    private var isEditing: Bool { task != nil }

    private var canSave: Bool {
        TaskItem(title: title, description: description).isValid
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Title") {
                    TextField("e.g. Finish lab report", text: $title)
                    Text("\(title.count)/\(TaskItem.maxTitleLength)")
                        .font(.caption)
                        .foregroundStyle(title.count > TaskItem.maxTitleLength ? Color.red : Color.secondary)
                }

                Section("Description") {
                    TextField("Write some details...", text: $description, axis: .vertical)
                        .lineLimit(3...8)        // a closed range (Lab 1)
                }
            }
            .navigationTitle(isEditing ? "Edit Task" : "New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(title.trimmingCharacters(in: .whitespacesAndNewlines), description)
                        dismiss()
                    }
                    .disabled(!canSave)
                }
            }
        }
    }
}

#Preview {
    TaskFormView { _, _ in }
}
