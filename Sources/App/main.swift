import Vapor
import HTTP    //need this for Response(redirect: ) to work
import VaporSQLite



class Customer: NodeRepresentable {   //NodeRepresentable turns the class into a Node to be use for JSON
    var customerId: Int?
    var firstName: String?
    var lastName: String?
    
    //neccesarry function for NodeRepresentable
    func makeNode(context: Context) throws -> Node {
        return try Node(node: ["customerId": self.customerId, "firstName": self.firstName, "lastName": self.lastName])
    }
}

let drop = Droplet()
//// localhost:8080/hello
//drop.get ("hello") { request in
//    return try JSON(node: ["message":"Hello World"])
//}
//
//// localhost:8080/names
//
//drop.get("names") { request in
//    
//    return try JSON(node: ["names": ["alex", "lisa", "bart"]])
//}
//
////class turned to json // localhost:8080/customer
//drop.get("customer") { request in
//    let customer = Customer()
//    customer.firstName = "John"
//    customer.lastName = "Doe"
//    return try JSON(node: customer)   //customer class needs to be turned into a node so its fits the parameter
//    
//}
//
////nesting
//drop.get("foo", "bar") {request in
//        return "fooBar"
//}
//
////get an error
//drop.get("404") { request in
//    throw Abort.notFound
//}
//
////custom error
//drop.get("error") { request in
//    throw Abort.custom(status: .badRequest, message: "Sorry guys!")
//
//}
//
////redirect to another page...need to import HTTP
//drop.get("vapor") { request in
//    return Response(redirect: "http://vapor.codes")
//    
//}
//
////parameters...strong coding the type and adding the variable in the request will have the same effect
//drop.get("users", /*":id"*/ Int.self) { request, userId in
//    
////    //request does not autocomplete
////    guard let userId = request.parameters["id"]?.int else {
////        throw Abort.notFound
////    }
//    
//    return "UserId is \(userId)"
//}
//
////grouping routes
////grouping by closures
//// .group does not autocomplete***
//drop.group("task") {tasks in
//    tasks.get("all") {request in
//        return "Hello World!"
//    }
//}

//grouping by grouped()  **xcode can not parse this FOR NOW...no problem with the vapor code though
//let taskGroups = drop.grouped("tasks")
//taskGroups.get("all") { request in
//    return "Hello World"
//}

//taskGroups.post("create") {request in
//    return "Created"
//}

//POST   //try to send in JSON format because its much faster and less footprints in the server
//this one posts to Postman extension on google
//drop.post("users") { request in
//    
//    guard let firstName = request.json?["firstName"]?.string, let lastName = request.json?["lastName"]?.string else {
//        throw Abort.badRequest
//    }
//    
//    return firstName + ", " + lastName
//    
//}

//Intergrating SQL into vapor
//try drop.addProvider(VaporSQLite.Provider.self)

//try drop.addProvider(VaporSQLite.Provider.self)
//drop.get("version") { request in
    ////testing if integration worked by returning the version # of sqlite
    //let result = try drop.database?.driver.raw("SELECT sqlite_version()")
    //return try JSON(node: result)
//}

////writing into the SQL DB
//drop.post("customers", "create") { request in
    //guard let firstName = request.json?["firstName"]?.string,
        //let lastName = request.json?["lastName"]?.string else {
           //throw Abort.badRequest
   // }
                                                //sql codes goes in here, learn them!
   // let result = try drop.database?.driver.raw("INSERT INTO Customers(firstName, lastName) VALUES(?,?)", [firstName, lastName])
    
    //return try JSON(node: result)
//}

////Getting data from SQL DB
//drop.get("customers", "all") { request in
    //var customers = [Customer]()
                                                //sql codes go in here, learn them
    //let result = try drop.database?.driver.raw("SELECT customerId, firstName, lastName FROM Customers;")
    
    //guard let nodeArray = result?.nodeArray else {
       // return try  JSON(node: [])
    //}
    
    //for node in nodeArray {
        //let customer = Customer()
        //customer.customerId = node["customerId"]?.int
        //customer.firstName = node["firstName"]?.string
        //customer.lastName = node["lastName"]?.string
        
        //customers.append(customer)
    //}
    
    //return try JSON(node: customers)
//}

////Validation
////email validation
//drop.post("register") { request in
    
    //let email: Valid<Email> = try request.data["email"].validated()
    //return "Validated \(email)"
    
//}
//unique in array validation
//drop.post("unique") { request in
    
    //guard let inputArray = request.data["input"]?.string else {
        //throw Abort.badRequest
    //}
    
    //let unique: Valid<Unique<[String]>> = try inputArray.components(separatedBy: ",").validated()
    
    //return "Validated \(unique)"
    
//}

//matches validation
//drop.post("keys") { request in
    //guard let keyCodes = request.data["keys"]?.string else {
        //throw Abort.badRequest
    //}
    
    //let key: Valid<Matches<String>> = try keyCodes.validated(by: Matches("Secret"))
    //return "Validated \(key)"

    
//}

///Custom Validation

///building a PasswordValidator class
//class PasswordValidator: ValidationSuite {
    
    ///ValidationSuite is a protocol so it needs this func
    //static func validate(input value: String) throws {
        //let evaluation = !OnlyAlphanumeric.self && Count.containedIn(low: 5, high: 12)
        //try evaluation.validate(input: value)
    //}
//}

//drop.post("register") { request in

    //guard let inputPassword = request.data["password"]?.string else {
        //throw Abort.badRequest
    //}
    
    ///alphanumeric is false so must containt other characters and must contain between 5 and 12 characters
    //let password = try inputPassword.validated(by: !OnlyAlphanumeric.self && Count.containedIn(low: 5, high: 12))
    ///another way of validating and will return a bool
    //let isValid = inputPassword.passes(PasswordValidator.self)
    
    ///this is another way of testing but will throw if invalid
    //let isTested = try inputPassword.tested(by: PasswordValidator.self)
    
    ///using the PasswordValidator class to validate instead (refactoring the validator to a class so we can use it in many instances)
    //let password : Valid<PasswordValidator> = try inputPassword.validated()
    
    //return "Validated \(password)"

//}

//Basic Controllers - the fetch functions are inside the TaskViewController() //inside Controllers folder
try drop.addProvider(VaporSQLite.Provider.self)

let controller = TaskViewController()
controller.addRoutes(drop: drop)

//drop.resource(path: String, resource: Resource<StringInitializable>) //Means were gonna use RESTful here
//drop.resource("tasks", controller)

drop.run()




















