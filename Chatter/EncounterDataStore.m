//
//  EncounterDataStore.m
//  Chatter
//
//  Created by Danny on 4/16/14.
//  Copyright (c) 2014 Danny. All rights reserved.
//

#import "EncounterDataStore.h"

@interface EncounterDataStore ()

@property(strong, nonatomic)NSMutableArray *userNames;

@end

@implementation EncounterDataStore

+(EncounterDataStore *) sharedInstance
{
    static EncounterDataStore *_sharedDataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      _sharedDataStore = [[EncounterDataStore alloc]init];
                  });
    return _sharedDataStore;
}

-(void) addUsername:(NSString *)userName
{
    self.userNames = [NSMutableArray new];
    [self.userNames addObject:userName];
}

-(void)changeUserName:(NSString *)userName
{
    [self.userNames replaceObjectAtIndex:0 withObject:userName];
}

-(void)removeUserName
{
    [self.userNames removeObject:[self.userNames lastObject]];
}

-(NSString *)getUserNameAtIndex:(NSInteger)index
{
    return [self.userNames objectAtIndex:index];
}

-(NSInteger) count
{
    return [self.userNames count];
}

@end
