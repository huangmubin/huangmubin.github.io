import Foundation


// MARK: - 爬虫
func WebCrawler() {
    let filePath = "/Users/Myron/Desktop/Swifter - Swift 必备 tips.html"
    // 获取全部网页 Url
    let rootUrl = "http://swifter.tips"
    let start = "| Swifter\" href=\""
    let end = "\">"
    
    guard let request = NSURL(string: rootUrl) else { return }
    guard let data = NSData(contentsOfURL: request) else { return }
    guard let html = NSString(data: data, encoding: NSUTF8StringEncoding) as? String else { return }
    let scanner = NSScanner(string: html)
    
    var urls = [String]()
    var urlContainer: NSString?
    while !scanner.atEnd {
        scanner.scanUpToString(start, intoString: nil)
        if scanner.scanUpToString(end, intoString: &urlContainer) {
            urls.append(urlContainer!.stringByReplacingOccurrencesOfString(start, withString: rootUrl))
        }
    }
    
    // 进行爬取
    let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    let group = dispatch_group_create()
    
    for url in urls {
        dispatch_group_async(group, queue, {
            if let request = NSURL(string: url) {
                if let data = NSData(contentsOfURL: request) {
                    if data.writeToFile("\(filePath)\(url.substringWithRange(Range(rootUrl.endIndex ..< url.endIndex.predecessor())))", atomically: true) {
                        print("\(url) is Ok")
                    } else {
                        print("\(url) is Fail")
                    }
                }
            }
        })
    }
    
    dispatch_group_notify(group, queue) {
        print("文件写入结束")
    }
}

