//
//  MainMenuViewController.m
//  lottoticketvip
//
//  Created by Greg Ellis on 2013-07-16.
//  Copyright (c) 2013 ellis. All rights reserved.
//

#import "MainMenuViewController.h"
#import "ScratchViewController.h"
#import "Common.h"
#import "KSLabel.h"
#import "GameVariables.h"
#import "KGModal.h"
#import "BButton.h"
#import "AppDelegate.h"
#import "UICountingLabel.h"
#import "UILevelProgress.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController
@synthesize bannerView_, btnRemoveAds, btnGetCredits, btnOptions;

- (id)init
{
	if((self=[super init]))
	{
        
    }
    return self;
}

-(void) updateCardView{
    [cardContainer setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ticket%d.png", selectedTicket+1]]];
    [[cardContainer viewWithTag:LOCKED_VIEW] removeFromSuperview];
    
    int levellock = ticketLockedLevel[selectedTicket];
    if(levellock>0 && mLevel < levellock){
        UIImageView *locked = [Common makeImage:@"lockticket.png" left:0 top:0];
        UIImageView *levelbackground = [Common makeImage:@"levelpanel.png" left:90 top:100];
        [locked addSubview:levelbackground];
        
        KSLabel *unlocklevel = [[KSLabel alloc] initWithFrame:CGRectMake(0, 0, levelbackground.frame.size.width, levelbackground.frame.size.height)];
        [unlocklevel setFont:[UIFont fontWithName:@"BerlinSansFB-Bold" size:22]];
        [unlocklevel setOutersize:3];
        [unlocklevel setBackgroundColor:[UIColor clearColor]];
        [unlocklevel setTextColor:[UIColor whiteColor]];
        [unlocklevel setTextAlignment:NSTextAlignmentCenter];
        [levelbackground addSubview:unlocklevel];
        
        [unlocklevel setText:[NSString stringWithFormat:@"%d", levellock]];
        [locked setTag:LOCKED_VIEW];
        [cardContainer addSubview:locked];
        [btnGetTicket setHidden:YES];
    }
    else{
        [btnGetTicket setHidden:NO];
    }
    [cardContainer setNeedsDisplay];
    
    if(ticketPrice[selectedTicket] == 0)
        [creditCost setText:[NSString stringWithFormat:@"FREE"]];
    else
        [creditCost setText:[NSString stringWithFormat:@"%d CREDITS", ticketPrice[selectedTicket]]];
}

-(void)leftarrow:(id)sender{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate playClick];
    
    selectedTicket--;
    if(selectedTicket<0)
        selectedTicket = NUM_TICKETS-1;
    
   [self updateCardView];
    
}

-(void)rightarrow:(id)sender{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate playClick];
    
    selectedTicket++;
    if(selectedTicket>=NUM_TICKETS)
        selectedTicket = 0;
    
    [self updateCardView];
    
}

-(void)restorepurchases:(BButton*)sender{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate restoreIAP];
}

-(void)coinsbuy:(BButton*)sender{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate buyIAPitem:sender.tag];
}

-(void)refresh{
    [creditsLabel setText:[NSString stringWithFormat:@"%d", mCredit]];
    [pg setProgress:(float)((float)mLevelProgress/(float)MAX_LEVELPROGRESS)];
    [level setText:[NSString stringWithFormat:@"%d", mLevel]];
    [pg setNeedsDisplay];
}

-(void)stopCount{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [delegate.winCounterPlayer stop];
}

-(void)claimCredits:(id)sender{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    mCredit = [delegate getBalance];
    mCredit += 20;
    
    delegate.bGiveBonus = NO;
    
    [delegate playWinCounter];
    
    [delegate setBalance:mCredit];
    //[self refresh];
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    formatter.maximumFractionDigits = 2;
    creditsLabel.method = UILabelCountingMethodLinear;
    creditsLabel.formatBlock = ^NSString *(float value){
        NSString * formattedAmount = [formatter stringFromNumber:[NSNumber numberWithFloat:value]];
        return formattedAmount;
    };
    [creditsLabel countFrom:mCredit-20 to:mCredit withDuration:3.0];
    [self performSelector:@selector(stopCount) withObject:nil afterDelay:3.0];
    
    [[KGModal sharedInstance] hideAnimated:YES];
}

