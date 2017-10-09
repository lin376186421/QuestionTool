//
//  FFJKBDQuestionItem.m
//  333
//
//  Created by PageZhang on 16/1/15.
//  Copyright © 2016年 Chelun. All rights reserved.
//

#import "FFJKBDQuestionItem.h"

@implementation FFJKBDQuestionItem
+ (BOOL)AUTOINCREMENT {
    return YES;
}
+ (NSString *)tableName {
    return @"t_question";
}
// 仅用于对照数据关系，不参与使用
+ (FFOrderedDictionary *)versions {
    static FFOrderedDictionary *versions = nil;
    if (versions == nil) {
        FFOrderedDictionary *version0 = [FFOrderedDictionary new];
        [version0 setObject:@"INTEGER" forKey:@"question_id"];
        [version0 setObject:@"INTEGER" forKey:@"media_type"];
        [version0 setObject:@"INTEGER" forKey:@"chapter_id"];
        [version0 setObject:@"TEXT"    forKey:@"label"];
        [version0 setObject:@"BLOB"    forKey:@"question"];
        [version0 setObject:@"BLOB"    forKey:@"media_content"];
        [version0 setObject:@"INTEGER" forKey:@"media_width"];
        [version0 setObject:@"INTEGER" forKey:@"media_height"];
        [version0 setObject:@"INTEGER" forKey:@"answer"];
        [version0 setObject:@"TEXT"    forKey:@"option_a"];
        [version0 setObject:@"TEXT"    forKey:@"option_b"];
        [version0 setObject:@"TEXT"    forKey:@"option_c"];
        [version0 setObject:@"TEXT"    forKey:@"option_d"];
        [version0 setObject:@"TEXT"    forKey:@"option_e"];
        [version0 setObject:@"TEXT"    forKey:@"option_f"];
        [version0 setObject:@"TEXT"    forKey:@"option_g"];
        [version0 setObject:@"TEXT"    forKey:@"option_h"];
        [version0 setObject:@"BLOB"    forKey:@"explain"];
        [version0 setObject:@"INTEGER" forKey:@"difficulty"];
        [version0 setObject:@"DOUBLE"  forKey:@"wrong_rate"];
        [version0 setObject:@"INTEGER" forKey:@"option_type"];
        
        versions = [FFOrderedDictionary new];
        [versions setObject:version0 forKey:@(0)];
    }
    return versions;
}

