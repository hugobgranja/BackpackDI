# BackpackDI
Simple swift dependency injection framework inspired by [Swinject](https://github.com/Swinject/Swinject) and [SwinjectAutoregistration](https://github.com/Swinject/SwinjectAutoregistration)

# Table of Contents
1. [Features](#features)
2. [Installation](#installation)
3. [Usage](#usage)
   - [Creating a Container](#1-creating-a-container)
   - [Registering Services](#2-registering-services)
   - [Resolving Services](#3-resolving-services)
   - [Auto-registration](#4-auto-registration)
   - [Arguments](#5-arguments)

## Features
- **Lifetime management**
- **Auto-registration**
- **Arguments**

## Installation
Add it as a dependency in your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/hugobgranja/BackpackDI", from: "1.0.0")
],
targets: [
    .target(
        name: "YourProject",
        dependencies: [..., "BackpackDI"]
    )
]
```

## Usage
### 1. Creating a Container  
To get started, initialize an instance of the Container class:
```swift
let container = Container()
```

### 2. Registering services
Register your dependencies with a specific lifetime (default is .transient).

```swift
// Register a service as transient
container.register(MyService.self) { _ in MyServiceImpl() }

// Register a singleton
container.register(MyService.self, lifetime: .singleton) { _ in MyServiceImpl() }

// Register a service with dependencies
container.register(AnotherService.self) { r in 
    AnotherServiceImpl(myService: r.resolve(MyService.self))
}
```

Note: If you try to register a service with the same type multiple times, the latest registration will overwrite previous ones.

### 3. Resolving services
To retrieve a registered service, use the resolve method.
```swift
let myService: MyService = container.resolve(MyService.self)
````

For a throwing version, use resolveThrowing to handle errors if the service isn't registered.

```swift
do {
    let myService: MyService = try container.resolveThrowing(MyService.self)
} catch {
    print("Service not found")
}
```

### 4. Auto-registration
Auto register reduces the amount of code required to register a dependency.  
 It can automatically register a service, resolving its dependencies and injecting them into its initializer.

```swift
class MyService {
    private let anotherService: AnotherService

    init(anotherService: AnotherService) {
        self.anotherService = anotherService
    }
}

container.register(AnotherService.self) { _ in AnotherServiceImpl() }
container.autoRegister(MyService.self, using: MyService.init)
```

### 5. Arguments
When registering services, you can pass additional arguments to the resolve method to customize the instance creation. This is useful when services require parameters that vary between calls or are only available at runtime. To define these arguments, include them as parameters in the register closure, which the container will pass in during resolution. For example:

```swift
container.register(MyService.self) { r, arg1, arg2 in
    MyServiceImpl(
        dependency: r.resolve(AnotherService.self),
        arg1: arg1,
        arg2: arg2
    )
}
```

To resolve the service with arguments, provide the necessary parameters when calling resolve
```swift
let myService: MyService = container.resolve(MyService.self, arguments: "Argument1", 42)
```