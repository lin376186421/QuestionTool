//
//  LogViewController.m
//  QuestionTools
//
//  Created by 林 on 2017/5/19.
//  Copyright © 2017年 林. All rights reserved.
//

#import "LogViewController.h"
#import "NSLogCell.h"

@interface LogViewController ()<NSOutlineViewDelegate,NSOutlineViewDataSource>
{
    IBOutlet NSOutlineView *_outLineView;
    IBOutlet NSScrollView *_scrollView;
}

@end

@implementation LogViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _outLineView = nil;
    [App_Delegate setLogWindowController:nil];
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    [App_Delegate setLogWindowController:self];
    //todo fuck
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logAdd:) name:APP_LOG_ADD_EVENT object:nil];
//    NSLog(@"%@",App_Delegate.logArr);
    [_scrollView setLineScroll:0];
    [_scrollView setPageScroll:0];
    _outLineView.delegate = self;
    _outLineView.dataSource = self;
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    [self reloadData];
}

//- (void)logAdd:(NSNotification *)n
//{
//    [self reloadData];
//}

- (void)reloadData
{
    [_outLineView reloadData];
    [_outLineView layoutSubtreeIfNeeded];
//  其实 _outLineView == _scrollView.documentView
//    if (_scrollView.documentView.frame.size.height > _scrollView.frame.size.height) {
//        [_scrollView scrollPoint:CGPointMake(0, _scrollView.documentView.frame.size.height-_scrollView.frame.size.height)];
//    }
    NSLog(@"%@",NSStringFromSize(_scrollView.documentView.frame.size));
}

- (void)addLog
{
//    [_outLineView insertItemsAtIndexes:[NSIndexSet indexSetWithIndex:App_Delegate.logArr.count] inParent:nil withAnimation:NSTableViewAnimationEffectFade];
    [self reloadData];
}

#pragma mark NSOutlineViewDataSource
- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    return App_Delegate.logArr.count;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    if (item == nil)
    { //root
        return [App_Delegate.logArr objectAtIndex:index];
    }
    return nil;
}
- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    return NO;
}


#pragma mark NSOutlineViewDelegate
- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    NSLogCell *cell = [[NSLogCell alloc] initWithNibName:@"NSLogCell" bundle:nil];
    [cell view];
    [cell setLog:item];
    
//    LessonSeriesCellViewController *cell = [[LessonSeriesCellViewController alloc] init];
//    
//    LessonSeriesCellView *cellView = (LessonSeriesCellView *)cell.view;
//    
//    if ([item isKindOfClass:[LessonSeries class]])
//    {
//        [cellView setLessonSeries:item];
//        [cellView setIsLocal:_isLocal];
//    }
//    return cellView;
    return cell.view;
}
- (CGFloat)outlineView:(NSOutlineView *)outlineView heightOfRowByItem:(id)item
{
    CGFloat h = [NSLogCell cellHeightWithItem:item];
    return h;
}
#pragma mark NSOutline Drag
- (void)outlineView:(NSOutlineView *)outlineView draggingSession:(NSDraggingSession *)session willBeginAtPoint:(NSPoint)screenPoint forItems:(NSArray *)draggedItems
{
    
}
- (void)outlineView:(NSOutlineView *)outlineView draggingSession:(NSDraggingSession *)session endedAtPoint:(NSPoint)screenPoint operation:(NSDragOperation)operation
{
}

- (id <NSPasteboardWriting>)outlineView:(NSOutlineView *)outlineView pasteboardWriterForItem:(id)item
{
//    if ([item isKindOfClass:[LessonSeries class]])
//    {
//        return [[NSPasteboardItem alloc] init];
//    }
//    else
//    {
//        return nil;
//    }
    return nil;
}

- (NSDragOperation)outlineView:(NSOutlineView *)outlineView validateDrop:(id <NSDraggingInfo>)info proposedItem:(id)item proposedChildIndex:(NSInteger)index
{
    if (index >= 0)
    {
        return NSDragOperationMove;
    }
    else
    {
        return NSDragOperationNone;
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView acceptDrop:(id <NSDraggingInfo>)info item:(id)item childIndex:(NSInteger)index
{
    if (index >= 0)
    {
        return YES;
    }
    
    return NO;
}


@end
