//
//  DatabaseHandler.swift
//  Funseum
//
//  Created by SonPT on 2021-12-04.
//


import Foundation
import SQLite3

class DatabaseHandler {
    
    let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
    
    func openDatabase() -> OpaquePointer? {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("Meal2.sqlite")
        
        var db: OpaquePointer?
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        return db
    }
    
    func createTicketTable() {
        let db = openDatabase()
  
        
        let createTableString = """
        CREATE TABLE IF NOT EXISTS Ticket(
        Id INTEGER PRIMARY KEY AUTOINCREMENT,
        TicketId TEXT UNIQUE,
        UserId TEXT,
        EventId TEXT,
        EventName TEXT,
        Quantity INT,
        Time TEXT,
        CreatedDate TEXT
        );
        """
        
        
        // 1
        var createTableStatement: OpaquePointer?
        // 2
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) ==
            SQLITE_OK {
            // 3
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("\nTicket table created.")
            } else {
                print("\nTicket table is not created.")
            }
        } else {
            print("\nCREATE TABLE IF NOT EXISTS statement is not prepared.")
        }
        // 4
        sqlite3_finalize(createTableStatement)
    }
  
    
    func insertData(TicketId: String, UserId: String, EventId: String, EventName: String, Quantiy: Int, Time: String, CreatedDate: String){
        let db = openDatabase()
        //creating a statement
        var stmt: OpaquePointer?
        
        //the insert query
        let queryString = "INSERT INTO Ticket (TicketId, UserId, EventId, EventName, Quantity, Time, CreatedDate) VALUES (?,?,?,?,?,?,?);"
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        //binding the parameters
        if sqlite3_bind_text(stmt, 1, TicketId, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 2, UserId, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 3, EventId, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 4, EventName, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        if sqlite3_bind_int(stmt, 5, Int32(Quantiy)) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 6, Time, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 7, CreatedDate, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        
        
        //executing the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting ticket: \(errmsg)")
            return
        }
        
        
        //displaying a success message
        print("Tickets saved successfully")
    }
    
   
    
    func getTicketList(userId: String) -> [ticketInfo] {
        var ticketList = [ticketInfo]()
        let db = openDatabase()
 
        let queryString = "SELECT * FROM Ticket WHERE UserId LIKE ?;"
        //statement pointer
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing query: \(errmsg)")
            return ticketList
        }
        
        //binding the parameters
        if sqlite3_bind_text(stmt, 1, userId, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return ticketList
        }
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            ticketList.append(ticketInfo(
                                ticketId : String(cString: sqlite3_column_text(stmt, 1)),
                                  userId : String(cString: sqlite3_column_text(stmt, 2)),
                                eventId : String(cString: sqlite3_column_text(stmt, 3)),
                                eventName : String(cString: sqlite3_column_text(stmt, 4)),
                                quantity: Int(sqlite3_column_int(stmt, 5)),
                                time : String(cString: sqlite3_column_text(stmt, 6)),
                                createdDate :String(cString: sqlite3_column_text(stmt, 7))
            ))
        }
        return ticketList
    }
    
    func deleteTicketList(userId: String) {
        let db = openDatabase()
 
        let queryString = "DELETE FROM Ticket WHERE UserId LIKE ?;"
        //statement pointer
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing query: \(errmsg)")
            return
        }
        
        //binding the parameters
        if sqlite3_bind_text(stmt, 1, userId, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        //executing the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting hero: \(errmsg)")
            return
        }
        
        
        //displaying a success message
        print("Tickets deleted successfully")
    }
    
    
  
    
}

