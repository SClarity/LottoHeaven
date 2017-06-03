//
//  SFSConfettiScreen.h
//  lottoticketvip
//
//  Created by Greg Ellis on 2013-07-25.
//  Copyright (c) 2013 ellis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface SFSConfettiScreen : UIView

@property(nonatomic, weak) CAEmitterLayer *confettiEmitter;
@property(nonatomic, assign) CGFloat decayAmount;

@end