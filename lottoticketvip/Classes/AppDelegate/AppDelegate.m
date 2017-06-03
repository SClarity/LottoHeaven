//
//  AppDelegate.m
//  lottoticketvip
//
//  Created by Greg Ellis on 2013-07-16.
//  Copyright (c) 2013 ellis. All rights reserved.
//

#import "AppDelegate.h"
#import "FMDBDataAccess.h"
#import "MainMenuViewController.h"
#import "ScratchViewController.h"
#import "GameVariables.h"
#import "Card.h"
#import "Common.h"
#import "poker.h"
#import "KGModal.h"
#import "BButton.h"
#import "SVProgressHUD.h"

#import "ALSdk.h"
#import "ALInterstitialAd.h"


@implementation AppDelegate
@synthesize databaseName;
@synthesize databasePath;
@synthesize db;
@synthesize mainMenuViewController;
@synthesize observer, removeads, cheerPlayer, dingDongPlayer, clickPlayer, chachingPlayer, awwPlayer, winCounterPlayer, backgroundPlayer, bellPlayer;
@synthesize bGiveBonus;

- (void)restoreIAP{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    
    /*loadingView = [[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
	
	UIActivityIndicatorView *actInd = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	actInd.frame = CGRectMake(128.0f, 45.0f, 25.0f, 25.0f);
	[loadingView addSubview:actInd];
	[actInd startAnimating];
	
    
	UILabel *l = [[UILabel alloc]init];
	l.frame = CGRectMake(100, -25, 210, 100);
	l.text = NSLocalizedString(@"Please Wait...", nil);
	l.font = [UIFont fontWithName:@"Helvetica" size:16];
	l.textColor = [UIColor whiteColor];
	l.shadowColor = [UIColor blackColor];
	l.shadowOffset = CGSizeMake(1.0, 1.0);
	l.backgroundColor = [UIColor clearColor];
	[loadingView addSubview:l];
    
	[loadingView show];*/
    
    [SVProgressHUD showWithStatus:@"Please Wait..."];
}

- (void)buyIAPitem:(int)buyType
{
	if (![SKPaymentQueue canMakePayments]){
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
															message:@"inApp purchase Disabled"
														   delegate:self
												  cancelButtonTitle:NSLocalizedString(@"OK", nil)
												  otherButtonTitles:nil];
		[alertView show];
		
		return;
	}
    
    enum {
        kChipPack1 = 1,
        kChipPack2 = 2,
        kChipPack3 = 3,
        kChipPack4 = 4,
        kChipPack5 = 5,
        kChipPack6 = 6,
        kRemoveAds = 7,
        kMoreJackpots = 8
    };
    
    selectedIdentifier = nil;
    
    switch (buyType) {
        case kMoreJackpots:
            selectedIdentifier = K_STORE_MORE_JACKPOTS;
            break;
        case kRemoveAds:
            selectedIdentifier = K_STORE_REMOVE_ADS;
            break;
        case kChipPack1:
            selectedIdentifier = K_STORE_CHIPS_20;
            break;
        case kChipPack2:
            selectedIdentifier = K_STORE_CHIPS_80;
            break;
        case kChipPack3:
            selectedIdentifier = K_STORE_CHIPS_320;
            break;
        case kChipPack4:
            selectedIdentifier = K_STORE_CHIPS_700;
            break;
        case kChipPack5:
            selectedIdentifier = K_STORE_CHIPS_2000;
            break;
        case kChipPack6:
            selectedIdentifier = K_STORE_CHIPS_5000;
            break;
            
        default:
            break;
    }
    
    DLog(@"%d", buyType);
    DLog(@"%@", selectedIdentifier);
    
    //SKPayment *payment = [SKPayment paymentWithProductIdentifier:selectedIdentifier];
    SKMutablePayment *payment = [[SKMutablePayment alloc] init];
    payment.productIdentifier = selectedIdentifier;
    payment.quantity = 1;
    
    //SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:[myproducts objectAtIndex:0]];
    
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
	/*loadingView = [[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
	
	UIActivityIndicatorView *actInd = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	actInd.frame = CGRectMake(128.0f, 45.0f, 25.0f, 25.0f);
	[loadingView addSubview:actInd];
	[actInd startAnimating];
	
    
	UILabel *l = [[UILabel alloc]init];
	l.frame = CGRectMake(100, -25, 210, 100);
	//l.text = NSLocalizedString(@"PLEASEWAIT", nil);
    l.text = @"Please Wait...";
	l.font = [UIFont fontWithName:@"Helvetica" size:16];
	l.textColor = [UIColor whiteColor];
	l.shadowColor = [UIColor blackColor];
	l.shadowOffset = CGSizeMake(1.0, 1.0);
	l.backgroundColor = [UIColor clearColor];
	[loadingView addSubview:l];
    
	[loadingView show];*/
    
    [SVProgressHUD showWithStatus:@"Please Wait..."];
}

