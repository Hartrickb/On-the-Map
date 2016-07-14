//
//  GCDBlackBox.swift
//  On the Map
//
//  Created by Bennett Hartrick on 7/14/16.
//  Copyright © 2016 Bennett. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(updates: () -> Void) {
    dispatch_async(dispatch_get_main_queue()) {
        updates()
    }
}

