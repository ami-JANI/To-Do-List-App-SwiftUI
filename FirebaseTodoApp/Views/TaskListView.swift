//
//  TaskListView.swift
//  FirebaseTodoApp
//
//  The main screen: shows the signed-in user's tasks with live updates.
//

import SwiftUI

struct TaskListView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    // @StateObject: this view creates and owns the TaskViewModel
    @StateObject private var taskViewModel = TaskViewModel()

    @State private var showAddSheet = false
    @State private var filter: TaskFilter = .all

    var body: some View {
        // Computed values used by the view
        let visibleTasks = taskViewModel.filteredTasks(filter)
        let counts = taskViewModel.taskCounts()          // tuple (total, done)

        NavigationStack {
            VStack(spacing: 0) {
                // Small summary header
                HStack {
                    Label("\(counts.total) tasks", systemImage: "list.bullet")
                    Spacer()
                    Label("\(counts.done) done", systemImage: "checkmark.seal")
                        .foregroundStyle(.green)
                }
                .font(.subheadline)
                .padding(.horizontal)
                .padding(.top, 8)

                Picker("Filter", selection: $filter) {
                    ForEach(TaskFilter.allCases) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(.segmented)
                .padding()

                if visibleTasks.isEmpty {
                    emptyState
                } else {
                    List {
                        ForEach(visibleTasks) { task in
                            NavigationLink {
                                TaskDetailView(taskId: task.id)
                            } label: {
                                TaskRowView(task: task) {
                                    taskViewModel.toggleDone(task)
                                }
                            }
                        }
                        .onDelete { offsets in
                            taskViewModel.deleteTasks(at: offsets, from: visibleTasks)
                        }
                    }
                    .listStyle(.plain)
                }

                if let message = taskViewModel.errorMessage {
                    Text(message)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .padding()
                }
            }
            .navigationTitle("My Tasks")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        taskViewModel.stopListening()
                        authViewModel.signOut()
                    } label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
            // .sheet opens the "New Task" form
            .sheet(isPresented: $showAddSheet) {
                TaskFormView { title, description in
                    taskViewModel.addTask(title: title, description: description)
                }
            }
        }
        // Share the TaskViewModel with the detail screen
        .environmentObject(taskViewModel)
        .onAppear {
            if let userId = authViewModel.user?.uid {
                taskViewModel.startListening(userId: userId)
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Spacer()
            Image(systemName: "tray")
                .font(.system(size: 50))
                .foregroundStyle(.secondary)
            Text(filter == .all ? "No tasks yet" : "No \(filter.rawValue.lowercased()) tasks")
                .font(.headline)
            Text("Tap + to add your first task.")
                .foregroundStyle(.secondary)
            Spacer()
        }
    }
}

