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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Browse" style:UIBarButtonItemStylePlain target:self action:nil];
    
    //Call datastore
    EncounterDataStore *dataStore = [EncounterDataStore sharedInstance];
    NSLog(@"%@",[dataStore getUserNameAtIndex:0]);
    NSLog(@"%d",[dataStore count]);

    UIImage *gearIcon = [UIImage imageNamed:@"settings-25"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:gearIcon style:UIBarButtonItemStylePlain target:self action:nil];
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




@end
