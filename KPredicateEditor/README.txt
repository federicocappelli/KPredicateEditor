@Credits: Federico Cappelli
@Support: (ahahah support :D) aniway: admin@federicocappelli.net
@use:

---in the init of your superview:
KPEViewController kpeViewController = [[KPEViewController alloc] initWithKeys: keysString
                                                          andSuggestions: suggestions
                                                                andFrame:CGRectMake(0.0, 374.0, 733.0, 33.0)];
kpeViewController.view.autoresizingMask = NSViewWidthSizable | NSViewMinYMargin;
kpeViewController.delegate = self;
[self.view addSubview:kpeViewController.view];

where:

keysString: array of NSString to show in the left popup menu
suggestions: Couples of key K - array A of NSString to show in the suggestions popup menu on right,where K is selected, if a K key don't have suggestions (don't have an array in A) the suggestions button not displayed.

---In you superview awakeFromNib

- (void)awakeFromNib
{   
	[self.kpeViewController addRow];
    [self resizeOfKPE:38.0];
}

---Manage number of row in predicate editor:

-(void)addRow;
-(void)removeRowAtIndex:(NSInteger)index;

---Return an array of KPredicate (only the valid, and compiled one)

-(NSArray *)getPredicates;
