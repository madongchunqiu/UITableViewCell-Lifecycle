//
//  MDRuntimeHelper.h
//  TableViewCellLifecycle
//
//  Created by Ma Dong on 1/10/16.
//  Copyright © 2016 Ma Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDRuntimeHelper : NSObject

/// swizzling
+ (void)switchMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector forClass:(Class)class;

/// add a selector/imp to the class, with the same prototype of an existing selector (prepare for swizzling)
+ (void)injectNewSelectorForClass:(Class)class withSelector:(SEL)newSelector andImp:(IMP)newImp toReplaceSelector:(SEL)oldSelector;

/// to check if a class (maybe not-subclass-of-NSObject) is a subclass of another one
+ (BOOL)isSubclass:(Class)childClass ofClass:(Class)rootClass;

@end
