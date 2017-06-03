//
//  Utility.m
//  expensegenie
//
//  Created by Greg Ellis on 2013-03-16.
//  Copyright (c) 2013 ellis. All rights reserved.
//

#import "Utility.h"


@implementation Utility

+(NSString *) getDatabasePath
{
    NSString *databasePath = [(AppDelegate *)[[UIApplication sharedApplication] delegate] databasePath];
    return databasePath;
}

+(void) showAlert:(NSString *)title message:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [alert show];
}

@end