-(void)transactionDidError:(NSError*)error{
    
    DLog(@"transaction did error: %@", error);
    //[loadingView dismissWithClickedButtonIndex:0 animated:NO];
    [SVProgressHUD dismiss];
    
    if(error){
        if (error.code != SKErrorPaymentCancelled)
        {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:[error localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                      otherButtonTitles:nil];
            [alertView show];
        }
    }
}

-(void)provideContent:(NSString*)transactionIdentifier{
    //NSLog(@"%@", transactionIdentifier);
    
    
    float fBalance = [self getBalance];
    float fAmount = 0.0f;
    bool  bRemoveAds = false;
    bool bEnabledMoreJackpots = false;
    if([transactionIdentifier isEqualToString:K_STORE_CHIPS_20]){
        fAmount  = 20.0f;
        fBalance += fAmount;
    }
    else if([transactionIdentifier isEqualToString:K_STORE_CHIPS_80]){
        fAmount = 80.0f;
        fBalance += fAmount;
    }
    else if([transactionIdentifier isEqualToString:K_STORE_CHIPS_320]){
        fAmount = 320.0f;
        fBalance += fAmount;
    }
    else if([transactionIdentifier isEqualToString:K_STORE_CHIPS_700]){
        fAmount = 700.0f;
        fBalance += fAmount;
    }
    else if([transactionIdentifier isEqualToString:K_STORE_CHIPS_2000]){
        fAmount = 2000.0f;
        fBalance += fAmount;
    }
    else if([transactionIdentifier isEqualToString:K_STORE_CHIPS_5000]){
        fAmount = 5000.0f;
        fBalance += fAmount;
    }
    else if([transactionIdentifier isEqualToString:K_STORE_REMOVE_ADS]){
        
        bAdsEnabled = NO;
		
		NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
		[userDefaults setBool:NO forKey:KEY_ADSENABLED];
		[userDefaults synchronize];
        bRemoveAds = true;
        
        UIViewController *view = [self.mainNavController topViewController];
        if([view isKindOfClass:[MainMenuViewController class]]){
            MainMenuViewController *mvc = (MainMenuViewController*)view;
            if(mvc.bannerView_ != nil){
                [mvc.bannerView_ removeFromSuperview];
                [mvc.btnRemoveAds removeFromSuperview];
                
                CGRect frame = mvc.btnOptions.frame;
                
                [mvc.btnOptions setFrame:CGRectMake(frame.origin.x+65, frame.origin.y, frame.size.width, frame.size.height)];
                frame = mvc.btnGetCredits.frame;
                [mvc.btnGetCredits setFrame:CGRectMake(frame.origin.x+65, frame.origin.y, frame.size.width, frame.size.height)];
                
            }
        }
    }
    else if([transactionIdentifier isEqualToString:K_STORE_MORE_JACKPOTS]){
        
        bMoreJackpotsEnabled = YES;
		
		NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
		[userDefaults setBool:YES forKey:KEY_MOREJACKPOTSENABLED];
		[userDefaults synchronize];
        
        bEnabledMoreJackpots = YES;
        
    }
    
    [self setBalance:fBalance];
    
    
    if(bEnabledMoreJackpots){
        NSString *strMessage = NSLocalizedString(@"Higher Payouts Pack has been abled! Enjoy as the tickets now pays out 30% more frequently!!!", nil);
        
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Success", nil)
                                                            message:strMessage
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    else if(!bRemoveAds){
        NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
        [nf setNumberStyle:NSNumberFormatterDecimalStyle];
        
        
        NSString *numberAsString = [nf stringFromNumber:[NSNumber numberWithInt:(int)fAmount]];
        NSString *strMessage = [NSString stringWithFormat:NSLocalizedString(@"%@ credits have been added to your balance. Enjoy!", nil), numberAsString];
        
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Success", nil)
                                                            message:strMessage
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                  otherButtonTitles:nil];
        [alertView show];
        
    }
    else{
        NSString *strMessage = NSLocalizedString(@"Ads have been permanently removed! Enjoy!", nil);
        
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Success", nil)
                                                            message:strMessage
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    
    UIViewController *view = [self.mainNavController topViewController];
    if([view isKindOfClass:[MainMenuViewController class]]){
        MainMenuViewController *mvc = (MainMenuViewController*)view;
        [mvc refresh];
    }
    else if([view isKindOfClass:[ScratchViewController class]]){
        ScratchViewController *svc = (ScratchViewController*)view;
        [svc refresh];
    }
}

-(void)transactionDidFinish:(NSString*)transactionIdentifier{
    
    DLog(@"transactionDidFinish");
	//[loadingView dismissWithClickedButtonIndex:0 animated:NO];
    [SVProgressHUD dismiss];
    
    //ok award the damn chips here
    
    //[self provideContent:transactionIdentifier];
}

- (void)setBalance:(int)amount{
    mCredit = amount;
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"com.ellis.lottoticketvip.Balance" accessGroup:nil];
    NSString *balanceString = [NSString stringWithFormat:@"%d", mCredit];
    [wrapper setObject:balanceString forKey:(__bridge id)kSecAttrService];
}

