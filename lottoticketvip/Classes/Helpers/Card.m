//
//  Card.m
//  lottoticketvip
//
//  Created by Greg Ellis on 2013-07-24.
//  Copyright (c) 2013 ellis. All rights reserved.
//

#import "Card.h"
#import "PokerConstants.h"

@implementation Card

-(id)initWithValue:(int)v{

    int s = (int)(v/13.0f);
    
    return [self initWithCardString:[NSString stringWithFormat:@"%@%@", s_card[v-(13*s)], s_suit[s]]];
}

-(id)initWithCardString:(NSString*)strCard{
    if((self=[super init]))
	{
        BOOL bIsValid = NO;
        for(int i=0; i<13; i++){
            for(int x=0; x<4; x++){
            NSString *strComp = [NSString stringWithFormat:@"%@%@", s_card[i], s_suit[x]];
                if([[strCard lowercaseString] isEqualToString:[strComp lowercaseString]]){
                    bIsValid = YES;
                    value = i+(x*13);
                    suit = x;
                    break;
                }
            }
        }
        
        NSAssert(bIsValid, @"Invalid Card String");
    }
    return self;
}

-(BOOL)isEqual:(Card*)object{
    return (object.getFace == self.getFace);
}

- (NSComparisonResult)compare:(Card *)otherObject {
    Card *card1 = self;
    Card *card2 = otherObject;
    
    if(card1.getFace > card2.getFace)
        return (NSComparisonResult)NSOrderedDescending;
    
    if(card1.getFace < card2.getFace)
        return (NSComparisonResult)NSOrderedAscending;
    
    return (NSComparisonResult) NSOrderedSame;
}

-(NSString*)getSuitString{
    return [NSString stringWithFormat:@"%@",s_suitname[suit]];
}

-(NSString*)getSuitAbbrev{
    return [NSString stringWithFormat:@"%@",s_suit[suit]];
}

-(NSString*)getFaceString{
    return [NSString stringWithFormat:@"%@",s_card[[self getFace]]];
}

-(NSString*)getCardString{
    return [NSString stringWithFormat:@"%@%@", [self getFaceString], [self getSuitAbbrev]];
}

-(int)getSuit{
    return suit;
}

-(int)getFace{
    return value-(13*suit);
}

-(int)getValue{
    return value;
}

@end
