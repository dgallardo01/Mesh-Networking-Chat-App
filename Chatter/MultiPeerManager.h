//
//  MultiPeerManager.h
//  Chatter
//
//  Created by Danny on 4/15/14.
//  Copyright (c) 2014 Danny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface MultiPeerManager : NSObject <MCSessionDelegate>

@property (strong, nonatomic)MCBrowserViewController *browser;
@property (strong, nonatomic)MCPeerID *peerID;
@property (strong, nonatomic)MCSession *session;
@property (strong, nonatomic)MCAdvertiserAssistant *advertiserAssistant;

-(instancetype)init;
-(void)setupMultipeerBrowser;
-(void)setupPeerAndSessionWithDisplayName:(NSString *)displayName;
-(void) advertiseSelf:(BOOL)shouldAdvertise;
-(MCPeerID *)getPeerID;




@end
