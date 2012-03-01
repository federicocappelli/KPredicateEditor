//
//  KPEViewController.m
//  Zanichelli_DizionariOSX
//
//  Created by Federico Cappelli on 29/12/11.
//  Copyright (c) 2011 Meta s.r.l. All rights reserved.
//

#import "KPEViewController.h"

@implementation KPEViewController

@synthesize suggestionForKey, keys, predicates, listView, maxWidth, delegate;

#define CELL_HEIGHT 36.0

-(id)initWithKeys:(NSArray *)keysString andSuggestions:(NSDictionary*)suggestions andFrame:(CGRect)frame
{
    self = [super init];
    if (self) 
    {
        if(keysString == NULL || suggestions == NULL || CGRectIsNull(frame) || CGRectIsEmpty(frame))
            return NULL;
        
        //Inizializzo componenti grafiche
        self.view = [[NSView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, CELL_HEIGHT)];
        
        self.listView=[[PXListView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
        self.listView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable | NSViewMaxXMargin | NSViewMaxYMargin;
        self.listView.delegate = self;
        [self.listView setCellSpacing:0.0f];
        [self.listView setAllowsEmptySelection:YES];
        [self.listView setAllowsMultipleSelection:YES];
        [self.listView registerForDraggedTypes:[NSArray arrayWithObjects: NSStringPboardType, nil]];
        self.listView.usesLiveResize = YES;
        [self.listView setHasVerticalScroller:YES];
        [self.listView setHasHorizontalScroller:NO];
        [self.listView setDrawsBackground:YES];
        [self.listView setAutohidesScrollers:YES];
        [[self.listView contentView] setCopiesOnScroll:NO];
        [self.view addSubview:self.listView];
        
        PXListDocumentView *docView = [[PXListDocumentView alloc] initWithFrame:self.view.frame];//CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, CELL_HEIGHT)];
        [docView setListView:self.listView];
        [self.listView setDocumentView:docView];
        
        //Data
        self.suggestionForKey = suggestions;
        self.keys = keysString;
        self.predicates = [[NSMutableArray alloc] init];
        
        //Options
        maxWidth = frame.size.width;
        //if(self.startWithFirstRow)
        //[self addRow];
    }
    
    return self;
}

-(void)dealloc
{
    [self.predicates release];
    [self.suggestionForKey release];
    [self.keys release];
    
    [super dealloc];
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"frame: (x:%f y:%f w:%f h:%f) predicates: %d",
            self.view.frame.origin.x,
            self.view.frame.origin.y,
            self.view.frame.size.width,
            self.view.frame.size.height,
            [self.predicates count]];
}

#pragma mark - Row

-(void)addRow
{
    KPredicate * pred = [[KPredicate alloc] initWithType:@"" Key:@"" operator:nil];
    [self.predicates addObject:pred];
    [self.listView reloadData];
}

-(void)removeRowAtIndex:(NSInteger)index
{
    [self.predicates removeObjectAtIndex:index];
    [self.listView reloadData];
}

#pragma mark - Predicate

-(NSArray *)getPredicates
{
    NSMutableArray * cleanedCopyOfPredicates = [[[NSMutableArray alloc] init] autorelease];
    for (KPredicate * pred in self.predicates) 
    {
        if(![pred.theSearchKey isEqualToString:@""] && pred.theSearchKey!=NULL)
            [cleanedCopyOfPredicates addObject:pred];
    }
    return cleanedCopyOfPredicates;
}

/*-(NSPredicate *)getPredicate
 {
 NSMutableString * allPredicates = [[[NSMutableString alloc] init] autorelease];
 //for (KPredicate * pred in self.predicates)
 for (int i=0; i<[self.predicates count]; i++)
 {
 KPredicate * pred = [self.predicates objectAtIndex:i];
 [allPredicates appendString:[pred description]];
 if(i+1 < [self.predicates count])
 [allPredicates appendString:@" AND "];
 }
 return [NSPredicate predicateWithFormat:allPredicates];
 }*/

#pragma mark - List View Delegate Methods

- (NSUInteger)numberOfRowsInListView: (PXListView*)aListView
{
	return [self.predicates count];
}

- (PXListViewCell*)listView:(PXListView*)aListView cellForRow:(NSUInteger)row
{
#define CELL_NAME   @"KPredicateCell"
	KPredicateViewCell *cell = NULL;// = (KPredicateViewCell*)[aListView dequeueCellWithReusableIdentifier:CELL_NAME];
	if(!cell) 
    {
		cell = [KPredicateViewCell cellLoadedFromNibNamed:@"KPredicateViewCell" reusableIdentifier:CELL_NAME];
        cell.delegate = self;
	}
	
    KPredicate * thisPredicate = [self.predicates objectAtIndex:row];
    [cell render:self.keys suggestions:self.suggestionForKey predicate:thisPredicate];
	return cell;
}

- (CGFloat)listView:(PXListView*)aListView heightOfRow:(NSUInteger)row
{
	return CELL_HEIGHT;
}

- (void)listViewSelectionDidChange:(NSNotification*)aNotification
{
    NSLog(@"Selection changed %@", [aNotification description]);
}

// The following are only needed for drag'n drop:
- (BOOL)listView:(PXListView*)aListView writeRowsWithIndexes:(NSIndexSet*)rowIndexes toPasteboard:(NSPasteboard*)dragPasteboard
{
	// +++ Actually drag the items, not just dummy data.
	[dragPasteboard declareTypes: [NSArray arrayWithObjects: NSStringPboardType, nil] owner: self];
	[dragPasteboard setString: @"Just Testing" forType: NSStringPboardType];
	
	return YES;
}

- (NSDragOperation)listView:(PXListView*)aListView validateDrop:(id <NSDraggingInfo>)info proposedRow:(NSUInteger)row
      proposedDropHighlight:(PXListViewDropHighlight)dropHighlight;
{
	return NSDragOperationCopy;
}

#pragma mark - KPredicateCellDelegate

-(void)addCellFromCell:(KPredicateViewCell *)cell
{
    //NSLog(@"add cell at row: %lu",cell.row+1);
    
    PXListDocumentView * dv = self.listView.documentView;
    [self addRow];
    [self.delegate resizeOfKPE:dv.frame.size.height];
}

-(void)deleteCell:(KPredicateViewCell *)cell
{
    if([self.predicates count]<2)
        return;
    [self removeRowAtIndex:cell.row];
    
    [self.delegate resizeOfKPE:(CELL_HEIGHT+1.0)*[self.predicates count]];
    //PXListDocumentView * dv = self.listView.documentView;
    //[self.delegate resizeOfKPE:dv.frame.size.height];
    
}

@end
