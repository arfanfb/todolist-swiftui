import SwiftUI

// Task model
struct TodoItem: Identifiable {
    let id = UUID()
    var title: String
    var isCompleted: Bool
}

// Main view model
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

// Main view
struct ContentView: View {
    @StateObject private var viewModel = TodoListViewModel()
    @State private var newTaskTitle = ""
    
    var body: some View {
        NavigationView {
            VStack {
                // Add task input field
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
                
                // Task list
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

// Task row view
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
            .buttonStyle(BorderlessButtonStyle())
            
            Text(task.title)
                .strikethrough(task.isCompleted)
                .foregroundColor(task.isCompleted ? .gray : .primary)
        }
    }
}

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
            .buttonStyle(BorderlessButtonStyle())
        }
    }
}

// Preview provider
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
