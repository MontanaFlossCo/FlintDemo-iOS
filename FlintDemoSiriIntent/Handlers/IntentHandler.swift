//
//  IntentHandler.swift
//  FlintDemoSiriIntent
//
//  Created by Marc Palmer on 10/09/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import Intents
import FlintCore

var hasRunFlintSetup = false

class IntentHandler: INExtension {

    /// - Tag: intenthandler
    override init() {
        super.init()
        if !hasRunFlintSetup {
            Flint.quickSetup(IntentFeatures.self)
            hasRunFlintSetup = true
        }
    }

    override func handler(for intent: INIntent) -> Any {
        // Can we auto-map these to actions? Handler must be specific protocol type, so no?
        switch intent {
            case is GetNoteIntent: return GetNoteIntentHandler()
            default: fatalError("Unknown intent type: \(intent)")
        }
    }
    
}
