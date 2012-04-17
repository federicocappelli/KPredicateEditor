//
//  KPEViewController.h
//  Zanichelli_DizionariOSX
//
//  Created by Federico Cappelli on 29/12/11.

/*
 Editor di predicati, personalizzabile
 
 Uso:
 
 Opzioni:
 maxWidth: se non impostato rende il KPE fisso e non espandibile, altrimenti si auto espande fino a maxWidth poi scrolla
 */

#import <Cocoa/Cocoa.h>
#import "PXListView.h"
#import "PXListDocumentView.h"
#import "KPredicateViewCell.h"
#import "KPredicate.h"

@protocol KPEDelegate;

@interface KPEViewController : NSViewController <PXListViewDelegate, KPredicateCellDelegate>
{
    //Data
    NSMutableArray * predicates;
    NSDictionary * suggestionForKey;
    NSArray * keys;
    
    //Options
    CGFloat maxWidth;
    
    //Views
    PXListView * listView;
    
    id <KPEDelegate> delegate;
}

@property(nonatomic, retain) NSMutableArray * predicates;
@property(nonatomic, retain) NSDictionary * suggestionForKey;
@property(nonatomic, retain) NSArray * keys;
@property CGFloat maxWidth;
@property(nonatomic, retain) PXListView * listView;
@property(nonatomic, assign) id <KPEDelegate> delegate;

/*Init, dove
 keysString: array di stringhe da mostrare nel menu a tendina di sinistra
 suggestions: coppie chiave K - array A di stringhe da mostrare come suggerimenti per il riempimento del campo di ricerca quando è selezionala la chiave K, se una chiave K non ha suggerimenti non inserire l'oggetto di chiave K*/
-(id)initWithKeys:(NSArray *)keysString suggestions:(NSDictionary*)suggestions origin:(CGPoint)origin width:(CGFloat)width;

//Aggiunge una riga in fondo
-(void)addRow;
//Elimina la cella a index
-(void)removeRowAtIndex:(NSInteger)index;

//Restituisce un array di KPredicate (eliminando i vuoti)
-(NSArray *)getPredicates;

@end

@protocol KPEDelegate

-(void)resizeOfKPE:(CGFloat)height;
@optional
-(void)crPerformedFromKPESearchField;
@end
