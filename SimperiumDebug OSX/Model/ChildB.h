//
//  ChildB.h
//  SimperiumDebug OSX
//
//  Created by Jorge Leandro Perez on 11/18/13.
//  Copyright (c) 2013 Jorge Leandro Perez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <Simperium-OSX/Simperium.h>


@class ChildA;

@interface ChildB : SPManagedObject

@property (nonatomic, retain) NSString	*name;
@property (nonatomic, retain) ChildA	*childA;

@end
