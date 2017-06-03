//
//  GameVariables.h
//  slotsvip
//
//  Created by Greg Ellis on 2013-07-09.
//  Copyright (c) 2013 ellis. All rights reserved.
//
#import "appvariables.h"

extern int mCredit;
extern bool bSoundOn;
extern bool bNotificationsOn;
extern bool bMusicOn;
extern int mLevel;
extern int mLevelProgress;

extern bool bAdsEnabled;
extern bool bMoreJackpotsEnabled;
#define LOCKED_VIEW 99
#define CHECK_VIEW 98

#define NUM_TICKETS 11
#define MAX_LEVELPROGRESS 1000
#define LEVEL_STEP 30

extern int ticketMaxPrize[NUM_TICKETS];
extern int ticketPrice[NUM_TICKETS];
extern int ticketScratchPos[NUM_TICKETS][2];
extern int ticketType[NUM_TICKETS];
extern int ticketLockedLevel[NUM_TICKETS];

extern int aryDollar[37];
extern int arySymbol[9];

extern float jackpot_percentage[37];

static const NSString *ticketName[NUM_TICKETS] = {
    @"Las Vegas Blackjack",
    @"Farm Lotto",
    @"Gold Rush",
    @"Money Mania",
    @"Treasure Island",
    @"Holdem Poker",
    @"Wheel Bonus",
    @"Egyptian King",
    @"Lucky Irish",
    @"Fish Poker",
    @"Candy Land"};



#define HANDRANK_HIGH_CARD           1
#define HANDRANK_ONE_PAIR            2
#define HANDRANK_TWO_PAIR            3
#define HANDRANK_STRAIGHT            4
#define HANDRANK_FLUSH               5
#define HANDRANK_FULL_HOUSE          6
#define HANDRANK_FOUR_OF_A_KIND      7
#define HANDRANK_STRAIGHT_FLUSH      8
#define HANDRANK_ROYAL_FLUSH         9

#define TICKET_LASVEGASBLACKJACK    1
#define TICKET_FARMLOTTO            2
#define TICKET_GOLDRUSH             3
#define TICKET_MONEYMANIA           4
#define TICKET_TREASUREISLAND       5
#define TICKET_HOLDEMPOKER          5
#define TICKET_WHEELBONUS           6
#define TICKET_EGYPTIANKING         7
#define TICKET_LUCKYIRISH           8
#define TICKET_FISHPOKER            9
#define TICKET_CANDYLAND            10

//how often will a ticket win?
#define TICKET_WIN_PERCENTAGE    20.0

//when ticket wins what percentage of time
//will which prize be won?
#define TICKET_PRIZE_1  0
#define TICKET_PRIZE_2  1
#define TICKET_PRIZE_3  2
#define TICKET_PRIZE_4  3
#define TICKET_PRIZE_5  4
#define TICKET_PRIZE_6  5
#define TICKET_PRIZE_7  6
#define TICKET_PRIZE_8  7
#define TICKET_PRIZE_9  8
#define TICKET_PRIZE_10  9
#define TICKET_PRIZE_11  10
#define TICKET_PRIZE_12  11
#define TICKET_PRIZE_13  12
#define TICKET_PRIZE_14  13
#define TICKET_PRIZE_15  14
#define TICKET_PRIZE_16  15
#define TICKET_PRIZE_17  16
#define TICKET_PRIZE_18  17
#define TICKET_PRIZE_19  18
#define TICKET_PRIZE_20  19
#define TICKET_PRIZE_25  20
#define TICKET_PRIZE_30  21
#define TICKET_PRIZE_40  22
#define TICKET_PRIZE_50  23
#define TICKET_PRIZE_75  24
#define TICKET_PRIZE_100  25
#define TICKET_PRIZE_150  26
#define TICKET_PRIZE_200  27
#define TICKET_PRIZE_250  28
#define TICKET_PRIZE_300  29
#define TICKET_PRIZE_400  30
#define TICKET_PRIZE_500  31
#define TICKET_PRIZE_1000  32
#define TICKET_PRIZE_2000  33
#define TICKET_PRIZE_4000  34
#define TICKET_PRIZE_5000  35
#define TICKET_PRIZE_10000  36

