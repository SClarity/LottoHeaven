//
//  KSLabel.m
//
//  Created by Greg Ellis
//  Copyright (c) 2012 VigorousCoding.com. All rights reserved.
//

#import "KSLabel.h"

@implementation KSLabel
@synthesize strokeColor, innerStrokeColor, outterStrokeColor;
@synthesize outersize, innersize;

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
	
	if (self) {
		self.backgroundColor = [UIColor clearColor];
        self.strokeColor = [UIColor blackColor];
        self.innerStrokeColor = self.outterStrokeColor = self.strokeColor;
        self.outersize = 4;
        self.innersize = 2;
    }
    
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
	CGSize shadowOffset = self.shadowOffset;
    UIColor *textColor = self.textColor;
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(c, self.outersize);
    CGContextSetLineJoin(c, kCGLineJoinRound);
    
    CGContextSetTextDrawingMode(c, kCGTextStroke);
    self.textColor = self.outterStrokeColor;
    [super drawTextInRect:rect];
    
    CGContextSetLineWidth(c, self.innersize);
    CGContextSetLineJoin(c, kCGLineJoinRound);
    
    CGContextSetTextDrawingMode(c, kCGTextStroke);
    self.textColor = self.innerStrokeColor;
    [super drawTextInRect:rect];
    
    CGContextSetTextDrawingMode(c, kCGTextFill);
    self.textColor = textColor;
    self.shadowOffset = CGSizeMake(0, 0);
    [super drawTextInRect:rect];
    
    self.shadowOffset = shadowOffset;
    
}
@end
