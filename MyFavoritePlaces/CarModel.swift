//
//  PlaceModel.swift

//  Created by Ника Перепелкина on 02/09/2019.
//  Copyright © 2019 Nika Perepelkina. All rights reserved.
//

import RealmSwift

class Car: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var year: String?
    @objc dynamic var manufacturer: String?
    @objc dynamic var imageData: Data?
    @objc dynamic var date = Date()
    @objc dynamic var model: String?
    @objc dynamic var typeOfBody: String?
    

    
    
    convenience init(name: String, year: String?, manufacturer: String?, imageData: Data?, model: String?, typeOfBody: String?) {
        self.init()
        self.name = name
        self.year = year
        self.manufacturer = manufacturer
        self.imageData = imageData
        self.model = model
        self.typeOfBody = typeOfBody
    }
    
    
}
