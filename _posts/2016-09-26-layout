---
layout: post
title: "Layout"
description: "更加简洁的 AutoLayout 设置方式。"
date: 2016-09-26
tags: [Swift, Codes, AutoLayout, Layout, Operation]
comments: true
share: true
---

iOS 开发中 Storyboard 的运用非常的常见，所以通过代码设置 AutoLayout 的场景会比较少。但是不代表没有。

* 需要纯代码构建界面（公司要求，创建 UI 控件）
* 需要根据屏幕方向或数据内容提供不同的约束方案。

可是苹果提供的 Autolayout 语法真是要让人抓狂的节奏。于是衍生了很多类库，如 

* [Stevia](https://github.com/s4cha/Stevia)
* [Masonry](https://github.com/SnapKit/Masonry)
* ...

另外还有 [MyLinearLayout](https://github.com/youngsoft/MyLinearLayout) ，这是基于 frame 的自动布局方案。

每一个方案都有自己不同的解决方法，有侧重于代码直观可读的，有侧重于代码简洁的。我自己比较喜欢能让代码变得更加简洁，当然这是在保证可读性的情况下的。

所以我就这一块进行比较深入的了解，并造一个轮子作为自己的学习成果。

# 背景知识

## NSLayoutConstraint

```
NSLayoutConstraint(item view1: AnyObject,
              attribute attr1: NSLayoutAttribute,
           relatedBy relation: NSLayoutRelation,
                 toItem view2: AnyObject?,
              attribute attr2: NSLayoutAttribute,
        multiplier multiplier: CGFloat,
                   constant c: CGFloat)
```

整个轮子就围绕着这一个核心方法来进行。

* 基础属性
	* item: 需要添加约束的对象
	* attr1: 对 item 进行约束的边
	* relation: 约束关系，大于小于等于
	* toItem: 约束的相对对象，可以是父视图或其他兄弟视图
	* attr2: 相对对象的约束边
	* multiplier: 位置计算的倍数参数
	* constant: 位置计算的常数参数
* 其他属性
	* priority: 约束的优先级。
	* active: 约束是否生效
	* identify: 可以给约束添加标识符
* 约束的计算式
	* item.attr1 = toItem.attr2 * multiplier + constant

## 链式编程

将多个相关操作通过 (.) 号连接起来，增加代码块的逻辑性以及可读性。最简单的实现办法，就是将函数的返回值设置为返回对象本身。

## 自定义操作符

* 设置自定义操作符

```
infix operator +-: AdditionPrecedence
```

操作符的位置(前中后缀) operator 操作符: 操作符优先级组

```
extension Vector2D {
    static func +- (left: Vector2D, right: Vector2D) -> Vector2D {
        return Vector2D(x: left.x + right.x, y: left.y - right.y)
    }
}
```

在 Swift 3 之前，操作符的运算还只能添加到全局， Swift 3 已经可以添加到类当中了，不过需要用 static 前缀。(那么还是一个全局……但是这样的改进对代码的易读性会更好，毕竟一看就知道这是有关于哪一个类的运算。)

不过差别还是有的，添加到类当中的运算必须要有该类作为参数之一。这其实还是很好理解其中的逻辑的，毕竟跟它没关系你添加到它里面干嘛呢……

[Apple: The Swift Programming Language(Swift 3) -> Language Guide -> Advanced Operators -> Custom Operators](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/AdvancedOperators.html#//apple_ref/doc/uid/TP40014097-CH27-ID28)

* 操作符优先级

苹果的标准操作符等级
[Swift Standard Library Operators](https://developer.apple.com/reference/swift/1851035-swift_standard_library_operators)

添加自定义操作符等级

precedencegroup precedence group name {
    higherThan: lower group names
    lowerThan: higher group names
    associativity: associativity
    assignment: assignment
}

[Apple: The Swift Programming Language(Swift 3) -> Language Peference -> Declarations -> Precedence Group Declaration](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Declarations.html#//apple_ref/doc/uid/TP40014097-CH34-ID550)


# 思考

## 要点

进行 AutoLayout 的时候，有几个元素是需要考虑清楚的。

* Who
	* 给哪个对象设置约束。
	* 相对于哪个对象。
	* 约束添加到那一个对象中。（一般是父视图）
* Where
	* 设置的约束是哪一条边。
	* 相对哪一条边。
* When
	* 什么时候进行添加？

## 方案

对此我做了两方面的尝试：

* 链式：通过链式给视图添加约束，大概是这样

```
Layout(view, item, second).leading().top().trailing().bottom()
```

* 重写操作符：通过操作符直观的表达约束关系

```
Layout(view).auto {
	item.top == second.top * 1.5 + 10
	...
}
```

两者的优缺点都有吧，链式可以极大的缩短代码的长度，操作符可以直观的“看到”约束是怎么样的，而且也比较好玩，但是代码量却不少。到底是更短的代码，还是更易读的代码……这是一个需要好好平衡的问题。

# 实现

## 伪代码

* Property
	* weak var view: UIView
	* weak var first: UIView
	* weak var second: UIView
* 链式 Methods
	* 辅助方法
		* 视图变化类方法：用于设置三个属性
		* 约束获取方法：用于获取设置之后的约束，以留着后期用于动画等操作。
	* 设置方法
		* 完全自定义的方法
		* 设置视图尺寸的方法
		* 设置 first 和 second 单边约束的方法
		* 常用的双边方法
		* 常用的多边方法
* 操作符 Methods
	* class View 用于进行操作符运算的新类型，保存约束所需要的信息。
		* Property
			* weak var `super`: UIView?
        	* weak var view: UIView!
        	* var attribute: NSLayoutAttribute
        	* var constant: CGFloat = 0
        	* var multiplier: CGFloat = 1
        	* var priority: UILayoutPriority?
        * Init
        * 重写操作符
        	* == <= >= : 添加运算
        	* * / : 设置 multiplier
        	* + - : 设置 constant
        	* >>> : 设置 priority
    * 扩展 UIView 添加相应约束的属性，造成可以直接 UIView 设置约束的错觉。

## 实现

```
//
//  Layout.swift
//  Layout
//
//  Created by 黄穆斌 on 16/9/24.
//  Copyright © 2016年 MuBinHuang. All rights reserved.
//

import UIKit

// MARK: - Layout

class Layout {
    
    // MARK: Views
    
    weak var view: UIView!
    weak var first: UIView!
    weak var second: UIView!
    
    // MARK: Init
    
    init(_ view: UIView) {
        self.view = view
    }
    
    // MARK: Set View
    
    func view(_ first: UIView) -> Layout {
        self.first = first
        self.first.translatesAutoresizingMaskIntoConstraints = false
        if self.second == nil {
            self.second = self.view
        }
        return self
    }
    
    func to(_ second: UIView) -> Layout {
        self.second = second
        return self
    }
    
    // MARK: Constraints
    
    var constrants: [NSLayoutConstraint] = []
    
    @discardableResult
    func get(layouts: ([NSLayoutConstraint]) -> Void) -> Layout {
        layouts(constrants)
        return self
    }
    
    @discardableResult
    func clear() -> Layout {
        constrants.removeAll(keepingCapacity: true)
        return self
    }
    
    // MARK: Custom Edge Methods
    
    @discardableResult
    func layout(edge: NSLayoutAttribute, to: NSLayoutAttribute? = nil, constant: CGFloat = 0, multiplier: CGFloat = 1, priority: UILayoutPriority = UILayoutPriorityDefaultHigh, related: NSLayoutRelation = .equal) -> Layout {
        let layout = NSLayoutConstraint(item: first, attribute: edge, relatedBy: related, toItem: second, attribute: to ?? edge, multiplier: multiplier, constant: constant)
        layout.priority = priority
        view.addConstraint(layout)
        constrants.append(layout)
        return self
    }
    
    @discardableResult
    func equal(edges: NSLayoutAttribute...) -> Layout {
        for edge in edges {
            let layout = NSLayoutConstraint(
                item: first,
                attribute: edge,
                relatedBy: .equal,
                toItem: second,
                attribute: edge,
                multiplier: 1,
                constant: 0
            )
            view.addConstraint(layout)
            constrants.append(layout)
        }
        return self
    }
    
    // MARK: - Size Edge Methods
    
    @discardableResult
    func size(height: CGFloat, priority: UILayoutPriority = UILayoutPriorityDefaultHigh) -> Layout {
        let layout = NSLayoutConstraint(
            item: first,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: height
        )
        layout.priority = priority
        first.addConstraint(layout)
        constrants.append(layout)
        return self
    }
    
    @discardableResult
    func size(width: CGFloat, priority: UILayoutPriority = UILayoutPriorityDefaultHigh) -> Layout {
        let layout = NSLayoutConstraint(
            item: first,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: width
        )
        layout.priority = priority
        first.addConstraint(layout)
        constrants.append(layout)
        return self
    }
    
    @discardableResult
    func size(ratio: CGFloat, constant: CGFloat = 0, priority: UILayoutPriority = UILayoutPriorityDefaultHigh) -> Layout {
        let layout = NSLayoutConstraint(
            item: first,
            attribute: .width,
            relatedBy: .equal,
            toItem: first,
            attribute: .height,
            multiplier: ratio,
            constant: constant
        )
        layout.priority = priority
        first.addConstraint(layout)
        constrants.append(layout)
        return self
    }
    
    // MARK: - One Edge Methods
    
    @discardableResult
    func leading(_ constant: CGFloat = 0, multiplier: CGFloat = 1, relate: NSLayoutRelation = .equal, priority: UILayoutPriority = UILayoutPriorityDefaultHigh) -> Layout {
        let layout = NSLayoutConstraint(
            item: first,
            attribute: .leading,
            relatedBy: relate,
            toItem: second,
            attribute: .leading,
            multiplier: multiplier,
            constant: constant
        )
        layout.priority = priority
        view.addConstraint(layout)
        constrants.append(layout)
        return self
    }
    
    @discardableResult
    func trailing(_ constant: CGFloat = 0, multiplier: CGFloat = 1, relate: NSLayoutRelation = .equal, priority: UILayoutPriority = UILayoutPriorityDefaultHigh) -> Layout {
        let layout = NSLayoutConstraint(
            item: first,
            attribute: .trailing,
            relatedBy: relate,
            toItem: second,
            attribute: .trailing,
            multiplier: multiplier,
            constant: constant
        )
        layout.priority = priority
        view.addConstraint(layout)
        constrants.append(layout)
        return self
    }
    
    @discardableResult
    func top(_ constant: CGFloat = 0, multiplier: CGFloat = 1, relate: NSLayoutRelation = .equal, priority: UILayoutPriority = UILayoutPriorityDefaultHigh) -> Layout {
        let layout = NSLayoutConstraint(
            item: first,
            attribute: .top,
            relatedBy: relate,
            toItem: second,
            attribute: .top,
            multiplier: multiplier,
            constant: constant
        )
        layout.priority = priority
        view.addConstraint(layout)
        constrants.append(layout)
        return self
    }
    
    @discardableResult
    func bottom(_ constant: CGFloat = 0, multiplier: CGFloat = 1, relate: NSLayoutRelation = .equal, priority: UILayoutPriority = UILayoutPriorityDefaultHigh) -> Layout {
        let layout = NSLayoutConstraint(
            item: first,
            attribute: .bottom,
            relatedBy: relate,
            toItem: second,
            attribute: .bottom,
            multiplier: multiplier,
            constant: constant
        )
        layout.priority = priority
        view.addConstraint(layout)
        constrants.append(layout)
        return self
    }
    
    @discardableResult
    func centerX(_ constant: CGFloat = 0, multiplier: CGFloat = 1, relate: NSLayoutRelation = .equal, priority: UILayoutPriority = UILayoutPriorityDefaultHigh) -> Layout {
        let layout = NSLayoutConstraint(
            item: first,
            attribute: .centerX,
            relatedBy: relate,
            toItem: second,
            attribute: .centerX,
            multiplier: multiplier,
            constant: constant
        )
        layout.priority = priority
        view.addConstraint(layout)
        constrants.append(layout)
        return self
    }
    
    @discardableResult
    func centerY(_ constant: CGFloat = 0, multiplier: CGFloat = 1, relate: NSLayoutRelation = .equal, priority: UILayoutPriority = UILayoutPriorityDefaultHigh) -> Layout {
        let layout = NSLayoutConstraint(
            item: first,
            attribute: .centerY,
            relatedBy: relate,
            toItem: second,
            attribute: .centerY,
            multiplier: multiplier,
            constant: constant
        )
        layout.priority = priority
        view.addConstraint(layout)
        constrants.append(layout)
        return self
    }
    
    @discardableResult
    func width(_ constant: CGFloat = 0, multiplier: CGFloat = 1, relate: NSLayoutRelation = .equal, priority: UILayoutPriority = UILayoutPriorityDefaultHigh) -> Layout {
        let layout = NSLayoutConstraint(
            item: first,
            attribute: .width,
            relatedBy: relate,
            toItem: second,
            attribute: .width,
            multiplier: multiplier,
            constant: constant
        )
        layout.priority = priority
        view.addConstraint(layout)
        constrants.append(layout)
        return self
    }
    
    @discardableResult
    func height(_ constant: CGFloat = 0, multiplier: CGFloat = 1, relate: NSLayoutRelation = .equal, priority: UILayoutPriority = UILayoutPriorityDefaultHigh) -> Layout {
        let layout = NSLayoutConstraint(
            item: first,
            attribute: .height,
            relatedBy: relate,
            toItem: second,
            attribute: .height,
            multiplier: multiplier,
            constant: constant
        )
        layout.priority = priority
        view.addConstraint(layout)
        constrants.append(layout)
        return self
    }
    
    // MARK: Two Edge Methods
    
    /// width and height
    @discardableResult
    func size(_ constant: CGFloat = 0, multiplier: CGFloat = 1) -> Layout {
        let _ = {
            let layout = NSLayoutConstraint(
                item: first,
                attribute: .width,
                relatedBy: .equal,
                toItem: second,
                attribute: .width,
                multiplier: multiplier,
                constant: constant
            )
            view.addConstraint(layout)
            constrants.append(layout)
        }()
        let _ = {
            let layout = NSLayoutConstraint(
                item: first,
                attribute: .height,
                relatedBy: .equal,
                toItem: second,
                attribute: .height,
                multiplier: multiplier,
                constant: constant
            )
            view.addConstraint(layout)
            constrants.append(layout)
        }()
        return self
    }
    
    /// centerX and centerY
    @discardableResult
    func center(_ constant: CGFloat = 0, multiplier: CGFloat = 1) -> Layout {
        let _ = {
            let layout = NSLayoutConstraint(
                item: first,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: second,
                attribute: .centerX,
                multiplier: multiplier,
                constant: constant
            )
            view.addConstraint(layout)
            constrants.append(layout)
        }()
        let _ = {
            let layout = NSLayoutConstraint(
                item: first,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: second,
                attribute: .centerY,
                multiplier: multiplier,
                constant: constant
            )
            view.addConstraint(layout)
            constrants.append(layout)
        }()
        return self
    }
    
    // MARK: Four Edge Methods
    
    /// top, bottom, leading, trailing
    @discardableResult
    func edges(zoom: CGFloat = 0) -> Layout {
        let _ = {
            let layout = NSLayoutConstraint(
                item: first,
                attribute: .top,
                relatedBy: .equal,
                toItem: second,
                attribute: .top,
                multiplier: 1,
                constant: zoom
            )
            view.addConstraint(layout)
            constrants.append(layout)
        }()
        let _ = {
            let layout = NSLayoutConstraint(
                item: first,
                attribute: .bottom,
                relatedBy: .equal,
                toItem: second,
                attribute: .bottom,
                multiplier: 1,
                constant: -zoom
            )
            view.addConstraint(layout)
            constrants.append(layout)
        }()
        let _ = {
            let layout = NSLayoutConstraint(
                item: first,
                attribute: .leading,
                relatedBy: .equal,
                toItem: second,
                attribute: .leading,
                multiplier: 1,
                constant: zoom
            )
            view.addConstraint(layout)
            constrants.append(layout)
        }()
        let _ = {
            let layout = NSLayoutConstraint(
                item: first,
                attribute: .trailing,
                relatedBy: .equal,
                toItem: second,
                attribute: .trailing,
                multiplier: 1,
                constant: -zoom
            )
            view.addConstraint(layout)
            constrants.append(layout)
        }()
        return self
    }
    
    /// width, height, centerX, centerY
    @discardableResult
    func align(offset: CGFloat = 0) -> Layout {
        let _ = {
            let layout = NSLayoutConstraint(
                item: first,
                attribute: .width,
                relatedBy: .equal,
                toItem: second,
                attribute: .width,
                multiplier: 1,
                constant: 0
            )
            view.addConstraint(layout)
            constrants.append(layout)
        }()
        let _ = {
            let layout = NSLayoutConstraint(
                item: first,
                attribute: .height,
                relatedBy: .equal,
                toItem: second,
                attribute: .height,
                multiplier: 1,
                constant: 0
            )
            view.addConstraint(layout)
            constrants.append(layout)
        }()
        let _ = {
            let layout = NSLayoutConstraint(
                item: first,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: second,
                attribute: .centerX,
                multiplier: 1,
                constant: offset
            )
            view.addConstraint(layout)
            constrants.append(layout)
        }()
        let _ = {
            let layout = NSLayoutConstraint(
                item: first,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: second,
                attribute: .centerY,
                multiplier: 1,
                constant: offset
            )
            view.addConstraint(layout)
            constrants.append(layout)
        }()
        return self
    }
}

// MARK: - Advanced Using

// MAKR: Custom Operation

/// Using to set the layout's priority.
infix operator >>>: AdditionPrecedence

// MARK: Safe Call Interface

extension Layout {
    
    static weak var `super`: UIView?
    
    @discardableResult
    func auto(_ layouts: () -> Void) -> Layout {
        DispatchQueue.main.sync {
            Layout.super = self.view
            layouts()
            Layout.super = nil
        }
        return self
    }
    
}

// MARK: - Layout.View

extension Layout {
    
    class View {
        weak var `super`: UIView?
        weak var view: UIView!
        var attribute: NSLayoutAttribute
        
        var constant: CGFloat = 0
        var multiplier: CGFloat = 1
        var priority: UILayoutPriority?
        
        init(view: UIView, attribute: NSLayoutAttribute) {
            self.view = view
            self.attribute = attribute
        }
    }
}

// MARK: - Custom Operations

extension Layout.View {
    
    // MARK: Results
    
    @discardableResult
    static func == (left: Layout.View, right: Layout.View) -> NSLayoutConstraint {
        let layout = NSLayoutConstraint(item: left.view, attribute: left.attribute, relatedBy: .equal, toItem: right.view, attribute: right.attribute, multiplier: right.multiplier, constant: right.constant)
        if right.priority != nil {
            layout.priority = right.priority!
        }
        if right.super == nil {
            Layout.super?.addConstraint(layout)
        } else {
            right.super?.addConstraint(layout)
        }
        return layout
    }
    
    @discardableResult
    static func == (left: Layout.View, right: CGFloat) -> NSLayoutConstraint {
        let layout = NSLayoutConstraint(item: left.view, attribute: left.attribute, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: right)
        left.view.addConstraint(layout)
        return layout
    }
    
    @discardableResult
    static func <= (left: Layout.View, right: Layout.View) -> NSLayoutConstraint {
        let layout = NSLayoutConstraint(item: left.view, attribute: left.attribute, relatedBy: .lessThanOrEqual, toItem: right.view, attribute: right.attribute, multiplier: right.multiplier, constant: right.constant)
        if right.priority != nil {
            layout.priority = right.priority!
        }
        if right.super == nil {
            Layout.super?.addConstraint(layout)
        } else {
            right.super?.addConstraint(layout)
        }
        return layout
    }
    
    @discardableResult
    static func >= (left: Layout.View, right: Layout.View) -> NSLayoutConstraint {
        let layout = NSLayoutConstraint(item: left.view, attribute: left.attribute, relatedBy: .greaterThanOrEqual, toItem: right.view, attribute: right.attribute, multiplier: right.multiplier, constant: right.constant)
        if right.priority != nil {
            layout.priority = right.priority!
        }
        if right.super == nil {
            Layout.super?.addConstraint(layout)
        } else {
            right.super?.addConstraint(layout)
        }
        return layout
    }
    
    // MARK: Values Set
    
    static func + (left: Layout.View, right: CGFloat) -> Layout.View {
        left.constant = right
        return left
    }
    static func - (left: Layout.View, right: CGFloat) -> Layout.View {
        left.constant = -right
        return left
    }
    static func * (left: Layout.View, right: CGFloat) -> Layout.View {
        left.multiplier = right
        return left
    }
    static func / (left: Layout.View, right: CGFloat) -> Layout.View {
        left.multiplier = 1/right
        return left
    }
    static func >>> (left: Layout.View, right: UILayoutPriority) -> Layout.View {
        left.priority = right
        return left
    }
    
}

// MARK: - Extension UIView

extension UIView {
    
    var leading: Layout.View {
        return Layout.View(view: self, attribute: .leading)
    }
    var trailing: Layout.View {
        return Layout.View(view: self, attribute: .trailing)
    }
    var top: Layout.View {
        return Layout.View(view: self, attribute: .top)
    }
    var bottom: Layout.View {
        return Layout.View(view: self, attribute: .bottom)
    }
    var centerX: Layout.View {
        return Layout.View(view: self, attribute: .centerX)
    }
    var centerY: Layout.View {
        return Layout.View(view: self, attribute: .centerY)
    }
    var width: Layout.View {
        return Layout.View(view: self, attribute: .width)
    }
    var height: Layout.View {
        return Layout.View(view: self, attribute: .height)
    }
    
}
```

# 总结

这篇明显的带有水分……可能是因为我对 AutoLayout 的封装还停留在非常浅层次的缘故。所谓的封装也只是写了一堆的方法，然后打包起来等着使用。唯一比较能说得上的学习点，就是对于链式编程的尝试以及自定义操作符的学习。

希望在接下来的使用中，可以对它进行改进。
