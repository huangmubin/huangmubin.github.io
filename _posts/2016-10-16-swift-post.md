---
layout: post
title: "Swift 3.0"
description: "记录 Swift 3.0 的笔记"
date: 2016-10-16
tags: [Swift]
comments: true
share: false
---

[TOC]

# 基础知识

* 类型
* 常量和变量
* 输出
* 注释
* 分号
* 数值型字面量
* 类型别名
* 元组
* 可选类型
* 错误处理

---

## 类型

> Swift 基础类型以及集合类型都是值类型。

* 基础类型
    * Int (Int8, Int16, Int32, Int64, UInt...)
    * Double (Float)
    * Bool
    * String (Character)
* 集合类型
    * Array
    * Set
    * Dictionary
* 元组 (Tuple)
    * (,)
* 可选类型
    * nil

## 常量和变量

> Swift 带有类型推断功能，属性的类型可以注明，也可以通过初始值推断。

* 常量: let \<name>: \<type> = \<value>
* 变量: var \<name>: \<type>\<!,? or noting> = \<value>

## 输出

```
public func print(_ items: Any..., separator: String = default, terminator: String = default)
```

## 注释

```
// 单行注释内容
/// 带 Xcode 代码提示的单行注释内容

/*
    多行注释内容
 */
/**
    带 Xcode 代码提示的多行注释内容
 */
```

## 分号

Swift 不强制要求使用分号，但是也可以使用，比如在同一行内些多条独立语句的时候。

## 数值型字面量

* 十进制数，没有前缀
* 二进制数，前缀是0b
* 八进制数，前缀是0o
* 十六进制数，前缀是0x

```
let decimalInteger = 17
let binaryInteger = 0b10001       // 17 in binary notation
let octalInteger = 0o21           // 17 in octal notation
let hexadecimalInteger = 0x11     // 17 in hexadecimal notation

let paddedDouble = 000123.456      // 123.456
let oneMillion = 1_000_000         // 1000000
let justOverOneMillion = 1_000_000.000_000_1 // 1000000.0000001
```

## 类型别名

```
// typealias <New Type Name> = <Old Type Name>
typealias AudioSample = UInt16
```

## 元组 (Tuples)

把多个值组合成为一个复合值，元组内部的值可以是任意类型，不要求是相同类型。

```
let http404Error = (404, "Not Found")
// http404Error 的类型是 (Int, String)，值是 (404, "Not Found")

let (statusCode, statusMessage) = http404Error
print("The status code is \(statusCode)")
// 输出 "The status code is 404"
print("The status message is \(statusMessage)")
// 输出 "The status message is Not Found"

let (justTheStatusCode, _) = http404Error
print("The status code is \(justTheStatusCode)")
// 输出 "The status code is 404"

print("The status code is \(http404Error.0)")
// 输出 "The status code is 404"
print("The status message is \(http404Error.1)")
// 输出 "The status message is Not Found"

let http200Status = (statusCode: 200, description: "OK")

print("The status code is \(http200Status.statusCode)")
// 输出 "The status code is 200"
print("The status message is \(http200Status.description)")
// 输出 "The status message is OK"
```

## 可选类型 (optional)

使用 ? 和 ! 来表示可选类型。? 表示使用的时候可能为 nil, ! 表示使用的时候自动解包。

## 错误处理 (error handing)

```
// 定义可能报错的函数
func canThrowAnError() throws {
    
}

// 调用该函数
do {
    try canThrowAnError()
    // 没有错误抛出
} catch {
    // 有错误抛出
}
```

## 断言

```
// 当 condition 为 true 则不会触发断言，否则就触发。
public func assert(_ condition: @autoclosure () -> Bool, _ message: @autoclosure () -> String = default, file: StaticString = #file, line: UInt = #line)
```

---

---

# 运算符 (Operators)

* 基本运算符
* 高级运算符

## 基本运算符 (Basic Operators)

* 赋值运算符 ( = )
* 正负号运算符 ( -, + )
* 算术运算符 ( +, -, *, /, % )
* 组合运算符 ( +=, -=, *=, /=, %= )
* 三元运算符 ( <条件> ? <true 返回值> : <false 返回值> )
* 比较运算符 ( \==, !=, >, <, >=, <=, =\==, !== )
* 空值运算符 ( \<可选类型> ?? \<假如可选类型为空时的返回值> )
* 区间运算符 ( ..., ..< )
* 逻辑运算符 ( !, &&, || )

> Swift 中可以对浮点数进行求余运算。

---

## 高级运算符 (Advanced Operators)

