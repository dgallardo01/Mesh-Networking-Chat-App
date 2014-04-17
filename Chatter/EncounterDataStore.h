//
//  EncounterDataStore.h
//  Chatter
//
//  Created by Danny on 4/16/14.
//  Copyright (c) 2014 Danny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EncounterDataStore : NSObject

-(void) addUsername:(NSString *)username;

-(void)removeUserName;

+(EncounterDataStore *) sharedInstance;

-(NSString *)getUserNameAtIndex:(NSInteger)index;

-(NSInteger) count;

@end
