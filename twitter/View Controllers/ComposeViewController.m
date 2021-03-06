//
//  ComposeViewController.m
//  twitter
//
//  Created by constanceh on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"
#import "Tweet.h"
#import "User.h"

@interface ComposeViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *composeTweet;
@property (weak, nonatomic) IBOutlet UILabel *charCount;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.composeTweet.delegate = self;
    
    // Customize compose tweet view UI
    self.composeTweet.layer.borderWidth = 1.6f;
    UIColor *twitterBlue = [UIColor colorWithRed:0.296 green:0.618 blue:0.922 alpha:1.0];
    self.composeTweet.layer.borderColor = [twitterBlue CGColor];
    self.composeTweet.clipsToBounds = YES;
    self.composeTweet.layer.cornerRadius = 8.0f;
    
    // Set initial characters left count of 140
    self.charCount.textColor = twitterBlue;
    self.charCount.text = @"140";
    
    // For replies, set beginning of text to be @mention
    if (self.isReply) {
        NSString* username = self.tweet.user.screenName;
        // Append '@' to the beginning of the retrieved username
        if (username) {
            self.composeTweet.text = [@"@" stringByAppendingString:username];
        }
    
    // For new Tweets, set placeholder text for the compose tweet box
    } else {
        self.composeTweet.text = @"What's happening?";
        self.composeTweet.textColor = [UIColor lightGrayColor];
    }
}

// Clicking cancel button in navigation bar dismisses compose view controller (goes to timeline)
- (IBAction)cancelButton:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

// Clicking Tweet button in navigation bar posts the Tweet and dismisses compose view controller (goes to timeline)
- (IBAction)tweetButton:(id)sender {
    // If user is composing a reply
    if (self.isReply) {
        [[APIManager shared]postStatusWithReply:self.tweet :self.composeTweet.text completion:^(Tweet *tweet, NSError *error) {
                if(error){
                    NSLog(@"Error composing reply: %@", error.localizedDescription);
//                    [self dismissViewControllerAnimated:true completion:nil];
                }
                else{
                    [self.delegate didTweet:tweet];
                    [self dismissViewControllerAnimated:true completion:nil];
                    NSLog(@"Compose reply Success!");
                }
            }];

    // If user is composing a new tweet (not a reply)
    } else {
        [[APIManager shared]postStatusWithText:self.composeTweet.text completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error composing Tweet: %@", error.localizedDescription);
//                [self dismissViewControllerAnimated:true completion:nil];
            }
            else{
                [self.delegate didTweet:tweet];
                [self dismissViewControllerAnimated:true completion:nil];
                NSLog(@"Compose Tweet Success!");
            }
        }];
    }
}

// Clear placeholder text when user begins editing the compose tweet box (for non-reply tweets)
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (!self.isReply) {
        if ([textView.text isEqualToString:@"What's happening?"]) {
             textView.text = @"";
             textView.textColor = [UIColor blackColor];
        }
        [textView becomeFirstResponder];
    }
}

// Set placeholder text (for non-reply tweets) if compose tweet box is empty
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (!self.isReply) {
        if ([textView.text isEqualToString:@""]) {
            textView.text = @"What's happening?";
            textView.textColor = [UIColor lightGrayColor]; //optional
        }
        [textView resignFirstResponder];
    }
}

// Displays characters left as the user types a Tweet at the bottom right corner of the compose box
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    // Set the max character limit
    int characterLimit = 140;
    
    // Construct what the new text would be if we allowed the user's latest edit
    NSString *newText = [self.composeTweet.text stringByReplacingCharactersInRange:range withString:text];
    
    // Update characters left count label. Set label text to red if characters left count < 20
    int charLeft = 140 - newText.length;
    NSString* characters = [NSString stringWithFormat:@"%i", charLeft];
    
    if (charLeft < 20) {
        self.charCount.textColor = UIColor.redColor;
    }
    self.charCount.text = characters;
    
    // Allow or disallow the new text based on the character limit
    return newText.length < characterLimit;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
