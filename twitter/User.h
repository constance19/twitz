//
//  User.h
//  twitter
//
//  Created by constanceh on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

// MARK: Properties

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *profilePicture;
@property (nonatomic, strong) NSNumber *tweetCount;
@property (nonatomic, strong) NSNumber *followerCount;
@property (nonatomic, strong) NSNumber *followingCount;
@property (nonatomic, strong) NSString *tagline;

// Create initializer
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
