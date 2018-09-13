//
//  IntentHandler.swift
//  FlintDemoSiriIntent
//
//  Created by Marc Palmer on 10/09/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import Intents

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        
        // Can we auto-map these to actions? Handler must be specific protocol type, so no?
        
        guard intent is GetNoteIntent else {
            fatalError()
        }

        return GetNoteIntentHandler()
    }
    
}
