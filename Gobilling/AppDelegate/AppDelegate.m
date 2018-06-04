#import "AppDelegate.h"

#import "FoodCategoriesViewController.h"

#import "APIClient.h"
#import "UIFont+DNStyle.h"
#import "LNStompClient.h"
#import <SocketRocket/SRWebSocket.h>
#import <ReactiveCocoa/ReactiveCocoa.h>


@implementation AppDelegate

static NSString * const address_ip = @"localhost";
static NSString * const rabbit_login = @"guest";
static NSString* const rabbit_password = @"guest";

//    /exchange -- SEND to arbitrary routing keys and SUBSCRIBE to arbitrary binding patterns;
//    /queue -- SEND and SUBSCRIBE to queues managed by the STOMP gateway;
//    /amq/queue -- SEND and SUBSCRIBE to queues created outside the STOMP gateway;
//    /topic -- SEND and SUBSCRIBE to transient and durable topics, delivery mode like round robin;
//    /temp-queue/ -- create temporary queues (in reply-to headers only).


#pragma mark - Getters

// init with DATAStack instead of CoreData to alleviate better

- (DATAStack *)dataStack
{
    if (_dataStack) return _dataStack;

    _dataStack = [[DATAStack alloc] initWithModelName:@"Gobilling"];

    return _dataStack;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    [UINavigationBar appearance].barTintColor = [UIColor colorWithRed:0.2 green:0.46 blue:0.84 alpha:1];

    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                         NSFontAttributeName            : [UIFont appTitleFont]};

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    // subscribe to stomp to update data
    [self subscribeStomp];

    FoodCategoriesViewController *mainController = [[FoodCategoriesViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mainController];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];

    return YES;
}

#pragma mark - Core Data stack

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self.dataStack persistWithCompletion:nil];
}

#pragma StompServer


- (void) subscribeStomp {
    NSString* HYPBaseURL = [[NSString alloc] initWithFormat:@"http://%@:15674/stomp", address_ip];
    
    APIClient *client = [APIClient new];
    LNStompClient* stompClient = [[LNStompClient alloc]
                   initWithURL: [NSURL URLWithString:HYPBaseURL]];
    
    // opening the STOMP client returns a raw WebSocket signal that you can subscribe to
    [[stompClient open]
     
     subscribeNext:^(id x) {
         if ([x class] == [SRWebSocket class]) {
             // First time connected to WebSocket, receiving SRWebSocket object
             //NSLog(@"web socket connected with: %@", x);
             
             [stompClient connectWithHeaders:@{
                                               kHeaderLogin: rabbit_login,
                                               kHeaderPasscode: rabbit_password
                                               }];
             
             
             // subscribe to a STOMP destination
//             NSString *destination = [NSString stringWithFormat:@"/topic/gobilling.%@", UIDevice.currentDevice.identifierForVendor.UUIDString];
             NSString *destination = @"/exchange/gobilling/sync";
             
             [[stompClient stompMessagesFromDestination:destination withHeaders:@{kHeaderPersistent : @"true"}]
              subscribeNext:^(LNStompMessage *message) {
                  NSLog(@"STOMP message received: body = %@", message.body);
                  NSData *data = [message.body dataUsingEncoding:NSUTF8StringEncoding];
                  [client fetchStoryUsingDataStackFromData: self.dataStack andData:data];
              }];
             
             
         } else if ([x isKindOfClass:[NSString class]]) {
             // Subsequent signals should be NSString
             // NSLog(@"STOMP message received: body = %@", x);
         }
     }
     error:^(NSError *error) {
         NSLog(@"web socket failed: %@", error);
     }
     completed:^{
         NSLog(@"web socket closed");
     }];
    
}

@end
