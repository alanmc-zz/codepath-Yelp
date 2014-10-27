//
//  SwitchCell.h
//  Yelp
//
//  Created by Alan McConnell on 10/26/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SwitchCell;

@protocol SwitchCellDelegate <NSObject>

- (void)switchCell:(SwitchCell *)cell didUpdateValue:(BOOL)value;

@end

@interface SwitchCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (assign, nonatomic) BOOL on;
@property (assign, nonatomic) BOOL enabled;
@property (weak, nonatomic) id<SwitchCellDelegate> delegate;

- (void)setOn:(BOOL)on animated:(BOOL)animated;

@end
