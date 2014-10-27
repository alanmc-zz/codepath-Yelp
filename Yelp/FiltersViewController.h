//
//  FiltersViewController.h
//  Yelp
//
//  Created by Alan McConnell on 10/26/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwitchCell.h"

@class FiltersViewController;

@protocol FiltersViewControllerDelegate <NSObject>

- (void)filtersViewControllers:(FiltersViewController *)filtersViewController didChangeFilters:(NSDictionary *)filters;

@end

@interface FiltersViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate>

@property (weak, nonatomic) id<FiltersViewControllerDelegate> delegate;

@end
