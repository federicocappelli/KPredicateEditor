//
//  KPEViewController.m
//  Zanichelli_DizionariOSX
//
//  Created by Federico Cappelli on 29/12/11.
//  Copyright (c) 2011 Meta s.r.l. All rights reserved.
//

#import "KPEViewController.h"

@implementation KPEViewController

@synthesize suggestionForKey, keys, predicates, listView, maxWidth, delegate, cellHeight;

-(id)initWithKeys:(NSArray *)keysString suggestions:(NSDictionary*)suggestions origin:(CGPoint)origin width:(CGFloat)width
{
    self = [super init];
    if (self) 
    {
        if(keysString == NULL)
            return NULL;
        
        //Instanzio cella per calcolare altezza
        KPredicateViewCell * cell = [KPredicateViewCell cellLoadedFromNibNamed:@"KPredicateViewCell" reusableIdentifier:@""];
        self.cellHeight = cell.frame.size.height;
        
        //Inizializzo componenti grafiche
        self.view = [[[NSView alloc] initWithFrame:NSMakeRect(origin.x, origin.y, width, self.cellHeight)] autorelease];
        
        self.listView=[[[PXListView alloc] initWithFrame:NSMakeRect(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)] autorelease];
        self.listView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable | NSViewMaxXMargin | NSViewMaxYMargin;
        self.listView.delegate = self;
        [self.listView setCellSpacing:0.0f];
        [self.listView setAllowsEmptySelection:NO];
        [self.listView setAllowsMultipleSelection:NO];
        //[self.listView registerForDraggedTypes:[NSArray arrayWithObjects: NSStringPboardType, nil]];
        self.listView.usesLiveResize = YES;
        [self.listView setHasVerticalScroller:NO];
        [self.listView setHasHorizontalScroller:NO];
        [self.listView setDrawsBackground:YES];
        [self.listView setAutohidesScrollers:YES];
        [[self.listView contentView] setCopiesOnScroll:NO];
        
        //[self.listView setBorderType:1];
        [self.listView setDrawsBackground:YES];
        [self.listView setBackgroundColor:[NSColor colorWithDeviceRed:0.749 green:0.749 blue:0.749 alpha:1.0]];
        
        [self.view addSubview:self.listView];
        
        PXListDocumentView *docView = [[[PXListDocumentView alloc] initWithFrame:self.listView.frame] autorelease];
        [docView setListView:self.listView];
        [self.listView setDocumentView:docView];
        
        //Data
        self.suggestionForKey = suggestions;
        self.keys = keysString;
        self.predicates = [[[NSMutableArray alloc] init] autorelease];
        
        //Options
        maxWidth = width;
        //if(self.startWithFirstRow)
        //[self addRow];
    }
    return self;
}

-(void)dealloc
{
    [predicates release];
    [suggestionForKey release];
    [keys release];
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
    KPredicate * pred = [[[KPredicate alloc] initWithType:@"" Key:@"" operator:nil] autorelease];
    [self.predicates addObject:pred];
    [self.listView reloadData];
}

-(void)removeRowAtIndex:(NSInteger)index
{
    [self.predicates removeObjectAtIndex:index];
    [self.listView reloadData];
}

-(void)reset
{
    [self.predicates removeAllObjects];
    [self addRow];
    [self.delegate resizeOfKPE:(self.cellHeight)];
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
    NSRange cellPosition;
    cellPosition.location = row;
    cellPosition.length = [self.predicates count];
    [cell render:self.keys suggestions:self.suggestionForKey predicate:thisPredicate position:cellPosition];
	return cell;
}

- (CGFloat)listView:(PXListView*)aListView heightOfRow:(NSUInteger)row
{
	return self.cellHeight;
}

/*
- (void)listViewSelectionDidChange:(NSNotification*)aNotification
{
    NSLog(@"Selection changed %@", [aNotification description]);
}

//The following are only needed for drag'n drop:
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
}*/

#pragma mark - KPredicateCellDelegate

-(void)addCellFromCell:(KPredicateViewCell *)cell
{
    //NSLog(@"add cell at row: %lu",cell.row+1);
    if ([self.predicates count]>=5)
    {
        return;
    }
    
    PXListDocumentView * dv = self.listView.documentView;
    [self addRow];
    [self.delegate resizeOfKPE:dv.frame.size.height];
}

-(void)deleteCell:(KPredicateViewCell *)cell
{
    if([self.predicates count]==1)
        return;
    [self removeRowAtIndex:cell.row];
    
    [self.delegate resizeOfKPE:(self.cellHeight)*[self.predicates count]];
    //PXListDocumentView * dv = self.listView.documentView;
    //[self.delegate resizeOfKPE:dv.frame.size.height];
}

-(void)searchFieldCRpressed
{
    [self.delegate crPerformedFromKPESearchField];
}

@end
