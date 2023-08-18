import XCTest
@testable import VaporForwardedHost
import Vapor

final class VaporForwardedHostTests: XCTestCase {
    let app = Application(.development)
    var appSchema: String {
        self.app.http.server.configuration.tlsConfiguration == nil ? "http" : "https"
    }
    func testDefault() throws {
        let urls: [URL] = [
            URL(string: "http://google.com/a/b?c=d#e")!,
            URL(string: "https://test.com/test/path")!,
        ]
        
        let tests: [(request: Request, forwardedProto: String?, forwardedHost: String?, forwardedPort: Int?)] = [(
            request: .init(
                application: self.app,
                method: .GET,
                url: URI("http://localhost:1234"),
                version: .http1_0,
                on: app.eventLoopGroup.any()
            ),
            forwardedProto: self.appSchema,
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
            forwardedProto: self.appSchema,
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
            forwardedProto: self.appSchema,
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
            forwardedProto: self.appSchema,
            forwardedHost: "host1",
            forwardedPort: 1111
        ), ]

        for test in tests {
            XCTAssertEqual(test.request.forwardedProto, test.forwardedProto)
            XCTAssertEqual(test.request.forwardedHost, test.forwardedHost)
            XCTAssertEqual(test.request.forwardedPort, test.forwardedPort)
            
            for url in urls {
                var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
                components.scheme = test.forwardedProto
                components.host = test.forwardedHost
                components.port = test.forwardedPort
                
                let expectedURL = components.url!
                
                XCTAssertEqual(test.request.forwardedURL(from: url), expectedURL)
                XCTAssertEqual(test.request.forwardedURL(from: URI(stringLiteral: url.absoluteString)).string, URI(stringLiteral: expectedURL.absoluteString).string)
            }
        }
    }
}
