//
//  GalleryRepositoryTest.swift
//  ArtGallery
//
//  Created by aulia_nastiti on 08/06/25.
//

import XCTest
import Combine
@testable import ArtGallery

final class GalleryRepositoryTest: XCTestCase {
    private var mockApiService: APIServiceMock!
    private var userDefaults: UserDefaults!
    private var sut: GalleryRepository!
    private var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        mockApiService = APIServiceMock()
        userDefaults = UserDefaults(suiteName: "TestDefaults")
        userDefaults.removePersistentDomain(forName: "TestDefaults")
        sut = GalleryRepositoryImpl(mockApiService, userDefaults)
    }

    override func tearDown() {
        cancellables.removeAll()
        sut = nil
        mockApiService = nil
        userDefaults.removePersistentDomain(forName: "TestDefaults")
        userDefaults = nil
        super.tearDown()
    }

    func testFetchGalleryItems_success_setsImageUrlInUserDefaults() {
        // Given
        let expectedUrl = "https://example.com/iiif"
        let mockResponse = GalleryResponse(
            pagination: .init(total: 1, limit: 1, offset: 0, totalPages: 1, currentPage: 1),
            data: [],
            config: .init(iiifUrl: expectedUrl)
        )

        mockApiService.fetchGalleryItemsHandler = { _ in
            return Just(mockResponse)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }

        let expectation = self.expectation(description: "Fetch succeeds")

        var result: GalleryResponse?

        // When
        sut.fetchGalleryItems(1)
            .sink(receiveCompletion: { _ in
                expectation.fulfill()
            }, receiveValue: { response in
                result = response
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertEqual(result?.config.iiifUrl, expectedUrl)
        XCTAssertEqual(mockApiService.fetchGalleryItemsCallCount, 1)
        XCTAssertEqual(userDefaults.string(forKey: "imageUrl"), expectedUrl)
    }

    func testFetchGalleryItems_failure_doesNotSetImageUrl() {
        // Given
        let expectedError = ApiError.failToDecode

        mockApiService.fetchGalleryItemsHandler = { _ in
            return Fail(error: expectedError).eraseToAnyPublisher()
        }

        let expectation = self.expectation(description: "Fetch fails")

        var resultError: Error?

        // When
        sut.fetchGalleryItems(1)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    resultError = error
                }
                expectation.fulfill()
            }, receiveValue: { _ in })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNotNil(resultError)
        XCTAssertNil(userDefaults.string(forKey: "imageUrl"))
    }

    func testSearchGallery_success_returnsExpectedData() {
        // Given
        let expectedResponse = GalleryResponse(
            pagination: .init(total: 1, limit: 1, offset: 0, totalPages: 1, currentPage: 1),
            data: [],
            config: .init(iiifUrl: "https://example.com")
        )

        mockApiService.searchGalleryHandler = { _, _ in
            return Just(expectedResponse)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }

        let expectation = self.expectation(description: "Search success")
        var result: GalleryResponse?

        // When
        sut.searchGallery("cat", 1)
            .sink(receiveCompletion: { _ in expectation.fulfill() },
                  receiveValue: { response in result = response })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertEqual(result, expectedResponse)
        XCTAssertEqual(mockApiService.searchGalleryCallCount, 1)
    }

    func testSearchGallery_failure_returnsError() {
        // Given
        let expectedError = ApiError.failToDecode

        mockApiService.searchGalleryHandler = { _, _ in
            return Fail(error: expectedError)
                .eraseToAnyPublisher()
        }

        let expectation = self.expectation(description: "Search failure")
        var error: Error?

        // When
        sut.searchGallery("fail", 1)
            .sink(receiveCompletion: { completion in
                if case let .failure(e) = completion {
                    error = e
                }
                expectation.fulfill()
            }, receiveValue: { _ in })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNotNil(error)
        XCTAssertEqual(String(describing: error!), String(describing: expectedError))
    }
}
