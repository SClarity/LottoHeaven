//
//  ScratchViewController.m
//  lottoticketvip
//
//  Created by Greg Ellis on 2013-07-16.
//  Copyright (c) 2013 ellis. All rights reserved.
//

#import "ScratchViewController.h"
#import "Common.h"
#import "GameVariables.h"
#import "KSLabel.h"
#import "NSMutableArray+Shuffling.h"
#import "Toast+UIView.h"
#import "Card.h"
#import "poker.h"
#import "AppDelegate.h"
#import "SFSConfettiScreen.h"
#import "SFSFireworksScreen.h"
#import "UICountingLabel.h"
#import "BButton.h"
#import "KGModal.h"
#import "UILevelProgress.h"

@interface ScratchViewController ()

@end

@implementation ScratchViewController

-(id)initWithTicket:(int)tid
{
    if((self=[super init]))
	{
        ticketid = tid;
        DLog(@"ticket id: %d", ticketid);
        
        
    }
    
    return self;
}

- (id)init
{
	return [self initWithTicket:0];
}

float ReportAlphaPercent(CGImageRef imgRef)
{
    size_t w = CGImageGetWidth(imgRef);
    size_t h = CGImageGetHeight(imgRef);
    
    unsigned char *inImage = malloc(w * h * 4);
    memset(inImage, 0, (h * w * 4));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(inImage, w, h, 8, w * 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetShouldAntialias(context, NO);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), imgRef);
    
    int byteIndex = 0;
    float alphaCount = 0.0f;
    
    for(int i = 0; i < (w * h); i++) {
        
        if (inImage[byteIndex + 3]) { // if the alpha value is not 0, count it
           
        }
        else{
             alphaCount++;
        }
        
        
        byteIndex += 4;
    }
    
    free(inImage);
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    return (alphaCount / ((float)w * (float)h)) * 100.0f;
}

-(void)checkTicketButtonAnimStopped{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate playDingDong];
}

-(void)playAnotherButtonAnimStopped{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate playBell];
}

-(void)showPlayAnotherButton{
    if([btnPlayAnother isHidden]){
    [btnPlayAnother setFrame:CGRectMake(btnPlayAnother.frame.origin.x, -100, btnPlayAnother.frame.size.width, btnPlayAnother.frame.size.height)];
    
    [UIView beginAnimations:@"showplayanotherbutton" context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationDelegate:self];
    //[UIView setAnimationDidStopSelector:@selector(checkTicketButtonAnimStopped)];
    
    [btnPlayAnother setHidden:NO];
    [btnPlayAnother setFrame:CGRectMake(btnPlayAnother.frame.origin.x, 35, btnPlayAnother.frame.size.width, btnPlayAnother.frame.size.height)];
    
    [UIView commitAnimations];
    
    [self performSelector:@selector(playAnotherButtonAnimStopped) withObject:nil afterDelay:0.5];
    }
}

-(void)showCheckTicketButton{
    
    [btnCheckTicket setFrame:CGRectMake(btnCheckTicket.frame.origin.x, -100, btnCheckTicket.frame.size.width, btnCheckTicket.frame.size.height)];

    [UIView beginAnimations:@"showcheckticketbutton" context:nil];
    [UIView setAnimationDuration:1.5f];
    [UIView setAnimationDelegate:self];
    //[UIView setAnimationDidStopSelector:@selector(checkTicketButtonAnimStopped)];
    
    [btnCheckTicket setHidden:NO];
    [btnCheckTicket setFrame:CGRectMake(btnCheckTicket.frame.origin.x, 35, btnCheckTicket.frame.size.width, btnCheckTicket.frame.size.height)];
    
    [UIView commitAnimations];
    
    [self performSelector:@selector(checkTicketButtonAnimStopped) withObject:nil afterDelay:1.0];
}

-(void)scratchImageView:(ScratchImageView *)maskView cleatPercentWasChanged:(float)clearPercent{
    
    if(clearPercent > 60.0f && [btnCheckTicket isHidden] && btnCheckTicket.tag != 1){
        [self showCheckTicketButton];
        [btnCheckTicket setTag:1];
    }
    //NSLog(@"percentage: %f%%", clearPercent);
}

-(void)back:(id)sender{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate playClick];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch* touch = [touches anyObject];
    if(touch.view == checkView && ![checkView isHidden]){
        [self hideCheckView];
    }
    //if(touch.view == levelView){
       // [self hideLevelView];
   // }
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

-(void)hideCheckView{
    
    if([backgroundView viewWithTag:CHECK_VIEW] == nil)
        return;
    
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [checkView removeFromSuperview];
    [delegate.cheerPlayer stop];
    [delegate.awwPlayer stop];
    [delegate.winCounterPlayer stop];
    
    bNewLevel = NO;
    
    if(ticketPrice[ticketid]<=0){
        
    int extra = 0;
    if(mLevel<2) extra = 170;
    else if(mLevel<5) extra = 70;
    
    
    mLevelProgress += LEVEL_STEP+extra;
    
        if(mLevelProgress>=MAX_LEVELPROGRESS){
            mLevel++;
            mLevelProgress = 0;
            
            [self refresh];
            [self newLevel];
            bNewLevel = YES;
        }
    }

    [self refresh];
    
    if(!bNewLevel)
        [self showPlayAnotherButton];
}

