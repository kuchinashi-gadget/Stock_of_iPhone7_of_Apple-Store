//
//  Read_setting.swift
//  apple_store
//
//  Created by KosukeOkano on 2016/09/29.
//  Copyright © 2016年 岡野光祐. All rights reserved.
//

import UIKit

class Read_setting: NSObject {
    
    let defaults = UserDefaults.standard
    
    func read_setting() -> Int{
        
        var apple_store_no = 0
        
        if((defaults.object(forKey: "apple_store_no")) != nil){
            
            apple_store_no = (defaults.integer(forKey: "apple_store_no") as? Int)!
        }
        
        return apple_store_no
        
    }
    
    func write_setting(NO:Int){
        
        defaults.set(NO, forKey: "apple_store_no")
        
        defaults.synchronize()
    }

}
