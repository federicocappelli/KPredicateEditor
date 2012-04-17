//
//  MyListViewCell.m
//  PXListView
//
//  Created by Alex Rozanski on 29/05/2010.
//  Copyright 2010 Alex Rozanski. http://perspx.com. All rights reserved.
//

#import "KPredicateViewCell.h"

#import <iso646.h>


@implementation KPredicateViewCell

@synthesize delegate, typeButton, suggestionsButton, searchField, thePredicate, texture, keys, suggestions, searchSuggestionSelected, suggestionsButtonImage;

#pragma mark -
#pragma mark Init/Dealloc

- (id)initWithReusableIdentifier: (NSString*)identifier
{
	if((self = [super initWithReusableIdentifier:identifier]))
	{
        self.texture = [NSColor colorWithPatternImage:[NSImage imageNamed:@"cell_bk.png"]];
	}
	
	return self;
}

-(void)awakeFromNib
{   
    self.searchField.delegate = self;
    self.searchSuggestionSelected = NULL;
}

- (void)dealloc
{
    
	[super dealloc];
}

#pragma mark - Render

-(void)render:(NSArray *)keysString suggestions:(NSDictionary*)suggestionsForKeys predicate:(KPredicate *)predicate;
{
    self.keys = keysString;
    self.suggestions = suggestionsForKeys;
    self.thePredicate = predicate;
    [self.typeButton addItemsWithTitles:keysString];
    
    //Se il predicato non è vuoto ripristino lo stato
    if(![predicate.theType isEqualToString:@""] && predicate.theType != NULL)
    {
        [self.typeButton selectItemWithTitle:predicate.theType];
        NSArray * sugg = [NSArray arrayWithArray:[self.suggestions objectForKey:predicate.theType]];
        if([sugg count]>0 && sugg != NULL)
        {
            
            [self setSuggestionButtonHide:FALSE];            
            NSMutableArray * suggVisualizzati = [[[NSMutableArray alloc] init] autorelease];
            for (SearchSuggestion * ss in sugg)
            {
                [suggVisualizzati addObject:ss.visibleValue];
            }
            [self.suggestionsButton addItemsWithTitles:suggVisualizzati];
        }
        else
            [self setSuggestionButtonHide:TRUE];
        [self.searchField setStringValue:predicate.theSearchKey];
    }
    else //Impostazioni base
    {
        //Imposto i suggerimenti per la prima chiave
        NSArray * sugg = [NSArray arrayWithArray:[self.suggestions objectForKey:[keysString objectAtIndex:0]]];
        if([sugg count]>0 && sugg != NULL)
        {
            [self setSuggestionButtonHide:FALSE];
            
            NSMutableArray * suggVisualizzati = [[[NSMutableArray alloc] init] autorelease];
            for (SearchSuggestion * ss in sugg)
            {
                [suggVisualizzati addObject:ss.visibleValue];
            }
            [self.suggestionsButton addItemsWithTitles:suggVisualizzati];
        }
        else
            [self setSuggestionButtonHide:TRUE];
    }
}

#pragma mark -
#pragma mark Reuse

- (void)prepareForReuse
{
    
}

#pragma mark -
#pragma mark Drawing

- (void)drawRect:(NSRect)dirtyRect
{
    //Sfondo
    CGContextRef context = (CGContextRef) [[NSGraphicsContext currentContext] graphicsPort];
    CGContextSetRGBFillColor(context, 0.929,0.929,0.929,1.0);
    CGContextFillRect(context, NSRectToCGRect(dirtyRect));
    
    //Linea chiara in alto
    NSBezierPath* bPath = [NSBezierPath bezierPath];
    [bPath setLineWidth:1.0];
    [[NSColor colorWithCalibratedRed:0.976 green:0.980 blue:0.976 alpha:1.0] set];
    [bPath moveToPoint:NSMakePoint(0.5, self.frame.size.height)];
    [bPath lineToPoint:NSMakePoint(self.frame.size.width, self.frame.size.height)];
    [bPath stroke];   
    
    //Linea grigia in basso
    NSBezierPath* aPath = [NSBezierPath bezierPath];
    [aPath setLineWidth:1.0];
    [[NSColor colorWithCalibratedRed:0.749 green:0.749 blue:0.749 alpha:1.0] set];
    [aPath moveToPoint:NSMakePoint(0.5, 0.5)];
    [aPath lineToPoint:NSMakePoint(self.frame.size.width, 0.5)];
    [aPath stroke];
}


