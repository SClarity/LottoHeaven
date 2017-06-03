//
//  Card.h
//  lottoticketvip
//
//  Created by Greg Ellis on 2013-07-24.
//  Copyright (c) 2013 ellis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject{
    int value;
    int suit;
}

-(id)initWithValue:(int)v;
-(id)initWithCardString:(NSString*)strCard;

-(int)getSuit;
-(int)getFace;
-(int)getValue;

-(NSString*)getSuitAbbrev;
-(NSString*)getSuitString;
-(NSString*)getFaceString;
-(NSString*)getCardString;

- (NSComparisonResult)compare:(Card *)otherObject;

@end
