//
//  APIServiceTEst.swift
//  ArtGallery
//
//  Created by aulia_nastiti on 08/06/25.
//

import XCTest
import Combine
@testable import ArtGallery

final class APIServiceTest: XCTestCase {
    private var urlSession: URLSession!
    private var sut: APIService!
    private var jsonHelper: JsonHelper!
    private var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: configuration)
        jsonHelper = JsonHelper()

        sut = APIServiceImpl(urlSession)
    }

    override func tearDown() {
        cancellables.removeAll()
        sut = nil
        urlSession = nil
        jsonHelper = nil
    }

    func testFetchGalleryItems_success() throws {
        let mockGalleryData = try jsonHelper.readJson(
            "GalleryResponse",
            bundle: Bundle(for: type(of: self))
        ).data(using: .utf8)!
        
        let expectedData = jsonHelper.decodeJSON(GalleryResponse.self, from: mockGalleryData)

        MockURLProtocol.requestHandler = { _ in
            return (HTTPURLResponse(), mockGalleryData)
        }

        let expectation = self.expectation(description: "success")

        sut.fetchGalleryItems(1)
            .sink(receiveCompletion: { _ in expectation.fulfill() },
                  receiveValue: { response in
                XCTAssertEqual(response, expectedData)
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchGalleryItems_failToDecode() {
        let mockData = Data()
        let expectedError = ApiError.failToDecode

        MockURLProtocol.requestHandler = { _ in
            return (HTTPURLResponse(), mockData)
        }

        let expectation = self.expectation(description: "decode failure")

        sut.fetchGalleryItems(1)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion,
                   let err = error as? ApiError {
                    XCTAssertEqual(err, expectedError)
                    expectation.fulfill()
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }

    func testSearchGallery_success() throws {
        let mockGalleryData = try jsonHelper.readJson(
            "GalleryResponse",
            bundle: Bundle(for: type(of: self))
        ).data(using: .utf8)!
        
        let expectedData = jsonHelper.decodeJSON(GalleryResponse.self, from: mockGalleryData)

        MockURLProtocol.requestHandler = { _ in
            return (HTTPURLResponse(), mockGalleryData)
        }

        let expectation = self.expectation(description: "search success")

        sut.searchGallery("test", 1)
            .sink(receiveCompletion: { _ in expectation.fulfill() },
                  receiveValue: { response in
                XCTAssertEqual(response, expectedData)
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }

    func testSearchGallery_failToDecode() {
        let mockData = Data()

        MockURLProtocol.requestHandler = { _ in
            return (HTTPURLResponse(), mockData)
        }

        let expectation = self.expectation(description: "search decode fail")

        sut.searchGallery("test", 1)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion,
                   let err = error as? ApiError {
                    XCTAssertEqual(err, .failToDecode)
                    expectation.fulfill()
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }
}
