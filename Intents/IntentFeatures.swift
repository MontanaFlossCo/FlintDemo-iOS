//
//  IntentFeatures.swift
//  FlintDemo
//
//  Created by Marc Palmer on 15/09/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import Foundation
import FlintCore

/// This is the root level of feature groupings for intents from the app.
final class IntentFeatures: FeatureGroup {
    static var description = "Demo intent features"
    
    static var subfeatures: [FeatureDefinition.Type] = [
        SiriFeature.self
    ]
}
