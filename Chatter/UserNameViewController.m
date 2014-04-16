//
//  UserNameViewController.m
//  Chatter
//
//  Created by Danny on 4/16/14.
//  Copyright (c) 2014 Danny. All rights reserved.
//

#import "UserNameViewController.h"
#import "ChatViewController.h"

@interface UserNameViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property(strong, nonatomic)ChatViewController *chatVC;

@end

@implementation UserNameViewController

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
    
    self.chatVC = [[ChatViewController alloc]init];

    self.userNameTextField.delegate = self;
    [self.userNameTextField becomeFirstResponder];
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.userNameTextField resignFirstResponder];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.chatVC];

    [self presentViewController:navigationController animated:YES completion:nil];
    return YES;
    
    
}


@end
