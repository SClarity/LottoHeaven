//
//  SFSFireworksScreen.h
//  lottoticketvip
//
//  Created by Greg Ellis on 2013-07-30.
//  Copyright (c) 2013 ellis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface SFSFireworksScreen : UIView{
    
}

@property(nonatomic, weak) CAEmitterLayer *confettiEmitter;
@property(nonatomic, assign) CGFloat decayAmount;

@end
