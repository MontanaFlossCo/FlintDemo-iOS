//
//  DocumentEditingFeature.swift
//  FlintDemo
//
//  Created by Marc Palmer on 04/05/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import Foundation
import FlintCore

class DocumentEditingFeature: FeatureGroup {
    static var subfeatures: [FeatureDefinition.Type] = [
        PhotoAttachmentsFeature.self
    ]
}