#pragma mark -
#pragma mark Accessibility

- (NSArray*)accessibilityAttributeNames
{
	NSMutableArray*	attribs = [[[super accessibilityAttributeNames] mutableCopy] autorelease];
	
	[attribs addObject: NSAccessibilityRoleAttribute];
	[attribs addObject: NSAccessibilityDescriptionAttribute];
	[attribs addObject: NSAccessibilityTitleAttribute];
	[attribs addObject: NSAccessibilityEnabledAttribute];
	
	return attribs;
}

- (BOOL)accessibilityIsAttributeSettable:(NSString *)attribute
{
	if( [attribute isEqualToString: NSAccessibilityRoleAttribute]
       or [attribute isEqualToString: NSAccessibilityDescriptionAttribute]
       or [attribute isEqualToString: NSAccessibilityTitleAttribute]
       or [attribute isEqualToString: NSAccessibilityEnabledAttribute] )
	{
		return NO;
	}
	else
		return [super accessibilityIsAttributeSettable: attribute];
}

- (id)accessibilityAttributeValue:(NSString*)attribute
{
	if([attribute isEqualToString:NSAccessibilityRoleAttribute])
	{
		return NSAccessibilityButtonRole;
	}
	
    if([attribute isEqualToString:NSAccessibilityDescriptionAttribute]
       or [attribute isEqualToString:NSAccessibilityTitleAttribute])
	{
		return [self.searchField stringValue];
	}
    
	if([attribute isEqualToString:NSAccessibilityEnabledAttribute])
	{
		return [NSNumber numberWithBool:YES];
	}
    
    return [super accessibilityAttributeValue:attribute];
}

#pragma mark - Handler

-(IBAction)addRow:(id)sender
{
    [self.delegate addCellFromCell:self];
}

-(IBAction)deleteRow:(id)sender
{
    [self.delegate deleteCell:self];
}

-(IBAction)typePopUpSelected:(id)sender
{
    NSArray * sugg = [self.suggestions objectForKey:[self.typeButton titleOfSelectedItem]];
    
    if([sugg count]>0 && sugg != NULL)
    {
        [self setSuggestionButtonHide:FALSE];
        [self.suggestionsButton removeAllItems];
        NSMutableArray * suggVisualizzati = [[[NSMutableArray alloc] init] autorelease];
        for (SearchSuggestion * ss in sugg)
        {
            [suggVisualizzati addObject:ss.visibleValue];
        }
        [self.suggestionsButton addItemsWithTitles:suggVisualizzati];
    }
    else
        [self setSuggestionButtonHide:TRUE];
    
    [self.searchField setStringValue:@""];
    [self updatePredicate];
}

-(IBAction)suggestionsPopUpSelected:(id)sender
{
    for (SearchSuggestion * ss in [self.suggestions objectForKey:[self.typeButton titleOfSelectedItem]])
    {
        if([ss.visibleValue isEqualToString:[self.suggestionsButton titleOfSelectedItem]])
        {
            self.searchSuggestionSelected = ss;
            break;
        }
    }
    NSString * newString;
    if([self.searchField.stringValue isEqualToString:@""] || self.searchField.stringValue == NULL)
        newString = [self.searchField.stringValue stringByAppendingFormat:[NSString stringWithFormat:@"(%@)",self.searchSuggestionSelected.searchValue]];
    else
        newString = [self.searchField.stringValue stringByAppendingFormat:[NSString stringWithFormat:@" (%@)",self.searchSuggestionSelected.searchValue]];
    
    [self.searchField setStringValue:newString];
    [self updatePredicate];
}

-(IBAction)searchFieldSelector:(id)sender
{
    [self.delegate searchFieldCRpressed];
}

#pragma mark - NSTextFieldDelegate

-(void)controlTextDidEndEditing:(NSNotification *)obj
{
    //NSLog(@"fine");
}

-(void)controlTextDidChange:(NSNotification *)obj
{
    [self updatePredicate];
}

#pragma mark - Update Predicate

-(void)updatePredicate
{
    self.thePredicate.theType = [self.typeButton titleOfSelectedItem];
    self.thePredicate.theSearchKey = self.searchField.stringValue;
}

-(void)setSuggestionButtonHide:(BOOL)visible
{
    [self.suggestionsButton setHidden:visible];
    [self.suggestionsButtonImage setHidden:visible];
}

@end
