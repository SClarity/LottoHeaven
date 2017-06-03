//
//  AppDelegate.h
//  lottoticketvip
//
//  Created by Greg Ellis on 2013-07-16.
//  Copyright (c) 2013 ellis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeychainItemWrapper.h"
#import "StoreObserver.h"
#import "Chartboost.h"
#import "RevMobAds.h"
#import <AVFoundation/AVFoundation.h>

@class FMDBDataAccess;

@class MainMenuViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, AVAudioSessionDelegate, StoreObserverProtocol, SKProductsRequestDelegate, RevMobAdsDelegate, ChartboostDelegate>{
    StoreObserver *observer;
    UIAlertView			*loadingView;

    NSString           *selectedIdentifier;
    int startupForeground, startupDidFinish;
    
    AVAudioPlayer *cheerPlayer, *dingDongPlayer, *clickPlayer, *chachingPlayer, *awwPlayer, *winCounterPlayer, *bellPlayer, *backgroundPlayer;
    BOOL bGiveBonus;
    
}

- (void) playCheer;
- (void) playDingDong;
- (void) playClick;
- (void) playChaChing;
- (void) playAww;
- (void) playWinCounter;
- (void) playBackground;
- (void) playBell;

- (void) showadsnow;
- (void) saveGameVariable;
- (void) setBalance:(int)amount;
- (int) getBalance;

- (void) buyIAPitem:(int)buyType;
- (void) restoreIAP;

-(void)soundoption:(UIButton*)sender;
-(void)musicoption:(UIButton*)sender;
-(void)notificationoption:(UIButton*)sender;
-(void)getcredits:(id)sender;
-(void)options:(id)sender;

-(void) moreGames;

@property bool removeads;
@property BOOL bGiveBonus;
@property (nonatomic, strong) AVAudioPlayer *cheerPlayer;
@property (nonatomic, strong) AVAudioPlayer *chachingPlayer;
@property (nonatomic, strong) AVAudioPlayer *dingDongPlayer;
@property (nonatomic, strong) AVAudioPlayer *clickPlayer;
@property (nonatomic, strong) AVAudioPlayer *awwPlayer;
@property (nonatomic, strong) AVAudioPlayer *winCounterPlayer;
@property (nonatomic, strong) AVAudioPlayer *backgroundPlayer;
@property (nonatomic, strong) AVAudioPlayer *bellPlayer;
@property (nonatomic, strong) StoreObserver *observer;

@property (strong, nonatomic) UINavigationController *mainNavController;
@property (strong, nonatomic) MainMenuViewController *mainMenuViewController;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, copy) NSString* databaseName;
@property (nonatomic, copy) NSString* databasePath;
@property (strong, nonatomic) FMDBDataAccess *db;

@end
