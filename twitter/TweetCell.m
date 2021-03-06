//
//  TweetCell.m
//  twitter
//
//  Created by constanceh on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    // Instantiate and set the target-action
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
    
    // Attach the gesture recognizer to the profile image view and make sure it can receive touches (userInteraction)
    [self.profileImage addGestureRecognizer:profileTapGestureRecognizer];
    [self.profileImage setUserInteractionEnabled:YES];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)didTapFavorite:(id)sender {
    // Unfavorite
    if (self.tweet.favorited) {
        // Update the local tweet model
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        
        // Update cell UI
        NSString *favCount = [NSString stringWithFormat:@"%i", self.tweet.favoriteCount];
        [self.likeButton setTitle:favCount forState:UIControlStateNormal];
        [self.likeButton setSelected:NO];
        
        // Send a POST request to the POST favorites/create endpoint
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
             }
         }];
    
    // Favorite
    } else {
        // Update the local tweet model
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        
        // Update cell UI
        NSString *favCount = [NSString stringWithFormat:@"%i", self.tweet.favoriteCount];
        [self.likeButton setTitle:favCount forState:UIControlStateNormal];
        [self.likeButton setSelected:YES];
        
        // Send a POST request to the POST favorites/create endpoint
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
             }
         }];
    }
}

- (IBAction)didTapRetweet:(id)sender {
    // Unretweet
    if (self.tweet.retweeted) {
        // Update the local tweet model
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        
        // Update cell UI
        NSString *retweetCount = [NSString stringWithFormat:@"%i", self.tweet.retweetCount];
        [self.retweetButton setTitle:retweetCount forState:UIControlStateNormal];
        [self.retweetButton setSelected:NO];
        
        
        // Send a POST request to the POST retweets/create endpoint
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
             }
         }];
    
    // Retweet
    } else {
        // Update the local tweet model
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        
        // Update cell UI
        NSString *retweetCount = [NSString stringWithFormat:@"%i", self.tweet.retweetCount];
        [self.retweetButton setTitle:retweetCount forState:UIControlStateNormal];
        [self.retweetButton setSelected:YES];
        
        
        // Send a POST request to the POST retweets/create endpoint
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
             }
         }];
    }
}

// Gesture recognizer when user taps the profile image of a Tweet cell
- (void) didTapUserProfile:(UITapGestureRecognizer *)sender{
    // Call method delegate
    [self.delegate tweetCell:self didTap:self.tweet.user];
}

@end
