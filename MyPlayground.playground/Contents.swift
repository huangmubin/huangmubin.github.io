//: Playground - noun: a place where people can play

import Cocoa

let input = "/Users/Myron/MyronCodeNote/huangmubin.github.io/Draft.html"
let blogTool = BlogTool()

// 解析地址
if !blogTool.inputAnalysis(input) {
    print("\(blogTool.path.home) - \(blogTool.path.draft)")
}

// 解析 Draft.html 并保存
if !blogTool.draftAnalysis() {
    print("blogTool.draftAnalysis()")
}
    print(blogTool.name)
    print(blogTool.path)

// 给目录文档插入新条目并更新


print("Done")

//<!--
//    LifeNotes/LifeNotes.html
//LifeNotes/2016-07-09_测试.html
//测试#
//-->


//let draftPath = "/Users/Myron/职业生涯文档/huangmubin.github.io/Draft.html"
//let draftPath = "/Users/Myron/MyronCodeNote/huangmubin.github.io/Draft.html"
//let homePath = "/Users/Myron/MyronCodeNote/huangmubin.github.io/"
/*
 获取 Draft.html 文件
 解析 Draft.html 中的 头 <!-- --> 中的内容
    格式：第一个 \n 之后是目录文件；第二个 \n 之后是保存地址；第三个 \n 之后，如果有 # 号，则前面是 Tip。第四个 \n 表示结束。
 保存 Draft.html
 读取 目录文件
 查找 <!--Add--> 位置
 将其替换成 <p><a id=\"\(file.name)\" href=\"\(file.index)\">\(file.name)</a></p>\n\n<!--Add-->
 保存目录文件
 打开 tip
 */





//
//let file = File()
//
//func readFile(draftPath: String) -> String? {
//    guard let fileData = NSData(contentsOfFile: draftPath) else { return nil }
//    guard let fileStr = NSString(data: fileData, encoding: NSUTF8StringEncoding) as? String else { return nil }
//    return fileStr
//}
//
////
//if let note = readFile(draftPath) {
//    file.note = note
//}
//
////
//func takeInfo(file: File) {
//    var index = ""
//    var tips = ""
//    var save = ""
//    var type = 0
//    for c in file.note.characters {
//        switch type {
//        case 0:
//            if c == "\n" {
//               type = 1
//            }
//        case 1:
//            if c == "\n" {
//                type = 2
//                file.index = index
//            } else {
//                index.append(c)
//            }
//        case 2:
//            if c == "\n" {
//                type = 3
//                file.savePath = save
//            } else {
//                save.append(c)
//            }
//        case 3:
//            if c == "\n" {
//                file.name = file.savePath.substringFromIndex(file.savePath.startIndex.advancedBy(10))
//                return
//            } else if c == "#" {
//                file.tips.append(tips)
//                tips.removeAll(keepCapacity: true)
//            } else {
//                tips.append(c)
//            }
//        default:
//            break
//        }
//    }
//}
//
//// 
//takeInfo(file)
//
//print(file.index)
//print(file.tips)
//
//func saveFile(file: File, home: String) -> Bool {
//    if let data = file.note.dataUsingEncoding(NSUTF8StringEncoding) {
//        return data.writeToFile(home + file.savePath, atomically: true)
//    } else {
//        return false
//    }
//}
//func saveString(note: String, path: String) -> Bool {
//    if let data = note.dataUsingEncoding(NSUTF8StringEncoding) {
//        return data.writeToFile(path, atomically: true)
//    } else {
//        return false
//    }
//}
//
//saveFile(file, home: homePath)
//
//// 
//func addLink(file: File, linkNote: String, path: String) -> Bool {
//    var type = 0
//    var note = linkNote
//    var tip = ""
//    //<p><a id="" href="https://guides.github.com/features/mastering-markdown/"></a></p>
//    let inset = "<p><a id=\"\(file.name)\" href=\"\(file.index)\">\(file.name)</a></p>"
//    note.removeAll(keepCapacity: true)
//    for c in linkNote.characters {
//        switch type {
//        case 0:
//            if c == "<" {
//                type = 1
//                tip.append(c)
//            } else {
//                note.append(c)
//            }
//        case 1:
//            if c == "!" {
//                type = 2
//                tip.append(c)
//            } else {
//                for t in tip.characters {
//                    note.append(t)
//                }
//                tip.removeAll(keepCapacity: true)
//                type = 0
//            }
//        case 2:
//            if c == "-" {
//                type = 3
//                tip.append(c)
//            } else {
//                for t in tip.characters {
//                    note.append(t)
//                }
//                tip.removeAll(keepCapacity: true)
//                type = 0
//            }
//        case 3:
//            if c == "-" {
//                type = 4
//                tip.append(c)
//            } else {
//                for t in tip.characters {
//                    note.append(t)
//                }
//                tip.removeAll(keepCapacity: true)
//                type = 0
//            }
//        case 4:
//            if c == "A" {
//                type = 5
//                tip.append(c)
//            } else {
//                for t in tip.characters {
//                    note.append(t)
//                }
//                tip.removeAll(keepCapacity: true)
//                type = 0
//            }
//        case 5:
//            if c == "d" {
//                type = 6
//                tip.append(c)
//            } else {
//                for t in tip.characters {
//                    note.append(t)
//                }
//                tip.removeAll(keepCapacity: true)
//                type = 0
//            }
//        case 6:
//            if c == "d" {
//                type = 7
//                tip.append(c)
//            } else {
//                for t in tip.characters {
//                    note.append(t)
//                }
//                tip.removeAll(keepCapacity: true)
//                type = 0
//            }
//        case 7:
//            if c == "-" {
//                type = 8
//                tip.append(c)
//            } else {
//                for t in tip.characters {
//                    note.append(t)
//                }
//                tip.removeAll(keepCapacity: true)
//                type = 0
//            }
//        case 8:
//            if c == "-" {
//                type = 9
//                tip.append(c)
//            } else {
//                for t in tip.characters {
//                    note.append(t)
//                }
//                tip.removeAll(keepCapacity: true)
//                type = 0
//            }
//        case 9:
//            if c == ">" {
//                type = 10
//                tip.append(c)
//                for t in inset.characters {
//                    note.append(t)
//                }
//                for t in tip.characters {
//                    note.append(t)
//                }
//            } else {
//                for t in tip.characters {
//                    note.append(t)
//                }
//                tip.removeAll(keepCapacity: true)
//                type = 0
//            }
//        default:
//            note.append(c)
//        }
//    }
//    return saveString(note, path: path)
//}
//
//if let indexNote = readFile(homePath + file.index) {
//    print(addLink(file, linkNote: indexNote, path: homePath + file.index))
//}
//print("Done")

