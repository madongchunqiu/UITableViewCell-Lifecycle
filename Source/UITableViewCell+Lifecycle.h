//
//  UITableViewCell+Lifecycle.h
//  TableViewCellLifecycle
//
//  Created by Ma Dong on 1/10/16.
//  Copyright © 2016 Ma Dong. All rights reserved.
//
// to use this, check
//  1. the class that conforms to UITableViewDelegate satisfy one of below criteria:
//      a. a subclass of MDTableViewDelegate (preferred)
//      b. a subclass of UITableViewController
//  2. if table view cell overrides layoutSubviews, be sure to call [super layoutSubviews],
//      otherwise, cellDidAppear & cellDidLayoutSubviews won't work
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (Lifecycle)

@property (nonatomic) BOOL isCellWillAppearFired; //!< YES, if the cell ever triggered cellWillAppear 
@property (nonatomic) BOOL isCellDidAppearFired; //!< YES, if the cell ever triggered cellDidAppear 
@property (nonatomic) BOOL isCellDidLayoutSubviewsFired; //!< YES, if the cell ever triggered cellDidLayoutSubviews 

- (void)cellWillAppear;

/// if custom cell overrides layoutSubviews, be sure to call [super layoutSubviews]
- (void)cellDidAppear;
/// layoutSubviews may be called in dequeReusableCell, this is made as a replacement for layoutSubviews of a cell
- (void)cellDidLayoutSubviews;

- (void)cellDidDisappear;

@end
