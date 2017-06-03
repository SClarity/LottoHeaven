//
//  MyStoreObserver.h
//  PDFReader
//
//  Created by Alexander Rudenko on 12/2/09.
//  Copyright 2009 r3apps.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "appvariables.h"


@protocol StoreObserverProtocol <NSObject>
	-(void)transactionDidFinish:(NSString*)transactionIdentifier;
	-(void)transactionDidError:(NSError*)error;
    -(void)provideContent:(NSString*)transactionIdentifier;
@end


@interface StoreObserver : NSObject <SKPaymentTransactionObserver> {
	id <StoreObserverProtocol> delegate;	
}

@property (nonatomic, strong) id <StoreObserverProtocol> delegate;

- (void) paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions;
- (void) restoreTransaction: (SKPaymentTransaction *)transaction;
- (void) completeTransaction: (SKPaymentTransaction *)transaction;
@end

