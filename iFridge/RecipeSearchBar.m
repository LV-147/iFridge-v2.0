//
//  RecipeSearchBar.m
//  iFridge
//
//  Created by Vladius on 5/29/15.
//  Copyright (c) 2015 Alexey Pelekh. All rights reserved.
//

#import "RecipeSearchBar.h"
#import "DataDownloader.h"
#import "RecipesTVC.h"

@implementation RecipeSearchBar

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    RecipesTVC *tvc = [[RecipesTVC alloc] init];
    [tvc searchForRecipesForQuery:self.text];
}// called when text starts editing

/*- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
}// called when text ends editing
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
}// called when text changes (including clear)

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
}// called when keyboard search button pressed
- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar;{
    
}// called when bookmark button pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
}// called when cancel button pressed
- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar NS_AVAILABLE_IOS(3_2){

}// called when search results button pressed*/


@end