- (void)setupConfig:(NSDictionary *)jsonDict {
    // 多媒体内容
    self.media_content = [jsonDict objectForKey:@"media_content"];
    switch (self.media_type) {
        case 0: break;
        case 1:
        {
//            self.media_content = [GTMBase64 encodeData:self.media_content];
            self.media = [NSString stringWithFormat:@"%d.jpg", self.question_id];
//            NSMutableData *mData = [self.media_content mutableCopy];
//            mData.bytes[0] = 0xff;
        }
            break;
        case 2: self.media = [NSString stringWithFormat:@"%d.mp4", self.question_id]; break;
        default:
            NSLog(@"#############警告###############media_type = %zd", self.media_type);
            break;
    }
    
    // 转换答案
    const NSArray *vs = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H"];
    NSString *str = @"";
    int v = self.answer/16;
    for (int i=0; i<vs.count; i++) {
        if (v & (int)pow(2, i)) {
            str = [str stringByAppendingString:vs[i]];
        }
    }
    self.answer_char = str;
    
    static NSMutableArray *chapterIds = nil;

    if (!chapterIds) {
        chapterIds = [NSMutableArray array];
    }
    
    // 转换章节
    switch (self.chapter_id) {
            // 科一小车、客车、货车
        case 121:
        case 122:
        case 123:
        case 124: {
            self.course = 1;
            self.cert_type = 1 + 2 + 4;
            self.chapter_id = self.chapter_id-120;
        } break;
            // 科一客车
        case 125: {
            self.course = 1;
            self.cert_type = 2;
            self.chapter_id = 5;
        } break;
            // 科一货车
        case 126: {
            self.course = 1;
            self.cert_type = 4;
            self.chapter_id = 6;
        } break;
            // 科三小车
        case 127:
        case 128:
        case 129:
        case 130:
        case 131:
        case 132:
        case 133: {
            self.course = 3;
            self.cert_type = 1;
            self.chapter_id = self.chapter_id-126;
        } break;
            
            // 科三客车、货车
        case 134:
        case 135:
        case 136:
        case 137:
        case 138:
        case 139:
        case 140: {
            self.course = 3;
            self.cert_type = 2 + 4;
            self.chapter_id = self.chapter_id-133;
        } break;
            
            // 摩托车
        case 207:
        case 208:
        case 209:
        case 210: {
            if (self.chapter_id == 208) {
                self.course = 3;
            } else {
                self.course = 1;
            }
            self.cert_type = 8;
            self.chapter_id = self.chapter_id-206;
        } break;
            
            // 客运
        case 173:
        case 174:
        case 175:
        case 176:
        case 177: {
            self.course = 1;
            self.cert_type = 128;
            self.chapter_id = self.chapter_id-172;
        } break;
            
            // 货运
        case 178:
        case 179:
        case 180:
        case 181:
        case 182: {
            self.course = 1;
            self.cert_type = 32;
            self.chapter_id = self.chapter_id-177;
        } break;
            
            // 危险品
        case 200:
        case 201:
        case 202:
        case 203:
        case 204: {
            self.course = 1;
            self.cert_type = 256;
            self.chapter_id = self.chapter_id-199;
        } break;
            
            // 教练
        case 183:
        case 184:
        case 185:
        case 186:
        case 187:
        case 188:
        case 189:
        case 190:
        case 191:
        case 192:
        case 193:
        case 194:
        case 195:
        case 196:
        case 197:
        case 198:
        case 199:
        case 211: {
            self.course = 1;
            self.cert_type = 64;
            self.chapter_id = self.chapter_id-182;
        } break;
            
            // 出租车
        case 212:
        case 213:
        case 214:
        case 215:
        case 216:
        case 217:
        case 218:
        case 219: {
            self.course = 1;
            self.cert_type = 16;
            self.chapter_id = self.chapter_id-211;
        } break;
            
        case 205: {
            // 福州科一
            self.course = 1;
            self.cert_type = 1;
            self.chapter_id = 103;
        } break;
        case 206: {
            // 福州科四
            self.course = 3;
            self.cert_type = 1;
        } break;
        case 220: {
            // 武汉
            self.course = 1;
            self.cert_type = 1;
            self.chapter_id = 102;
        } break;
        case 221:
        case 222: {
            // 上海 + 快处易赔
            self.course = 1;
            self.cert_type = 1;
            self.chapter_id = 101;
        } break;
        case 223:
        {
            //宿迁 客运
            self.course = 1;
            self.cert_type = 128;
            self.chapter_id = 201;
        }break;
        case 224: {
            //宿迁 货运
            self.course = 1;
            self.cert_type = 32;
            self.chapter_id = 202;
        } break;
        case 225:
        {
            //四川货运
            self.course = 1;
            self.cert_type = 32;
            self.chapter_id = 203;
        }
            break;
        case 226:
        {
            //网约车
            self.course = 1;
            self.cert_type = 512;
        }
            break;
        case 227:
        case 228:
        case 229:
        case 230:
        case 231:
        case 232:
        case 233:
        case 234:
        {
            //网约车 和出租车 相同， 我们不需要
        }
            break;
        case 235:
        {
            //济南题 小车 科一
            self.course = 1;
            self.cert_type = 1;
            self.chapter_id = 104;
        }
            break;
        case 270:
        {
            //北京题 小车 科四
            self.course = 3;
            self.cert_type = 1;
            self.chapter_id = 105;
        }
            break;
        case 271:
        {
            //四川题 小车 科一
            self.course = 1;
            self.cert_type = 1;
            self.chapter_id = 106;
        }
            break;
        default:
        {
            if (![chapterIds containsObject:@(self.chapter_id)]) {
                [chapterIds addObject:@(self.chapter_id)];
                NSLog(@"新增 chapter_id = %zd", self.chapter_id);
            }
        }
            break;
    }
}

@end

@implementation FFJKBDKnowledgeItem

+ (BOOL)AUTOINCREMENT {
    return YES;
}
+ (NSString *)tableName {
    return @"t_dictionary";
}

- (void)setupConfig:(NSDictionary *)jsonDict
{
    NSLog(@"%@", jsonDict);
}

// 仅用于对照数据关系，不参与使用
+ (FFOrderedDictionary *)versions {
    static FFOrderedDictionary *versions = nil;
    if (versions == nil) {
        FFOrderedDictionary *version0 = [FFOrderedDictionary new];
        [version0 setObject:@"TEXT" forKey:@"name"];
        [version0 setObject:@"BLOB" forKey:@"value"];
        [version0 setObject:@"TEXT" forKey:@"groups"];
        versions = [FFOrderedDictionary new];
        [versions setObject:version0 forKey:@(0)];
    }
    return versions;
}

@end

@implementation FFJKBDKnowledgeIdItem

+ (instancetype)itemFromResultSet:(FMResultSet *)rs
{
    FFJKBDKnowledgeIdItem *item = [FFJKBDKnowledgeIdItem new];
    item.question_id = [rs intForColumnIndex:1];
    item.knowledge_id = [rs intForColumnIndex:2];
    return item;
}

@end
