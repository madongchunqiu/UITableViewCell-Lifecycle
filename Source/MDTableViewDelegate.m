//
//  MDTableViewDelegate.m
//  TableViewCellLifecycle
//
//  Created by Ma Dong on 1/10/16.
//  Copyright © 2016 Ma Dong. All rights reserved.
//
// create default implementations for tableView:willDisplayCell:forRowAtIndexPath: & tableView:didEndDisplayingCell:forRowAtIndexPath:
//  so that method swizzling is possible in UITableViewCell+lifecycle
//

#import "MDTableViewDelegate.h"

@implementation MDTableViewDelegate
@end

#pragma mark -

@interface MDTableViewDelegate (CellLifecycle)  <UITableViewDelegate>
@end

@implementation MDTableViewDelegate (CellLifecycle)

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    return;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return;
}
@end