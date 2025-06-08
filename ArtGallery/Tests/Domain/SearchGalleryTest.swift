//
//  SearchGalleryTest.swift
//  ArtGallery
//
//  Created by aulia_nastiti on 08/06/25.
//
import XCTest
import Combine
@testable import ArtGallery

final class SearchGalleryImplTest: XCTestCase {
    private var mockRepository: GalleryRepositoryMock!
    private var sut: SearchGallery!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockRepository = GalleryRepositoryMock()
        sut = SearchGalleryImpl(mockRepository)
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        sut = nil
        mockRepository = nil
        super.tearDown()
    }

    func testExecute_success_forwardsToRepository() {
        // Given
        let expectedResponse = createGalleryResponse()
        let expectation = expectation(description: "use case forwards to repo")

        mockRepository.searchGalleryHandler = { query, page in
            return Just(expectedResponse)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }

        var result: GalleryResponse?

        // When
        sut.execute("cat", 1)
            .sink(receiveCompletion: { _ in expectation.fulfill() },
                  receiveValue: { value in result = value })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertEqual(result, expectedResponse)
        XCTAssertEqual(mockRepository.searchGalleryCallCount, 1)
    }

    func testExecute_failure_forwardsError() {
        // Given
        let expectedError = ApiError.failToDecode
        let expectation = expectation(description: "use case forwards failure")

        mockRepository.searchGalleryHandler = { _, _ in
            return Fail(error: expectedError)
                .eraseToAnyPublisher()
        }

        var resultError: Error?

        // When
        sut.execute("dog", 1)
            .sink(receiveCompletion: { completion in
                if case let .failure(e) = completion {
                    resultError = e
                }
                expectation.fulfill()
            }, receiveValue: { _ in })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNotNil(resultError)
        XCTAssertEqual(String(describing: resultError!), String(describing: expectedError))
        XCTAssertEqual(mockRepository.searchGalleryCallCount, 1)
    }
}
