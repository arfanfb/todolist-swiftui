# To-Do List App

This is a simple To-Do List application built using SwiftUI. The app allows users to add, toggle, and delete tasks.

## Features

- **Add Task**: Users can add new tasks to the list.
- **Toggle Task**: Users can mark tasks as completed or incomplete.
- **Delete Task**: Users can delete tasks from the list.

## Code Overview

### Models

#### TodoItem

Represents a single task in the to-do list.

```swift
struct TodoItem: Identifiable {
    let id = UUID()
    var title: String
    var isCompleted: Bool
}
```

### View Models

#### TodoListViewModel

Manages the list of tasks and provides methods to add, toggle, and delete tasks.

```swift
class TodoListViewModel: ObservableObject {
    @Published var tasks: [TodoItem] = []
    
    func addTask(_ title: String) {
        let task = TodoItem(title: title, isCompleted: false)
        tasks.append(task)
    }
    
    func toggleTask(_ task: TodoItem) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
        }
    }
    
    func deleteTask(_ task: TodoItem) {
        tasks.removeAll(where: { $0.id == task.id })
    }
}
```

### Views

#### ContentView

The main view that contains the input field for adding tasks and the list of tasks.

```swift
struct ContentView: View {
    @StateObject private var viewModel = TodoListViewModel()
    @State private var newTaskTitle = ""
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("New task", text: $newTaskTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        if !newTaskTitle.isEmpty {
                            viewModel.addTask(newTaskTitle)
                            newTaskTitle = ""
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                            .font(.title2)
                    }
                }
                .padding()
                
                List {
                    ForEach(viewModel.tasks) { task in
                        TaskRow(task: task, viewModel: viewModel)
                    }
                }
            }
            .navigationTitle("To-Do List")
        }
    }
}
```

#### TaskRow

A view that represents a single row in the task list, containing the task and delete button.

```swift
struct TaskRow: View {
    let task: TodoItem
    @ObservedObject var viewModel: TodoListViewModel
    
    var body: some View {
        HStack {
            Task(task: task, viewModel: viewModel, action: {
                viewModel.toggleTask(task)
                print("toggle")
            })
            .contentShape(Rectangle())
            
            Spacer()
            
            Delete(viewModel: viewModel, action: {
                viewModel.deleteTask(task)
                print("delete")
            })
            .contentShape(Rectangle())
        }
        .padding(.vertical, 5)
    }
}
```

#### Task

A view that represents the task with a toggle button.

```swift
struct Task: View {
    let task: TodoItem
    @ObservedObject var viewModel: TodoListViewModel
    var action: () -> Void
    
    var body: some View {
        HStack {
            Button {
                self.action()
            } label : {
                VStack {
                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(task.isCompleted ? .green : .gray)
                }
            }
            
            Text(task.title)
                .strikethrough(task.isCompleted)
                .foregroundColor(task.isCompleted ? .gray : .primary)
        }
    }
}
```

#### Delete

A view that represents the delete button.

```swift
struct Delete: View {
    @ObservedObject var viewModel: TodoListViewModel
    var action: () -> Void
    
    var body: some View {
        HStack {
            Button {
                self.action()
            } label: {
                VStack {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
        }
    }
}
```

### Preview

```swift
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
```

## How to Run

1. Open the project in Xcode.
2. Build and run the project on the simulator or a physical device.
3. Add, toggle, and delete tasks using the provided UI.