-(void)showBonus{
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate playClick];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 450, 200)];
    
    CGRect welcomeLabelRect = contentView.bounds;
    welcomeLabelRect.origin.y = 10;
    welcomeLabelRect.size.height = 30;
    //welcomeLabelRect.size.width -= 10;
    UIFont *welcomeLabelFont = [UIFont boldSystemFontOfSize:30];
    UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:welcomeLabelRect];
    welcomeLabel.text = @"Bonus Credits!";
    welcomeLabel.font = welcomeLabelFont;
    welcomeLabel.textColor = [UIColor whiteColor];
    welcomeLabel.textAlignment = NSTextAlignmentCenter;
    welcomeLabel.backgroundColor = [UIColor clearColor];
    welcomeLabel.shadowColor = [UIColor blackColor];
    welcomeLabel.shadowOffset = CGSizeMake(0, 1);
    [contentView addSubview:welcomeLabel];
    
    BButton *claimCredits = [[BButton alloc] initWithFrame:CGRectMake(100, 116, 255, 50) type:BButtonTypeWarning];
    claimCredits.tag = 1;
    [claimCredits addTarget:self action:@selector(claimCredits:) forControlEvents:UIControlEventTouchUpInside];
    [claimCredits setTitle:@"Claim Credits!" forState:UIControlStateNormal];
    [contentView addSubview:claimCredits];
    
    
    
    [[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(alertView.tag == 1){
        if(buttonIndex == 1){
            [self.navigationController pushViewController:[[ScratchViewController alloc] initWithTicket:selectedTicket] animated:YES];
        }
    }
    else if(alertView.tag == 2){
        [delegate getcredits:nil];
    }
    else if(alertView.tag == 3){
        
    }
}

-(void)getticket:(id)sender{
    
    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Credits" message:@"Would like to use 5 credits to play this ticket?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil];
    //[alert show];
    int levellock = ticketLockedLevel[selectedTicket];
    if(levellock>0 && mLevel < levellock){
        
        /*UIAlertView* v = [[UIAlertView alloc] initWithTitle:@"Locked" message:[NSString stringWithFormat:@"You need to reach Level %d before you can play this ticket or you can unlock it now.", levellock] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Unlock Now!", nil];
        v.tag = 3;
        [v show];*/
        
        [Common showAlert:@"Locked!" message:[NSString stringWithFormat:@"You need to reach Level %d before you can play this ticket!", levellock]];
        return; 
    }
    
    if(mCredit < ticketPrice[selectedTicket]){
        UIAlertView* v = [[UIAlertView alloc] initWithTitle:@"Not Enough Credits" message:@"Sorry, you don't have enough credits to play this ticket." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Get Credits", nil];
        v.tag = 2;
        [v show];
        
        return;
    }
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate playChaChing];
    
    mCredit = mCredit - ticketPrice[selectedTicket];
    [delegate setBalance:mCredit];
    
    int extra = 0;
    if(mLevel<2) extra = 170;
    else if(mLevel<5) extra = 70;
    
    if(ticketPrice[selectedTicket]>0)
        mLevelProgress += LEVEL_STEP+extra;
    
    if(mLevelProgress>=MAX_LEVELPROGRESS){
        mLevel++;
        mLevelProgress = 0;
    }
    
    [self.navigationController pushViewController:[[ScratchViewController alloc] initWithTicket:selectedTicket] animated:YES];

    [self refresh];
}

-(void)removeads:(id)sender{
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate buyIAPitem:7];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UIView *subview = [backgroundView hitTest:[[touches anyObject] locationInView:backgroundView] withEvent:nil];
    if(subview == cardContainer){
        [self getticket:nil];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(delegate.bGiveBonus){
        
        [self showBonus];
    }
    
    [self refresh];
}

-(void)moreGames:(id)sender{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate moreGames];
}

