//
//  SFSFireworksScreen.m
//  lottoticketvip
//
//  Created by Greg Ellis on 2013-07-30.
//  Copyright (c) 2013 ellis. All rights reserved.
//

#import "SFSFireworksScreen.h"

@implementation SFSFireworksScreen {
    __weak CAEmitterLayer *_confettiEmitter;
    CGFloat _decayAmount;
}


- (id)initWithFrame:(CGRect)frame {
    
    if ((self = [super initWithFrame:frame])) {
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    // Cells spawn in the bottom, moving up
	CAEmitterLayer *fireworksEmitter = (CAEmitterLayer*)self.layer;
    CGRect viewBounds = self.bounds;
	fireworksEmitter.emitterPosition = CGPointMake(viewBounds.size.width/2.0, viewBounds.size.height);
	fireworksEmitter.emitterSize	= CGSizeMake(viewBounds.size.width/2.0, 0.0);
	fireworksEmitter.emitterMode	= kCAEmitterLayerOutline;
	fireworksEmitter.emitterShape	= kCAEmitterLayerLine;
	fireworksEmitter.renderMode		= kCAEmitterLayerAdditive;
	fireworksEmitter.seed = (arc4random()%100)+1;
        
        fireworksEmitter.emitterPosition = CGPointMake(self.bounds.size.width/2, 0);
        fireworksEmitter.emitterSize = self.bounds.size;
	
	// Create the rocket
	CAEmitterCell* rocket = [CAEmitterCell emitterCell];
	
	rocket.birthRate		= 5.0;
	rocket.emissionRange	= 0.25 * M_PI;  // some variation in angle
	rocket.velocity			= 380;
	rocket.velocityRange	= 100;
	rocket.yAcceleration	= 75;
	rocket.lifetime			= 1.02;	// we cannot set the birthrate < 1.0 for the burst
	
	rocket.contents			= (id) [[UIImage imageNamed:@"DazRing"] CGImage];
	rocket.scale			= 0.2;
	rocket.color			= [[UIColor redColor] CGColor];
	rocket.greenRange		= 1.0;		// different colors
	rocket.redRange			= 1.0;
	rocket.blueRange		= 1.0;
	rocket.spinRange		= M_PI;		// slow spin
	
    
	
	// the burst object cannot be seen, but will spawn the sparks
	// we change the color here, since the sparks inherit its value
	CAEmitterCell* burst = [CAEmitterCell emitterCell];
	
	burst.birthRate			= 5.0;		// at the end of travel
	burst.velocity			= 0;
	burst.scale				= 2.5;
	burst.redSpeed			=-1.5;		// shifting
	burst.blueSpeed			=+1.5;		// shifting
	burst.greenSpeed		=+1.0;		// shifting
	burst.lifetime			= 0.35;
	
	// and finally, the sparks
	CAEmitterCell* spark = [CAEmitterCell emitterCell];
	
	spark.birthRate			= 400;
	spark.velocity			= 125;
	spark.emissionRange		= 2* M_PI;	// 360 deg
	spark.yAcceleration		= 75;		// gravity
	spark.lifetime			= 3;
    
	spark.contents			= (id) [[UIImage imageNamed:@"DazStarOutline"] CGImage];
	spark.scaleSpeed		=-0.2;
	spark.greenSpeed		=-0.1;
	spark.redSpeed			= 0.4;
	spark.blueSpeed			=-0.1;
	spark.alphaSpeed		=-0.25;
	spark.spin				= 2* M_PI;
	spark.spinRange			= 2* M_PI;
	
	// putting it together
	fireworksEmitter.emitterCells	= [NSArray arrayWithObject:rocket];
	rocket.emitterCells				= [NSArray arrayWithObject:burst];
	burst.emitterCells				= [NSArray arrayWithObject:spark];

    
}

return self;
}

+ (Class) layerClass {
    return [CAEmitterLayer class];
}

static NSTimeInterval const kDecayStepInterval = 0.1;
- (void) decayStep {
    _confettiEmitter.birthRate -=_decayAmount;
    if (_confettiEmitter.birthRate < 0) {
        _confettiEmitter.birthRate = 0;
    } else {
        [self performSelector:@selector(decayStep) withObject:nil afterDelay:kDecayStepInterval];
    }
}

- (void) decayOverTime:(NSTimeInterval)interval {
    _decayAmount = (CGFloat) (_confettiEmitter.birthRate /  (interval / kDecayStepInterval));
    [self decayStep];
}

- (void) stopEmitting {
    _confettiEmitter.birthRate = 0.0;
}

@end
