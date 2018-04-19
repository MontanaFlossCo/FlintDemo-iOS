//
//  DocumentEditSession.swift
//  FlintDemo
//
//  Created by Marc Palmer on 18/04/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import Foundation

class DocumentEditSession {
    static let shared = DocumentEditSession()
    
    var currentDocumentBeingEdited: Document?
}