-(void)freeGames:(id)sender{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [[RevMobAds session] openAdLinkWithDelegate:delegate];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate playBackground];
	// Do any additional setup after loading the view.
    selectedTicket = 0;
    
    UIImage *imgBackground = [UIImage imageNamed:@"black_background.png"];
    
    backgroundView = [[UIImageView alloc] initWithImage:imgBackground];
    [backgroundView setUserInteractionEnabled:YES];
    

    if(!IS_IPHONE_5){
        [backgroundView setFrame:CGRectMake(-44, 0, backgroundView.frame.size.width, backgroundView.frame.size.height)];
    }
    
    cardContainer = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"ticket%d.png", selectedTicket+1]]];
    [cardContainer setUserInteractionEnabled:YES];
    [cardContainer setFrame:CGRectMake(170, 58, cardContainer.frame.size.width, cardContainer.frame.size.height)];
    [backgroundView addSubview:cardContainer];
    
    //238
    btnGetTicket = [Common makeButton:@"getticket.png" left:178 top:165 action:@selector(getticket:) delegate:self];
    [backgroundView addSubview:btnGetTicket];
    
    
    
    int leftincrease = 65;
    if(bAdsEnabled){
        leftincrease = 0;
    btnRemoveAds = [Common makeButton:@"removeads.png" left:343 top:209 action:@selector(removeads:) delegate:self];
    [backgroundView addSubview:btnRemoveAds];
    }
    
    btnGetCredits = [Common makeButton:@"getcredits.png" left:107+leftincrease top:209 action:@selector(getcredits:) delegate:delegate];
    [backgroundView addSubview:btnGetCredits];
    
    btnOptions = [Common makeButton:@"options.png" left:240+leftincrease top:209 action:@selector(options:) delegate:delegate];
    [backgroundView addSubview:btnOptions];
    
    UIButton* btnLeftArrow = [Common makeButton:@"leftarrow.png" left:110 top:103 action:@selector(leftarrow:) delegate:self];
    [backgroundView addSubview:btnLeftArrow];
    
    UIButton* btnRightArrow = [Common makeButton:@"rightarrow.png" left:408 top:103 action:@selector(rightarrow:) delegate:self];
    [backgroundView addSubview:btnRightArrow];
    
    UIImageView *topBar = [Common makeImage:@"headerbar_2.png" left:0 top:0];
    [backgroundView addSubview:topBar];
    
    
    creditsLabel = [[UICountingLabel alloc] initWithFrame:CGRectMake(293, 8, 200, 25)];
    [creditsLabel setText:[NSString stringWithFormat:@"%d", mCredit]];
    [creditsLabel setStrokeColor:[UIColor blackColor]];
    [creditsLabel setOutersize:2];
    [creditsLabel setInnersize:0];
    [creditsLabel setBackgroundColor:[UIColor clearColor]];
    [creditsLabel setFont:[UIFont fontWithName:@"NeoSansPro-BoldItalic" size:13]];
    [creditsLabel setTextColor:[UIColor whiteColor]];
    [backgroundView addSubview:creditsLabel];
    
    UIButton *btnCredits = [Common makeButton:@"btncredits.png" left:394 top:2 action:@selector(getcredits:) delegate:delegate];
    [backgroundView addSubview:btnCredits];
    
    KSLabel *creditLabel = [[KSLabel alloc] initWithFrame:CGRectMake(0, 1, btnCredits.frame.size.width, btnCredits.frame.size.height)];
    [creditLabel setFont:[UIFont fontWithName:@"BerlinSansFB-Bold" size:15]];
    [creditLabel setOutersize:1];
    [creditLabel setBackgroundColor:[UIColor clearColor]];
    [creditLabel setText:@"CREDITS"];
    [creditLabel setTextColor:[UIColor whiteColor]];
    [creditLabel setTextAlignment:NSTextAlignmentCenter];
    [btnCredits addSubview:creditLabel];
    

    UIImageView *credits = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"creditsbig.png"]];
    [credits setFrame:CGRectMake(215, 41, credits.frame.size.width, credits.frame.size.height)];
    [backgroundView addSubview:credits];
    
    creditCost = [[KSLabel alloc] initWithFrame:CGRectMake(200, 47, 160, 26)];
    [creditCost setTextAlignment:NSTextAlignmentCenter];
    [creditCost setStrokeColor:[UIColor blackColor]];
    [creditCost setOutersize:2];
    [creditCost setInnersize:0];
    [creditCost setBackgroundColor:[UIColor clearColor]];
    [creditCost setFont:[UIFont fontWithName:@"BerlinSansFB-Bold" size:22]];
    [creditCost setTextColor:[UIColor whiteColor]];
    [backgroundView addSubview:creditCost];
    
    [self.view addSubview:backgroundView];
    

    pg = [[UILevelProgress alloc] initWithFrame:CGRectMake(120, 3, 95, 25)];
    [pg setOuterColor:[UIColor colorWithRed:0.0/255.0f green:166.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
    [pg setInnerColor:[UIColor colorWithRed:0.0/255.0f green:166.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
    [pg setEmptyColor:[UIColor blackColor]];
    
    [pg setProgress:0.0f];
    
    [topBar addSubview:pg];
    
    UIImageView *lp = [Common makeImage:@"levelpanel.png" left:210 top:0];
    [topBar addSubview:lp];
    
    level = [[KSLabel alloc] initWithFrame:CGRectMake(0, 0, lp.frame.size.width, lp.frame.size.height)];
    [level setFont:[UIFont fontWithName:@"BerlinSansFB-Bold" size:22]];
    [level setOutersize:3];
    [level setBackgroundColor:[UIColor clearColor]];
    [level setTextColor:[UIColor whiteColor]];
    [level setTextAlignment:NSTextAlignmentCenter];
    [lp addSubview:level];
    
    [level setText:[NSString stringWithFormat:@"%d", mLevel]];
    
    
    
    BButton *btnSettings = [BButton awesomeButtonWithOnlyIcon:FAIconCog color:[UIColor colorWithRed:28.0/255.0 green:113.0/255.0 blue:255.0/255.0 alpha:1.0]];
    [btnSettings setFrame:CGRectMake(480, 2, 40, 28)];
    [btnSettings addTarget:delegate action:@selector(options:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:btnSettings];
    
    
    
    if(bAdsEnabled){
    bannerView_ = [[GADBannerView alloc]
                   initWithFrame:CGRectMake(135,
                                            280,
                                            GAD_SIZE_320x50.width,
                                            GAD_SIZE_320x50.height)];
    
    // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
    bannerView_.adUnitID = ADMOB_UNIT_ID;
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    bannerView_.rootViewController = self;
    
    [backgroundView addSubview:bannerView_];
    
    // Initiate a generic request to load it with an ad.
    [bannerView_ loadRequest:[GADRequest request]];
    }
    
    
    [self updateCardView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
