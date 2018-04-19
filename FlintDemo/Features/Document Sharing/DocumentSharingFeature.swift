//
//  DocumentSharingFeature.swift
//  FlintDemo
//
//  Created by Marc Palmer on 19/04/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import Foundation
import FlintCore

final class DocumentSharingFeature: ConditionalFeature {
    static var availability: FeatureAvailability = .runtimeEvaluated
    
    /// Change this to `false` to see Sharing be unavailable
    static var isAvailable: Bool? = true
    
    static var description: String = "Sharing of documents"
    
    static let share = action(DocumentShareAction.self)
    
    static func prepare(actions: FeatureActionsBuilder) {
        actions.declare(share)
    }
}
