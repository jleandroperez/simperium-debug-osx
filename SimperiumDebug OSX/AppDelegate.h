//
//  AppDelegate.h
//  SimperiumDebug OSX
//
//  Created by Jorge Leandro Perez on 11/18/13.
//  Copyright (c) 2013 Jorge Leandro Perez. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Simperium-OSX/Simperium.h>


@class SDTestWindowController;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow									*window;
@property (strong) IBOutlet SDTestWindowController						*testWindowController;

@property (readonly, strong, nonatomic) Simperium						*simperium;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator	*persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel			*managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext			*managedObjectContext;

- (IBAction)saveAction:(id)sender;
+ (AppDelegate*)delegate;

@end
