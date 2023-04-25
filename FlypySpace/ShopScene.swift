//
//  ShopScene.swift
//  FlypySpace
//
//  Created by Brandon Torres on 4/5/17.
//  Copyright © 2017 Brandon Torres. All rights reserved.
//

import UIKit
import SpriteKit
import StoreKit

class ShopScene:SKScene, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    
    @available(iOS 3.0, *)
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
    }
    
    
    
    override func didMove(to view: SKView) {
        
        // Set IAPS
        if(SKPaymentQueue.canMakePayments()) {
            print("IAP is enabled, loading")
            let productID:NSSet = NSSet(objects: "bundle id", "bundle id")
            let request: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
            request.delegate = self
            request.start()
        } else {
            print("please enable IAPS")
        }
    }
    
    func btnRemoveAds() {
        for product in list {
            let prodID = product.productIdentifier
            if(prodID == "bundle id") {
                p = product
                buyProduct()
                break;
            }
        }
        
    }
    
    func btnAddCoins() {
        for product in list {
            let prodID = product.productIdentifier
            if(prodID == "bundle id") {
                p = product
                buyProduct()
                break;
            }
        }
    }
    
    
    
    func removeAds() {
        print("ads removed")
    }
    

    func addCoins() {
        print("added 50 coins")
    }
    
    func addPowerUps() {
        print("added 10 coin magnets")
        print("added 10 sheilds")
        
    }
    
    func addLevel() {
        print("Added New Level")
    }
    

    func RestorePurchases() {
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    var list = [SKProduct]()
    var p = SKProduct()
    
    
    
    
    func buyProduct() {
        print("buy " + p.productIdentifier)
        let pay = SKPayment(product: p)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(pay as SKPayment)
    }
    
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("product request")
        let myProduct = response.products
        
        for product in myProduct {
            print("product added")
            print(product.productIdentifier)
            print(product.localizedTitle)
            print(product.localizedDescription)
            print(product.price)
            
            list.append(product as SKProduct)
        }
    }
    
    // 4
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("transactions restored")
        
        var purchasedItemIDS = [buyProduct(),addCoins(), addPowerUps()]
        for transaction in queue.transactions {
            let t: SKPaymentTransaction = transaction as SKPaymentTransaction
            
            let prodID = t.payment.productIdentifier as String
            
            switch prodID {
            case "bundle id":
                print("remove ads")
                removeAds()
            case "bundleid":
                print("add coins to account")
                addCoins()
                case "bundleID":
                print("Added Level")
            default:
                print("IAP not setup")
            }
            
        }
    }
    
    
    private func paymentQueue(queue: SKPaymentQueue!, updatedTransactions transactions: [AnyObject]!) {
        print("add paymnet")
        
        for transaction:AnyObject in transactions {
            let trans = transaction as! SKPaymentTransaction
            print(trans.error ?? transaction)
            
            switch trans.transactionState {
                
            case .purchased:
                print("buy, ok unlock iap here")
                print(p.productIdentifier)
                
                let prodID = p.productIdentifier as String
                switch prodID {
                case "bundle id":
                    print("remove ads")
                    removeAds()
                case "bundle id":
                    print("add coins to account")
                    addCoins()
                    case "bundle id":
                    print("addex powerups")
                    addPowerUps()
                    case "bundleID":
                    print("added new level")
                    addLevel()
                default:
                    print("IAP not setup")
                }
                
                queue.finishTransaction(trans)
                break;
            case .failed:
                print("buy error")
                queue.finishTransaction(trans)
                break;
            default:
                print("default")
                break;
                
            }
        }
    }
    
    
    func finishTransaction(trans:SKPaymentTransaction) {
        print("finish trans")
    }
    
    
    private func paymentQueue(queue: SKPaymentQueue!, removedTransactions transactions: [AnyObject]!) {
        print("remove trans");
    }
}
