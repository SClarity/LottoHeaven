//
//  KSLabel.h
//
//  Created by Greg Ellis
//  Copyright (c) 2012 VigorousCoding.com. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface KSLabel : UILabel {
    UIColor *strokeColor, *innerStrokeColor, *outterStrokeColor;
    int outersize, innersize;
}

@property (nonatomic, retain) UIColor *strokeColor;
@property (nonatomic, retain) UIColor *innerStrokeColor;
@property (nonatomic, retain) UIColor *outterStrokeColor;
@property int outersize, innersize;
@end
