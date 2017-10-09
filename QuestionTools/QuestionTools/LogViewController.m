//
//  LogViewController.m
//  QuestionTools
//
//  Created by 林 on 2017/5/19.
//  Copyright © 2017年 林. All rights reserved.
//

#import "LogViewController.h"
#import "NSLogCell.h"
#import "LogCellPopView.h"
#import "LogOutLineView.h"

@interface LogViewController ()<NSOutlineViewDelegate,NSOutlineViewDataSource>
{
    IBOutlet LogOutLineView *_outLineView;
    IBOutlet NSScrollView *_scrollView;
    NSPopover *_popover;
    NSUInteger _selectRow;
}

@end

@implementation LogViewController

- (void)dealloc
{
    [App_Delegate setLogWindowController:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _outLineView = nil;
}

- (void)windowWillClose:(NSNotification *)notification
{
    [App_Delegate setLogWindowController:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _outLineView = nil;
    [NSApp stopModalWithCode:0];
}

- (void)windowDidLoad {
    [super windowDidLoad];
    [App_Delegate setLogWindowController:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectOutView:) name:APP_EVENT_LOG_OUTLINEVIEW_MOUSEDONW object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popAction1:) name:APP_EVENT_POP_ACTION_1 object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popAction2:) name:APP_EVENT_POP_ACTION_2 object:nil];
    _outLineView.delegate = self;
    _outLineView.dataSource = self;
    [self reloadData];
}

//- (void)windowDidResize:(NSNotification *)notification
//{
//    [self reloadData];
//}

- (void)reloadData
{
    [_outLineView reloadData];
    if (_scrollView.documentView.frame.size.height > _scrollView.frame.size.height) {
        NSView *contentView = [_scrollView contentView];//就是NSClipView
        [contentView scrollPoint:CGPointMake(0, (_scrollView.documentView.frame.size.height - _scrollView.frame.size.height + 10))];
    }
}

- (void)addLog
{
    [_outLineView insertItemsAtIndexes:[NSIndexSet indexSetWithIndex:App_Delegate.logArr.count-1] inParent:nil withAnimation:NSTableViewAnimationEffectFade];
    if (_scrollView.documentView.frame.size.height > _scrollView.frame.size.height) {
        NSView *contentView = [_scrollView contentView];//就是NSClipView 大小固定   documentView size变化
//        NSLog(@"%@   %@",NSStringFromRect(_scrollView.documentView.frame),NSStringFromRect(contentView.frame));
        [contentView scrollPoint:CGPointMake(0, (_scrollView.documentView.frame.size.height - _scrollView.frame.size.height + 10))];
    }
}

- (void)selectOutView:(NSNotification *)n
{
    NSDictionary *dic = n.object;
    NSUInteger row = [[dic objectForKey:@"row"] integerValue];
    [self selectRow:row];
}

- (void)selectRow:(NSUInteger)row
{
    [self createPopover];
    
    NSView *rowView = [_outLineView rowViewAtRow:row makeIfNecessary:NO];
    NSRect frame = rowView.frame;
    frame.origin.x = frame.origin.y = 0;
    [_popover showRelativeToRect:frame ofView:rowView preferredEdge:NSMaxYEdge];
    
    _selectRow = row;
}

- (void)createPopover
{
    if (_popover == nil)
    {
        _popover = [[NSPopover alloc] init];
        _popover.contentViewController = [[LogCellPopView alloc] initWithNibName:@"LogCellPopView" bundle:nil];
        _popover.animates = NO;
        _popover.behavior = NSPopoverBehaviorTransient;
    }
}

- (void)popAction1:(NSNotification *)n
{
    [_popover close];
    NSString *info = [App_Delegate.logArr objectAtIndex:_selectRow];
    [App_Delegate addStrToPasteboard:info];
}

- (void)popAction2:(NSNotification *)n
{
    [_popover close];
    [App_Delegate.logArr removeObjectAtIndex:_selectRow];
    [_outLineView removeItemsAtIndexes:[NSIndexSet indexSetWithIndex:_selectRow] inParent:nil withAnimation:NSTableViewAnimationSlideRight];
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
    // indentation 缩近距离
    NSLogCell *cell = [[NSLogCell alloc] initWithNibName:@"NSLogCell" bundle:nil];
    [cell view];
    [cell setLog:item];
    return cell.view;
}
- (CGFloat)outlineView:(NSOutlineView *)outlineView heightOfRowByItem:(id)item
{
    CGFloat h = [NSLogCell cellHeightWithItem:item windowFrame:self.window.frame];
    return h;
}
#pragma mark NSOutline Drag

//- (void)outlineView:(NSOutlineView *)outlineView draggingSession:(NSDraggingSession *)session willBeginAtPoint:(NSPoint)screenPoint forItems:(NSArray *)draggedItems
//{
//    
//}
//- (void)outlineView:(NSOutlineView *)outlineView draggingSession:(NSDraggingSession *)session endedAtPoint:(NSPoint)screenPoint operation:(NSDragOperation)operation
//{
//    
//}

//- (id <NSPasteboardWriting>)outlineView:(NSOutlineView *)outlineView pasteboardWriterForItem:(id)item
//{
//    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//    pasteboard.string = attributedLabel.text;
//    if ([item isKindOfClass:[LessonSeries class]])
//    {
//        return [[NSPasteboardItem alloc] init];
//    }
//    else
//    {
//        return nil;
//    }
//    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
//    [pasteboard setString:(NSString *)item forType:NSGeneralPboard];
//    NSPasteboardItem *pItem = [[NSPasteboardItem alloc] init];
//    [pItem setString:(NSString *)item forType:NSPasteboardTypeString];
//    return pItem;
//    return nil;
//}

//- (NSDragOperation)outlineView:(NSOutlineView *)outlineView validateDrop:(id <NSDraggingInfo>)info proposedItem:(id)item proposedChildIndex:(NSInteger)index
//{
//    if (index >= 0)
//    {
//        return NSDragOperationMove;
//    }
//    else
//    {
//        return NSDragOperationNone;
//    }
//}
//
//- (BOOL)outlineView:(NSOutlineView *)outlineView acceptDrop:(id <NSDraggingInfo>)info item:(id)item childIndex:(NSInteger)index
//{
//    if (index >= 0)
//    {
//        return YES;
//    }
//    
//    return NO;
//}



@end
