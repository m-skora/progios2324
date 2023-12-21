//
//  ContentView.swift
//  arrayList2
//
//  Created by mikolaj on 08/12/2023.
//

import SwiftUI

struct Task: Identifiable {
    var id = UUID()
    var name: String
    var description: String
    var imageName: String
}

struct ContentView: View {
    let tasks: [Task] = [
        Task(name: "Task 1", description: "Description for Task 1", imageName: "task1"),
        Task(name: "Task 2", description: "Description for Task 2", imageName: "task2"),
    ]

    var body: some View {
        NavigationView {
            List(tasks) { task in
                NavigationLink(destination: TaskDetailView(task: task)) {
                        Text(task.name)
                }
            }
            .navigationBarTitle("Task List")
        }
    }
}
