//
//  MyStoreObserver.m
//  PDFReader
//
//  Created by Alexander Rudenko on 12/2/09.
//  Copyright 2009 r3apps.com. All rights reserved.
//

#import "StoreObserver.h"
#import "AppDelegate.h"

@implementation StoreObserver
@synthesize delegate;

- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // Optionally, display an error here.
		NSLog(@"transaction.error: %@", [transaction.error localizedDescription]);

    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];

	[delegate transactionDidError:transaction.error];
}

-(void)recordTransaction:(SKPaymentTransaction *)transaction {
	NSLog(@"recordTransaction: %@", [transaction.error localizedDescription]);
}


-(void)provideContent:(NSString *)identifier{
	NSLog(@"provideContent: %@", identifier);
    
    [delegate provideContent:identifier];
}

- (void) completeTransaction: (SKPaymentTransaction *)transaction{
	NSLog(@"purchased: %@", transaction.payment.productIdentifier);
    
    [self recordTransaction: transaction];
    [self provideContent: transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
    [delegate transactionDidFinish:transaction.payment.productIdentifier];
}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction{
	NSLog(@"Transaction Restored");

    [self recordTransaction: transaction];
    [self provideContent: transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
    [delegate transactionDidFinish:transaction.payment.productIdentifier];
}

-(void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    [delegate transactionDidFinish:nil];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
}
@end
