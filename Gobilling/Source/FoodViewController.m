
#import "FoodViewController.h"

#import "DNFoodCategory.h"
#import "DNFood.h"
#import "DATAStack.h"
#import "DATASource.h"

#import "NSString+ANDYSizes.h"
#import "UIFont+DNStyle.h"

static NSString * const FoodTableViewCellIdentifier = @"FoodTableViewCellIdentifier";
static const CGFloat FoodTableViewCellHeight = 70.0;
static const CGFloat FoodTableViewCellOffset = 40.0;

@interface FoodViewController ()

@property (nonatomic, weak) DNFoodCategory *foodCategory;
@property (nonatomic, weak) DATAStack *dataStack;
@property (nonatomic) DATASource *dataSource;

@end

@implementation FoodViewController

#pragma mark - Initializers

- (instancetype)initWithFoodCategory:(DNFoodCategory *)foodCategory andDataStack:(DATAStack *)dataStack
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (!self) return nil;

    _foodCategory  = foodCategory;
    _dataStack = dataStack;

    return self;
}


#pragma mark - Getters

- (DATASource *)dataSource
{
   
    if (_dataSource) return _dataSource;

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Food"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                              ascending:YES]];
    
    
    request.predicate = [NSPredicate predicateWithFormat:@"cat = %@", self.foodCategory.remoteID];

    _dataSource = [[DATASource alloc] initWithTableView:self.tableView
                                           fetchRequest:request
                                         cellIdentifier:FoodTableViewCellIdentifier
                                            mainContext:self.dataStack.mainContext
                                          configuration:^(UITableViewCell *cell,
                                                          DNFood *food,
                                                          NSIndexPath *indexPath) {
                                              
                                              cell.textLabel.text = food.name;
                                              cell.textLabel.font = [UIFont foodFont];
                                              cell.textLabel.numberOfLines = 0;
                                              
                                          }];

    return _dataSource;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = self.foodCategory.name;
    self.tableView.dataSource = self.dataSource;
    self.tableView.rowHeight = FoodTableViewCellHeight;
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:FoodTableViewCellIdentifier];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DNFood *food = [self.dataSource.fetchedResultsController objectAtIndexPath:indexPath];
    return [food.name heightUsingFont:[UIFont foodFont]
                                andWidth:[[UIScreen mainScreen] bounds].size.width] + FoodTableViewCellOffset;
}

@end
