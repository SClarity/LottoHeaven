//
//  ScratchViewController.h
//  lottoticketvip
//
//  Created by Greg Ellis on 2013-07-16.
//  Copyright (c) 2013 ellis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScratchImageView.h"


@class UICountingLabel;
@class KSLabel;
@class UILevelProgress;

@interface ScratchViewController : UIViewController<ScratchImageFilledDelegate, UIAlertViewDelegate>{
    UIImageView *backgroundView;
    ScratchImageView *iv;
    int ticketid;
    UIButton *btnCheckTicket;
    UIButton *btnPlayAnother;
    UICountingLabel *creditsLabel;
    
    UILevelProgress *pg;
    KSLabel *level;
    
    NSMutableArray *match3;
    bool bNewLevel;
    
    BOOL bIsWinner;
    int prizebox_value;
    
    UIView *checkView, *levelView;
}

-(void)refresh;
-(id)initWithTicket:(int)tid;
-(void)showBonus;

@end
