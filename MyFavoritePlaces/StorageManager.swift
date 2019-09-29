//
//  StorageManager.swift

//
//  Created by Ника Перепелкина on 04/09/2019.
//  Copyright © 2019 Nika Perepelkina. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveObject(_ car: Car) {
        
        try! realm.write {
            realm.add(car)
        }
    }
    
    static func deleteObject(_ car: Car) {
        
        try! realm.write {
            realm.delete(car)
        }
    }
}
