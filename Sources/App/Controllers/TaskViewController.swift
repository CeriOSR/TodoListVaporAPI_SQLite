//
//  TaskViewController.swift
//  TodoList
//
//  Created by Rey Cerio on 2017-03-24.
//
//

//must put check App as the Target Membership
//this is basically to clean up the main.swift file by refactoring all the controllers into a controller file

import Vapor
import HTTP
import VaporSQLite
import Foundation

////Restfull: adding an extension to the TaskViewController that adheres to the ResourceRepresentable protocol
//extension TaskViewController: ResourceRepresentable {
//    
//    //this func is needed by the ResourceRepresentable protocol
//    func makeResource() -> Resource<Task> {
//        return Resource(
//            //index will be handled by the index function inside TaskViewController
//            index: index,
//            show: show
//        )
//    }
//}
//
////Restfull: this is the model for the tasks
//class  Task: StringInitializable {
//    var name: String?
//    
//    //needs required, initializes the model class
//    required init?(from string: String) throws {
//        self.name = string
//    }
//}
//
//final class TaskViewController {
//    
//    func addRoutes(drop: Droplet) {
//        
//        drop.get("tasks", "all", handler : getAllTasks)
//        drop.get("tasks", Int.self, handler: getById)
//    }
//    
//    func getById(req: Request, taskId: Int) -> ResponseRepresentable {
//        return "Task id is \(taskId)"
//    }
//    
//    func getAllTasks(req: Request) -> ResponseRepresentable {
//        return "Get all tasks"
//    }
//    
//    //RESTful controllers. we need this function, an extention to the class that adheres to ResourceRepresentable and a Model class that will handle the data
//    func index(_ req: Request) throws -> ResponseRepresentable {
//        return "Index"
//    }
//    
//    //show route
//    func show(_ req: Request, task: Task) throws -> ResponseRepresentable {
//        return "Show"
//    }
//    
//    /*essentially doing this code but inside another file which is in the Controller's folder
//     handlers are functions and need to be built by us
//     
//    drop.get("task", "all") {request in
//    
//        return "All the tasks"
//    } */
//    
//}

class Task: NodeRepresentable {
    var taskId: Int?
    var title: String?
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: ["taskId": self.taskId, "title": self.title ])
    }


}

extension Task {
    convenience init?(node: Node) {
        self.init()
        
        guard let taskId = node["taskId"]?.int, let title = node["title"]?.string else {
            return nil
        }
        
        self.taskId = taskId
        self.title = title
        
    }
}

final class TaskViewController {
    
    func addRoutes(drop: Droplet) {
    
        drop.get("tasks", "all", handler: getAll)  //fetching
        drop.post("tasks", "create", handler: create)   //writing into database
        drop.post("tasks", "delete", handler: delete)   //deleting an entry
    }
    
    func delete(_ req: Request) throws -> ResponseRepresentable {
        //get the taskId first
        guard let taskId = req.data["taskId"]?.int else {
            throw Abort.badRequest
        }
                                //SQL code
        try drop.database?.driver.raw("DELETE FROM Tasks WHERE taskId = ?", [taskId])
        
        return try JSON(node: ["success": true])
    }

    
    //writing into database
    func create(_ req: Request) throws -> ResponseRepresentable {
        
        guard let title = req.data["title"]?.string else {
            throw Abort.badRequest
        }
        
        try drop.database?.driver.raw("INSERT INTO Tasks(title) VALUES(?)", [title])
        return try JSON(node: ["success": true])
    }
    
    //fetching all
    func getAll(_ req: Request ) throws -> ResponseRepresentable {
        
        let result = try drop.database?.driver.raw("SELECT taskId, title from Tasks;")
        
        guard let node = result?.nodeArray else {
            return try JSON(node: [])
        }
        
        let tasks = node.flatMap(Task.init)
        
        return try JSON(node: tasks)
    }
    
}