#define TICKET_PRIZE_HIT_RATE_1  51.0
#define TICKET_PRIZE_HIT_RATE_2  26.0
#define TICKET_PRIZE_HIT_RATE_3  2.0
#define TICKET_PRIZE_HIT_RATE_4  2.0
#define TICKET_PRIZE_HIT_RATE_5  2.0
#define TICKET_PRIZE_HIT_RATE_6  2.0
#define TICKET_PRIZE_HIT_RATE_7  2.0
#define TICKET_PRIZE_HIT_RATE_8  2.0
#define TICKET_PRIZE_HIT_RATE_9  2.0
#define TICKET_PRIZE_HIT_RATE_10  0.59
#define TICKET_PRIZE_HIT_RATE_11  0.5
#define TICKET_PRIZE_HIT_RATE_12  0.5
#define TICKET_PRIZE_HIT_RATE_13  0.5
#define TICKET_PRIZE_HIT_RATE_14  0.5
#define TICKET_PRIZE_HIT_RATE_15  0.5
#define TICKET_PRIZE_HIT_RATE_16  0.5
#define TICKET_PRIZE_HIT_RATE_17  0.5
#define TICKET_PRIZE_HIT_RATE_18  0.5
#define TICKET_PRIZE_HIT_RATE_19  0.5
#define TICKET_PRIZE_HIT_RATE_20  0.5
#define TICKET_PRIZE_HIT_RATE_25  0.5
#define TICKET_PRIZE_HIT_RATE_30  0.5
#define TICKET_PRIZE_HIT_RATE_40  0.5
#define TICKET_PRIZE_HIT_RATE_50  0.5
#define TICKET_PRIZE_HIT_RATE_75  0.5
#define TICKET_PRIZE_HIT_RATE_100  0.10
#define TICKET_PRIZE_HIT_RATE_150  0.10
#define TICKET_PRIZE_HIT_RATE_200  0.10
#define TICKET_PRIZE_HIT_RATE_250  0.10
#define TICKET_PRIZE_HIT_RATE_300  0.10
#define TICKET_PRIZE_HIT_RATE_400  0.10
#define TICKET_PRIZE_HIT_RATE_500  0.10
#define TICKET_PRIZE_HIT_RATE_1000  0.05
#define TICKET_PRIZE_HIT_RATE_2000  0.05
#define TICKET_PRIZE_HIT_RATE_4000  0.05
#define TICKET_PRIZE_HIT_RATE_5000  0.05
#define TICKET_PRIZE_HIT_RATE_10000  0.01

#define TICKET_TYPE_MATCH_3                 1
#define TICKET_TYPE_MATCH_3_PRIZEBOX        2
#define TICKET_TYPE_BLACKJACK               3
#define TICKET_TYPE_POKER                   4
#define TICKET_TYPE_SUM_PRIZEBOX            5
#define TICKET_TYPE_NUMBERS                 6
#define TICKET_TYPE_7_11_21                 7
#define TICKET_TYPE_NUMBERS_PRIZEBOX        8

#define MORE_JACKPOT_INCREASE       15.0

#define STARTUP_CREDIT              50
#define KEY_PAID                    @"Paid"
#define KEY_BET                     @"Bet"
#define KEY_CREDIT                  @"Credit"
#define KEY_SOUND                   @"Sound"
#define KEY_MUSIC                   @"Music"
#define KEY_NOTIFICATIONS           @"Notifications"
#define KEY_ADSENABLED              @"AdsEnabled"
#define KEY_MOREJACKPOTSENABLED  	@"MoreJackpotsEnabled"
#define KEY_LEVEL                   @"Level"
#define KEY_LEVELPROGRESS           @"LevelProgress"

