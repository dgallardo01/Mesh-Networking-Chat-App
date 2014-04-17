//
//  ChatViewController.h
//  Chatter
//
//  Created by Danny on 4/15/14.
//  Copyright (c) 2014 Danny. All rights reserved.
//

#import "BORChatRoom.h"
#import "MultiPeerManager.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>


@interface ChatViewController : BORChatRoom <MCBrowserViewControllerDelegate>

@end
