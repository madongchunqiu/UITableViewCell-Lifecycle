//
//  Example2Cell.m
//  TableViewCellLifecycle
//
//  Created by Ma Dong on 1/10/16.
//  Copyright © 2016 Ma Dong. All rights reserved.
//

#import "Example2Cell.h"

@interface Example2Cell ()
{
    NSTimer* timer;
}
@end

@implementation Example2Cell

- (void)cellWillAppear {
    NSLog(@" 🍏 Example2Cell - cellWillAppear");
}

- (void)cellDidAppear {
    NSLog(@" 🍏 Example2Cell - cellDidAppear");
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerWorks) userInfo:nil repeats:YES];
}

- (void)cellDidLayoutSubviews {
    NSLog(@" 🍏 Example2Cell - cellDidLayoutSubviews");
}

- (void)cellDidDisappear {
    NSLog(@" 🍏 Example2Cell - cellDidDisappear");
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}

- (void)timerWorks
{
    self.labelText.text = [NSString stringWithFormat:@"%@%@",
                           self.labelText.text,
                           [NSUUID UUID].UUIDString];
}


@end
