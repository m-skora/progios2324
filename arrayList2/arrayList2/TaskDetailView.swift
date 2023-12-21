//
//  TaskDetailView.swift
//  arrayList2
//
//  Created by mikolaj on 08/12/2023.
//

import SwiftUI

struct TaskDetailView: View {
    var task: Task

    var body: some View {
        VStack {
            Image(task.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 200)

            Text(task.name)
                .font(.title)
                .padding()

            Text(task.description)
                .padding()

            Spacer()
        }
        .navigationBarTitle(task.name)
    }
}
