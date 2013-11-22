//
//  SDTestWindowController.m
//  SimperiumDebug OSX
//
//  Created by Jorge Leandro Perez on 11/18/13.
//  Copyright (c) 2013 Jorge Leandro Perez. All rights reserved.
//

#import "SDTestWindowController.h"
#import "AppDelegate.h"
#import "ParentA.h"
#import "ChildA.h"
#import "ChildB.h"


static NSInteger kTestSize = 10;


@interface SDTestWindowController () <SPBucketDelegate>
@property (nonatomic, weak, readwrite) IBOutlet NSTextField *statusTextField;
@property (nonatomic, weak, readwrite) IBOutlet NSTextField *level1FailedTextField;
@property (nonatomic, weak, readwrite) IBOutlet NSTextField *level2FailedTextField;
@end


@implementation SDTestWindowController

- (void)dealloc
{
	NSLog(@"<> %@ dealloc", NSStringFromClass([self class]));
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithWindow:(NSWindow *)window
{
    if ((self = [super initWithWindow:window])) {
		NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
		[nc addObserver:self selector:@selector(refreshUI) name:NSWindowDidBecomeKeyNotification object:window];
    }
    return self;
}

- (void)refreshUI
{
	NSLog(@"<> %@ refreshUI", NSStringFromClass([self class]));
	
	[[[AppDelegate delegate] simperium] setAllBucketDelegates:self];
		
	NSManagedObjectContext *context = [[AppDelegate delegate] managedObjectContext];
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([ParentA class])];

	NSError *error;
	NSArray *array = [context executeFetchRequest:request error:&error];
	if (array == nil)
	{
		NSLog(@"<> Error executing fetch request");
	}
	
	NSInteger failedRelationshipsLevel1	= 0;
	NSInteger failedRelationshipsLevel2	= 0;
	
	for(ParentA *parent in array)
	{
		if(parent.childA == nil) {
			++failedRelationshipsLevel1;
		}
		
		if(parent.childA.childB == nil) {
			++failedRelationshipsLevel2;
		}
	}
	
	self.statusTextField.stringValue		= [NSString stringWithFormat:@"Total Objects: %ld", array.count];
	self.level1FailedTextField.stringValue	= [NSString stringWithFormat:@"Failed Relationships Level #1: %ld", failedRelationshipsLevel1];
	self.level2FailedTextField.stringValue	= [NSString stringWithFormat:@"Failed Relationships Level #2: %ld", failedRelationshipsLevel2];
}


- (IBAction)insertObjects:(id)sender
{
	NSManagedObjectContext *context = [[AppDelegate delegate] managedObjectContext];
	for(int i = -1; ++i < kTestSize; ) {
		ParentA* root	= [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([ParentA class]) inManagedObjectContext:context];
		ChildA* childA	= [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([ChildA class]) inManagedObjectContext:context];
		ChildB* childB	= [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([ChildB class]) inManagedObjectContext:context];
		
		root.childA		= childA;
		childA.childB	= childB;
	}
	
	NSError* error = nil;
	if([context save:&error] == false) {
		NSLog(@"<> Error saving context: %@", error);
	}
}

- (IBAction)deleteObjects:(id)sender
{
	NSManagedObjectContext *context = [[AppDelegate delegate] managedObjectContext];
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([ParentA class])];
	
	NSError *error;
	NSArray *array = [context executeFetchRequest:request error:&error];
	if (array == nil) {
		NSLog(@"<> Error executing fetch request");
		return;
	}
	
	for(ParentA *parent in array) {
		[context deleteObject:parent];
	}
	
	error = nil;
	if([context save:&error] == false) {
		NSLog(@"<> Error saving context: %@", error);
	}
}

- (IBAction)signOut:(id)sender
{
	Simperium* s = [[AppDelegate delegate] simperium];
	[s signOutAndRemoveLocalData:YES];
    [s authenticateIfNecessary];

    [self.window performSelector:@selector(orderOut:) withObject:self afterDelay:0.1];
}


#pragma mark SPBucketDelegate

- (void)bucketDidAcknowledgeDelete:(SPBucket *)bucket
{
	NSLog(@"<> %@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
	[self refreshUI];
}

- (void)bucketDidFinishIndexing:(SPBucket *)bucket
{
	NSLog(@"<> %@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
	[self refreshUI];
}

- (void)bucket:(SPBucket *)bucket didChangeObjectForKey:(NSString *)key forChangeType:(SPBucketChangeType)changeType memberNames:(NSArray *)memberNames
{
	NSLog(@"<> %@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
	[self refreshUI];
}

- (void)bucket:(SPBucket *)bucket didReceiveObjectForKey:(NSString *)key version:(NSString *)version data:(NSDictionary *)data
{
	NSLog(@"<> %@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
	[self refreshUI];
}

@end
