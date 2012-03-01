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
-(void)render:(NSArray *)keysString suggestions:(NSDictionary*)suggestionsForKeys predicate:(KPredicate *)predicate;
-(void)setSuggestionButtonHide:(BOOL)visible;

@end

@protocol KPredicateCellDelegate

-(void)deleteCell:(KPredicateViewCell*)cell;
-(void)addCellFromCell:(KPredicateViewCell*)cell;

@end