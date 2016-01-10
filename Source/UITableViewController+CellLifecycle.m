//
//  UITableViewController+CellLifecycle.m
//  TableViewCellLifecycle
//
//  Created by Ma Dong on 1/10/16.
//  Copyright © 2016 Ma Dong. All rights reserved.
//
// NOTE: UITableViewController conforms for UITableViewDelegate by default
//  just create default implementations for tableView:willDisplayCell:forRowAtIndexPath: & tableView:didEndDisplayingCell:forRowAtIndexPath:
//  so that method swizzling is possible in UITableViewCell+lifecycle
//

#import "UITableViewController+CellLifecycle.h"

@implementation UITableViewController (CellLifecycle)

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    return;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return;
}

@end