- (int)getBalance{
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"com.ellis.lottoticketvip.Balance" accessGroup:nil];
    NSString *balance = [wrapper objectForKey:(__bridge id)kSecAttrService];
    //NSLog(@"balancestring: %@", balance);
    if(balance != nil && ![balance isEqualToString:@""])
        mCredit = [balance intValue];
    
    return mCredit;
}

-(void) saveGameVariable {
	//Save money and sound setting
	DLog(@"Save game....");
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[self setBalance:mCredit];
    [userDefaults setInteger:mCredit forKey:KEY_CREDIT];
	[userDefaults setBool:bSoundOn forKey:KEY_SOUND];
    [userDefaults setBool:bNotificationsOn forKey:KEY_NOTIFICATIONS];
    [userDefaults setBool:bMusicOn forKey:KEY_MUSIC];
    [userDefaults setInteger:mLevel forKey:KEY_LEVEL];
    [userDefaults setInteger:mLevelProgress forKey:KEY_LEVELPROGRESS];
	[userDefaults synchronize];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *products = response.products;
	for (SKProduct *inAppProduct in products)
	{
        DLog(@"Product title: %@" , inAppProduct.localizedTitle);
        DLog(@"Product description: %@" , inAppProduct.localizedDescription);
        DLog(@"Product price: %@" , inAppProduct.price);
        DLog(@"Product id: %@" , inAppProduct.productIdentifier);
        
        //[myproducts addObject:inAppProduct];
    }
    
    
    for (NSString *invalidProductId in response.invalidProductIdentifiers)
    {
        DLog(@"Invalid product id: %@" , invalidProductId);
    }
    
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
}

-(void) createAndCheckDatabase
{
    BOOL success;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //********************************************
	//** remove this line for launch!!!
	//*********************************************
	//[fileManager removeItemAtPath:databasePath error:NULL];
    
    success = [fileManager fileExistsAtPath:databasePath];
    
    if(success) return;
    
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseName];
    
    [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
}

- (void) playCheer{
    if(!bSoundOn) return;
    
    [self.cheerPlayer stop];
    [self.cheerPlayer setCurrentTime:0];
    [self.cheerPlayer play];
}

- (void) playDingDong{
     if(!bSoundOn) return;
    
    [self.dingDongPlayer stop];
     [self.dingDongPlayer setCurrentTime:0];
    [self.dingDongPlayer play];
}

- (void) playClick{
     if(!bSoundOn) return;
    
    [self.clickPlayer stop];
    [self.clickPlayer setCurrentTime:0];
    [self.clickPlayer play];
}

-(void) playChaChing{
     if(!bSoundOn) return;
    
    [self.chachingPlayer stop];
    [self.chachingPlayer setCurrentTime:0];
    [self.chachingPlayer play];
}

-(void) playAww{
     if(!bSoundOn) return;
    
    [self.awwPlayer stop];
     [self.awwPlayer setCurrentTime:0];
    [self.awwPlayer play];
}

-(void) playWinCounter{
     if(!bSoundOn) return;
    
    [self.winCounterPlayer stop];
    [self.winCounterPlayer setCurrentTime:0];
    [self.winCounterPlayer play];
}

-(void) playBackground{
    if(!bMusicOn) return;
    
    [self.backgroundPlayer stop];
    [self.backgroundPlayer setCurrentTime:0];
    [self.backgroundPlayer play];
}

- (void) playBell{
    if(!bSoundOn) return;
    
    [self.bellPlayer stop];
    [self.bellPlayer setCurrentTime:0];
    [self.bellPlayer play];
}

-(void)soundoption:(UIButton*)sender{
    [sender setSelected:![sender isSelected]];
    bSoundOn = ![sender isSelected];
}

-(void)musicoption:(UIButton*)sender{
    [sender setSelected:![sender isSelected]];
    bMusicOn = ![sender isSelected];
    
    if(bMusicOn)
        [self playBackground];
    else
        [self.backgroundPlayer stop];
}

