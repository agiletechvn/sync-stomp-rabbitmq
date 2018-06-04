@import UIKit;

@class DNFoodCategory;

static NSString * const FoodCategoryTableViewCellIdentifier = @"FoodCategoryTableViewCellIdentifier";
static const CGFloat FoodCategoryTableViewCellHeight = 65.0;

@interface FoodCategoryTableViewCell : UITableViewCell

- (void)updateWithFoodCategory:(DNFoodCategory *)foodCategory;

@end
