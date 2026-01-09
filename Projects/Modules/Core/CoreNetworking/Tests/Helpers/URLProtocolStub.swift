//
//  URLProtocolStub.swift
//  CoreNetworking
//
//  Created by Matheus Martins on 08/01/26.
//

import Foundation

/// A URLProtocol that intercepts requests and returns a configurable stub.
/// Prefer injecting a URLSession using `URLSessionConfiguration.protocolClasses`
/// instead of registering globally via `URLProtocol.registerClass`.
final class URLProtocolStub: URLProtocol {
    private static var stub: Stub?
    private static let lock = NSLock()

    private struct Stub {
        let data: Data?
        let response: URLResponse?
        let error: Error?
    }

    static func stub(data: Data?, response: URLResponse?, error: Error?) {
        lock.lock()
        defer { lock.unlock() }
        stub = .init(data: data, response: response, error: error)
    }

    static func startInterceptingRequests() {
        // Not needed if you inject protocolClasses in URLSessionConfiguration.
        // Kept for compatibility.
        URLProtocol.registerClass(URLProtocolStub.self)
    }

    static func stopInterceptingRequests() {
        URLProtocol.unregisterClass(URLProtocolStub.self)
        lock.lock()
        defer { lock.unlock() }
        stub = nil
    }

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        let currentStub: Stub? = {
            Self.lock.lock()
            defer { Self.lock.unlock() }
            return Self.stub
        }()

        // 1) Transport error path
        if let error = currentStub?.error {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }

        // 2) Response is required for a "success path"
        if let response = currentStub?.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }

        // 3) Data (optional)
        if let data = currentStub?.data {
            client?.urlProtocol(self, didLoad: data)
        }

        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
