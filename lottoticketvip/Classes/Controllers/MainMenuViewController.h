//
//  MainMenuViewController.h
//  lottoticketvip
//
//  Created by Greg Ellis on 2013-07-16.
//  Copyright (c) 2013 ellis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GADBannerView.h"

@class KSLabel;
@class BButton;
@class UICountingLabel;
@class UILevelProgress;

@interface MainMenuViewController : UIViewController<UIAlertViewDelegate>{
    UIImageView *backgroundView;
    UICountingLabel *creditsLabel;
    KSLabel *creditCost;
    UIButton *btnRemoveAds;
    int selectedTicket;
    UIImageView *cardContainer;
    UIButton* btnGetTicket;
    UIButton* btnGetCredits;
    UIButton* btnOptions;
    
    UILevelProgress *pg;
    KSLabel *level;
    
    GADBannerView *bannerView_;
}
-(void)refresh;
-(void)showBonus;

@property (nonatomic, strong)  GADBannerView *bannerView_;
@property (nonatomic, strong) UIButton *btnRemoveAds;
@property (nonatomic, strong) UIButton *btnGetCredits;
@property (nonatomic, strong) UIButton *btnOptions;

@end
