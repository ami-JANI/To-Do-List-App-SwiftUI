//
//  TaskRowView.swift
//  FirebaseTodoApp
//

import SwiftUI

/// One row in the task list.
struct TaskRowView: View {
    let task: TaskItem
    let onToggle: () -> Void          // the parent decides what happens on tap

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onToggle) {
                Image(systemName: task.statusIcon)
                    .font(.title2)
                    .foregroundStyle(task.isDone ? Color.green : Color.gray)
            }
            .buttonStyle(.borderless)     // so tapping the icon does not open the detail page

            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.headline)
                    .strikethrough(task.isDone)
                    .foregroundStyle(task.isDone ? Color.secondary : Color.primary)

                Text(task.shortDescription)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    List {
        TaskRowView(task: TaskItem(title: "Finish lab report", description: "Upload to the portal")) {}
        TaskRowView(task: TaskItem(title: "Buy milk", isDone: true)) {}
    }
}
