//
//  MyListViewCell.h
//  PXListView
//
//  Created by Alex Rozanski on 29/05/2010.
//  Copyright 2010 Alex Rozanski. http://perspx.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "PXListViewCell.h"
#import "KPredicate.h"
#import "SearchSuggestion.h"

@protocol KPredicateCellDelegate;

@interface KPredicateViewCell : PXListViewCell <NSTextFieldDelegate>
{
    id <KPredicateCellDelegate> delegate;
    NSRange position;
    
    NSButton * addButton;
    NSButton * removeButton;
    NSPopUpButton * typeButton;
    NSPopUpButton * suggestionsButton;
    NSImageView * suggestionsButtonImage;
    NSTextField * searchField;
    KPredicate * thePredicate;
    NSColor * texture;
    
    NSArray * keys;
    NSDictionary * suggestions;
    SearchSuggestion * searchSuggestionSelected;
}

@property (nonatomic, assign) id <KPredicateCellDelegate> delegate;
@property NSRange position;
@property (nonatomic, retain) IBOutlet NSButton * addButton;
@property (nonatomic, retain) IBOutlet NSButton * removeButton;
@property (nonatomic, retain) IBOutlet NSPopUpButton * typeButton;
@property (nonatomic, retain) IBOutlet NSPopUpButton * suggestionsButton;
@property (nonatomic, retain) IBOutlet NSImageView * suggestionsButtonImage;
@property (nonatomic, retain) IBOutlet NSTextField * searchField;
@property (nonatomic, retain) KPredicate * thePredicate;
@property (nonatomic, retain) NSColor * texture;
@property (nonatomic, retain) NSArray * keys;
@property (nonatomic, retain) NSDictionary * suggestions;
@property (nonatomic, retain) SearchSuggestion * searchSuggestionSelected;

-(IBAction)addRow:(id)sender;
-(IBAction)deleteRow:(id)sender;
-(IBAction)typePopUpSelected:(id)sender;
-(IBAction)suggestionsPopUpSelected:(id)sender;
-(void)updatePredicate;
-(void)render:(NSArray *)keysString suggestions:(NSDictionary*)suggestionsForKeys predicate:(KPredicate *)predicate position:(NSRange)cellPosition;
-(void)setSuggestionButtonHide:(BOOL)visible;
-(IBAction)searchFieldSelector:(id)sender;

@end

@protocol KPredicateCellDelegate

@optional
-(void)deleteCell:(KPredicateViewCell*)cell;
-(void)addCellFromCell:(KPredicateViewCell*)cell;
-(void)searchFieldCRpressed;
@end