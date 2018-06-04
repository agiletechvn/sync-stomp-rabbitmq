@import Foundation;
#import "DATAStack.h"

@interface APIClient : NSObject

- (void)fetchStoryUsingDataStackFromURL:(DATAStack *)dataStack andURL:(NSString*) url;

- (void)fetchStoryUsingDataStackFromData:(DATAStack *)dataStack andData:(NSData*) data;

@end
