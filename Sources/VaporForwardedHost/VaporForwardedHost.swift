import Vapor

extension Request {
    public var forwardedHost: String! {
        if let host = self.headers[HTTPHeaders.Name.xForwardedHost].first ?? self.headers[HTTPHeaders.Name.host].first {
           if let colon = host.firstIndex(of: ":") {
              return String(host[..<colon])
           } else {
              return host
           }
        }
      
        return self.url.host
    }
   
    public var forwardedPort: Int? {
        if let host = self.headers[HTTPHeaders.Name.xForwardedHost].first ?? self.headers[HTTPHeaders.Name.host].first {
            if let colon = host.firstIndex(of: ":") {
                return Int(String(host[host.index(after: colon)...]))
            } else {
                return nil
            }
        }
        
        return self.url.port
    }
   
    public var forwardedProto: String! {
        if let proto = self.headers[HTTPHeaders.Name.xForwardedProto].first ?? self.url.scheme {
            return proto
        }
        
        return self.application.http.server.configuration.tlsConfiguration == nil ? "http" : "https"
    }
   
    public func forwardedURL(from url: URL) -> URL {
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return url
        }
        
        components.scheme = self.forwardedProto
        components.host = self.forwardedHost ?? components.host
        components.port = self.forwardedPort ?? components.port
        
        return components.url ?? url
    }
    
    public func forwardedURI(from uri: URI) -> URI {
        var uri = uri
        
        uri.scheme = self.forwardedProto
        uri.host = self.forwardedHost ?? uri.host
        uri.port = self.forwardedPort ?? uri.port
        
        return uri
    }
}
