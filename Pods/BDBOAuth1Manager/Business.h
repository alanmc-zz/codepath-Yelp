//
//  Business.h
//  Yelp
//
//  Created by Alan McConnell on 10/26/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Business : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *categories;

@property (strong, nonatomic) NSString *ratingImageURL;
@property (strong, nonatomic) NSString *thumbnailURL;

@property (assign, nonatomic) float distance;
@property (assign, nonatomic) NSInteger reviewCount;

+ (NSArray *)businessesWithDictionaries:(NSArray *)dicts;

@end
