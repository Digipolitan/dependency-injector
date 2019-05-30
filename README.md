DependencyInjector
=================================

[![Swift Version](https://img.shields.io/badge/swift-5.0-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Build Status](https://travis-ci.org/Digipolitan/dependency-injector.svg?branch=master)](https://travis-ci.org/Digipolitan/dependency-injector)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/DependencyInjector.svg)](https://img.shields.io/cocoapods/v/DependencyInjector.svg)
[![Carthage Compatible](https://img.shields.io/badge/carthage-compatible-brightgreen.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Swift Package Manager Compatible](https://img.shields.io/badge/swift%20package%20manager-compatible-brightgreen.svg?style=flat)](https://swift.org/package-manager/)
[![Platform](https://img.shields.io/cocoapods/p/DependencyInjector.svg?style=flat)](http://cocoadocs.org/docsets/DependencyInjector)
[![Twitter](https://img.shields.io/badge/twitter-@Digipolitan-blue.svg?style=flat)](http://twitter.com/Digipolitan)

Dependency injector Swift. Compatible for swift server-side and swift for iOS

## Installation

### CocoaPods

To install DependencyInjector with CocoaPods, add the following lines to your `Podfile`.

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

pod 'DependencyInjector'
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate DependencyInjector into your Xcode project using Carthage, specify it in your `Cartfile`:

```
github 'Digipolitan/dependency-injector' ~> 2.0
```

Run `carthage update` to build the framework and drag the built `DependencyInjector.framework` into your Xcode project.

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler.

Once you have your Swift package set up, adding DependencyInjector as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/Digipolitan/dependency-injector.git", from: "2.0.0")
]
```

## The Basics

First you must create a Module and register some providers

```swift
let module = Module()
module.bind(IAnimal.self).to(Dog.self)
```

IAnimal is a protocol that MUST be implemented by the Dog class

```swift
public protocol IAnimal {

    var name: String { get }

    func scream() -> String
}

open class Dog: IAnimal, Injectable {

    public var name: String

    public required convenience init(injector: Injector, arguments: [String : Any]?) throws {
        self.init(name: arguments?["name"] as? String ?? "Athina")
    }

    init(name: String) {
        self.name = name
    }

    public func scream() -> String {
        return "Barking"
    }
}
```

After that, you must register your module inside an injector

```swift
Injector.default.register(module: module)
```

Finally, inject an IAnimal and retrieve a concrete class registered inside your module

```swift
if let animal = try? Injector.default.inject(IAnimal.self) {
  print(animal.name) // print Athina
  print(animal.scream()) // print Barking
}
```

## Advanced

### Arguments

Register a provider that handle arguments :

```swift
let module = Module()
module.bind(IAnimal.self).with { (_, arguments) -> IAnimal? in
  if let name = arguments?["name"] as? String {
    return Dog(name: name)
  }
  return nil
}
Injector.default.register(module: module)
```

Inject an IAnimal with arguments Dictionary<String, Any> :

```swift
if let animal = Injector.default.inject(IAnimal.self, arguments: ["name": "Athina"]) {
  print(animal.name) // print Athina
  print(animal.scream()) // print Barking
}
if let otherAnimal = Injector.default.inject(IAnimal.self, arguments: ["name": "Yoda"]) {
  print(otherAnimal.name) // print Yoda
  print(otherAnimal.scream()) // print Barking
}
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for more details!

This project adheres to the [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md).
By participating, you are expected to uphold this code. Please report
unacceptable behavior to [contact@digipolitan.com](mailto:contact@digipolitan.com).

## License

DependencyInjector is licensed under the [BSD 3-Clause license](LICENSE).
