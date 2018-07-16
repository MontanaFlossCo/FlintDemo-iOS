//
//  DocumentSharingFeature.swift
//  FlintDemo
//
//  Created by Marc Palmer on 19/04/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import Foundation
import FlintCore

/// A sharing feature that is not always available, depending on constraints checked at runtime.
final class DocumentSharingFeature: ConditionalFeature {
    static func constraints(requirements: FeatureConstraintsBuilder) {
        // This feature is only available on iOS
        requirements.iOSOnly = .any

        // Allow runtime toggling via `isEnabled`
        requirements.runtimeEnabled()
        
        // Require an in-app purchase.
        // requirements.purchase(sharingPurchaseRequirement)
    }

    /// Change this to `false` to see Sharing be unavailable
    static var isEnabled: Bool? = true
    
    static var description: String = "Sharing of documents"
    
    static let share = action(DocumentShareAction.self)
    
    static func prepare(actions: FeatureActionsBuilder) {
        actions.declare(share)
    }
}
