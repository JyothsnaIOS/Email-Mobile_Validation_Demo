//
//  ViewController.m
//  Signup_Demo
//
//  Created by Jenkins on 06/09/16.
//  Copyright © 2016 srinivas. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UITextField *txtuserName;

@property (strong, nonatomic) IBOutlet UITextField *txtemailID;

@property (strong, nonatomic) IBOutlet UITextField *txtMobilenum;

@property (strong, nonatomic) IBOutlet UITextField *txtPassword;

- (IBAction)saveAction:(id)sender;

- (IBAction)tapedAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *activeView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Email and Mobile no validation with MBProhressHud Alert message");
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveAction:(id)sender {
    
    [self.view endEditing:YES];
    
    if (![self validateEntries])
    {
        return;
    }

}

- (IBAction)tapedAction:(id)sender
{
    [self.txtMobilenum resignFirstResponder];
    [self.txtemailID resignFirstResponder];
    [self.txtPassword resignFirstResponder];
    [self.txtuserName resignFirstResponder];
}

- (BOOL)validateEntries
{
    BOOL goodToGo = YES;
    NSMutableString *mutableString = [[NSMutableString alloc] init];
    if (self.txtuserName.text.length == 0)
    {
        goodToGo = NO;
        [mutableString appendString:@"Name is required"];
    }
    if (self.txtemailID.text.length == 0) {
        goodToGo = NO;
        
        if (mutableString.length > 0)
        {
            [mutableString appendString:@"\nEmail Id is required"];
        }
        else
        {
            [mutableString appendString:@"Email Id is required"];
        }
        
    }
    else if (![self stringIsValidEmail:self.txtemailID.text]&&self.txtemailID.text.length!=0)
    {
        goodToGo = NO;
        if (mutableString.length > 0)
        {
            [mutableString appendString:@"\nPlease enter a valid Email Id"];
        }
        else
        {
            [mutableString appendString:@"Please enter a valid Email Id"];
        }
    }
    if (self.txtPassword.text.length == 0) {
        goodToGo = NO;
        if (mutableString.length > 0)
        {
            [mutableString appendString:@"\nPassword is required"];
        }
        else
        {
            [mutableString appendString:@"Password is required"];
        }
        
    }
    
    if (self.txtMobilenum.text.length == 0) {
        goodToGo = NO;
        if (mutableString.length > 0)
        {
            [mutableString appendString:@"\nMobile number is required"];
        }
        else
        {
            [mutableString appendString:@"Mobile number is required"];
        }
    }
    
  
    
    else if (![self mobileNumberIsValid:self.txtMobilenum.text]&&self.txtMobilenum.text.length!=0)
    {
        goodToGo = NO;
        if (mutableString.length > 0)
        {
            [mutableString appendString:@"\nPlease enter a valid mobile number"];
        }
        else
        {
            [mutableString appendString:@"Please enter a valid mobile number"];
        }
    }
    
    if (!goodToGo)
    {
       
        [self mbProgress:mutableString];
    }
    return goodToGo;
}

// Email Address validation method
-(BOOL)stringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

// Mobile Number validation Method
-(BOOL)mobileNumberIsValid:(NSString *)checkNumber
{
//    NSString *stringToBeTested = checkNumber;
//    NSString *mobileNumberPattern = @"[0-9]";
//    NSPredicate *mobileNumberPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileNumberPattern];
//    BOOL validMobileNumber = [mobileNumberPred evaluateWithObject:stringToBeTested];
//    return validMobileNumber;
    
    NSString *stringToBeTested = checkNumber;
  //  NSString *mobileNumberPattern = @"[789][0-9]{9}";
    NSString *mobileNumberPattern = @"[789][0-9]{3}([0-9]{6})?";
    NSPredicate *mobileNumberPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileNumberPattern];
    BOOL matched = [mobileNumberPred evaluateWithObject:stringToBeTested];
    
    return matched;
}


- (void)mbProgress:(NSString*)message{
    MBProgressHUD *hubHUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hubHUD.mode=MBProgressHUDModeText;
    hubHUD.detailsLabelText=message;
    hubHUD.detailsLabelFont=[UIFont systemFontOfSize:15];
    hubHUD.margin=20.f;
    hubHUD.yOffset=150.f;
    hubHUD.removeFromSuperViewOnHide = YES;
    [hubHUD hide:YES afterDelay:2];
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
    
    
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:)name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:)name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height+10, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, _activeView.frame.origin) ) {
        [self.scrollView scrollRectToVisible:_activeView.frame animated:YES];
    }
}
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets=UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}


@end
