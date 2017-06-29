DGDependencyInjector
=================================

[![Build Status](https://travis-ci.org/Digipolitan/dependency-injector-swift.svg?branch=master)](https://travis-ci.org/Digipolitan/dependency-injector-swift)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/DGDependencyInjector.svg)](https://img.shields.io/cocoapods/v/DGDependencyInjector.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/cocoapods/p/DGDependencyInjector.svg?style=flat)](http://cocoadocs.org/docsets/DGDependencyInjector)
[![Twitter](https://img.shields.io/badge/twitter-@Digipolitan-blue.svg?style=flat)](http://twitter.com/Digipolitan)

Dependency injector Swift. Compatible for swift server-side and swift for iOS

## Installation

### CocoaPods

To install DGDependencyInjector with CocoaPods, add the following lines to your `Podfile`.

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0' # or platform :osx, '10.10' if your target is OS X.
use_frameworks!

pod 'DGDependencyInjector'
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

DGDependencyInjector is licensed under the [BSD 3-Clause license](LICENSE).
