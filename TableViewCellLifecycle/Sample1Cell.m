//
//  Sample1Cell.m
//  TableViewCellLifecycle
//
//  Created by Ma Dong on 1/10/16.
//  Copyright © 2016 Ma Dong. All rights reserved.
//

#import "Sample1Cell.h"
#import "UITableViewCell+Lifecycle.h"

@interface Sample1Cell ()
{
    NSTimer* timer;
}
@end

@implementation Sample1Cell

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)cellWillAppear {
    NSLog(@" 🍎 Sample1Cell - cellWillAppear");
}

- (void)cellDidAppear {
    NSLog(@" 🍎 Sample1Cell - cellDidAppear");
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerWorks) userInfo:nil repeats:YES];
}

- (void)cellDidLayoutSubviews {
    NSLog(@" 🍎 Sample1Cell - cellDidLayoutSubviews");
}

- (void)cellDidDisappear {
    NSLog(@" 🍎 Sample1Cell - cellDidDisappear");
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}

- (void)timerWorks
{
    self.constraintViewWidth.constant += 5.f;
}

@end
