

#import "APIClient.h"
#import "Sync.h"


@import UIKit;


@interface APIClient ()

@property (nonatomic, weak) DATAStack *dataStack;

@end

@implementation APIClient

- (void)fetchStoryUsingDataStackFromData:(DATAStack *)dataStack andData:(NSData*) data
{
    NSError *serializationError = nil;
    NSJSONSerialization *JSON = [NSJSONSerialization JSONObjectWithData:data
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&serializationError];
    
    if (serializationError) {
        // NSLog(@"Error serializing JSON: %@", serializationError);
    } else {
        // all from json message, id is good so it can be NSArray from JSON for id Value
        NSPredicate *predicate = nil;
        NSString *predicateString = [JSON valueForKey:@"predicate"];
        if (predicateString != nil) {
            NSArray *predicateArguments = [JSON valueForKey:@"predicate_args"];
            predicate = [NSPredicate predicateWithFormat:predicateString argumentArray:predicateArguments];
            
        }
        
        [Sync changes:[JSON valueForKey:@"data"]
        inEntityNamed: [JSON valueForKey:@"entity"]
            predicate:predicate
            dataStack:dataStack
           completion:^(NSError *error) {
               [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
           }];
    }

}

- (void)fetchStoryUsingDataStackFromURL:(DATAStack *)dataStack andURL:(NSString *)url
{
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSOperationQueue *queue = [NSOperationQueue new];
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (connectionError) {
                                   NSLog(@"There was an error: %@", [[[connectionError userInfo] objectForKey:@"error"] capitalizedString]);
                               } else {
                                   [self fetchStoryUsingDataStackFromData:dataStack andData:data];
                               }
                           }];
}

@end
