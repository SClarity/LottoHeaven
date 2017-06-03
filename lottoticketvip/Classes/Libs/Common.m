//
//  Common.m
//  expensegenie
//
//  Created by Greg Ellis on 2013-05-28.
//  Copyright (c) 2013 ellis. All rights reserved.
//

#import "Common.h"

@implementation Common

+(void)cancelAllLocalNotifications{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

+(void)scheduleLocalNotification:(NSDate*)date message:(NSString*)message{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay: 3];
    [components setMonth: 7];
    [components setYear: 2013];
    [components setHour:17];
    [components setMinute: 0];
    [components setSecond: 0];
    [calendar setTimeZone: [NSTimeZone defaultTimeZone]];
    NSDate *dateToFire = [calendar dateFromComponents:components];
    
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = dateToFire;
    localNotification.alertBody = message;
    localNotification.alertAction = @"get your free credits";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.applicationIconBadgeNumber = 1;
    localNotification.repeatInterval = NSDayCalendarUnit;
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

- (UIImage *)createBlankMaskForImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    CGContextRef context = CGBitmapContextCreate (NULL, image.size.width, image.size.height,
                                                  8, 0, colorSpace, kCGImageAlphaNone);
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 0.0); // don't use alpha
    CGContextFillRect(context, CGRectMake(0.0, 0.0, image.size.width, image.size.height));
    CGImageRef imageref = CGBitmapContextCreateImage(context);
    UIImage *result = [UIImage imageWithCGImage:imageref];
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CFRelease(imageref);
    
    return result;
}

// the following came from http://mobiledevelopertips.com/cocoa/how-to-mask-an-image.html

- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage
{
    CGImageRef maskRef = maskImage.CGImage;
    
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef masked = CGImageCreateWithMask([image CGImage], mask);
    
    UIImage *result = [UIImage imageWithCGImage:masked];
    
    CGImageRelease(masked);
    CGImageRelease(mask);
    
    return result;
}

+(NSString*) convertToCurrency:(double)amount withSymbol:(NSString*)symbol{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSString *groupingSeparator = [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator];
    [formatter setGroupingSeparator:groupingSeparator];
    [formatter setCurrencySymbol:symbol];
    [formatter setMaximumFractionDigits:2];
    [formatter setUsesGroupingSeparator:YES];
    
    NSString *formattedString = [formatter stringFromNumber:[NSDecimalNumber numberWithDouble:amount]];
    return formattedString;
}

+(NSString*) convertToCurrency:(double)amount{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSString *groupingSeparator = [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator];
    [formatter setGroupingSeparator:groupingSeparator];
    [formatter setCurrencySymbol:@"$"];
    [formatter setMaximumFractionDigits:2];
    [formatter setUsesGroupingSeparator:YES];
    
    NSString *formattedString = [formatter stringFromNumber:[NSDecimalNumber numberWithDouble:amount]];
    return formattedString;
}

+(UIColor*)makeColorWithRed:(int)red green:(int)green blue:(int)blue alpha:(float)alpha{
    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha];
}

+(UIColor*)makeColorWithRed:(int)red green:(int)green blue:(int)blue{
    return [self makeColorWithRed:red green:green blue:blue alpha:1.0];
}

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *noHashString = [stringToConvert stringByReplacingOccurrencesOfString:@"#" withString:@""]; // remove the #
    NSScanner *scanner = [NSScanner scannerWithString:noHashString];
    [scanner setCharactersToBeSkipped:[NSCharacterSet symbolCharacterSet]]; // remove + and $
    
    unsigned hex;
    if (![scanner scanHexInt:&hex]) return nil;
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:1.0f];
}

+(void) showAlert:(NSString *)title message:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [alert show];
}

+(UIButton*)makeButton:(NSString*)strImage left:(int)left top:(int)top action:(SEL)action delegate:(id)delegate{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *imgButton = [UIImage imageNamed:strImage];
    [button setBackgroundImage:imgButton forState:UIControlStateNormal];
    button.frame = CGRectMake(left, top, imgButton.size.width, imgButton.size.height);
    [button addTarget:delegate action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

+(UIButton*)makeInvisibleButton:(int)left top:(int)top width:(int)width height:(int)height action:(SEL)action delegate:(id)delegate{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame = CGRectMake(left, top, width, height);
    [button addTarget:delegate action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

+(UIImageView*)makeImage:(NSString*)strImage left:(int)left top:(int)top{
    UIImage *imgImage = [UIImage imageNamed:strImage];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:imgImage];
    imageView.frame = CGRectMake(left, top, imgImage.size.width, imgImage.size.height);
    return imageView;
}

+(NSString *) genRandomStringLength: (int) len
{
    NSString *letters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++)
        [randomString appendFormat: @"%c", [letters characterAtIndex: rand()%[letters length]]];
    
    return randomString;
}

+(int)genRandomNumber:(int)from to:(int)to{
    return (int)from + arc4random() % (to-from+1);
}

+(BOOL) isEmpty:(id)thing{
    return thing == nil
    || [thing isKindOfClass:[NSNull class]]
    || ([thing respondsToSelector:@selector(length)]
        && [(NSData *)thing length] == 0)
    || ([thing respondsToSelector:@selector(count)]
        && [(NSArray *)thing count] == 0);
}

+(NSString*)dateToString:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	NSString *currentdate = [dateFormatter stringFromDate:date];
    return currentdate;
}

+(NSDate *)dateFromString:(NSString*)strDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [[NSDate alloc] init];
    date = [dateFormatter dateFromString:strDate];
    return date;
}