-(void)hideLevelView{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [levelView removeFromSuperview];
    [delegate.cheerPlayer stop];
    
    if(bNewLevel){
        [self showPlayAnotherButton];
    }
}

-(void)stopCount{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [delegate.winCounterPlayer stop];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(alertView.tag == 1){
        if(buttonIndex == 1){
            [self.navigationController pushViewController:[[ScratchViewController alloc] initWithTicket:ticketid] animated:YES];
        }
    }
    else if(alertView.tag == 2){
        [delegate getcredits:nil];
    }
}

-(void)playanother:(id)sender{
    if(mCredit < ticketPrice[ticketid]){
        UIAlertView* v = [[UIAlertView alloc] initWithTitle:@"Not Enough Credits" message:@"Sorry, you don't have enough credits to play this ticket." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Get Credits", nil];
        v.tag = 2;
        [v show];
        
        return;
    }
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate playChaChing];
    
    mCredit = mCredit - ticketPrice[ticketid];
    [delegate setBalance:mCredit];
    int extra = 0;
    
    if(mLevel<2) extra = 170;
    else if(mLevel<5) extra = 70;
    
    if(ticketPrice[ticketid]>0)
        mLevelProgress += LEVEL_STEP+extra;

    if(mLevelProgress>=MAX_LEVELPROGRESS){
        mLevel++;
        mLevelProgress = 0;
    }
    [self.navigationController pushViewController:[[ScratchViewController alloc] initWithTicket:ticketid] animated:YES];
    [self refresh];
}

-(void)newLevel{
     AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    levelView = [[UIView alloc] initWithFrame:backgroundView.bounds];
    [levelView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6f]];
    
    [backgroundView addSubview:levelView];
    
        SFSFireworksScreen *confetti = [[SFSFireworksScreen alloc] initWithFrame:backgroundView.frame];
        [levelView addSubview:confetti];
        [delegate playCheer];
        
        KSLabel *winnerLabel = [[KSLabel alloc] initWithFrame:CGRectMake(0, 0, backgroundView.bounds.size.width, 100)];
        [winnerLabel setBackgroundColor:[UIColor clearColor]];
        [winnerLabel setOutersize:8];
        [winnerLabel setInnersize:0];
        [winnerLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [winnerLabel setNumberOfLines:4];
        [winnerLabel setOutterStrokeColor:[UIColor blackColor]];
        [winnerLabel setInnerStrokeColor:[UIColor blackColor]];
        [winnerLabel setTextColor:[UIColor whiteColor]];
        [winnerLabel setFont:[UIFont fontWithName:@"NeoSansPro-BoldItalic" size:30]];
        [winnerLabel setText:[NSString stringWithFormat:@"Congratulations!\nYou have reached\nLevel %d!", mLevel]];
        [winnerLabel setTextAlignment:NSTextAlignmentCenter];
        [winnerLabel setFrame:CGRectMake(winnerLabel.frame.origin.x, 20/*backgroundView.center.y-(winnerLabel.frame.size.height/2)*/, backgroundView.bounds.size.width, 125)];
        [levelView addSubview:winnerLabel];
    
    //does this new level unlock a ticket
    BOOL bUnlockedTicket = NO;
    int unlocked_ticket_index = -1;
    for(int i=0; i<NUM_TICKETS; i++){
        int ll = ticketLockedLevel[i];
        if(ll == mLevel){
            bUnlockedTicket = YES;
            unlocked_ticket_index = i;
            break;
        }
    }
    
    if(bUnlockedTicket){
        
        UIImageView *cardimage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"ticket%d.png", unlocked_ticket_index+1]]];
        [cardimage setFrame:CGRectMake(backgroundView.bounds.size.width/2-(cardimage.frame.size.width/2), 180, cardimage.frame.size.width, cardimage.frame.size.height)];
        [levelView addSubview:cardimage];
        
        KSLabel *winnerLabel = [[KSLabel alloc] initWithFrame:CGRectMake(0, 0, backgroundView.bounds.size.width, 100)];
        [winnerLabel setBackgroundColor:[UIColor clearColor]];
        [winnerLabel setOutersize:8];
        [winnerLabel setInnersize:0];
        [winnerLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [winnerLabel setNumberOfLines:4];
        [winnerLabel setOutterStrokeColor:[UIColor blackColor]];
        [winnerLabel setInnerStrokeColor:[UIColor blackColor]];
        [winnerLabel setTextColor:[UIColor whiteColor]];
        [winnerLabel setFont:[UIFont fontWithName:@"NeoSansPro-BoldItalic" size:30]];
        [winnerLabel setText:[NSString stringWithFormat:@"You have unlocked\n%@!", ticketName[unlocked_ticket_index]]];
        [winnerLabel setTextAlignment:NSTextAlignmentCenter];
        [winnerLabel setFrame:CGRectMake(winnerLabel.frame.origin.x, 200, backgroundView.bounds.size.width, 125)];
        [levelView addSubview:winnerLabel];
    }
    
    
    
    [self performSelector:@selector(hideLevelView) withObject:nil afterDelay:5.0];
}

