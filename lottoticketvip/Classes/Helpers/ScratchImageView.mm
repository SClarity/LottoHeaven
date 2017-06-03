//
//  ScratchImageView.m
//  lottoticketvip
//
//  Created by Greg Ellis on 2013-07-17.
//  Copyright (c) 2013 ellis. All rights reserved.
//

#import "ScratchImageView.h"
#import "PointTransforms.h"

enum{ radius = 30 };

@interface ScratchImageView()

- (UIImage *)addTouches:(NSSet *)touches;

@property (nonatomic) CGContextRef imageContext;
@property (nonatomic) CGColorSpaceRef colorSpace;

@end

@implementation ScratchImageView
@synthesize scratchImageFilledDelegate;
@synthesize imageContext,colorSpace;

- (void)dealloc {
    [timer invalidate];
    timer = nil;
	CGColorSpaceRelease(self.colorSpace);
	CGContextRelease(self.imageContext);
    [super dealloc];
}

float ReportAlphaPercent(CGImageRef imgRef)
{
    size_t w = CGImageGetWidth(imgRef);
    size_t h = CGImageGetHeight(imgRef);
    
    unsigned char *inImage = (unsigned char*)malloc(w * h * 4);
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

-(void)percTimer:(NSTimer*)timer{
    if(bCheckFlag)
        perc = [self procentsOfImageMasked];
}


- (id)initWithFrame:(CGRect)frame image:(UIImage *)img {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
        perc = 0.0f;
		self.userInteractionEnabled = YES;
		self.backgroundColor = [UIColor clearColor];
		self.scratchImageFilledDelegate = nil;
		
		self.image = img;
		CGSize size = self.image.size;
        //NSLog(@"start: %f, %f", size.width, size.height);
        
        float scale = [[UIScreen mainScreen] scale];
		
		// initalize bitmap context
		self.colorSpace = CGColorSpaceCreateDeviceRGB();
		self.imageContext = CGBitmapContextCreate(0,size.width*scale,size.height*scale,8,size.width*scale*4,
                                                  colorSpace,kCGImageAlphaPremultipliedLast);
		CGContextDrawImage(self.imageContext, CGRectMake(0, 0, size.width*scale, size.height*scale), self.image.CGImage);
		
		int blendMode = kCGBlendModeClear;
		CGContextSetBlendMode(self.imageContext, (CGBlendMode) blendMode);
        
        /* trying to fix scale*/
        CGContextRef ctx = self.imageContext;
        
        CGImageRef cgImage = CGBitmapContextCreateImage(ctx);
        UIImage *image = [UIImage imageWithCGImage:cgImage];
        CGImageRelease(cgImage);
        self.image = image;
		if(!timer)
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(percTimer:) userInfo:nil repeats:YES];
        
        bCheckFlag = NO;
    }
    return self;
}

#pragma mark -

- (double)procentsOfImageMasked {
    return ReportAlphaPercent(self.image.CGImage);//100.0;
}

#pragma mark - UIResponder

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    bCheckFlag = NO;
    perc = [self procentsOfImageMasked];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    bCheckFlag = YES;
	self.image = [self addTouches:touches];
    //// NSLog(@"touch");
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"imageTouchImage" object:nil];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	self.image = [self addTouches:touches];
}

#pragma mark -

- (UIImage *)addTouches:(NSSet *)touches{
    
    float scale = [[UIScreen mainScreen] scale];
	CGSize size = self.image.size;
	CGContextRef ctx = self.imageContext;
	
	CGContextSetFillColorWithColor(ctx,[UIColor clearColor].CGColor);
	CGContextSetStrokeColorWithColor(ctx,[UIColor colorWithRed:0 green:0 blue:0 alpha:0].CGColor);
	
	// process touches
	for (UITouch *touch in touches) {
		CGContextBeginPath(ctx);
		CGRect rect = {[touch locationInView:self], {scale*radius, scale*radius}};
        
		rect.origin = fromUItoQuartz(rect.origin, self.bounds.size);

		if(UITouchPhaseBegan == touch.phase){
			// on begin, we just draw ellipse
            
            //NSLog(@"bef loc: %f, %f size: %f, %f", rect.origin.x, rect.origin.y, size.width, size.height);
            
			rect.origin.y -= radius;
			rect.origin.x -= radius;
			rect.origin = scalePoint(rect.origin, self.bounds.size, size);
			
            // NSLog(@"aft loc: %f, %f size: %f, %f", rect.origin.x, rect.origin.y, size.width, size.height);
            
			CGContextAddEllipseInRect(ctx, rect);
			CGContextFillPath(ctx);
            
		} else if(UITouchPhaseMoved == touch.phase) {
			// then touch moved, we draw superior-width line
			rect.origin = scalePoint(rect.origin, self.bounds.size, size);
			CGPoint prevPoint = [touch previousLocationInView:self];
			prevPoint = fromUItoQuartz(prevPoint, self.bounds.size);
			prevPoint = scalePoint(prevPoint, self.bounds.size, size);
			
			CGContextSetStrokeColor(ctx,CGColorGetComponents([UIColor yellowColor].CGColor));
			CGContextSetLineCap(ctx, kCGLineCapRound);
			CGContextSetLineWidth(ctx, scale*radius);
			CGContextMoveToPoint(ctx, prevPoint.x, prevPoint.y);
			CGContextAddLineToPoint(ctx, rect.origin.x, rect.origin.y);
			CGContextStrokePath(ctx);
		}
	}

    //only run this every half of a second for speed.
    
    [self.scratchImageFilledDelegate scratchImageView:self cleatPercentWasChanged:perc];
	
	CGImageRef cgImage = CGBitmapContextCreateImage(ctx);
	UIImage *image = [UIImage imageWithCGImage:cgImage];
	CGImageRelease(cgImage);
	
	return image;
}


@end
