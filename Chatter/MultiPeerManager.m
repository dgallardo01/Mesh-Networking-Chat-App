//
//  MultiPeerManager.m
//  Chatter
//
//  Created by Danny on 4/15/14.
//  Copyright (c) 2014 Danny. All rights reserved.
//

#import "MultiPeerManager.h"

@interface MultiPeerManager ()


@end

@implementation MultiPeerManager

-(instancetype)init
{
    self = [super init];
    
    if(self)
    {
        _peerID = nil;
        _session = nil;
        _browser = nil;
        _advertiserAssistant = nil;
    }
    return self;
}

-(void)setupMultipeerBrowser
{
    self.browser = [[MCBrowserViewController alloc] initWithServiceType:@"chatter"
                                                                session:self.session];
}

-(void)setupPeerAndSessionWithDisplayName:(NSString *)displayName
{
    self.peerID = [[MCPeerID alloc] initWithDisplayName:displayName];
    self.session = [[MCSession alloc] initWithPeer:self.peerID];
    self.session.delegate = self;
}

-(void) advertiseSelf:(BOOL)shouldAdvertise
{
    if(shouldAdvertise)
    {
        self.advertiserAssistant = [[MCAdvertiserAssistant alloc] initWithServiceType:@"chatter"
                                                                        discoveryInfo:nil
                                                                              session:self.session];
        [self.advertiserAssistant start];
    }
    else
    {
        [self.advertiserAssistant stop];
        self.advertiserAssistant = nil;
    }
}

#pragma mark - MCSession Delegate Methods

-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    NSDictionary *dict = @{@"peerID": peerID,
                           @"state" : [NSNumber numberWithInt:state]
                           };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MCDidChangeStateNotification" object:nil userInfo:dict];
    
}

-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    NSDictionary *dict = @{@"data": data,
                           @"peerID" : peerID
                           };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MCDidReceiveDataNotification"
                                                        object:nil
                                                      userInfo:dict];
}

-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
    
}

-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
    
}

-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
    
}

#pragma mark - Access Properties


-(MCPeerID *)getPeerID
{
    return self.peerID;
}

@end
