//
//  SiriFeature.swift
//  FlintDemo
//
//  Created by Marc Palmer on 11/09/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import Foundation
import Intents
import FlintCore


@available(iOS 12, *)
final class SiriFeature: Feature, IntentMapped {
    static let description = "Siri access to documents"

    static let getNote = action(GetNoteAction.self)

    static func intentMappings<BuilderType>(intents: BuilderType) where SiriFeature == BuilderType.FeatureType, BuilderType : IntentMappingsBuilder {
        // Declare that incoming continued intents of this type must be forward to this action
        intents.forward(intentType: GetNoteIntent.self, to: getNote)
    }
    
    static func prepare(actions: FeatureActionsBuilder) {
        actions.declare(getNote)
    }
}
