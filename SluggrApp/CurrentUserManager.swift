//
//  CurrentUserManager.swift
//  SluggrApp
//
//  Created by Dustin Hennessy on 8/25/15.
//  Copyright (c) 2015 DustinHennessy. All rights reserved.
//

import UIKit

class CurrentUserManager: NSObject {

    static let sharedInstance = CurrentUserManager()
    
    var currentUser :Users?
    
    private override init() {
        super.init()
        println("THC WAS HERE")
    }
}