-(void)notificationoption:(UIButton*)sender{
    [sender setSelected:![sender isSelected]];
    bNotificationsOn = ![sender isSelected];
    
    [Common cancelAllLocalNotifications];
    if(bNotificationsOn){
        [Common scheduleLocalNotification:nil message:@"Your FREE credits are waiting!"];
    }
}

-(void)coinsbuy:(BButton*)sender{
    [self buyIAPitem:sender.tag];
}

-(void)getcredits:(id)sender{
    
    //AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [self playClick];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 450, 290)];
    
    CGRect welcomeLabelRect = contentView.bounds;
    welcomeLabelRect.origin.y = 10;
    welcomeLabelRect.size.height = 30;
    //welcomeLabelRect.size.width -= 10;
    UIFont *welcomeLabelFont = [UIFont boldSystemFontOfSize:30];
    UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:welcomeLabelRect];
    welcomeLabel.text = @"Credits Shop";
    welcomeLabel.font = welcomeLabelFont;
    welcomeLabel.textColor = [UIColor whiteColor];
    welcomeLabel.textAlignment = NSTextAlignmentCenter;
    welcomeLabel.backgroundColor = [UIColor clearColor];
    welcomeLabel.shadowColor = [UIColor blackColor];
    welcomeLabel.shadowOffset = CGSizeMake(0, 1);
    [contentView addSubview:welcomeLabel];
    
    BButton *coinPack1 = [[BButton alloc] initWithFrame:CGRectMake(15, 45, 120, 50) type:BButtonTypeSuccess];
    coinPack1.tag = 1;
    [coinPack1 addTarget:self action:@selector(coinsbuy:) forControlEvents:UIControlEventTouchUpInside];
    [coinPack1 setTitle:@"20 credits\n$1.99" forState:UIControlStateNormal];
    [contentView addSubview:coinPack1];
    
    BButton *coinPack2 = [[BButton alloc] initWithFrame:CGRectMake(150, 45, 120, 50) type:BButtonTypeSuccess];
    coinPack2.tag = 2;
    [coinPack2 addTarget:self action:@selector(coinsbuy:) forControlEvents:UIControlEventTouchUpInside];
    [coinPack2 setTitle:@"80 credits\n$4.99" forState:UIControlStateNormal];
    [contentView addSubview:coinPack2];
    
    BButton *coinPack3 = [[BButton alloc] initWithFrame:CGRectMake(285, 45, 120, 50) type:BButtonTypeSuccess];
    coinPack3.tag = 3;
    [coinPack3 addTarget:self action:@selector(coinsbuy:) forControlEvents:UIControlEventTouchUpInside];
    [coinPack3 setTitle:@"320 credits\n$9.99" forState:UIControlStateNormal];
    [contentView addSubview:coinPack3];
    
    BButton *coinPack4 = [[BButton alloc] initWithFrame:CGRectMake(15, 110, 120, 50) type:BButtonTypeSuccess];
    coinPack4.tag = 4;
    [coinPack4 addTarget:self action:@selector(coinsbuy:) forControlEvents:UIControlEventTouchUpInside];
    [coinPack4 setTitle:@"700 credits\n$19.99" forState:UIControlStateNormal];
    [contentView addSubview:coinPack4];
    
    BButton *coinPack5 = [[BButton alloc] initWithFrame:CGRectMake(150, 110, 120, 50) type:BButtonTypeSuccess];
    coinPack5.tag = 5;
    [coinPack5 addTarget:self action:@selector(coinsbuy:) forControlEvents:UIControlEventTouchUpInside];
    [coinPack5 setTitle:@"2,000 credits\n$49.99" forState:UIControlStateNormal];
    [contentView addSubview:coinPack5];
    
    BButton *coinPack6 = [[BButton alloc] initWithFrame:CGRectMake(285, 110, 120, 50) type:BButtonTypeSuccess];
    coinPack6.tag = 6;
    [coinPack6 addTarget:self action:@selector(coinsbuy:) forControlEvents:UIControlEventTouchUpInside];
    [coinPack6 setTitle:@"5,000 credits\n$99.99" forState:UIControlStateNormal];
    [contentView addSubview:coinPack6];
    
    BButton *boostPayoutPack = [[BButton alloc] initWithFrame:CGRectMake(100, 174, 255, 50) type:BButtonTypePrimary];
     boostPayoutPack.tag = 8;
     [boostPayoutPack addTarget:self action:@selector(coinsbuy:) forControlEvents:UIControlEventTouchUpInside];
     [boostPayoutPack setTitle:@"30% More Winners\n$4.99" forState:UIControlStateNormal];
     [contentView addSubview:boostPayoutPack];
     
     /*if(bAdsEnabled){
     removeAdsUpgrade = [[BButton alloc] initWithFrame:CGRectMake(15, 320, 255, 50) type:BButtonTypeDanger];
     removeAdsUpgrade.tag = 7;
     [removeAdsUpgrade addTarget:self action:@selector(coinsbuy:) forControlEvents:UIControlEventTouchUpInside];
     [removeAdsUpgrade setTitle:@"Remove Ads\n$1.99" forState:UIControlStateNormal];
     [contentView addSubview:removeAdsUpgrade];
     }*/
    
    
    BButton *restorePurchases = [[BButton alloc] initWithFrame:CGRectMake(100, 231, 255, 50) type:BButtonTypeDefault];
    restorePurchases.tag = 7;
    [restorePurchases addTarget:self action:@selector(restoreIAP) forControlEvents:UIControlEventTouchUpInside];
    [restorePurchases setTitle:@"Restore Purchases" forState:UIControlStateNormal];
    [restorePurchases addAwesomeIcon:FAIconDownloadAlt beforeTitle:YES];
    [contentView addSubview:restorePurchases];
    
    
    
    [[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];
    
}