* 位运算符 ( 反:~  与:&  或:|  异或:^  左移:<<  右移:>>)
* 溢出运算符: 正常情况下整数溢出 Swift 会报错，如果想要不进行报错，而是采取截断处理，可以使用溢出运算符进行加减乘法运算 ( 溢出加法:&+  溢出减法:&-  溢出乘法:&* )
* 优先级和结合性: [苹果官方文档 Swift Standard Library Operators](https://developer.apple.com/reference/swift/1851035-swift_standard_library_operators#//apple_ref/doc/uid/TP40016054)
* 运算符函数: 与普通函数的差别在于函数名换成了运算符而且只有一到两个参数。
* 自定义运算符: 
    * 自定义运算符可定义在全局，或类型当中，当定义在类型当中时必须使用该类型作为参数之一。
    * 自定义运算符有 ( prefix:前缀  infix:中缀  postfix:后缀  )
    * 自定义默认优先级会比 Ternary 分组要高 (所以是 Logical disjunction 分组?)

```
// 位运算符
    // 按位反运算 ( 0 1 交换 )
    let bits: UInt8 =  0b00001111
    ~bits           // 0b11110000
    
    // 按位与运算 ( 都是 1 才为 1 )
    let bitsA: UInt8 =  0b11111100
    let bitsB: UInt8 =  0b00111111
    bitsA & bitsB    // 0b00111100
    
    // 按位或运算 ( 有一个 1 则为 1)
    let bitsA: UInt8 =  0b10110010
    let bitsB: UInt8 =  0b01011110
    bitsA | bitsB    // 0b11111110
    
    // 按位异或运算符 ( 只有 1 个是 1 时为 1 )
    let bitsA: UInt8 =  0b00010100
    let bitsB: UInt8 =  0b00000101
    bitsA ^ bitsB    // 0b00010001
    
    // 按位左移、右移运算符
    let bits: UInt8 = 4 // 00000100
    bits << 1           // 00001000
    bits << 2           // 00010000
    bits << 5           // 10000000
    bits << 6           // 00000000
    bits >> 2           // 00000001
    
// 自定义运算符以及运算符函数
    <prefix / infix / postfix> operator <运算符>: <优先级，或为空则默认级别>
    static func <运算符>(left: <Type>, right: <Type>) -> <Type> {
        ...
    }
    
    struct Vector2D {
        var x = 0.0, y = 0.0
    }
    
    extension Vector2D {
        static func + (left: Vector2D, right: Vector2D) -> Vector2D {
            return Vector2D(x: left.x + right.x, y: left.y + right.y)
        }
    }
    
    infix operator +-: AdditionPrecedence
    
    extension Vector2D {
        static func +- (left: Vector2D, right: Vector2D) -> Vector2D {
            return Vector2D(x: left.x + right.x, y: left.y - right.y)
        }
    }
    
    let firstVector = Vector2D(x: 1.0, y: 2.0)
    let secondVector = Vector2D(x: 3.0, y: 4.0)
    let plusMinusVector = firstVector +- secondVector
```

---

---

# 字符串与字符

> 字符串是 struct 类型

```
// 字符
    let <name>: Character = "!"

// 初始化
    var <name>: String = String()
    var <name>: String = "Some String \(<value>) Other String"

// 字符串常用操作
    /*
        * 运算符 ( +, += )
        * 函数操作 ( append(), insert(), remove(), removeSubrange() )
        * 获取字符及字符数量 ( String.characters, String.characters.count )
    */

// Unicode
    /*
        * 转义字符
            * \0(空字符)    \\(反斜线)    \t(水平制表符)
            * \n(换行符)    \r(回车符)    \"(双引号)    \'(单引号)
        * Unicode 标量
            * \u{任意一到八位十六进制数且可用的 Unicode 位码}
    */

// String.Index 字符串索引
    let test = "This is a long String, and is end!"
                ^                                 ^
                test.startIndex                   test.endIndex
    // * 利用下标访问字符串
    test[test.startIndex]                       // T
    test[test.index(before: test.endIndex)]     // !
    test[test.index(after: test.startIndex)]    // h
    test[test.index(test.index, offsetBy: 5)]   // s
    test[test.endIndex]                         // 错误
    test.index(after: test.endIndex)            // 错误
    test[test.startIndex ..< test.index(test.startIndex, offsetBy: 6)] // This i

    // * 遍历下标
    for index in test.characters.indices {
        print(test[index])
    }
    // This is a long String, and is end!
```

---

---


# 集合类型

* Arrays
* Sets
* Dictionaries 

> Swift 中集合类型都是泛型
> 集合类型的数据类型必须明确

## Array<Element>

```
// 创建
    var <name>: [<type>] = [Type](repeating: <init value>, count: <number>)

// 访问
    <array>[<index>]
    <array>[<Range>]

// 常用操作
    /*
        * 运算符 ( +, += )
        * 常用属性 ( count, isEmpty )
        * 常用方法 ( append(), insert(), remove(), removeAll(), removeLast(), removeFirst() )
    */

// 遍历
    for value in array {
        /* do some thing */
    }

    for (index, value) in array.enumerate() {
        /* do some thing */
    }
```

---

## Set<Element>

> 集合类型必须遵守 Hashable 协议

```
// 创建
    var <name>: Set<<type>> = Set<<type>>()

// 常用操作
    /*
        * 常用属性 ( count, isEmpty )
        * 常用方法 ( insert(), remove(), removeAll(), removeFirst(), contains() )
    */

// 遍历
    for value in set {
        /* do some thing */
    }

    for (index, value) in set.sorted() {
        /* do some thing */
    }

// 集合操作
    var a: Set<Int> = [1,2,3,4,5]
    var b: Set<Int> = [3,4,5,6,7]
    a.intersection(b)        // [3,4,5]         相交元素
    a.symmetricDifference(b) // [1,2,6,7]       非相交元素
    a.union(b)               // [1,2,3,4,5,6,7] 所有元素
    a.subtracting(b)         // [1,2]           a 中的非相交元素

// 集合运算
    * ==                        // 是否完全一致
    * a.isSubset(of: b)         // a 中的元素 b 是否都有
    * a.isSuperset(of: b)       // b 中的元素 a 是否都有
    * a.isStrictSubset(of: b)   // a 中的元素 b 是否都有，并且 a != b
    * a.isStrictSuperset(of: b) // b 中的元素 a 是否都有，并且 a != b
    * a.isDisjoint(with: b)     // a b 是否没有交集
```

---

## Dictionary<Hashable, Any>

> key 必须遵守 Hashable 协议

```
// 创建
    var <name>: Dictionary<<key type>, <value type>> = Dictionary<<key type>, <value type>>()

// 访问和修改
    <dic>[<key>] = <Any>? // 如果 Any 不为空则是新增或修改 key 值，否则就是删除 key 值。

// 常用操作
    /*
        * 常用属性 ( count, isEmpty )
        * 常用方法 ( updateValue(), remove(), removeValue(), removeAll(), contains() )
    */

// 遍历
    for (key, value) in dic {
        /* do some thing */
    }

    for key in dic.keys.sorted() {
        /* do some thing */
    }

    for value in dic.values.sorted() {
        /* do some thing */
    }
```

---

---

# 控制流

* 循环
* 分支
* 控制转移语句

## 循环

```
// for-in

    for <value or _> in <array like 0 ..< 10, or [1,2,3]> {
        /* do some thing */
    }

// while

    while <条件> {
        /* do some thing */
    }

    repeat {
        
    } while <条件>

```

---

## 分支

```
// if

    if <条件> {
        /* do some thing */
    } else if <条件> {
        /* do some thing */
    } else {
        /* do some thing */
    }

// switch

    switch <值> {
    case <条件>:
        /* do some thing */
    case <条件>:
        /* do some thing */
    default:
        /* do some thing */
    }

    // 各种示例
        let value: Int = 10
        switch value {
        case 0: // 单一匹配
            /* do some thing */
        case 1, 2, 3: // 复合匹配
            /* do some thing */
        case 4 ..< 7: // 区间匹配
            /* do some thing */
        default:
            /* do some thing */
        }

        let tuple: (Int, Int) = (10, 10)
        switch tuple {
        case (0, 0): // 单一匹配
            /* do some thing */
        case (1, 1), (2, 2):            // 复合匹配
            /* do some thing */
        case (3 ..< 5, 4 ..< 6):        // 区间匹配
            /* do some thing */
        case (_, 7), (8, _):            // _ 匹配所有值，表示忽略
            /* do some thing */
        case (let x, 9):                // 忽略并获取 $0 值
            /* do some thing */
        case let (x, y):                // 忽略并获取 $0, $1 值
            /* do some thing */
        case let (x, y) where x == 7:   // 使用 where 添加限定条件
            /* do some thing */
        default: 
            /* do some thing */
        }

// guard

    guard <条件> else {
        <必须有 retrun, continue 等退出条件>
    }

    // 解包
    guard let <value> = <value>? else {
        <必须有 retrun, continue 等退出条件>
    }
```

---

##  控制转移语句

```
// continue 跳过当前循环中的后面部分，直接进入下一次循环

// break 跳出当前的循环

// return 退出当前的函数

// fallthrough switch 语句中使用，让某个 case 可以进入下一个 case.

// throw 错误抛出

// 循环标签

    <name>: while <条件> {
        /* do some thing */
        <name2>: while <条件> {
            /* do some thing */
            break name // 直接退出 name 循环
        }
    }

// Api 检查

    if #available(<platform name> <version>, <...>, *) {
        // statements to execute if the APIs are available
    } else {
        // fallback statements to execute if the APIs are unavailable
    }

    if #available(iOS 10, macOS 10.12, *) {
        /* iOS 使用 iOS 10 的 API, macOS 使用 macOS 10.12 的 API */
    } else {
        /* 其他版本的 Api */
    }

```

---

---

# 函数与闭包及其调用

* 函数
* 闭包
* 可选链

## 函数

函数定义: func \<name>(<参数外部名> <参数内部名>: \<inout> <参数类型> = <默认值> <可变参数 ...>) -> <返回值类型>

函数类型: (<参数类型>...) -> <返回值参数>

嵌套函数: 函数中可以定义函数，该函数只有在函数内部有效。

---

## 闭包

闭包是自包含的代码库，可以在代码中被传递和使用。闭包可以捕获和存储其所在上下文中任意的常量和变量来使用，所以会导致引用计数 +1 从而有循环引用的风险。

全局函数是一个有名字但不会捕获任何值的闭包。嵌套函数是有名字并可以捕获函数内值的闭包。闭包表达式一般都是匿名闭包。

单表达式的闭包可以省略 retrun 关键字。

闭包内的参数在未定义的情况下可以使用 \$0 来对参数名称进行缩写，\$0 表示第一个参数， $1 表示第二个参数，以此类推。

闭包是引用类型的值。

@noescape 表示非逃逸闭包，限定了闭包的生命周期只能存在于当前函数当中。

@autoclosure 表示自动闭包，这种闭包不接受参数，并且由返回值。用于传递作为参数的表达式，并可以省略花括号。自动闭包都默认带了 noescape 属性，如果想要声明为可逃逸闭包则是 @autoclosure(escaping).

```
{ (<参数名>: <参数类型>) -> <返回值类型> in
    <闭包实现>
}

闭包在使用的时候可以有几种不同的方式，以 sorted 调用为例: 
    // 完整
    closures.sort(by: { (v0: Int, v1: Int) -> Bool in
        return v0 > v1
    })

    // 上下文推断
    closures.sort(by: { v0, v1 in
        return v0 > v1
    })

    // 隐式返回值
    closures.sort(by: { $0 > $1 })

    // 运算符函数返回
    closures.sort(by: >)

    // 尾闭包
    closures.sort { $0 > $1 }

// 非逃逸闭包
    func name(@noescape closures: (Int) -> Bool) {
        if closures(10) {
            return
        }
    }

// 自动闭包
    func name(@autoclosure(escaping) closures: () -> String) {
        customerProviders.append(closures)
    }
```

---

## 可选链

```
if let <value> = <object>.<value>?.<function>?.<dictionary>[<key>]?.<array>[<index>] {
    /* 只要其中有 1 个 nil, 就会返回 nil, 否则会逐层解压。*/
    /* 利用可选链的特性，可以实现链式编程。 */
}
```

---

---

# 枚举

* 普通枚举
* 关联值 (实际上等于把每个 case 都变成可以储存值的元组类型。)
* 原始值 (以及其隐式赋值还有初始化)
* 递归枚举 (普通枚举并不能以自己作为值类型，但是递归枚举可以，使用 indirect)

```
// 普通枚举

    enum <name> {
        case <case>
        case <case>
        ...
    }

    enum <name> {
        case <value>, <value> ...
    }

    enum Type {
        case a
        case b
    }

    var type: Type = Type.a

// 关联值

    enum <name> {
        case <case>(<type>, <type>...)
        case <case>(<type or other type> ...)
    }

    enum Type {
        case a(Int)
        case b(String)
        case c(Int, Double)
    }

    var type: Type = Type.a(10)
    var type: Type = Type.b("Test")
    var type: Type = Type.c(10, 5.0)

// 原始值

    enum <name>: <type> {
        case <case> = <value>
        case <case> = <value>
        ...
    }

    enum <name>: <type> {
        case <case> = <value>, <case>, <case> = <value>, <case>...
    }

    enum Type: Int {
        case a = 1, b, c, d = 10, e, f
    }

    var type: Type = Type.b // rawValue = 2; Type.e.rawValue = 11
    var type: Type? = Type(rawValue: 12) // Type.f

// 递归枚举

    // 部分可使用递归
    enum <name> {
        case <case>(<type>)
        indirect case <case>(<name>)
    }
    // 全部可使用递归
    indirect enum <name> {
        case <case>(<type>)
        case <case>(<name>)
    }

    indirect enum Type {
        case a(Int)
        case b(Type)
    }

    indirect enum ArithmeticExpression {
        case number(Int)
        case addition(ArithmeticExpression, ArithmeticExpression)
        case multiplication(ArithmeticExpression, ArithmeticExpression)
    }

    let five = ArithmeticExpression.number(5)
    let four = ArithmeticExpression.number(4)
    let sum = ArithmeticExpression.addition(five, four)
    let product = ArithmeticExpression.multiplication(sum, ArithmeticExpression.number(2))

    func evaluate(_ expression: ArithmeticExpression) -> Int {
        switch expression {
        case let .number(value):
            return value
        case let .addition(left, right):
            return evaluate(left) + evaluate(right)
        case let .multiplication(left, right):
            return evaluate(left) * evaluate(right)
        }
    }

    print(evaluate(product))
    // return ((5) + (4)) * (2)
    // 18
```

---

---

# 类和结构体

* 类
* 结构体
* 属性
* 方法
* 下标
* 继承
* 构造过程
* 析构过程
* 嵌套类型
* 扩展

* 类与结构体的差异:
    * 类是引用类型，结构体是值类型;
    * 结构体不允许继承;
    * 结构体不能类型转换;
    * 结构体没有析构器;
* 符合以下条件可以考虑使用结构体而不是类:
    * 主要封装少量简单数据
    * 被传递或赋值的时候希望是拷贝而不是引用
    * 封装的值也希望是拷贝而不是引用
    * 不需要继承

## 类

> 可以使用 (=\==) 以及 (!==) 判断两个类是否是同一个对象。

```
class <name>: <super class>, <protocol> {

    /** 属性 **/
    var <name>: <type> = <value or no>      // 存储属性
    lazy var <name>: <type> = <value>       // 延迟属性
    static var <name>: <type> = <value>     // 类型属性，静态属性
    let <name>: <type> = {                  // 通过闭包对值进行初始化, let var 都行
        return <value>
    }()
    var <name>: <type> {                    // 计算属性，不存储内容
        get {
            /* 只读属性可以不写 get {}, 直接 return */
            return <value>
        }
        set(newValue) {
            /* set 属性可以不设置，则是只读属性 */
        }
    }
    var <name>: <type> = <value> {          // 添加属性观察器
        didSet {
            /* ... */
        }
        willSet {
            /* ... */
        }
    }

    /** 方法 **/
    func <name>(...) {                      // 实例方法

    }
    override func <father func name>(...) { // 重写方法

    }
    class func <name>(...) {                // 类方法

    }

    /** 下标 **/
    subscript(...) -> <type> {
        get {
            return <value>
        }
        set(newValue) {
            /* ... */
        }
    }

    /** 构造器和析构器**/
    init(...) {
        // super.init(...)
    }
    convenience init(...) {
        /* ... */
        self.init(...)
    }
    deinit {

    }
}
```

---

## 结构体

```
struct <name>: <protocol> {

    /** 属性 **/
    var <name>: <type> = <value or no>      // 存储属性
    lazy var <name>: <type> = <value>       // 延迟属性
    var <name>: <type> {                    // 计算属性，不存储内容
        get {
            /* 只读属性可以不写 get {}, 直接 return */
            return <value>
        }
        set(newValue) {
            /* set 属性可以不设置，则是只读属性 */
        }
    }
    var <name>: <type> = <value> {          // 添加属性观察器
        didSet {
            /* ... */
        }
        willSet {
            /* ... */
        }
    }
    static var <name>: <type> = <value>     // 类型属性，静态属性


    /** 方法 **/
    func <name>(...) {

    }
    mutating func <name>(...) {

    }
    static func <name>(...) {

    }

    /** 下标 **/
    subscript(...) -> <type> {
        get {
            return <value>
        }
        set(newValue) {
            /* ... */
        }
    }

    /** 构造器 **/
    init(...) {
        // super.init(...)
    }
}


```

---


## 属性

* 储存属性 let var
* 延迟属性 lazy
* 计算属性 set get
* 属性监听器 didSet willSet
* 静态属性 static
* 全局属性默认是延迟计算的

## 方法

* 实例方法 (struct 中修改到值属性的方法需要添加 mutating)
* 类型方法

## 下标

subscript(\<name>: \<Type>...) -> \<Type>

## 继承

* 重写(override): 继承之后可以使用重写关键字来重写父类的方法 
    * 方法
    * 属性 
    * 属性观察器
    * 构造器
* 调用父类(super): 在重写的方法或属性中可以通过 super. 来调用父类的变量或函数。
* 防止重写(final): 子类再不能重写它。
    * 属性 final var
    * 方法 final func
    * 不可继承类 final class

---

## 构造过程

* 储存属性在构建实例的时候必须被初始化，可选属性可以被自动初始化成 nil
    * 常量属性可以等到构造过程进行设置
* 不带外部名的构造器参数 init(_ value: Int)
* class 和 strut 都提供了默认构造器
    * strut 构造器中可以调用其他构造器 self.init(...)
    * class 构造器中可以使用父类构造器 super.init(...)
    * convenience 便捷构造器，在该构造器中需要调用其他构造器
* init?(...) init!(...) 可失败构造器，在当中返回 nil 表示失败
    * 可以在子类中使用非可失败构造器重写父类的可失败构造器
* required init() 必要构造器，子类必须要重写构造器

* 构造器规则
    * 指定构造器必须调用其父类的指定构造器 (或默认调用的 super.init())
    * 便捷构造器必须调用该类的其他构造器。

* 两段式构造过程中构造流程展示：
    * 阶段 1
        * 某个指定构造器或便利构造器被调用。
        * 完成新实例内存的分配，但此时内存还没有被初始化。
        * 指定构造器确保其所在类引入的所有存储型属性都已赋初值。存储型属性所属的内存完成初始化。
        * 指定构造器将调用父类的构造器，完成父类属性的初始化。
        * 这个调用父类构造器的过程沿着构造器链一直往上执行，直到到达构造器链的最顶部。
        * 当到达了构造器链最顶部，且已确保所有实例包含的存储型属性都已经赋值，这个实例的内存被认为已经完全初始化。此时阶段 1 完成。
    * 阶段 2
        * 从顶部构造器链一直往下，每个构造器链中类的指定构造器都有机会进一步定制实例。构造器此时可以访问self、修改它的属性并调用实例方法等等。
        * 最终，任意构造器链中的便利构造器可以有机会定制实例和使用self。

---

## 析构过程

析构器会在实例释放发生之前被自动调用。

---

## 嵌套类型

class / struct / enum 类型中都可以再定义新的类型。

```
Struct A {
    enum B {
        case ab
        enum C {
            case abc
        }
    }
}
let abc = A.B.C.abc
```

---

## 扩展 extension

```
// 使用
    extension <Type> {
        ...
    }
```

* 计算属性 var \<name>: \<Type> { get {} set {} }
* 构造器 init(...) {}
* 方法 func \<name>(...) {}
* 可变实例方法 mutating func \<name>(...) {}
* 下标 subscript(...) -> \<Type> {}
* 嵌套类型 
* 协议

---

---

# 自动引用计数 (ARC)

* 默认引用都是强引用
* weak var \<name>: \<Type>? 使用 weak 来进行弱引用，弱应用都是 optional 值。
* unowned var \<name>: \<Type> 使用 unowned 来进行无主引用，同样是弱引用，但是非 optional 值，所以在实例被释放后，再使用会导致错误。
* 如果确定在使用期间肯定不会被释放，应该用 unowned，否则使用 weak
* 闭包捕获默认是强引用，通过定义闭包的捕获列表可设置弱引用。

```
var <closure>: (<type>...) -> <return type> = {
    [unowned <value>, weak <value> = self.value] (<value>: <type>...) -> <return type> in
    ...
    return ...
}

lazy var closure: (Int, String) -> String = {
    [unowned self, weak delegate = self.delegate!] (index: Int, stringToProcess: String) -> String in
    return ...
}
```

---

---

# 错误处理

* defer 使用 defer 可以定义当前代码块不论在什么位置退出都会调用的代码块。

```
// 使用准守 Error 协议的枚举来表示错误
    enum <error name>: Error {
        case <case>
    }

    enum VendingMachineError: Error {
        case invalidSelection
        case insufficientFunds(coinsNeeded: Int)
        case outOfStock
    }

// 在发生错误的地方抛出错误抛出错误
    throw <error>

    throw VendingMachineError.insufficientFunds(coinsNeeded: 5)

// 使用 throws 表示一个函数可能会抛出错误
    func <name>(...) throws -> <type>

// do-catch 处理错误
    do {
        try <expression>
        <无错误>
    } catch <error case> {
        <错误处理>
    } catch <error case> where <错误限定条件> {
        <错误处理>
    } catch {
        <不被前面条件捕获的错误处理>
    }

    var vendingMachine = VendingMachine()
    vendingMachine.coinsDeposited = 8
    do {
        try buyFavoriteSnack(person: "Alice", vendingMachine: vendingMachine)
    } catch VendingMachineError.invalidSelection {
        print("Invalid Selection.")
    } catch VendingMachineError.outOfStock {
        print("Out of Stock.")
    } catch VendingMachineError.insufficientFunds(let coinsNeeded) {
        print("Insufficient funds. Please insert an additional \(coinsNeeded) coins.")
    }

// try? 处理，如果错误返回 nil
    let <value> = try? <expression>

// try! 处理，禁用错误传递，如果错误就崩溃
    let <value> = try! <expression>
```

```
// defer
func processFile(filename: String) throws {
    if exists(filename) {
        let file = open(filename)
        defer {
            close(file)
        }
        while let line = try file.readline() {
            // Work with the file.
        }
        // close(file) is called here, at the end of the scope.
    }
}
```

---

---

# 类型转换

* is : 类型检查，if \<value> is \<Type> {}
* as? / as! : 转型，if let \<name> = \<value> as? \<Type> {}
* Any : 表示任意类型
* AnyObject : 表示任意 class 类型

---

---



# 协议

* 定义
    * 属性
    * 方法
    * 构造器
    * 下标
* 使用
    * class / struct 实现
    * 作为类型
    * 通过协议实现委托代理模式
    * 通过扩展来实现协议
    * 协议可以在集合中使用
* 协议操作
    * 协议可以继承一个或多个协议，并添加新内容
    * 协议合成: 可以将多个协议进行合成作为类型
    * 通过 is 和 as 可以对协议进行一致性检查
    * 协议扩展: 协议扩展不能扩展存储方法，而且必须提供默认实现。
        * 协议扩展可通过 where 语句进行限制，只有符合的部分才会有该方法。
* 专属协议: 通过添加 class 字段表明该协议只能被 class 类型使用
* 可选协议，可选协议需要添加 @objc 关键字，表示使用它的类都继承自 NSObject
* 泛型协议: 在泛型章节中的关联类型详细说明

```
// 定义，以下包含协议可以定义的内容
    protocol <name> {
        var <name>: <Type> { get set }          // 定义属性
        
        func <name>(...) -> <Type>              // 定义方法
        static func <name>(...) -> <Type>       // 定义静态方法
        mutating func <name>(...) -> <Type>     // 定义 mutating 方法
        
        init(...)                               // 定义构造器
        
        subscript(_: <Type>) -> <Type> { get set } // 下标
    }

// 遵循某协议
    class <name>: <Protocol> {
        /* 实现协议所规定的内容 */
    }

// 将协议作为类型
    func <name>(<name>: <Protocol>) -> <Type> {
        ...
    }

// 通过扩展实现协议
    extension <Class/Struct>: <Protocol> {
        /* 实现协议所规定的内容 */
    }

// 继承
    protocol <Sub Protocol>: <Protocol>, <Protocol1> ... {
        /* 定义 */
    }
    
// 合成
    func <name>(<name>: protocol<<Protocol>, <Protocol1>>) -> <Type> {
        ...
    }
    
// 一致性
    if <value> is <Protocol> { }
    if let <name> = <value> as? <Protocol> { }
    
// 可选协议及参数
    @objc protocol <Protocol> {
        @objc optional func <name>(forCount count: Int) -> Int
        @objc optional var <name>: Int { get }
    }
    
    if let <name> = <Optional Protocol>.<Optional func>?(...) { }
    
// 协议扩展
    extension <Protocol> {
        /* 不能扩展存储属性，而且必须提供默认实现 */
    }

// 限制条件
    extension <Protocol> where <限定条件> {
        /* 不能扩展存储属性，而且必须提供默认实现，只有符合限定条件的对象才会有该内容。 */
    }
    
// 关联类型
    protocol <Name> {
        associatedtype <Type name>
        /* ... use Type name */
    }
    class/struct <Name>: <associated Protocol> {
        typealias <Type name> = <Type>
        /* 使用 typealias 指定 Type name 为具体类型 */
    }
    class/struct <Name><Generics>: <associated Protocol> {
        /* Generics 可以就是 Type Name */
    }

```


---

---


# 泛型

* 泛型函数: 所定义的占位类型符必须在函数声明中出现(参数或返回值)
* 泛型类型
* 扩展泛型类型: 可使用占位类型符。
* 泛型约束
* 关联类型: 通常使用 associatedtype 定义泛型协议，然后通过实现 typealias 来指定类型，或使用泛型类型来指定类型
* where 子句可以约束泛型或泛型类型


```
/* Generics 表示泛型类型，不加 <> 号，因为泛型需要被 <> 包含 */
// 泛型函数
    func <name><Generics>(...) -> <Type> {
        ...
    }
    
    func genericsFunc<T>(input: T) -> T {
        ...
    }

// 泛型类型
    class/struct <name><Generics> {
        
    }
    
    class Stack<T> {
        var item = [T]()
    }
    
    let s = Stack<Int>()

// 泛型约束
    func <name><Generics: <Class or Protocol>>(...) {
        ...
    }
    
    func findIndex<T: Equatable>(array: [T], _ valueToFind: T) -> Int? {
        for (index, value) in array.enumerate() {
            if value == valueToFind {
                return index
            }
        }
        return nil
    }

// 关联类型
    protocol <Name> {
        associatedtype <Type name>
        /* ... use Type name */
    }
    class/struct <Name>: <associated Protocol> {
        typealias <Type name> = <Type>
        /* 使用 typealias 指定 Type name 为具体类型 */
    }
    class/struct <Name><Generics>: <associated Protocol> {
        /* Generics 可以就是 Type Name */
    }
    
    protocol Test {
        associatedtype Item
        func append(item: Item)
    }
    
    struct TestStruct: Test {
        typealias Item = Int
        func append(item: Item) { ... }
    }
    
    class Stack<T>: Test {
        var item = [T]()
        func append(item: T) { ... }
    }
    
    let test = TestStruct()
    let stack = Stack<Int>()
    
// Where 子句
    func test<A: Test, B: Test>(a: A, b: B) -> Bool where A.Item == B.Item, A.Item: Equatable {
        /* 
            test 函数有两个泛型 A, B
            A 遵守 Test 协议，B 遵守 Test 协议(可以是不同的协议)
            并且 (where)
            A 的 Item 类型 必须等于 B 的 Item 类型 (比如都是 Int?)
            并且 (,)
            A 的 Item 类型遵守 Equatable 协议
         */
    }
```

---

---

# 访问控制

* 模块和源文件: Swift 中框架和应用都是独立的模块，通过 import 导入。
* 访问级别
    * public      : 其他模块也可访问(框架访问级别)。
    * internal    : 同一模块才可访问(默认访问级别)。
    * fileprivate : 当前文件才能访问(文件访问级别)。
    * private     : 当前作用域内才能访问(内部访问级别)。
    * 不可以在实体中定义级别更高的实体。
* 子类化以及重写规则
    * 具有公共访问或更低级别的类，只能在定义它的模块中被子类化。
    * 具有公共访问或更低级别的方法，只能在定义它的模块中被子类重写。
    * Public 级别的类可以被它们定义的以及 import 它们的模块子类化
    * Public 级别的方法可以被它们定义的以及 import 它们的模块子类化
* 单元测试 target 
    * 单元测试中默认只能访问 open 级别，但是在导入应用模块的语句前添加 @testable 则可以进行所有权限的访问。
* 各种类型访问级别
    * 自定义类型: 默认 internal, 可以显示指定
    * 子类: 不能高于父类级别。
    * 函数: 如果参数及返回值中最低级别不低于当前环境的级别，则按当前环境级别来算。否则需要显示的指定访问级别，不能无法编译。
    * 嵌套类型: 默认 internal 但是如果低于环境，则与环境一致。
    * 元组: 按元组中最低级别的访问权限来算。
    * 枚举: 枚举成员与枚举的访问基本一致，无法单独设置。而且枚举中使用的原始值或关联值不能低于该枚举的访问级别。
    * 常量/变量/属性/下标: 不能高于他们的类型。
    * 构造器: require 类型的构造器必须等同所属类型，其他的可以低于。
    * 结构体默认构造器: 默认 internal, 如存储属性有低于 internal 则按最低级别算。
    * 协议: 协议的方法和属性必须和协议保持一样的级别。
    * 协议继承: 不能高于原协议。
    * 扩展: 默认 internal, 但是不能高于原内容。
    * 泛型: 取决于泛型类似和泛型函数本身。
    * 别名: 不能高于原类型的等级。

---

---

# 指针

* 申请内容空间并初始化一个指针: 手动申请空间的指针必须手动释放内存，否则会引起内存泄露
* 通过参数传递获取指针
* 通过 withUnsafeMutablePointer 直接访问变量的指针
* 通过 withMemoryRebound 函数对指针的类型进行转换
* 通过 UnsafeRawPointer 来获取一个 void* 指针并转换成其他类型的指针
* 通过 advanced 函数来对指针进行移动
* 使用 UnsafeBufferPointer 指针数组

> 注意：当你使用指针指向某个变量的时候，ARC 环境下并不会给这个变量添加引用计数，所以有可能会在你调用之前就把该变量释放，这时候再使用指针将会出现不可预知的结果。

```
// 申请内存空间并初始化一个指针
    let <name> = UnsafeMutablePointer<Type>.allocate(capacity: Int) 
                                        // 申请内存空间
    <Pointer>.initialize(to: <value>)   // 初始化内存空间
    <Pointer>.pointee                   // 通过 pointee 变量可以访问指针的内容，就好像 *pointer
    <Pointer>.deallocate(capacity: Int) // 释放内存空间
    
    let pointer = UnsafeMutablePointer<String>.allocate(capacity: 1)
    pointer.initialize(to: "Test")
    pointer.pointee // "Test"
    pointer.deallocate(capacity:1) 
    
// 通过参数传递获取指针
    func method(name: UnsafePointer<Type>) { }
    method(name: &value) // 使用 & 在传递参数的时候传递 value 的指针
    
// 通过 withUnsafeMutablePointer 直接访问变量的指针
    func withUnsafeMutablePointer<T, Result>(to arg: inout T, _ body: (UnsafeMutablePointer<T>) throws -> Result) rethrows -> Result
    
    var value: String = "Test"
    withUnsafeMutablePointer(to: &value) { $0.pointee += "OK" }
    print(value) // TestOK

// 通过 withMemoryRebound 函数对指针的类型进行转换
    func withMemoryRebound<T, Result>(to: T.Type, capacity count: Int, _ body: (UnsafeMutablePointer<T>) throws -> Result) rethrows -> Result
    
    var addr = sockaddr()
    withUnsafeMutablePointer(to: &addr) {
        $0.withMemoryRebound(to: sockaddr_in.self, capacity: 1) {
            $0.pointee.sin_addr.s_addr = inet_addr("127.0.0.1")
        }
    }
    
// 通过 UnsafeRawPointer 来获取一个 void* 指针并转换成其他类型的指针
    let intP = UnsafeMutablePointer<Int>.allocate(capacity: 1)
    intP.initialize(to: 200)
    let voidP = UnsafeRawPointer(intP)
    let int32P = voidP.assumingMemoryBound(to: Int32.self)
    int32P.pointee // 200
    
// 通过 advanced 函数来对指针进行移动
    var p = UnsafeMutablePointer<Int>.allocate(capacity: 5)
    for i in 0 ..< 5 {
        p.advanced(by: i).pointee = i + 10
    }
    for i in 0 ..< 5 {
        print(p.advanced(by: i).pointee) // 10, 11, 12, 13, 14
    }
    p.deallocate(capacity: 5)
    
    * 需要注意的是，如果这里把循环的次数改成 5 以上的数字也不会崩溃。而且可以正常的进行赋值操作。但是就好像 C 中的指针一样，你不会知道这到底会有什么影响。

// 使用 UnsafeBufferPointer 指针数组
    // 使用上一个例子中的 p 指针
    var ap = UnsafeBufferPointer(start: p, count: 5)
    ap.forEach {
        print($0) // 10, 11, 12, 13, 14
    }
    
    // 数组类型本身也有方法访问 UnsafeBufferPointer
    var a = [20,21,22,23,24]
    a.withUnsafeBufferPointer {
        $0.forEach {
            print($0) // 20, 21, 22, 23, 24
        }
    }
    
    // 事实上，可以直接把数组当成 UnsafePointer 进行传递
    func method<T>(p: UnsafePointer<T>) {
        print(p.pointee)
    }
    method(p: a) // 20
```
