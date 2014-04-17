//
//  AppDelegate.h
//  Chatter
//
//  Created by Danny on 4/14/14.
//  Copyright (c) 2014 Danny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultiPeerManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