-(void)options:(id)sender{
    [self playClick];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 450, 220)];
    
    CGRect welcomeLabelRect = contentView.bounds;
    welcomeLabelRect.origin.y = 10;
    welcomeLabelRect.size.height = 30;
    //welcomeLabelRect.size.width -= 10;
    UIFont *welcomeLabelFont = [UIFont boldSystemFontOfSize:30];
    UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:welcomeLabelRect];
    welcomeLabel.text = @"Game Options";
    welcomeLabel.font = welcomeLabelFont;
    welcomeLabel.textColor = [UIColor whiteColor];
    welcomeLabel.textAlignment = NSTextAlignmentCenter;
    welcomeLabel.backgroundColor = [UIColor clearColor];
    welcomeLabel.shadowColor = [UIColor blackColor];
    welcomeLabel.shadowOffset = CGSizeMake(0, 1);
    [contentView addSubview:welcomeLabel];
    
    
    UIButton *btnSound = [Common makeButton:@"btnsoundon.png" left:120 top:65 action:@selector(soundoption:) delegate:self];
    UIImage *imgButton = [UIImage imageNamed:@"btnsoundon.png"];
    [btnSound setBackgroundImage:imgButton forState:UIControlStateNormal];
    UIImage *imgSelectedButton = [UIImage imageNamed:@"btnsoundoff.png"];
    [btnSound setBackgroundImage:imgSelectedButton forState:UIControlStateSelected];
    btnSound.frame = CGRectMake(120, 65, imgButton.size.width, imgButton.size.height);
    [contentView addSubview:btnSound];
    
    [btnSound setSelected:!bSoundOn];
    
    UIButton *btnMusic = [Common makeButton:@"btnmusicon.png" left:120 top:110 action:@selector(musicoption:) delegate:self];
    imgButton = [UIImage imageNamed:@"btnmusicon.png"];
    [btnMusic setBackgroundImage:imgButton forState:UIControlStateNormal];
    imgSelectedButton = [UIImage imageNamed:@"btnmusicoff.png"];
    [btnMusic setBackgroundImage:imgSelectedButton forState:UIControlStateSelected];
    btnMusic.frame = CGRectMake(120, 110, imgButton.size.width, imgButton.size.height);
    [contentView addSubview:btnMusic];
    
    [btnMusic setSelected:!bMusicOn];
    
    UIButton *btnNotification = [Common makeButton:@"btnnotificationson.png" left:120 top:155 action:@selector(notificationoption:) delegate:self];
    imgButton = [UIImage imageNamed:@"btnnotificationson.png"];
    [btnNotification setBackgroundImage:imgButton forState:UIControlStateNormal];
    imgSelectedButton = [UIImage imageNamed:@"btnnotificationsoff.png"];
    [btnNotification setBackgroundImage:imgSelectedButton forState:UIControlStateSelected];
    btnNotification.frame = CGRectMake(120, 155, imgButton.size.width, imgButton.size.height);
    [contentView addSubview:btnNotification];
    
    [btnNotification setSelected:!bNotificationsOn];
    
    /*BButton *claimCredits = [[BButton alloc] initWithFrame:CGRectMake(100, 116, 255, 50) type:BButtonTypeWarning];
     claimCredits.tag = 1;
     [claimCredits addTarget:self action:@selector(claimCredits:) forControlEvents:UIControlEventTouchUpInside];
     [claimCredits setTitle:@"Claim Credits!" forState:UIControlStateNormal];
     [contentView addSubview:claimCredits];*/
    
    
    
    [[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [ALSdk initializeSdk];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.databaseName = @"database.sqlite";
    
    bGiveBonus = NO;
 
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[AVAudioSession sharedInstance] setDelegate:self];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"cheering" ofType:@"mp3"];
    AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:nil];
    self.cheerPlayer = newPlayer;
    
    cheerPlayer.numberOfLoops = 0;
    cheerPlayer.currentTime = 0;
    cheerPlayer.volume = 1.0;
    [self.cheerPlayer prepareToPlay];
    
    
    filePath = [[NSBundle mainBundle] pathForResource:@"dingdong" ofType:@"mp3"];
    newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:nil];
    self.dingDongPlayer = newPlayer;
    
    dingDongPlayer.numberOfLoops = 0;
    dingDongPlayer.currentTime = 0;
    dingDongPlayer.volume = 1.0;
    [self.dingDongPlayer prepareToPlay];
    
    
    
    filePath = [[NSBundle mainBundle] pathForResource:@"click" ofType:@"mp3"];
    newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:nil];
    self.clickPlayer = newPlayer;
    
    clickPlayer.numberOfLoops = 0;
    clickPlayer.currentTime = 0;
    clickPlayer.volume = 1.0;
    [self.clickPlayer prepareToPlay];
    
    filePath = [[NSBundle mainBundle] pathForResource:@"chaching" ofType:@"mp3"];
    newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:nil];
    self.chachingPlayer = newPlayer;
    
    chachingPlayer.numberOfLoops = 0;
    chachingPlayer.currentTime = 0;
    chachingPlayer.volume = 1.0;
    [self.chachingPlayer prepareToPlay];
    
    filePath = [[NSBundle mainBundle] pathForResource:@"lose" ofType:@"mp3"];
    newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:nil];
    self.awwPlayer = newPlayer;
    
    awwPlayer.numberOfLoops = 0;
    awwPlayer.currentTime = 0;
    awwPlayer.volume = 1.0;
    [self.awwPlayer prepareToPlay];
    
    
    filePath = [[NSBundle mainBundle] pathForResource:@"winsound2" ofType:@"mp3"];
    newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:nil];
    self.winCounterPlayer = newPlayer;
    
    winCounterPlayer.numberOfLoops = -1;
    winCounterPlayer.currentTime = 0;
    winCounterPlayer.volume = 1.0;
    [self.winCounterPlayer prepareToPlay];
    
    filePath = [[NSBundle mainBundle] pathForResource:@"lottobackground2" ofType:@"mp3"];
    newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:nil];
    self.backgroundPlayer = newPlayer;
    
    backgroundPlayer.numberOfLoops = -1;
    backgroundPlayer.currentTime = 0;
    backgroundPlayer.volume = 1.0;
    [self.backgroundPlayer prepareToPlay];
    
    filePath = [[NSBundle mainBundle] pathForResource:@"dingbell1" ofType:@"mp3"];
    newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:nil];
    self.bellPlayer = newPlayer;
    
    bellPlayer.numberOfLoops = 0;
    bellPlayer.currentTime = 0;
    bellPlayer.volume = 1.0;
    [self.bellPlayer prepareToPlay];
    
    
    
    /*NSString *chipSelectFilePath = [[NSBundle mainBundle] pathForResource:@"chipselect" ofType:@"mp3"];
    AVAudioPlayer *chipPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:chipSelectFilePath] error:nil];
    self.chipSelectPlayer = chipPlayer;
    
    NSString *chipDropFilePath = [[NSBundle mainBundle] pathForResource:@"chipdrop" ofType:@"mp3"];
    AVAudioPlayer *dropPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:chipDropFilePath] error:nil];
    self.chipDropPlayer = dropPlayer;
    
    NSString *winCounterFilePath = [[NSBundle mainBundle] pathForResource:@"wincounter" ofType:@"mp3"];
    AVAudioPlayer *winPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:winCounterFilePath] error:nil];
    self.winningPlayer = winPlayer;*/
    
    srand48( getpid() );
    // seed the random number generator
    /*srand48( getpid() );
    
    
    
    int deck[52];
    
    // initialize the deck
    init_deck( deck );
    
    int hand[5] = {deck[0],deck[13],deck[11],deck[24],deck[37]};
    int hand2[5] = {deck[14],deck[15],deck[16],deck[17],deck[18]};
    
    int r = eval_5hand(hand);
    int hr = hand_rank(r);
    
    int r2 = eval_5hand(hand2);
    int hr2 = hand_rank(r2);
    
    DLog(@"eval: %@", [NSString stringWithUTF8String:value_str[hr]]);
    DLog(@"eval: %@", [NSString stringWithUTF8String:value_str[hr2]]);
    print_hand(hand, 5);
    print_hand(hand2, 5);
    
    if(r<r2)
     DLog(@"hand1: > hand2:");
    else if(r>r2)
         DLog(@"hand1: < hand2:");
    else
        DLog(@"hand1:= hand2:");*/
    
    /*Card *cc = [[Card alloc] initWithValue:17];
    
    NSLog(@"face %@ suit: %@ card: %@ value: %d", [cc getFaceString], [cc getSuitString], [cc getCardString], [cc getValue]);
    
    Card *c = [[Card alloc] initWithCardString:@"2s"];
    NSLog(@"face %@ suit: %@ card: %@ value: %d", [c getFaceString], [c getSuitString], [c getCardString], [c getValue]);
    
    Card *card1 = [[Card alloc] initWithCardString:@"Ks"];
    Card *card2 = [[Card alloc] initWithCardString:@"6s"];
    Card *card3 = [[Card alloc] initWithCardString:@"Tc"];
    Card *card4 = [[Card alloc] initWithCardString:@"Ts"];
    Card *card5 = [[Card alloc] initWithCardString:@"6d"];
    NSMutableArray *cards = [[NSMutableArray alloc] initWithObjects:card1, card2, card3, card4, card5, nil];
    Hand *hand = [[Hand alloc] initWithCards:cards];

    NSLog(@"handrank: %@", [hand getHandRankString]);
    
    Hand *handtwo = [[Hand alloc] initWithHandString:@"5s Kc Ad 6h 4s"];*/
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [RevMobAds startSessionWithAppID:REVMOB_ID];
    //ok revmob
    
    /*for(NSString* family in [UIFont familyNames]) {
        NSLog(@"%@", family);
        for(NSString* name in [UIFont fontNamesForFamilyName: family]) {
            NSLog(@"  %@", name);
        }
    }*/
    
    observer = [[StoreObserver alloc] init];
    observer.delegate = self;
    [[SKPaymentQueue defaultQueue] addTransactionObserver:observer];
    
    /*[userDefaults setObject:nil forKey:KEY_ADSENABLED];
    [userDefaults setObject:nil forKey:KEY_MOREJACKPOTSENABLED];
    [userDefaults setObject:nil forKey:KEY_CREDIT];
    [userDefaults setObject:nil forKey:KEY_LEVEL];
    [userDefaults setObject:nil forKey:KEY_LEVELPROGRESS];
    [userDefaults synchronize];*/
    
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"com.ellis.lottoticketvip.Balance" accessGroup:nil];
    NSString *balance = [wrapper objectForKey:(__bridge id)kSecAttrService];

	if ([userDefaults objectForKey:KEY_CREDIT] == nil && (balance == nil || [balance isEqualToString:@""])) {
		mCredit = STARTUP_CREDIT;
        
        [userDefaults setInteger:mCredit forKey:KEY_CREDIT];
        [self setBalance:mCredit];
		bSoundOn = YES;
        bNotificationsOn = YES;
        bMusicOn = YES;
	} else {
		//mCredit = [userDefaults integerForKey:KEY_CREDIT];
        mCredit = [self getBalance];
        
		bSoundOn = [userDefaults boolForKey:KEY_SOUND];
        bNotificationsOn = [userDefaults boolForKey:KEY_NOTIFICATIONS];
        bMusicOn = [userDefaults boolForKey:KEY_MUSIC];
	}
    
    if ([userDefaults objectForKey:KEY_SOUND] == nil) {
		bSoundOn = YES;
        bNotificationsOn = YES;
        bMusicOn = YES;
	} else {
		bSoundOn = [userDefaults boolForKey:KEY_SOUND];
        bNotificationsOn = [userDefaults boolForKey:KEY_NOTIFICATIONS];
        bMusicOn = [userDefaults boolForKey:KEY_MUSIC];
	}
    
    if ([userDefaults objectForKey:KEY_LEVEL] == nil) {
		mLevel = 1;
	} else {
		mLevel = [userDefaults integerForKey:KEY_LEVEL];
	}
    
    if ([userDefaults objectForKey:KEY_LEVELPROGRESS] == nil) {
		mLevelProgress = 0;
	} else {
		mLevelProgress = [userDefaults integerForKey:KEY_LEVELPROGRESS];
	}
    
    
	//Payout Locking...
	if ([userDefaults objectForKey:KEY_ADSENABLED] == nil) {
		bAdsEnabled = YES;
	} else {
		bAdsEnabled = [userDefaults boolForKey:KEY_ADSENABLED];
	}
    
    if ([userDefaults objectForKey:KEY_MOREJACKPOTSENABLED] == nil) {
		bMoreJackpotsEnabled = NO;
	} else {
		bMoreJackpotsEnabled = [userDefaults boolForKey:KEY_MOREJACKPOTSENABLED];
	}
    
    //removelater
    //mCredit = STARTUP_CREDIT;
    //[self setBalance:mCredit];
    //bAdsEnabled = NO;
	
	DLog(@"Loading... Credit %d, Sound %d notifications: %d music: %d", mCredit, bSoundOn, bNotificationsOn, bMusicOn);
	DLog(@"Ads Enabled is %d", bAdsEnabled);
    DLog(@"More Jackpots Enabled is %d", bMoreJackpotsEnabled);
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    self.databasePath = [documentDir stringByAppendingPathComponent:self.databaseName];
    
    [self createAndCheckDatabase];
    self.db = [[FMDBDataAccess alloc] init];
    
   
    startupDidFinish = 1;
    
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (locationNotification) {
        
        //give the free daily credits bonus!!!
        bGiveBonus = YES;
        //mCredit = [self getBalance];
        //mCredit += 20;
        
        //[self setBalance:mCredit];
        
        // Set icon badge number to zero
        application.applicationIconBadgeNumber = 0;
    }
    else{
        bGiveBonus = NO;
    }
    
    [Common cancelAllLocalNotifications];
    
    if(bNotificationsOn)
        [Common scheduleLocalNotification:nil message:@"Your FREE credits are waiting!"];
    
    self.mainMenuViewController = [[MainMenuViewController alloc] init];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.mainNavController = [[UINavigationController alloc] initWithRootViewController:mainMenuViewController];
    self.mainNavController.navigationBarHidden = YES;
    
    if([self.window respondsToSelector:@selector(setRootViewController:)])
        [self.window setRootViewController: self.mainNavController];
    else
        [self.window addSubview: self.mainNavController.view];
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"FREE Credits"
                                                        message:notification.alertBody
                                                       delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];*/
    }
    else{
        //bGiveBonus = YES;
    }
    
    UIViewController *view = [self.mainNavController topViewController];
    if([view isKindOfClass:[MainMenuViewController class]]){
        MainMenuViewController *mvc = (MainMenuViewController*)view;
        [mvc showBonus];
        
    }
    else if([view isKindOfClass:[ScratchViewController class]]){
        ScratchViewController *svc = (ScratchViewController*)view;
        [svc showBonus];
    }
    // Request to reload table view data
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
    
    // Set icon badge number to zero
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self saveGameVariable];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     startupForeground = 1;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if (startupDidFinish == 1 || startupForeground==1) {
        //Do normal startup stuff
        [self performSelector:@selector(showadsnow) withObject:nil afterDelay:1.5f];
        
        //SlotsVipLayer* layer = (SlotsVipLayer*) [[[CCDirector sharedDirector] runningScene] getChildByTag:SCENE_SLOTVIPSCENE];
        //[layer getChips:nil];
        
        //[self showadsnow];
    }
    startupDidFinish = 0;
    startupForeground = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self saveGameVariable];
}

