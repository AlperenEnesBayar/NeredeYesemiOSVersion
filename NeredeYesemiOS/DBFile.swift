//
//  DBFile.swift
//  NeredeYesemiOS
//
//  Created by Alperen Enes Bayar on 24.05.2021.
//

import Foundation
import SQLite3

class DBHelper {
    var db: OpaquePointer?
    var path: String = "myDB.sqlite"
    
    init() {
        self.db = createDB()
        self.createTable()
    }
    
    func createDB() -> OpaquePointer? {
        let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathExtension(path)
        
        var db: OpaquePointer? = nil
        
        if sqlite3_open(filePath.path, &db) != SQLITE_OK {
            print("There is error in creating DB")
            return nil
        }else{
            return db
        }
    }
    
    func createTable(){
        let querry = "CREATE TABLE IF NOT EXISTS rest(id INTEGER PRIMARY KEY AUTOINCREMENT, restaurant_name TEXT, restaurant_phone TEXT, cuisine TEXT);"
        var createTable: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, querry, -1, &createTable, nil) == SQLITE_OK {
            if sqlite3_step(createTable) == SQLITE_DONE {
                print("Table creation success")
            }
            else {
                print("Table creation failed")
            }
        }
        else {
            print("Table preperation failed")
        }
    }
    
    func insert(rest: RestraurantID)
    {
        let querry = "INSERT INTO rest (id, restaurant_name, restaurant_phone, cuisine) VALUES (?,?,?,?)"
        var statement: OpaquePointer? = nil
        
        var isEmpty = false
        if readRests().isEmpty{
            isEmpty = true
        }
        
        if sqlite3_prepare_v2(db, querry, -1, &statement, nil) == SQLITE_OK {
            if isEmpty{
                sqlite3_bind_int(statement, 1, 1)
            }
            sqlite3_bind_text(statement, 2, (rest.restaurant_name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, (rest.restaurant_phone as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 4, (rest.cuisines[0] as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_DONE{
                print("Data inserted success")
            }
            else{
                print("Data is not inserted in table")
            }
        }else{
            print("Querry is not as per requirement")
        }
    }
    
    func readRests() -> [RestraurantID] {
        var list = [RestraurantID]()
        
        let query = "SELECT * FROM rest;"
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW{
                let id = Int(sqlite3_column_int(statement, 0))
                let name = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                let phone = String(describing: String(cString: sqlite3_column_text(statement, 2)))
                let cuisine = [String(describing: String(cString: sqlite3_column_text(statement, 3)))]
                
                let temp_rest: RestraurantID = RestraurantID(restaurant_name: name, restaurant_phone: phone, cuisines: cuisine, menus: [MenuID(menu_name: "a", menu_sections: [MenuSectionID(section_name: "a", menu_items: [MenuItemID(name: "a", description: "a", pricing: [Price(price: 1.1)])])])])
                
                
                list.append(temp_rest)
            }
        }
        
        return list
    }
    
}

