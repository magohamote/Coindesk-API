//
//  FileManager+DocumentDirectory.swift
//  Coindesk-API
//
//  Created by Cédric Rolland on 07.02.19.
//  Copyright © 2019 Cédric Rolland. All rights reserved.
//

import Foundation

struct FileManagerHelper {
    static let documentsDirectory: URL? = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first
}
