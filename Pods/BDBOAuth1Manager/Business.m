//
//  Business.m
//  Yelp
//
//  Created by Alan McConnell on 10/26/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "Business.h"

@implementation Business

- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        
        self.name = dict[@"name"];
        self.thumbnailURL = dict[@"image_url"];
        self.ratingImageURL = dict[@"rating_img_url_large"];
        
        self.distance = [dict[@"distance"] integerValue] * 0.000621371;
        self.reviewCount = [dict[@"review_count"] integerValue];

        NSString *address = [dict valueForKeyPath:@"location.address"][0];
        NSString *neighborhood = [dict valueForKeyPath:@"location.neighborhoods"][0];
        self.address = [NSString stringWithFormat:@"%@, %@", address, neighborhood];

        
        NSArray *categories = dict[@"categories"];
        NSMutableArray *categoryNames = [NSMutableArray array];
        [categories enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [categoryNames addObject:obj[0]];
        }];
        self.categories = [categoryNames componentsJoinedByString:@", "];
    }
    return self;
}
+ (NSArray *)businessesWithDictionaries:(NSArray *)dicts {
    NSMutableArray *businesses = [NSMutableArray array];
    for (NSDictionary *dict in dicts) {
        Business *business = [[Business alloc] initWithDictionary:dict];
        [businesses addObject:business];
    }
    return businesses;
}

@end