-(void)checkticket:(id)sender{
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate playClick];
    
    
    checkView = [[UIView alloc] initWithFrame:backgroundView.bounds];
    checkView.tag = CHECK_VIEW;
    [checkView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6f]];
    
    [backgroundView addSubview:checkView];
    
    if(bIsWinner){
        SFSConfettiScreen *confetti = [[SFSConfettiScreen alloc] initWithFrame:backgroundView.frame];
        [checkView addSubview:confetti];
        [delegate playCheer];
        [delegate playWinCounter];
        
        KSLabel *winnerLabel = [[KSLabel alloc] initWithFrame:CGRectMake(0, 0, backgroundView.bounds.size.width, 50)];
        [winnerLabel setBackgroundColor:[UIColor clearColor]];
        [winnerLabel setOutersize:8];
        [winnerLabel setInnersize:0];
        [winnerLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [winnerLabel setNumberOfLines:0];
        [winnerLabel setOutterStrokeColor:[UIColor blackColor]];
        [winnerLabel setInnerStrokeColor:[UIColor blackColor]];
        [winnerLabel setTextColor:[UIColor whiteColor]];
        [winnerLabel setFont:[UIFont fontWithName:@"NeoSansPro-BoldItalic" size:30]];
        [winnerLabel setText:[NSString stringWithFormat:@"You won $%d worth of credits!", prizebox_value]];
        [winnerLabel setTextAlignment:NSTextAlignmentCenter];
        [winnerLabel setFrame:CGRectMake(winnerLabel.frame.origin.x, backgroundView.center.y-(winnerLabel.frame.size.height/2), backgroundView.bounds.size.width, 50)];
        [checkView addSubview:winnerLabel];
        
        float nPrev = mCredit;
        mCredit+=prizebox_value;
        
        NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterCurrencyStyle;
        formatter.maximumFractionDigits = 2;
        creditsLabel.method = UILabelCountingMethodLinear;
        creditsLabel.formatBlock = ^NSString *(float value){
            NSString * formattedAmount = [formatter stringFromNumber:[NSNumber numberWithFloat:value]];
            return formattedAmount;
        };
        [creditsLabel countFrom:nPrev to:mCredit withDuration:3.0];
        [self performSelector:@selector(stopCount) withObject:nil afterDelay:3.0];
    }
    else{
        [delegate playAww];
        
        KSLabel *winnerLabel = [[KSLabel alloc] initWithFrame:CGRectMake(0, 0, backgroundView.bounds.size.width, 50)];
        [winnerLabel setBackgroundColor:[UIColor clearColor]];
        [winnerLabel setOutersize:8];
        [winnerLabel setInnersize:0];
        [winnerLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [winnerLabel setNumberOfLines:0];
        [winnerLabel setOutterStrokeColor:[UIColor blackColor]];
        [winnerLabel setInnerStrokeColor:[UIColor blackColor]];
        [winnerLabel setTextColor:[UIColor whiteColor]];
        [winnerLabel setFont:[UIFont fontWithName:@"NeoSansPro-BoldItalic" size:30]];
        [winnerLabel setText:[NSString stringWithFormat:@"Your ticket is not a winner :("]];
        [winnerLabel setTextAlignment:NSTextAlignmentCenter];
        [winnerLabel setFrame:CGRectMake(winnerLabel.frame.origin.x, backgroundView.center.y-(winnerLabel.frame.size.height/2), backgroundView.bounds.size.width, 50)];
        [checkView addSubview:winnerLabel];
    }
    
    [self refresh];
    [btnCheckTicket setHidden:YES];
    
    if(bIsWinner)
        [self performSelector:@selector(hideCheckView) withObject:nil afterDelay:5.0];
    else
        [self performSelector:@selector(hideCheckView) withObject:nil afterDelay:1.5];
}

-(void)refresh{
    [creditsLabel setText:[NSString stringWithFormat:@"%d", mCredit]];
   [pg setProgress:(float)((float)mLevelProgress/(float)MAX_LEVELPROGRESS)];
    [level setText:[NSString stringWithFormat:@"%d", mLevel]];
    [pg setNeedsDisplay];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refresh];
    
    
    if(mLevel >1 && mLevelProgress == 0 && ticketPrice[ticketid]>0)
        [self newLevel];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.view.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:0.0/255.0 alpha:1.0];
    
    UIImage *imgBackground = [UIImage imageNamed:[NSString stringWithFormat:@"ticket%d_background.png", ticketid+1]];
    
    backgroundView = [[UIImageView alloc] initWithImage:imgBackground];
    [backgroundView setUserInteractionEnabled:YES];
    
    if(!IS_IPHONE_5){
        [backgroundView setFrame:CGRectMake(-44, 0, backgroundView.frame.size.width, backgroundView.frame.size.height)];
    }
    
    UIImageView *topBar = [Common makeImage:@"headerbar_2.png" left:0 top:0];
    [backgroundView addSubview:topBar];
    
    UIButton *btnBack = [Common makeButton:@"back.png" left:49 top:1 action:@selector(back:) delegate:self];
    [backgroundView addSubview:btnBack];
    
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
    
    btnCheckTicket = [Common makeButton:@"checkticket.png" left:387 top:33 action:@selector(checkticket:) delegate:self];
    [btnCheckTicket setTag:0];
    [btnCheckTicket setHidden:YES];
    [backgroundView addSubview:btnCheckTicket];
    
    btnPlayAnother = [Common makeButton:@"playanother.png" left:350 top:33 action:@selector(playanother:) delegate:self];
    [btnPlayAnother setTag:1];
    [btnPlayAnother setHidden:YES];
    [backgroundView addSubview:btnPlayAnother];
    

    UIImageView *scratch_under = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"scratcharea%d_under.png", ticketid+1]]];
    [scratch_under setFrame:CGRectMake(ticketScratchPos[ticketid][0], ticketScratchPos[ticketid][1], scratch_under.frame.size.width, scratch_under.frame.size.height)];
    [scratch_under setUserInteractionEnabled:YES];
    [backgroundView addSubview:scratch_under];
    
    iv = [[ScratchImageView alloc] initWithFrame:CGRectMake(ticketScratchPos[ticketid][0], ticketScratchPos[ticketid][1], scratch_under.frame.size.width, scratch_under.frame.size.height) image:[UIImage imageNamed:[NSString stringWithFormat:@"scratcharea%d_cover.png", ticketid+1]]];
    [iv setUserInteractionEnabled:YES];
    [iv setScratchImageFilledDelegate:self];
    [backgroundView addSubview:iv];
    
    creditsLabel = [[UICountingLabel alloc] initWithFrame:CGRectMake(293, 8, 200, 25)];
    [creditsLabel setText:[NSString stringWithFormat:@"%d", mCredit]];
    [creditsLabel setStrokeColor:[UIColor blackColor]];
    [creditsLabel setOutersize:2];
    [creditsLabel setInnersize:0];
    [creditsLabel setBackgroundColor:[UIColor clearColor]];
    [creditsLabel setFont:[UIFont fontWithName:@"NeoSansPro-BoldItalic" size:13]];
    [creditsLabel setTextColor:[UIColor whiteColor]];
    [backgroundView addSubview:creditsLabel];
    
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
    [level setText:[NSString stringWithFormat:@"%d", mLevel]];
    [level setTextColor:[UIColor whiteColor]];
    [level setTextAlignment:NSTextAlignmentCenter];
    [lp addSubview:level];
    
    BButton *btnSettings = [BButton awesomeButtonWithOnlyIcon:FAIconCog color:[UIColor colorWithRed:28.0/255.0 green:113.0/255.0 blue:255.0/255.0 alpha:1.0]];
    [btnSettings setFrame:CGRectMake(480, 2, 40, 28)];
    [btnSettings addTarget:delegate action:@selector(options:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:btnSettings];
    
    match3 = [[NSMutableArray alloc] initWithCapacity:6];
    
    bIsWinner = NO;
    
    /* Generate Random Table to Decide Winner or Loser */
    NSMutableArray *winTable = [[NSMutableArray alloc] initWithCapacity:2000];
    for(int i=0; i<2000;i++)
        [winTable addObject:[NSNumber numberWithInt:0]];
    
    int numspots = (int)2000.0f*(TICKET_WIN_PERCENTAGE/100.0f);
    for(int x=0; x<numspots; x++){
        winTable[x] = [NSNumber numberWithInt:1];
    }
    
    [winTable shuffle];
    
    NSNumber *winner = [winTable objectAtIndex:0];
    bIsWinner = [winner boolValue];
    /* End Generate Winner Loser */
    
#ifdef DEBUG
    //[backgroundView makeToast:[NSString stringWithFormat:@"%@", [winner integerValue]!=0?@"WINNER":@"LOSER"] duration:2.0 position:@"center"];
#endif
    
    int maxprize = ticketMaxPrize[ticketid];
    int minprize = 0;//ticketPrice[ticketid];
    minprize = minprize -1;
    
    if(minprize<=0) minprize = 0;
    
    NSMutableArray *randomTable = [[NSMutableArray alloc] initWithCapacity:2000];
    NSNumber *number = [NSNumber numberWithInt:0];
    
    DLog(@"max prize: $%d", aryDollar[maxprize-1]);
    
    if([winner integerValue]!=0){ //WINNER
        
        DLog(@"WINNER");
        
        for(int i=0; i<2000;i++)
            [randomTable addObject:[NSNumber numberWithInt:-1]];
        
        float fJackpotInc = 0.0f;
        if(bMoreJackpotsEnabled)
            fJackpotInc = MORE_JACKPOT_INCREASE;
        int spot = 0;
        
        for(int i=0; i<37; i++){
            int numspots = (int)2000.0f*(jackpot_percentage[i]+fJackpotInc/100.0f);
            for(int x=0; x<numspots; x++){
                randomTable[spot] = [NSNumber numberWithInt:i];
                spot++;
            }
        }
        
        [randomTable shuffle];
        
        number = [randomTable objectAtIndex:0];
        DLog(@"max prize: $%d minprize: $%d genprize: $%d", aryDollar[maxprize-1], aryDollar[minprize], aryDollar[[number integerValue]]);
        while(aryDollar[[number integerValue]]>=aryDollar[maxprize-1] || aryDollar[[number integerValue]]<aryDollar[minprize]){
            [randomTable removeObjectAtIndex:0];
            number = [randomTable objectAtIndex:0];
            DLog(@"DENY WINNER! Too Big!");
        }
    }
    else{
        DLog(@"LOSER");
    }
    
    
    if(ticketType[ticketid] == TICKET_TYPE_MATCH_3){
        DLog(@"Match 3");
        
        if([winner integerValue] != 0){
            DLog(@"WINNER");
            
            //ok so generate the proper array
            //for the selected winner
            prizebox_value = aryDollar[[number intValue]];

            for(int i=0; i<3; i++)
                [match3 addObject:[NSNumber numberWithInt:aryDollar[[number intValue]]]];
            
            for(int i=0; i<3; i++){
                int index = 0;
                NSNumber *gennumber = [NSNumber numberWithInt:aryDollar[index]];
                NSInteger occurrences = 0;
                
                do{
                    index = [Common genRandomNumber:0 to:maxprize-1];
                    gennumber = [NSNumber numberWithInt:aryDollar[index]];
                    occurrences = [[match3 indexesOfObjectsPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {return [obj isEqual:gennumber];}] count];
                    
                }while(occurrences>1);
                
                [match3 addObject:gennumber];
            }
            
            [match3 shuffle];
            //end generate array for winner
        }
        else{
            DLog(@"LOSER");
            
            for(int i=0; i<6; i++){
                
                int index = 0;
                NSNumber *gennumber = [NSNumber numberWithInt:aryDollar[index]];
                NSInteger occurrences = 0;
                
                do{
                    index = [Common genRandomNumber:0 to:maxprize-1];
                    gennumber = [NSNumber numberWithInt:aryDollar[index]];
                    occurrences = [[match3 indexesOfObjectsPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {return [obj isEqual:gennumber];}] count];

                }while(occurrences>1);
                                
                [match3 addObject:gennumber];
            }
        }
        
        
        //deal the hand on screen
        int count = 0;
        for(int i=0; i<3; i++){
            for(int j=0; j<2; j++){
                NSNumber *number = [match3 objectAtIndex:count];
                
                UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png", [number integerValue]]]];
                [imgView setFrame:CGRectMake(15+(i*85), 15+(j*70), imgView.frame.size.width, imgView.frame.size.height)];
                [scratch_under addSubview:imgView];
                //NSLog(@"%@", [NSString stringWithFormat:@"index: %d %d.png",index, aryDollar[index]]);
                count++;
            }
        }
    }
    else if(ticketType[ticketid] == TICKET_TYPE_MATCH_3_PRIZEBOX){
        DLog(@"Match 3 Prize Box");
        
        int prizeboxleft = 25;
        int prizeboxtop = 85;
        int xinc = 85;
        int yinc = 70;
        int ystart = 15;
        
        int numSymbols = 0;
        NSString *prefix = @"";
        if(ticketid == TICKET_LUCKYIRISH){
            numSymbols = 8;
            prefix = @"irish";
        }
        else if(ticketid == TICKET_EGYPTIANKING)
        {
            prefix = @"egypt";
            numSymbols = 8;
        }
        else if(ticketid == TICKET_CANDYLAND)
        {
            prefix = @"candy";
            numSymbols = 8;
            //prizeboxleft = 15;
            //prizeboxtop = 85;
            xinc /= 1.3;
            ystart = 20;

        }
        
        if([winner integerValue] != 0){
            DLog(@"WINNER");
            
            
            //pick a prize amount
            //int index = [Common genRandomNumber:0 to:36];
            UIImageView *imgPrizeBox = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png", aryDollar[[number intValue]]]]];
            [imgPrizeBox setFrame:CGRectMake(prizeboxleft, prizeboxtop, imgPrizeBox.frame.size.width, imgPrizeBox.frame.size.height)];
            [scratch_under addSubview:imgPrizeBox];
            prizebox_value = aryDollar[[number intValue]];
            
            int index = [Common genRandomNumber:0 to:numSymbols];
            for(int i=0; i<3; i++)
                [match3 addObject:[NSNumber numberWithInt:arySymbol[index]]];
            
            
            for(int i=0; i<3; i++){
                int index = 0;
                NSNumber *gennumber = [NSNumber numberWithInt:arySymbol[index]];
                NSInteger occurrences = 0;
                
                do{
                    index = [Common genRandomNumber:0 to:numSymbols];
                    gennumber = [NSNumber numberWithInt:arySymbol[index]];
                    occurrences = [[match3 indexesOfObjectsPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {return [obj isEqual:gennumber];}] count];
                    
                }while(occurrences>1);
                
                [match3 addObject:gennumber];
            }
            
            [match3 shuffle];
        }
        else{
            DLog(@"LOSER");
            
            int index = [Common genRandomNumber:0 to:36];
            UIImageView *imgPrizeBox = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png", aryDollar[index]]]];
            [imgPrizeBox setFrame:CGRectMake(prizeboxleft, prizeboxtop, imgPrizeBox.frame.size.width, imgPrizeBox.frame.size.height)];
            [scratch_under addSubview:imgPrizeBox];
            prizebox_value = aryDollar[index];
            
            for(int i=0; i<6; i++){
                
                int index = 0;
                NSNumber *gennumber = [NSNumber numberWithInt:arySymbol[index]];
                NSInteger occurrences = 0;
                
                do{
                    index = [Common genRandomNumber:0 to:numSymbols];
                    gennumber = [NSNumber numberWithInt:arySymbol[index]];
                    occurrences = [[match3 indexesOfObjectsPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {return [obj isEqual:gennumber];}] count];
                    
                }while(occurrences>1);
                
                [match3 addObject:gennumber];
            }
        }
        
        int count =0;
        for(int i=0; i<3; i++){
            for(int j=0; j<2; j++){
                NSNumber *number = [match3 objectAtIndex:count];
                UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%d.png", prefix, [number integerValue]]]];
                [imgView setFrame:CGRectMake(120+(i*xinc), ystart+(j*yinc), imgView.frame.size.width, imgView.frame.size.height)];
                [scratch_under addSubview:imgView];
                count++;
            }
        }
    }
    else if(ticketType[ticketid] == TICKET_TYPE_BLACKJACK){
        DLog(@"Blackjack");
        
        
        int cardvalue[13]={11,2,3,4,5,6,7,8,9,10,10,10,10};

        
        //dealer hand
        //0...26
        int dealertotal = [Common genRandomNumber:17 to:18];
        UIImageView *imgHand = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"num_%d.png", dealertotal]]];
        [imgHand setFrame:CGRectMake(23, 174, imgHand.frame.size.width, imgHand.frame.size.height)];
        [scratch_under addSubview:imgHand];
        
        if([winner integerValue]!=0){
            DLog(@"WINNER");
            
            prizebox_value = aryDollar[[number integerValue]];
            
            //generate 2 losers and one winner
            int hands[3][2] = {{0,0}, {0,0}, {0,0}};
            int winningindex = [Common genRandomNumber:0 to:2];
            
            DLog(@"winning index: %d", winningindex);
            
            for(int i=0; i<3; i++){
                int card1_index = [Common genRandomNumber:0 to:12];
                int card2_index = [Common genRandomNumber:0 to:12];
                
                if(i==winningindex){ //make it a winner
                    DLog(@"WINNER: %d %d", cardvalue[card1_index], cardvalue[card2_index]);
                    while((cardvalue[card1_index] + cardvalue[card2_index]) <= dealertotal || cardvalue[card1_index] + cardvalue[card2_index] > 21){
                        card1_index = [Common genRandomNumber:0 to:12];
                        card2_index = [Common genRandomNumber:0 to:12];
                        
                        DLog(@"WINNER: %d %d", cardvalue[card1_index], cardvalue[card2_index]);
                    }
                }
                else{ //make it a loser
                    while(cardvalue[card1_index] + cardvalue[card2_index] >= dealertotal){
                        card2_index = [Common genRandomNumber:0 to:12];
                    }
                }
                
                hands[i][0] = card1_index;
                hands[i][1] = card2_index;
            }
            
            //3 user hands
            for(int i=0; i<3; i++){ //3 hands
                for(int j=0; j<3; j++){ // 2 cards + prize
                    
                    
                    //int index = [Common genRandomNumber:1 to:13];
                    
                    int index = 0;
                    if(i<2) //dont proces prize
                        index = hands[j][i];
                    
                    UIImageView *imgHand = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"card_%d.png", index+1]]];
                    
                    
                    int x= 120+(i*45);
                    int y = 19+(j*74);
                    if(i==2)
                    {
                        x+=12;
                        index = [Common genRandomNumber:0 to:36];
                        if(j==winningindex)
                            imgHand = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png", aryDollar[[number intValue]]]]];
                        else
                            imgHand = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png", aryDollar[index]]]];
                    }
                    
                    [imgHand setFrame:CGRectMake(x, y, imgHand.frame.size.width, imgHand.frame.size.height)];
                    [scratch_under addSubview:imgHand];
                }
            }
        }
        else{
            DLog(@"LOSER");
            
            //generate three losers
            int hands[3][2] = {{0,0}, {0,0}, {0,0}};
            for(int i=0; i<3; i++){
                int card1_index = [Common genRandomNumber:0 to:12];
                int card2_index = [Common genRandomNumber:0 to:12];
                
                while(cardvalue[card1_index] + cardvalue[card2_index] >= dealertotal){
                    card2_index = [Common genRandomNumber:0 to:12];
                }
                
                hands[i][0] = card1_index;
                hands[i][1] = card2_index;
            }
            
            
            //3 user hands
            for(int i=0; i<3; i++){ //3 hands
                for(int j=0; j<3; j++){ // 2 cards + prize
                    
                    
                    //int index = [Common genRandomNumber:1 to:13];
                    
                    int index = 0;
                    if(i<2) //dont process prize
                        index = hands[j][i];
                    
                    UIImageView *imgHand = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"card_%d.png", index+1]]];
                    
                    
                    int x= 120+(i*45);
                    int y = 19+(j*74);
                    if(i==2)
                    {
                        x+=12;
                        index = [Common genRandomNumber:0 to:36];
                        imgHand = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png", aryDollar[index]]]];
                    }
                    
                    [imgHand setFrame:CGRectMake(x, y, imgHand.frame.size.width, imgHand.frame.size.height)];
                    [scratch_under addSubview:imgHand];
                }
            }
        }
    }
    else if(ticketType[ticketid] == TICKET_TYPE_POKER){
        DLog(@"Poker");

        int deck[52];
        init_deck(deck);
        
        //deal hand to dealer that will lose so high card
        int dealerhand[5] = {deck[0],deck[13],deck[11],deck[24],deck[37]};
        int userhand1[5] = {deck[0],deck[13],deck[11],deck[24],deck[37]};
        int userhand2[5] = {deck[0],deck[13],deck[11],deck[24],deck[37]};
        
        do{
            shuffle_deck(deck);
            for(int i=0; i<5; i++){
                dealerhand[i] = deck[i];
            }
        }while(hand_rank(eval_5hand(dealerhand)) < FLUSH || hand_rank(eval_5hand(dealerhand)) > ONE_PAIR);
        
        int r = eval_5hand(dealerhand);
        int hr = hand_rank(r);
        DLog(@"dealer eval: %@", [NSString stringWithUTF8String:value_str[hr]]);
        print_hand(dealerhand, 5);

        
        for(int i=0; i<5; i++){
            int currentcard[1] = {dealerhand[i]};
            char cardstring[2];
            getCardString(cardstring, currentcard, 1);
            
            Card* c = [[Card alloc] initWithCardString:[NSString stringWithFormat:@"%@", [NSString stringWithUTF8String:cardstring]]];
            //DLog(@"%@", [NSString stringWithFormat:@"%d%@.png", [c getFace]+1, [c getSuitAbbrev]]);
            
            UIImageView *imgCard = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d%@.png", [c getFace]+1, [c getSuitAbbrev]]]];
            [imgCard setFrame:CGRectMake(68+(i*38), 25, imgCard.frame.size.width, imgCard.frame.size.height)];
            [scratch_under addSubview:imgCard];
        }
        
    
        if([winner integerValue]!=0){
            DLog(@"WINNER");
            //now deal a winner to the user
            do{
                shuffle_deck(deck);
                for(int i=0; i<5; i++){
                    userhand1[i] = deck[i];
                }
            }while(eval_5hand(userhand1) > eval_5hand(dealerhand) );
        }
        else{
            DLog(@"LOSER");
            
            //now deal a loser to the user
            do{
                shuffle_deck(deck);
                for(int i=0; i<5; i++){
                    userhand1[i] = deck[i];
                }
            }while(eval_5hand(userhand1) < eval_5hand(dealerhand) );
        }
    
        r = eval_5hand(userhand1);
        hr = hand_rank(r);
        DLog(@"user hand 1: %@", [NSString stringWithUTF8String:value_str[hr]]);
        print_hand(userhand1, 5);
        
        int pos1 = 107;
        int pos2 = 177;
        
        if(arc4random()%2==0){
            pos1 = 177;
            pos2 = 107;
        }
        
        for(int i=0; i<5; i++){
            int currentcard[1] = {userhand1[i]};
            char cardstring[2];
            getCardString(cardstring, currentcard, 1);
            
            Card* c = [[Card alloc] initWithCardString:[NSString stringWithFormat:@"%@", [NSString stringWithUTF8String:cardstring]]];
            //DLog(@"%@", [NSString stringWithFormat:@"%d%@.png", [c getFace]+1, [c getSuitAbbrev]]);
            
            UIImageView *imgCard = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d%@.png", [c getFace]+1, [c getSuitAbbrev]]]];
            [imgCard setFrame:CGRectMake(28+(i*38), pos1, imgCard.frame.size.width, imgCard.frame.size.height)];
            [scratch_under addSubview:imgCard];
        }
        
        
        //pick a prize amount
        int index = [Common genRandomNumber:0 to:36];
        prizebox_value = aryDollar[[number intValue]];
                                   
        UIImageView *imgPrizeBox = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png", aryDollar[[number intValue]]]]];
        [imgPrizeBox setFrame:CGRectMake(218, pos1, imgPrizeBox.frame.size.width, imgPrizeBox.frame.size.height)];
        [scratch_under addSubview:imgPrizeBox];
        
        //now deal a loser to the user
        do{
            shuffle_deck(deck);
            for(int i=0; i<5; i++){
                userhand2[i] = deck[i];
            }
        }while(eval_5hand(userhand2) < eval_5hand(dealerhand));
        
        r = eval_5hand(userhand2);
        hr = hand_rank(r);
        DLog(@"eval: %@", [NSString stringWithUTF8String:value_str[hr]]);
        print_hand(userhand2, 5);
        
        
        for(int i=0; i<5; i++){
            int currentcard[1] = {userhand2[i]};
            char cardstring[2];
            getCardString(cardstring, currentcard, 1);
            
            Card* c = [[Card alloc] initWithCardString:[NSString stringWithFormat:@"%@", [NSString stringWithUTF8String:cardstring]]];
            //DLog(@"%@", [NSString stringWithFormat:@"%d%@.png", [c getFace]+1, [c getSuitAbbrev]]);
            
            UIImageView *imgCard = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d%@.png", [c getFace]+1, [c getSuitAbbrev]]]];
            [imgCard setFrame:CGRectMake(28+(i*38), pos2, imgCard.frame.size.width, imgCard.frame.size.height)];
            [scratch_under addSubview:imgCard];
        }
        
        
        //pick a prize amount
        index = [Common genRandomNumber:0 to:36];
        imgPrizeBox = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png", aryDollar[index]]]];
        [imgPrizeBox setFrame:CGRectMake(218, pos2, imgPrizeBox.frame.size.width, imgPrizeBox.frame.size.height)];
        [scratch_under addSubview:imgPrizeBox];
        
    }
    else if(ticketType[ticketid] == TICKET_TYPE_SUM_PRIZEBOX){
        DLog(@"SUM Prizebox");
    }
    else if(ticketType[ticketid] == TICKET_TYPE_NUMBERS){
        DLog(@"Numbers");
        NSMutableArray *numbers = [[NSMutableArray alloc] initWithCapacity:40];
        for(int i=0; i<40; i++)
            [numbers addObject:[NSNumber numberWithInt:i+1]];
        
        [numbers shuffle];
        
        int luckynumbers[4] = {0,0,0,0};
        for(int i=0; i<4; i++) {
            luckynumbers[i] = [[numbers objectAtIndex:0] integerValue];
            [numbers removeObjectAtIndex:0];
            
            UIImageView *imgNumber = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"num_%d.png", luckynumbers[i]]]];
            [imgNumber setFrame:CGRectMake(180+(i*48), 10, imgNumber.frame.size.width, imgNumber.frame.size.height)];
            [scratch_under addSubview:imgNumber];
        }
        
        int mynumbers[12] = {0,0,0,0,0,0,0,0,0,0,0,0};
        [numbers removeAllObjects];
        
        for(int i=0; i<40; i++)
            [numbers addObject:[NSNumber numberWithInt:i+1]];
        
        [numbers shuffle];
        
        int winningindex = arc4random()%12;
        
        int index = 0;
        for(int i=0; i<2; i++){
            for(int j=0; j<6; j++){
                
                
                do{
                    mynumbers[index] = [[numbers objectAtIndex:0] integerValue];
                    [numbers removeObjectAtIndex:0];
                }while(mynumbers[index]==luckynumbers[0] ||
                       mynumbers[index]==luckynumbers[1] ||
                       mynumbers[index]==luckynumbers[2] ||
                       mynumbers[index]==luckynumbers[3]);
                
                
                DLog(@"winningspot: %d index: %d", winningindex, index );
                
                int dollarindex = [Common genRandomNumber:0 to:36];
                if([winner integerValue]!=0 && winningindex==index){
                    int lnindex = arc4random()%4;
                    mynumbers[index] = luckynumbers[lnindex];
                    dollarindex = [number integerValue];
                    prizebox_value = aryDollar[dollarindex];
                    DLog(@"winning number: %d winningspot: %d", luckynumbers[lnindex], winningindex );
                }
                
                
                UIImageView *imgNumber = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"num_%d.png", mynumbers[index]]]];
                [imgNumber setFrame:CGRectMake(10+(j*67), 65+(82*i), imgNumber.frame.size.width, imgNumber.frame.size.height)];
                [scratch_under addSubview:imgNumber];
                
                
                UIImageView *imgPrize = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png", aryDollar[dollarindex]]]];
                [imgPrize setFrame:CGRectMake(10+(j*67), 100+(82*i), imgPrize.frame.size.width, imgPrize.frame.size.height)];
                [scratch_under addSubview:imgPrize];
                
                index++;
            }
        }
    }
    else if(ticketType[ticketid] == TICKET_TYPE_NUMBERS_PRIZEBOX){
        DLog(@"Numbers Prizebox");
        
        int dollarindex = [Common genRandomNumber:0 to:36];
        if([winner integerValue]!=0)
            dollarindex = [number integerValue];
        
        UIImageView *imgPrizeBox = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png", aryDollar[dollarindex]]]];
        [imgPrizeBox setFrame:CGRectMake(158, 19, imgPrizeBox.frame.size.width, imgPrizeBox.frame.size.height)];
        [scratch_under addSubview:imgPrizeBox];
        
        
        NSMutableArray *numbers = [[NSMutableArray alloc] initWithCapacity:40];
        for(int i=0; i<40; i++)
            [numbers addObject:[NSNumber numberWithInt:i+1]];
        
        [numbers shuffle];
        
        int luckynumbers[4] = {0,0,0,0};
        for(int i=0; i<4; i++) {
            luckynumbers[i] = [[numbers objectAtIndex:0] integerValue];
            [numbers removeObjectAtIndex:0];
            
            UIImageView *imgNumber = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"num_%d.png", luckynumbers[i]]]];
            [imgNumber setFrame:CGRectMake(223+(i*48), 15, imgNumber.frame.size.width, imgNumber.frame.size.height)];
            [scratch_under addSubview:imgNumber];
        }
        
        int mynumbers[12] = {0,0,0,0,0,0,0,0,0,0,0,0};
        [numbers removeAllObjects];
        
        for(int i=0; i<40; i++)
            [numbers addObject:[NSNumber numberWithInt:i+1]];
        
        [numbers shuffle];
        
        
        int winningindex = arc4random()%12;
        
        int index = 0;
        
        for(int i=0; i<2; i++){
            for(int j=0; j<6; j++){
                
                do{
                    mynumbers[index] = [[numbers objectAtIndex:0] integerValue];
                    [numbers removeObjectAtIndex:0];
                }while(mynumbers[index]==luckynumbers[0] ||
                       mynumbers[index]==luckynumbers[1] ||
                       mynumbers[index]==luckynumbers[2] ||
                       mynumbers[index]==luckynumbers[3]);
                
                
                DLog(@"winningspot: %d index: %d", winningindex, index );
                
                if([winner integerValue]!=0 && winningindex==index){
                    int lnindex = arc4random()%4;
                    mynumbers[index] = luckynumbers[lnindex];
                    prizebox_value = aryDollar[dollarindex];
                    DLog(@"winning number: %d winningspot: %d", luckynumbers[lnindex], winningindex );
                }
                
                
                UIImageView *imgNumber = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"num_%d.png", mynumbers[index]]]];
                [imgNumber setFrame:CGRectMake(10+(j*68), 65+(44*i), imgNumber.frame.size.width, imgNumber.frame.size.height)];
                [scratch_under addSubview:imgNumber];
                
                index++;
            }
        }
    }
    
    [self.view addSubview:backgroundView];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UIView *subview = [backgroundView hitTest:[[touches anyObject] locationInView:backgroundView] withEvent:nil];
    //DLog(@"moving background");
    if(subview == iv){
        [iv touchesMoved:touches withEvent:event];
        
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
