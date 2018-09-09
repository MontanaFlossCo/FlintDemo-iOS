//
//  DocumentRef.swift
//  FlintDemo
//
//  Created by Marc Palmer on 18/04/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import Foundation
import FlintCore
import CoreSpotlight

/// A simple type for passing around references to documents as inputs to Action(s) etc.
///
/// Keep model types clean. See `DocumentRef+FlintAdditions` for extensions that Flint-ify this type
/// for use in URLs, NSUserActivity and Flint logging.
struct DocumentRef {
    let name: String
    let summary: String?

    init(name: String, summary: String?) {
        self.name = name
        self.summary = summary
    }
    
    var description: String { return name }
    
    var debugDescription: String { return "DocumentRef: \(name)" }
}

