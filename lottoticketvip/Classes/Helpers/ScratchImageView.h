//
//  ScratchImageView.h
//  lottoticketvip
//
//  Created by Greg Ellis on 2013-07-17.
//  Copyright (c) 2013 ellis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScratchImageView;
@protocol ScratchImageFilledDelegate
- (void)scratchImageView:(ScratchImageView *)maskView cleatPercentWasChanged:(float)clearPercent;
@end

@interface ScratchImageView : UIImageView{
    double perc;
    NSTimer *timer;
    bool bCheckFlag;
}

@property (nonatomic, readonly) double procentsOfImageMasked;
@property (nonatomic, assign) id<ScratchImageFilledDelegate> scratchImageFilledDelegate;

- (id)initWithFrame:(CGRect)frame image:(UIImage *)img;

@end
