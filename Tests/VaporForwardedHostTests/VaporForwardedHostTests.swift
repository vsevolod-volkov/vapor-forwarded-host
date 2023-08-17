import XCTest
@testable import VaporForwardedHost
import Vapor

final class VaporForwardedHostTests: XCTestCase {
    let app = Application(.development)
    func testDefault() throws {
        
        let tests: [(request: Request, forwardedHost: String?, forwardedPort: Int?)] = [(
            request: .init(
                application: self.app,
                method: .GET,
                url: URI("http://localhost:1234"),
                version: .http1_0,
                on: app.eventLoopGroup.any()
            ),
            forwardedHost: "localhost",
            forwardedPort: 1234
        ), (
            request: .init(
                application: self.app,
                method: .GET,
                url: URI("http://localhost:1234"),
                version: .http1_0,
                headers: [
                    HTTPHeaders.Name.xForwardedHost.description: "host1",
                ],
                on: app.eventLoopGroup.any()
            ),
            forwardedHost: "host1",
            forwardedPort: nil
        ), (
            request: .init(
                application: self.app,
                method: .GET,
                url: URI("http://localhost:1234"),
                version: .http1_1,
                headers: [
                    HTTPHeaders.Name.host.description: "host2:2222",
                ],
                on: app.eventLoopGroup.any()
            ),
            forwardedHost: "host2",
            forwardedPort: 2222
        ), (
            request: .init(
                application: self.app,
                method: .GET,
                url: URI("http://localhost:1234"),
                version: .http1_1,
                headers: [
                    HTTPHeaders.Name.xForwardedHost.description: "host1:1111",
                    HTTPHeaders.Name.host.description: "host2:2222",
                ],
                on: app.eventLoopGroup.any()
            ),
            forwardedHost: "host1",
            forwardedPort: 1111
        ), ]

        for test in tests {
            XCTAssertEqual(test.request.forwardedHost, test.forwardedHost)
            XCTAssertEqual(test.request.forwardedPort, test.forwardedPort)
        }
    }
}
