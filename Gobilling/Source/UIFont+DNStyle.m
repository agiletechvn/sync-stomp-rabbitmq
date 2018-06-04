#import "UIFont+DNStyle.h"

@implementation UIFont (DNStyle)

+ (UIFont *)appTitleFont
{
    return [UIFont fontWithName:@"Avenir-Medium" size:20.0f];;
}

+ (UIFont *)foodFont
{
    return [UIFont fontWithName:@"Avenir-Medium" size:14.0f];;
}

+ (UIFont *)headerFont
{
    return [UIFont fontWithName:@"Avenir-Medium" size:16.0f];;
}

+ (UIFont *)subtitleFont
{
    return [UIFont fontWithName:@"Avenir-Medium" size:13.0f];
}

+ (UIFont *)asideFont
{
    return [UIFont fontWithName:@"Avenir-Light" size:11.0f];
}

@end