+(NSString*)dateTimeToString:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString *currentdate = [dateFormatter stringFromDate:date];
    return currentdate;
}

+(NSDate *)dateTimeFromString:(NSString*)strDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [[NSDate alloc] init];
    date = [dateFormatter dateFromString:strDate];
    return date;
}

+(NSString*)dateToTimeString:(NSDate*)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"HH:mm:ss"];
	NSString *currentdate = [dateFormatter stringFromDate:date];
    return currentdate;
}

+(NSDate *)getFirstDayOfTheWeekFromDate:(NSDate *)givenDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // Find Sunday for the given date
    NSDateComponents *components = [calendar components:NSYearForWeekOfYearCalendarUnit |NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit fromDate:givenDate];
    [components setWeekday:1]; // 1 == Sunday, 7 == Saturday
    [components setWeek:[components week]];
    
    return [calendar dateFromComponents:components];
}

+(NSString *)formattedStringForDurationBetween:(NSDate*)dt1 and:(NSDate*)dt2{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlags fromDate:dt1 toDate:dt2 options:0];
    
    return [NSString stringWithFormat:@"%dy, %dd, %dh, %dm, %ds", [components year], [components day], [components hour], [components minute], [components second]];
}

+(NSDate *)addDays:(int)days toDate:(NSDate*)date{
    NSDateComponents *daycomp = [[NSDateComponents alloc] init];
    daycomp.day = days;
    return [[NSCalendar currentCalendar] dateByAddingComponents:daycomp toDate:date options:0];
}

+(NSDate *)addMonths:(int)months toDate:(NSDate*)date{
    NSDateComponents *monthcomp = [[NSDateComponents alloc] init];
    monthcomp.month = months;
    return [[NSCalendar currentCalendar] dateByAddingComponents:monthcomp toDate:date options:0];
}

+(NSDate *)addYears:(int)days toDate:(NSDate*)date{
    NSDateComponents *yearcomp = [[NSDateComponents alloc] init];
    yearcomp.year = days;
    return [[NSCalendar currentCalendar] dateByAddingComponents:yearcomp toDate:date options:0];
}

+ (BOOL) date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate {
    return (([date compare:beginDate] != NSOrderedAscending) && ([date compare:endDate] != NSOrderedDescending));
}

+(int)daysBetween:(NSDate*)dt1 and:(NSDate*)dt2{
    NSUInteger uintFlags = NSDayCalendarUnit;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:uintFlags fromDate:dt1 toDate:dt2 options:0];
    return [components day]+2;
}

+(int)yearsBetween:(NSDate*)dt1 and:(NSDate*)dt2{
    NSUInteger uintFlags = NSYearCalendarUnit;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:uintFlags fromDate:dt1 toDate:dt2 options:0];
    return [components year];
}

+(double)hoursBetween:(NSDate*)dt1 and:(NSDate*)dt2{
    NSTimeInterval distance = [dt1 timeIntervalSinceDate:dt2];
    double secondsInAnHour = 3600.0f;
    return fabs(distance / secondsInAnHour);
}

+(double)secondsBetween:(NSDate*)dt1 and:(NSDate*)dt2{
    NSTimeInterval distance = [dt1 timeIntervalSinceDate:dt2];
    return fabs(distance);
}

+(BOOL)saveImageLocally:(UIImage*)image withName:(NSString*)strImageName{
    BOOL bSuccess = YES;
    NSData* imageData = UIImagePNGRepresentation(image);
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [docsDir stringByAppendingPathComponent:strImageName];
    
    NSError *error = nil;
    [imageData writeToFile:path options:NSDataWritingAtomic error:&error];
    if(error!=nil)
        bSuccess = NO;
    
    return bSuccess;
}

+(UIImage *)urlToImage:(NSString*)url{
    UIImage *result;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    result = [UIImage imageWithData:data];
    return result;
}
@end
