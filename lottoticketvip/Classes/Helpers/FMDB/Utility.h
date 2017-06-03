//
//  Utility.h
//  expensegenie
//
//  Created by Greg Ellis on 2013-03-16.
//  Copyright (c) 2013 ellis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h" 

@interface Utility : NSObject{
    
}

+(NSString *) getDatabasePath;
+(void) showAlert:(NSString *) title message:(NSString *) msg;

@end
