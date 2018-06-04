#import "FoodCategoriesViewController.h"
#import "FoodViewController.h"
#import "FoodCategoryTableViewCell.h"
#import "APIClient.h"
#import "DATASource.h"
#import "DNFoodCategory.h"
#import "AppDelegate.h"


@interface FoodCategoriesViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, weak) DATAStack *dataStack;
@property (nonatomic) DATASource *dataSource;

@end

@implementation FoodCategoriesViewController


#pragma mark - Getters

- (DATASource *)dataSource
{
    if (_dataSource) return _dataSource;
    // cateId will be map to id as primaryKey, and remoteID is the filter
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FoodCategory"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"remoteID"
                                                              ascending:NO]];
    
    

    _dataSource = [[DATASource alloc] initWithTableView:self.tableView
                                           fetchRequest:request
                                         cellIdentifier:FoodCategoryTableViewCellIdentifier
                                            mainContext:self.dataStack.mainContext
                                          configuration:^(FoodCategoryTableViewCell *cell,
                                                          DNFoodCategory *foodCategory,
                                                          NSIndexPath *indexPath) {
                                              [cell updateWithFoodCategory:foodCategory];
                                          }];

    return _dataSource;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataStack = [(AppDelegate *)[[UIApplication sharedApplication] delegate] dataStack];

    [self.tableView registerClass:[FoodCategoryTableViewCell class]
           forCellReuseIdentifier:FoodCategoryTableViewCellIdentifier];
    self.tableView.dataSource = self.dataSource;
    self.tableView.rowHeight = FoodCategoryTableViewCellHeight;

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    self.title = @"Gobilling";
}


#pragma mark - UIViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - UITableViewDataSource

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DNFoodCategory *foodCategory = [self.dataSource.fetchedResultsController objectAtIndexPath:indexPath];
    FoodViewController *viewController = [[FoodViewController alloc] initWithFoodCategory:foodCategory
                                                                        andDataStack:self.dataStack];
    [self.navigationController pushViewController:viewController
                                         animated:YES];
}


@end
