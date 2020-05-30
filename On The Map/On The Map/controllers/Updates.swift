//
//  Updates.swift
//  On The Map
//
//  Created by Sergey on 21/2/20.
//  Copyright © 2020 Sergey. All rights reserved.
//
import Foundation
func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
