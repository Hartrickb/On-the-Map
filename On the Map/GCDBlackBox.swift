//
//  GCDBlackBox.swift
//  On the Map
//
//  Created by Bennett Hartrick on 7/14/16.
//  Copyright © 2016 Bennett. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}

