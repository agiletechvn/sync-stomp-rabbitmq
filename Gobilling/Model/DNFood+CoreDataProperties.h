//
//  DNFood+CoreDataProperties.h
//  Gobilling
//
//  Created by Thanh Tu on 11/26/15.
//  Copyright © 2015 Hyper. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DNFood.h"

NS_ASSUME_NONNULL_BEGIN

@interface DNFood (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *cat;
@property (nullable, nonatomic, retain) NSNumber *remoteID;

@end

NS_ASSUME_NONNULL_END
