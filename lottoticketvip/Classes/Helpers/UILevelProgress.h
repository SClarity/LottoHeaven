//
//  UILevelProgress.h
//  lottoticketvip
//
//  Created by Greg Ellis on 2013-07-30.
//  Copyright (c) 2013 ellis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILevelProgress : UIView{
    float progress ;
	UIColor *innerColor ;
	UIColor *outerColor ;
    UIColor *emptyColor ;
}

@property (nonatomic, strong) UIColor *innerColor;
@property (nonatomic, strong) UIColor *outerColor;
@property (nonatomic, strong) UIColor *emptyColor;
@property (nonatomic,assign) float progress ;

@end
