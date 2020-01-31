//
//  DataManager.swift
//  TeachAssist
//
//  Created by York Wei on 2019-12-13.
//  Copyright © 2019 York Wei. All rights reserved.
//

import Foundation

class DataManager {
    
    static let sharedDefaults = UserDefaults(suiteName: "group.todayTeachAssist")
        
    func saveData(value: Any, key: String) {
        DataManager.sharedDefaults?.setValue(value, forKey: key)
    }
    
    func retrieveData(key: String) -> Any? {
        DataManager.sharedDefaults?.value(forKey: key)
    }
    
    func removeData(key: String) {
        DataManager.sharedDefaults?.removeObject(forKey: key)
    }
    
}
