
@import UIKit;

@class DNFoodCategory;
@class DATAStack;

@interface FoodViewController : UITableViewController

- (instancetype)initWithFoodCategory:(DNFoodCategory *)foodCategory
                 andDataStack:(DATAStack *)dataStack;


@end
