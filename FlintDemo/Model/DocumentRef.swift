//
//  DocumentRef.swift
//  FlintDemo
//
//  Created by Marc Palmer on 18/04/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import Foundation
import FlintCore

/// A simple type for passing around references to documents as inputs to Action(s) etc.
///
/// Keep model types clean. See `DocumentRef+FlintAdditions` for extensions that Flint-ify this type
/// for use in URLs, NSUserActivity and Flint logging.
struct DocumentRef {
    let name: String

    init(name: String) {
        self.name = name
    }
}
