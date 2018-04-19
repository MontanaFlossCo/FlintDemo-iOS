//
//  AppFeatures.swift
//  FlintDemo
//
//  Created by Marc Palmer on 07/02/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import Foundation
import FlintCore

final class AppFeatures: FeatureGroup {
    static var description = "Demo app features"
    
    static var subfeatures: [FeatureDefinition.Type] = [
        DocumentManagementFeature.self,
        DocumentSharingFeature.self
    ]
}
