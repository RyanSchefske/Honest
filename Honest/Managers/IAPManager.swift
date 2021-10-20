//
//  IAPManager.swift
//  Honest
//
//  Created by Ryan Schefske on 7/26/20.
//  Copyright © 2020 Ryan Schefske. All rights reserved.
//

import UIKit
import StoreKit

enum IAPHandlerAlertType {
	case setProductIds
	case disabled
	case restored
	case purchased
	
	var message: String {
		switch self {
			case .setProductIds: return "Product ids not set, call setProductIds method!"
			case .disabled: return "Purchases are disabled in your device"
			case .restored: return "You've successfully restored your purchase"
			case .purchased: return "You've successfully bought this purchase!"
		}
	}
}

class IAPHandler: NSObject {
	
	static let shared = IAPHandler()
	private override init() { }
	
	fileprivate var productIds = [String]()
	fileprivate var productId = ""
	fileprivate var productsRequest = SKProductsRequest()
	fileprivate var fetchProductComplitition: (([SKProduct]) ->Void)?
	
	fileprivate var productToPurchase: SKProduct?
	fileprivate var purchaseProductComplitition: ((IAPHandlerAlertType, SKProduct?, SKPaymentTransaction?)->Void)?
	
	var isLogEnabled: Bool = true
	
	func setProductIds(ids: [String]) {
		self.productIds = ids
	}
	
	func canMakePurchase() -> Bool { return SKPaymentQueue.canMakePayments() }
	
	func purchase(product: SKProduct, complitition: @escaping ((IAPHandlerAlertType, SKProduct?, SKPaymentTransaction?) -> Void)) {
		self.purchaseProductComplitition = complitition
		self.productToPurchase = product
		
		if self.canMakePurchase() {
			let payment = SKPayment(product: product)
			SKPaymentQueue.default().add(self)
			SKPaymentQueue.default().add(payment)
			
			productId = product.productIdentifier
		} else {
			complitition(IAPHandlerAlertType.disabled, nil, nil)
		}
	}
	
	func restorePurchase() {
		SKPaymentQueue.default().add(self)
		SKPaymentQueue.default().restoreCompletedTransactions()
	}
	
	func fetchAvailableProducts(completion: @escaping (([SKProduct]) -> Void)) {
		self.fetchProductComplitition = completion
		
		if self.productIds.isEmpty {
			fatalError()
		} else {
			productsRequest = SKProductsRequest(productIdentifiers: Set(self.productIds))
			productsRequest.delegate = self
			productsRequest.start()
		}
	}
}

extension IAPHandler: SKProductsRequestDelegate, SKPaymentTransactionObserver {
	
	func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
		if response.products.count > 0 {
			if let completion = self.fetchProductComplitition {
				completion(response.products)
			}
		}
	}
	
	func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
		if let completion = self.purchaseProductComplitition {
			completion(IAPHandlerAlertType.restored, nil, nil)
		}
	}
	
	func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
		for transaction: AnyObject in transactions {
			if let trans = transaction as? SKPaymentTransaction {
				switch trans.transactionState {
					case .purchased:
						PersistenceManager.shared.setAdFreeVersion(true)
						SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
						if let completion = self.purchaseProductComplitition {
							completion(IAPHandlerAlertType.purchased, self.productToPurchase, trans)
						}
					
					case .failed:
						SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
						break
					
					case .restored:
						PersistenceManager.shared.setAdFreeVersion(true)
						SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
						break
					
					default: break
				}
			}
		}
	}
}
