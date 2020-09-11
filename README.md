# Toolbox

![Master](https://github.com/allaboutapps/Toolbox/workflows/Master/badge.svg?branch=master)
[![Swift 5](https://img.shields.io/badge/swift5-Swift5-orange)](https://developer.apple.com/swift)
[![SwiftUI](https://img.shields.io/badge/swiftUI-SwiftUI%20Ready-blue)](https://developer.apple.com/xcode/swiftui/)

## What is toolbox

Toolbox is a framework for iOS development with collected code snippets and extensions that is repeatedly copied from project to project. With the toolbox we want to save time and get rid of copy/paste stuff.

## How to use it

Import the framework to your  `class` with `import ToolBox`.

You are now able to use some helpers like:

### Builder Pattern

Old way
```
let fooView: UIView() = { 
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .white
    return view
}()
```
New way
```
let fooView = UIView().with { 
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .white
}
```

### Check if string is empty

It will return true if the string is optional, nil, empty, empty space, tab, newline or return

```
let string: String?
string.isBlank // => true

let string: String? = nil
string.isBlank // => true

let string = ""
string.isBlank // => true

let string = "  "
string.isBlank // => true

let string = "\n"
string.isBlank // => true
```

### Array safe index

Say Goodbye to `Index out of range`
```
let array = [1, 2, 3, 4]
array[safeIndex: 6] => nil
```

### UIView and UIStackView helpers

Add subView of UIView:

```
// old
view.addSubview(foo)
view.addSubview(bar)

// new

view.add(foo, bar)
```

Add arrangedSubview of UIStackView

```
// old
stackView.addArrangedSubview(foo)
stackView.addArrangedSubview(bar)

// new
stackView.addArrangedSubviews(foo, bar)
```

Remove all subviews form stackView now easier
`stackView.removeAllArrangedSubviews()`

### Create separator view on the easy way

```
let separatorView = UIView.createSeparatorView(width: UIScreen.main.bounds.width, height: 1.0, color: .gray, priority: .required)
```

### Style helper

Get rid of using the old way to define styles to the UILabel or UIButtons

The old way is inconsistent and in case you need to change the font size you need to go all through and change it manually
```
let label = UILabel().with {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.font = UIFont(name: "HelveticaNeue-UltraLight", size: 20.0)
    $0.textColor = .darkText
}
```

A new way with styles
```
// Define the styles on one place e.g. Appearance.swift

extension UIColor {

    struct App {
        static let text = .darkText
    }
}

extension Style {

static let headline1 = Style(font: UIFont(name: "HelveticaNeue-UltraLight", size: 20) ?? .systemFont(ofSize: 20), color: UIColor.App.text)

}

// and now in your classes you can use it like this

let label = UILabel().with {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.setStyle(.headline1)
}

```


## Installation

### Swift Package Manager

Add the following dependency to your `Package.swift` file:

```
.package(url: "https://github.com/allaboutapps/Toolbox", from: "1.0.0")
```
In any file you'd like to use Toolbox in, don't forget to import the framework with `import ToolBox`.

## Contributing

* Create something awesome, make the code better, add some functionality,
  whatever (this is the hardest part).
* [Fork it](http://help.github.com/forking/)
* Create new branch to make your changes
* Commit all your changes to your branch
* Submit a [pull request](http://help.github.com/pull-requests/)
