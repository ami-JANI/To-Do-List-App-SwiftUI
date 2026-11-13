//
//  TaskDetailView.swift
//  FirebaseTodoApp
//

import SwiftUI

struct TaskDetailView: View {
    let taskId: String

    @EnvironmentObject var taskViewModel: TaskViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var showEditSheet = false

    var body: some View {
        // Optional binding: the task can be nil if it was deleted on another device
        if let task = taskViewModel.task(withId: taskId) {
            Form {
                Section("Title") {
                    Text(task.title)
                        .font(.headline)
                }

                Section("Description") {
                    Text(task.description.isEmpty ? "No description" : task.description)
                        .foregroundStyle(task.description.isEmpty ? Color.secondary : Color.primary)
                }

                Section("Status") {
                    Button {
                        taskViewModel.toggleDone(task)
                    } label: {
                        Label(task.isDone ? "Completed" : "Not completed",
                              systemImage: task.statusIcon)
                            .foregroundStyle(task.isDone ? Color.green : Color.orange)
                    }
                    Text("Created: \(task.createdAt.formatted(date: .abbreviated, time: .shortened))")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                Section {
                    Button(role: .destructive) {
                        taskViewModel.deleteTask(task)
                        dismiss()
                    } label: {
                        Label("Delete Task", systemImage: "trash")
                    }
                }
            }
            .navigationTitle("Task Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Edit") {
                    showEditSheet = true
                }
            }
            .sheet(isPresented: $showEditSheet) {
                TaskFormView(task: task) { title, description in
                    var edited = task
                    edited.title = title
                    edited.description = description
                    taskViewModel.updateTask(edited)
                }
            }
        } else {
            VStack(spacing: 8) {
                Image(systemName: "questionmark.folder")
                    .font(.largeTitle)
                Text("This task no longer exists.")
            }
            .foregroundStyle(.secondary)
        }
    }
}