-(void)showadsnow{
    
    if(bAdsEnabled){
        //change here
        [[Chartboost sharedChartboost] setAppId:CHARTBOOST_APPID];
        [[Chartboost sharedChartboost] setAppSignature:CHARTBOOST_APPSIGNATURE];
        
        [[Chartboost sharedChartboost] startSession];
        [[Chartboost sharedChartboost] cacheInterstitial];
        [[Chartboost sharedChartboost] cacheMoreApps];
        
        
        RevMobFullscreen* fullscreen = [[RevMobAds session] fullscreen];
        fullscreen.delegate = self;
        [fullscreen showAd];
    }
}

#pragma mark REVMOB delegate
-(void) moreGames{
    [[Chartboost sharedChartboost] showMoreApps];
}
- (void) dispAds {
    [[RevMobAds session] showFullscreen];
}

- (void)revmobAdDidFailWithError:(NSError *)error {
    //[[Chartboost sharedChartboost] showInterstitial];
    [ALInterstitialAd showOver:[[UIApplication sharedApplication] keyWindow]];
}

- (void)revmobUserClosedTheAd {
    //[[Chartboost sharedChartboost] showInterstitial];
    [ALInterstitialAd showOver:[[UIApplication sharedApplication] keyWindow]];
}

- (void)installDidFail {
    
}

#pragma mark chartboost delegate
- (void) dispMoreApps {
    [[Chartboost sharedChartboost] showMoreApps];
}
- (void)didFailToLoadInterstitial:(NSString *)location {
    
    //    [[RevMobAds session] showFullscreen];
    
}

// Called when the user dismisses the interstitial
// If you are displaying the add yourself, dismiss it now.
- (void)didDismissInterstitial:(NSString *)location {
    
    //    [[RevMobAds session] showFullscreen];
    
}

// Same as above, but only called when dismissed for a close
- (void)didCloseInterstitial:(NSString *)location {
    
    //    [[RevMobAds session] showFullscreen];
    
}

@end
