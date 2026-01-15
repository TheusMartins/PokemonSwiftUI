import XCTest
@testable import CoreNetworking

final class RequesterTests: XCTestCase {
    
    override class func setUp() {
        super.setUp()
        URLProtocolStub.startInterceptingRequests()
    }

    override class func tearDown() {
        super.tearDown()
        URLProtocolStub.stopInterceptingRequests()
    }

    func test_request_invalidURL_throwsInvalidURL() async {
        // Given
        let sut = makeSUT()
        let infos = InvalidRequest()

        // When / Then
        do {
            _ = try await sut.request(basedOn: infos)
            XCTFail("Should not succeed with invalid URL")
        } catch {
            XCTAssertEqual(error as? RequestError, .invalidURL)
        }
    }

    func test_request_validURL_withTransportError_throwsTransportError() async {
        // Given
        let sut = makeSUT()
        let infos = ValidRequest()

        URLProtocolStub.stub(
            data: nil,
            response: nil,
            error: URLError(.notConnectedToInternet)
        )

        // When / Then
        do {
            _ = try await sut.request(basedOn: infos)
            XCTFail("Should not succeed with transport error")
        } catch {
            XCTAssertEqual(error as? RequestError, .transportError)
        }
    }

    func test_request_validURL_withNonHTTPURLResponse_throwsInvalidResponse() async {
        // Given
        let sut = makeSUT()
        let infos = ValidRequest()

        let expectedURL = URL(string: "https://pokeapi.co/api/v2/valid")!
        let nonHTTPResponse = URLResponse(
            url: expectedURL,
            mimeType: nil,
            expectedContentLength: 0,
            textEncodingName: nil
        )

        URLProtocolStub.stub(
            data: Data("anything".utf8),
            response: nonHTTPResponse,
            error: nil
        )

        // When / Then
        do {
            _ = try await sut.request(basedOn: infos)
            XCTFail("Should not succeed with non-HTTP response")
        } catch {
            XCTAssertEqual(error as? RequestError, .invalidResponse)
        }
    }

    func test_request_validURL_withNon2xxStatusCode_throwsInvalidStatusCode() async {
        // Given
        let sut = makeSUT()
        let infos = ValidRequest()

        let expectedURL = URL(string: "https://pokeapi.co/api/v2/valid")!
        let response = HTTPURLResponse(
            url: expectedURL,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil
        )!

        URLProtocolStub.stub(
            data: Data("server error".utf8),
            response: response,
            error: nil
        )

        // When / Then
        do {
            _ = try await sut.request(basedOn: infos)
            XCTFail("Should not succeed with non-2xx status code")
        } catch {
            XCTAssertEqual(error as? RequestError, .invalidStatusCode(500))
        }
    }

    func test_request_validURL_with2xxResponse_returnsSuccess() async throws {
        // Given
        let sut = makeSUT()
        let infos = ValidRequest()

        let expectedData = Data("response".utf8)
        let expectedURL = URL(string: "https://pokeapi.co/api/v2/valid")!

        let expectedResponse = HTTPURLResponse(
            url: expectedURL,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!

        URLProtocolStub.stub(data: expectedData, response: expectedResponse, error: nil)

        // When
        let result = try await sut.request(basedOn: infos)

        // Then
        XCTAssertEqual(result.data, expectedData)
        XCTAssertEqual(result.response.url, expectedURL)
    }

    // MARK: - Helpers

    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> DefaultRequester {
        let session = makeSession()
        let sut = DefaultRequester(session: session)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

    private func makeSession() -> URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolStub.self]
        return URLSession(configuration: config)
    }

    private struct InvalidRequest: RequestInfos {
        var baseURL: URL? = nil
        var endpoint: String = "invalid"
        var method: HTTPMethod = .get
        var parameters: [String : Any]? = nil
    }

    private struct ValidRequest: RequestInfos {
        var endpoint: String = "valid"
        var method: HTTPMethod = .get
        var parameters: [String : Any]? = nil
    }
}

// MARK: - Async XCTest helpers

private extension XCTestCase {
    func trackForMemoryLeaks(
        _ instance: AnyObject,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
