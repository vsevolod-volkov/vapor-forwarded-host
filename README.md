# vapor-forwarded-host

Simple extension for [Vapor](https://github.com/vapor/vapor).Request to determine host address even if accessed via proxy.

## Installation

Add to your Package.swift:

      let package = Package(
         ...
         dependencies: [
            .package(url: "https://github.com/vsevolod-volkov/vapor-forwarded-host.git", from: "0.1.0"),
         ],
         targets: [
            .target(
               ...
               dependencies: [
                  .product(name: "VaporForwardedHost", package: "vapor-forwarded-host"),
               ],
            ),
         ]
      )

Add to your swift module:

      import VaporForwardedHost

## Basic use cases

### Get forwarded schema, host and port
``` swift
app.get("source-page") { req in
   return """
      schema: \(req.fowardedSchema ?? "???")
      host: \(req.forwardedHost ?? "???")
      port \(req.forwardedPort.map { "\(req.forwardedPort!)" } ?? "-")
      """
}
```

### Form entire URL with given basic one
``` swift
app.get("source-page") { req in
   return """
      URL: \(req.forwardedURL(from: req.url))
      """
}
```
