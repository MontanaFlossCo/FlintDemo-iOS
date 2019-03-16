//
//  MyInAppPurchases.swift
//  FlintDemo
//
//  Created by Marc Palmer on 22/02/2019.
//  Copyright © 2019 Montana Floss Co. Ltd. All rights reserved.
//

import Foundation
import FlintCore

enum InAppPurchases {
    static let unlockAttachments = NonConsumableProduct(name: "Media Attachments",
                                                        description: "Add photos to notes",
                                                        productID: "NONCONSUMABLE0002")

    static let unlockAll = AutoRenewingSubscriptionProduct(name: "Unlock everything",
                                                           description: "Unrestricted access to everything",
                                                           productID: "SUBSCRIPTION0001")

    static let credit = ConsumableProduct(name: "A credit",
                                          description: "Credits you can spend in app",
                                          productID: "CREDIT")

    static let creditPack7 = ConsumableProduct(name: "7 credits",
                                              description: "Credits you can spend in app",
                                              productID: "CREDIT")
}

