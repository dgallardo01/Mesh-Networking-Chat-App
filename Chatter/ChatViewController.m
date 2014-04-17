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

@interface ChatViewController ()

@property (strong, nonatomic)MultiPeerManager *multipeerManager;

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
    self.title = @"chat";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Browse" style:UIBarButtonItemStylePlain target:self action:@selector(browserSetup)];
    
    //Initiate a multipeer manager
    self.multipeerManager = [[MultiPeerManager alloc]init];
    
    //Call datastore
    EncounterDataStore *dataStore = [EncounterDataStore sharedInstance];
    NSLog(@"%@",[dataStore getUserNameAtIndex:0]);
    NSLog(@"%d",[dataStore count]);
    
    //Create Gear Icon
    [self createGearButton];
    
    //Advertiser
    [self.multipeerManager setupPeerAndSessionWithDisplayName:[dataStore getUserNameAtIndex:0]];
    [self.multipeerManager advertiseSelf:YES];
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

        [self addMessage:message scrollToMessage:YES];
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:gearIcon style:UIBarButtonItemStylePlain target:self action:nil];
}

@end
