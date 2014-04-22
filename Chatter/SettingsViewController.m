//
//  SettingsViewController.m
//  Chatter
//
//  Created by Danny on 4/18/14.
//  Copyright (c) 2014 Danny. All rights reserved.
//

#import "SettingsViewController.h"
#import "EncounterDataStore.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property(strong, nonatomic)EncounterDataStore *dataStore;
@property(strong, nonatomic)MultiPeerManager *mcManager;

- (IBAction)settingsDoneButtonTapped:(id)sender;


@end

@implementation SettingsViewController

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
    self.dataStore = [EncounterDataStore sharedInstance];
    
    self.usernameTextField.delegate = self;
    
    self.usernameTextField.text = [self.dataStore getUserNameAtIndex:0];
    
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

- (IBAction)settingsDoneButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.mcManager.peerID = nil;
    self.mcManager.session = nil;
    self.mcManager.browser = nil;
    
    [self.dataStore changeUserName:self.usernameTextField.text];
    [self.mcManager setupMultipeerBrowser];
    [self.usernameTextField resignFirstResponder];
    
    return YES;
}

@end
