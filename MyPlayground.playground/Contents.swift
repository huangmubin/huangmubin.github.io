//: Playground - noun: a place where people can play

import Cocoa

let draftPath = "/Users/Myron/职业生涯文档/huangmubin.github.io/Draft.html"
let file = File()
func readFile(draftPath: String) -> String? {
    guard let fileData = NSData(contentsOfFile: draftPath) else { return nil }
    guard let fileStr = NSString(data: fileData, encoding: NSUTF8StringEncoding) as? String else { return nil }
    return fileStr
}



print(readFile(draftPath))
