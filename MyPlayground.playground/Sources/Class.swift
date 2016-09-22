import Foundation

// MARK: - Blog Tool Info

public class BlogTool: NSObject {
    public var infos: (folder: String, index: String, file: String) = ("","","")
    public var path: (home: String, draft: String, index: String, save: String) = ("","","","")
    public var tips: [String] = []
    public var name: String = ""
    
    public var blog: String = ""
    
    
    // MARK: 解析地址
    public func inputAnalysis(input: String) -> Bool {
        if let range = regex(input, pattern: "huangmubin.github.io") {
            path.home = input.sub(0, end: range.location + range.length)
            path.draft = input
            return true
        }
        return false
    }
    
    // MARK: 解析草稿文档并保存到相应位置
    public func draftAnalysis() -> Bool {
        if let text = readFile(path.draft) {
            // 解析头
            infos = ("","","")
            name.removeAll(keepCapacity: true)
            tips.removeAll(keepCapacity: true)
            
            var level = 0
            var tip = ""
            for c in text.characters {
                switch level {
                case 0:
                    if c == "\n" {
                        level = 1
                    }
                case 1:
                    if c == "\n" {
                        level = 2
                    } else {
                        infos.folder.append(c)
                    }
                case 2:
                    if c == "\n" {
                        level = 3
                    } else {
                        infos.index.append(c)
                    }
                case 3:
                    if c == "\n" {
                        level = 4
                    } else {
                        infos.file.append(c)
                    }
                case 4:
                    if c == "\n" {
                        level = 5
                    } else {
                        name.append(c)
                    }
                case 5:
                    if c == "\n" {
                        level = 6
                    } else if c == "#" {
                        tips.append(tip)
                        tip.removeAll(keepCapacity: true)
                    } else {
                        tip.append(c)
                    }
                case 6:
                    // 拼接路径
                    path.index = path.home + "/" + infos.folder + "/" + infos.index
                    path.save = path.home + "/" + infos.folder + "/" + infos.file
                    
                    // 修改和保存
                    if let range = regex2(text, pattern: "<title>Myron Blog</title>"), let link = regex2(text, pattern: "<a id=\"The Index File\" href=\"\"></a>") {
                        blog.removeAll(keepCapacity: true)
                        blog = text.sub(0, end: range.start)
                        blog += "<title>\(name)</title>"
                        blog += text.sub(range.end, end: link.start)
                        blog += "<a id=\"The Index File\" href=\"\(infos.index)\">Back</a>"
                        blog += text.sub(link.end, end: text.characters.count)
                        return saveFile(blog, path: path.save)
                    } else {
                        return false
                    }
                default:
                    return false
                }
            }
        }
        return false
    }
    
    // MARK: 解析目录文件并进行更新
    public func indexAnalysis() -> Bool {
        if let text = readFile(path.index) {
            var update = ""
            if let range = regex2(text, pattern: "<!-- -Add- -->") {
                update = text.sub(0, end: range.start)
                update += "<p><a id=\"\(infos.file)\" href=\"\(infos.file)\">\(name)</a><p>\n\n<!-- -Add- -->"
                update += text.sub(range.end, end: text.characters.count)
                
                return saveFile(update, path: path.index)
            }
        }
        return false
    }
    
    // MARK: 解析现有 Tips 记录获取
}

// MARK: - 文件

public func readFile(path: String) -> String? {
    if let data = NSData(contentsOfFile: path) {
        if let text = NSString(data: data, encoding: NSUTF8StringEncoding) as? String {
            return text
        }
    }
    return nil
}

public func saveFile(text: String, path: String) -> Bool {
    if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
        return data.writeToFile(path, atomically: true)
    } else {
        return false
    }
}

// MARK: - 正则表达

public func regex2(text: String, pattern: String) -> (start: Int, end: Int)? {
    if let regular = try? NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive) {
        let result = regular.rangeOfFirstMatchInString(text, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, text.characters.count))
        return (result.location, result.location + result.length)
    }
    return nil
}

public func regex(text: String, pattern: String) -> NSRange? {
    if let regular = try? NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive) {
        let result = regular.rangeOfFirstMatchInString(text, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, text.characters.count))
        return result
    }
    return nil
}

// MARK: - 字符串扩展

public extension String {
    func sub(start: Int, end: Int) -> String {
        return self.substringWithRange(self.startIndex.advancedBy(start) ..< self.startIndex.advancedBy(end))
    }
}