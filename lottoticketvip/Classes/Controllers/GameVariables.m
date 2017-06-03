
//
//  GameVariables.cpp
//  slotsvip
//
//  Created by Greg Ellis on 2013-07-09.
//  Copyright (c) 2013 ellis. All rights reserved.
//

#import "GameVariables.h"

int mCredit;
bool bSoundOn;
bool bAdsEnabled;
bool bMoreJackpotsEnabled;
bool bNotificationsOn;
bool bMusicOn;
int mLevel;
int mLevelProgress;

int ticketMaxPrize[NUM_TICKETS] = {5, 20, 25, 27, 28, 28, 30, 37, 37, 37, 37};

int ticketPrice[NUM_TICKETS] = {0, 1, 2, 4, 8, 10, 15, 20, 25, 30, 40};
int ticketScratchPos[NUM_TICKETS][2] = {{224,70},{260,70},{254,92},{87,78},{251,149},{233,72},{90,150},{148,147},{148,147},{233,72},{210,110}};
int ticketType[NUM_TICKETS] = {TICKET_TYPE_BLACKJACK, TICKET_TYPE_MATCH_3, TICKET_TYPE_MATCH_3, TICKET_TYPE_NUMBERS, TICKET_TYPE_MATCH_3, TICKET_TYPE_POKER, TICKET_TYPE_NUMBERS_PRIZEBOX, TICKET_TYPE_MATCH_3_PRIZEBOX, TICKET_TYPE_MATCH_3_PRIZEBOX, TICKET_TYPE_POKER, TICKET_TYPE_MATCH_3_PRIZEBOX};
int ticketLockedLevel[NUM_TICKETS] = {0,0,0,0,2,5,10,15,20,25,30};

float jackpot_percentage[37] = {TICKET_PRIZE_HIT_RATE_1,
                                TICKET_PRIZE_HIT_RATE_2,
                                TICKET_PRIZE_HIT_RATE_3,
                                TICKET_PRIZE_HIT_RATE_4,
                                TICKET_PRIZE_HIT_RATE_5,
                                TICKET_PRIZE_HIT_RATE_6,
                                TICKET_PRIZE_HIT_RATE_7,
                                TICKET_PRIZE_HIT_RATE_8,
                                TICKET_PRIZE_HIT_RATE_9,
                                TICKET_PRIZE_HIT_RATE_10,
                                TICKET_PRIZE_HIT_RATE_11,
                                TICKET_PRIZE_HIT_RATE_12,
                                TICKET_PRIZE_HIT_RATE_13,
                                TICKET_PRIZE_HIT_RATE_14,
                                TICKET_PRIZE_HIT_RATE_15,
                                TICKET_PRIZE_HIT_RATE_16,
                                TICKET_PRIZE_HIT_RATE_17,
                                TICKET_PRIZE_HIT_RATE_18,
                                TICKET_PRIZE_HIT_RATE_19,
                                TICKET_PRIZE_HIT_RATE_20,
                                TICKET_PRIZE_HIT_RATE_25,
                                TICKET_PRIZE_HIT_RATE_30,
                                TICKET_PRIZE_HIT_RATE_40,
                                TICKET_PRIZE_HIT_RATE_50,
                                TICKET_PRIZE_HIT_RATE_75,
                                TICKET_PRIZE_HIT_RATE_100,
                                TICKET_PRIZE_HIT_RATE_150,
                                TICKET_PRIZE_HIT_RATE_200,
                                TICKET_PRIZE_HIT_RATE_250,
                                TICKET_PRIZE_HIT_RATE_300,
                                TICKET_PRIZE_HIT_RATE_400,
                                TICKET_PRIZE_HIT_RATE_500,
                                TICKET_PRIZE_HIT_RATE_1000,
                                TICKET_PRIZE_HIT_RATE_2000,
                                TICKET_PRIZE_HIT_RATE_4000,
                                TICKET_PRIZE_HIT_RATE_5000,
                                TICKET_PRIZE_HIT_RATE_10000};


int arySymbol[9] = {1,2,3,4,5,6,7,8,9};
int aryDollar[37] = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,25,30,40,50,75,100,150,200,250,300,400,500,1000,2000,4000,5000,10000};