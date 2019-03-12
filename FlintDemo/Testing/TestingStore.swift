//
//  TestingStore.swift
//  FlintDemo
//
//  Created by Marc Palmer on 11/03/2019.
//  Copyright © 2019 Montana Floss Co. Ltd. All rights reserved.
//

import Foundation
import StoreKit
import FlintCore

/// This is a dummy store for making real In-App Purchases for internal testing by the Flint team only.
/// This requires the IAPs configured for this app in App Store Connect which is why you can't use it.
@objc
class TestingStore: NSObject, SKProductsRequestDelegate {
    var products: [SKProduct] = []
    let logging: ContextSpecificLogger?
    var productsRequest: SKProductsRequest?

    static var shared = TestingStore()
    
    override public init() {
        logging = Logging.development?.contextualLogger(with: "Store", topicPath: ["IAPs"])
        super.init()
    }
    
    public func requestProducts(_ productsToRequest: [Product]) {
        let productsRequest = SKProductsRequest(productIdentifiers: Set(productsToRequest.map { $0.productID }))
        productsRequest.delegate = self
        productsRequest.start()
        self.productsRequest = productsRequest
    }
    
    // MARK: Purchase implementation - proof of concept only, requires actual IAPs set up in App Store Connect to test.

    public func purchase(_ product: Product) {
        guard let productToPurchase = products.first(where: { $0.productIdentifier == product.productID }) else {
            logging?.error("Cannot purchase \(product), there are no matching products retrieved from the store")
            return
        }
        let payment = SKMutablePayment(product: productToPurchase)
        SKPaymentQueue.default().add(payment)
    }

    @objc
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        // This is just for internal testing of actual IAP purchases to verify Flint APIs for StoreKitPurchaseTracker.
        // You cannot test this yourself without creating the app on your App Store Connect account and creating the
        // purchases there.

        products = response.products
        productsRequest = nil
    }
}
