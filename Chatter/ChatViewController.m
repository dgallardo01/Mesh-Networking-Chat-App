//
//  ChatViewController.m
//  Chatter
//
//  Created by Danny on 4/15/14.
//  Copyright (c) 2014 Danny. All rights reserved.
//

#import "ChatViewController.h"
#import "BORChatMessage.h"
#import "BORChatCollectionViewController.h"
#import "EncounterDataStore.h"
#import "SettingsViewController.h"
#import <FontAwesomeKit.h>

#define SquareViewX 30
#define SquareViewY 29
#define SquareViewWidth 40
#define SquareViewHeight 40
#define SquareViewAlpha .2
#define SquareViewCornerRadius 20

#define UserBrowseButtonX 0
#define UserBrowseButtonY 0
#define UserBrowseButtonWidth 100
#define UserBrowseButtonXHeight 100

#define ConnectLabelX 30
#define ConnectLabelY -11
#define ConnectLabelWidth 70
#define ConnectLabelHeight 70
#define ConnectLabelFontSize 11.0f

@interface ChatViewController ()

@property (strong, nonatomic)MultiPeerManager *multipeerManager;
@property(strong, nonatomic)EncounterDataStore *dataStore;
-(void)peerDidChangeStateWithNotification:(NSNotification *)notification;
-(void)didReceiveDataWithNotification:(NSNotification *)notification;

@end

@implementation ChatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self createUsersBrosweButton];

    [self.navigationController setNavigationBarHidden:YES];
 
    //Initiate a multipeer manager
    self.multipeerManager = [[MultiPeerManager alloc]init];
    
    //Call datastore
    self.dataStore = [EncounterDataStore sharedInstance];
    NSLog(@"%@",[self.dataStore getUserNameAtIndex:0]);
    NSLog(@"%ld",(long)[self.dataStore count]);
    
    //Advertiser
    [self.multipeerManager setupPeerAndSessionWithDisplayName:[self.dataStore getUserNameAtIndex:0]];
    [self.multipeerManager advertiseSelf:YES];
    
    //Notification of changed state
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peerDidChangeStateWithNotification:)
                                                 name:@"MCDidChangeStateNotification"
                                               object:nil];
    
    //Notification of received data
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveDataWithNotification:)
                                                 name:@"MCDidReceiveDataNotification"
                                               object:nil];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.multipeerManager.peerID = [[MCPeerID alloc]initWithDisplayName:[self.dataStore getUserNameAtIndex:0]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)sendMessage
{
    
    id <BORChatMessage> message = [[BORChatMessage alloc] init];
    message.text = self.messageTextView.text;
    message.sentByCurrentUser = YES;
    message.date = [NSDate date];
    message.senderName = [self.dataStore getUserNameAtIndex:0];
    
    [self addMessage:message scrollToMessage:YES];
    
    NSData *dataToSend = [message.text dataUsingEncoding:NSUTF8StringEncoding];
    //send message to all connected users.
    NSArray *allPeers = self.multipeerManager.session.connectedPeers;
    NSError *error;
    
    [self.multipeerManager.session sendData:dataToSend
                                    toPeers:allPeers
                                   withMode:MCSessionSendDataReliable
                                      error:&error];
    
    if (error)
    {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    [super sendMessage];
}
-(void)browserSetup
{
    [self.multipeerManager setupMultipeerBrowser];
    [self.multipeerManager.browser setDelegate:self];
    [self presentViewController:self.multipeerManager.browser animated:YES completion:nil];
}

-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) createGearButton
{
    UIImage *gearIcon = [UIImage imageNamed:@"settings-25"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:gearIcon style:UIBarButtonItemStylePlain target:self action:@selector(settings)];
}
-(void)settings
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"main" bundle:nil];
    SettingsViewController *settingsVC = [storyboard instantiateViewControllerWithIdentifier:@"settingsVC"];
    [self presentViewController:settingsVC animated:YES completion:nil];
    
}

#pragma mark - Notification Center Methods
-(void)peerDidChangeStateWithNotification:(NSNotification *)notification
{
    
}

-(void)didReceiveDataWithNotification:(NSNotification *)notification
{
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSString *peerDisplayName = peerID.displayName;
    
    NSData *receivedData = [[notification userInfo] objectForKey:@"data"];
    NSString *receivedText = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    id <BORChatMessage> message = [[BORChatMessage alloc] init];
    message.text = receivedText;
    message.senderName = peerDisplayName;
    message.date = [NSDate date];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self addMessage:message scrollToMessage:YES];
        [super sendMessage];
    });
}

-(void)createUsersBrosweButton
{
    [self createConnectLabel];

    //Created circle bounding box
    UIImageView *squareView = [[UIImageView alloc]initWithFrame:CGRectMake(SquareViewX, SquareViewY, SquareViewWidth, SquareViewHeight)];
    
    squareView.image = [UIImage imageNamed:@"chatterUsersButton.png"];
    [squareView setAlpha:SquareViewAlpha];
    squareView.layer.cornerRadius = SquareViewCornerRadius;
    squareView.layer.masksToBounds = YES;
    [self.view addSubview:squareView];
    
    //Creates users icon
    FAKFontAwesome *usersIcon = [FAKFontAwesome usersIconWithSize:20.0f];
    [usersIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    
    //Creates actual button
    UIButton *usersBrowserButton = [UIButton buttonWithType:UIButtonTypeCustom];
    usersBrowserButton.frame = CGRectMake(UserBrowseButtonX, UserBrowseButtonY, UserBrowseButtonWidth, UserBrowseButtonXHeight);
    [usersBrowserButton setBackgroundImage:[UIImage imageWithStackedIcons:@[usersIcon]imageSize:CGSizeMake(100, 100)] forState:UIControlStateNormal];
    [usersBrowserButton addTarget:self action:@selector(browserSetup) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:usersBrowserButton];
    
}

-(void)createConnectLabel{
    UILabel *connectLabel = [[UILabel alloc] initWithFrame:CGRectMake(ConnectLabelX, ConnectLabelY, ConnectLabelWidth, ConnectLabelHeight)];
    connectLabel.text = @"Connect";
    [connectLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:ConnectLabelFontSize]];
    connectLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:connectLabel];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


@end

