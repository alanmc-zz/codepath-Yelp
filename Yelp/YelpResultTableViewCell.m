//
//  YelpResultTableViewCell.m
//  Yelp
//
//  Created by Alan McConnell on 10/25/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "YelpResultTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import <QuartzCore/QuartzCore.h>

@implementation YelpResultTableViewCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.titleLabel.preferredMaxLayoutWidth = self.titleLabel.frame.size.width;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setBusiness:(Business *)business {
    _business = business;
    
    [self setImageURL:business.thumbnailURL];
    [self setTitle:business.name];
    [self setDistance:[[NSString alloc] initWithFormat:@"%.2f mi", business.distance]];
    [self setRatingImage:business.ratingImageURL];
    [self setReviewCount:business.reviewCount];
    [self setLocation:business.address];
    [self setCategories:business.categories];
}

- (void)setImageURL:(NSString *)imageURL {
    [self.thumbnailView setImageWithURL:[NSURL URLWithString:imageURL]];
    self.thumbnailView.layer.cornerRadius = 12;
    self.thumbnailView.clipsToBounds = YES;
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)setDistance:(NSString *)distance {
    self.distanceLabel.text = distance;
}

- (void)setRatingImage:(NSString *)ratingImageURL {
    [self.ratingImageView setImageWithURL:[NSURL URLWithString:ratingImageURL]];
}

- (void)setReviewCount:(NSInteger)reviewCount {
    self.reviewCountLabel.text = [[NSString alloc] initWithFormat:@"%d Reviews", (int)reviewCount];
}

- (void)setCategories:(NSString*)categories {
    self.categoryLabel.text = categories;
}

- (void)setLocation:(NSString*)location {
    self.locationLabel.text = location;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.preferredMaxLayoutWidth = self.titleLabel.frame.size.width;
}
@end
