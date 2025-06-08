//
//  FetchGalleryTest.swift
//  ArtGallery
//
//  Created by aulia_nastiti on 08/06/25.
//
import XCTest
import Combine
@testable import ArtGallery

final class FetchGalleryImplTest: XCTestCase {
    private var mockRepository: GalleryRepositoryMock!
    private var sut: FetchGallery!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockRepository = GalleryRepositoryMock()
        sut = FetchGalleryImpl(mockRepository)
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        sut = nil
        mockRepository = nil
        super.tearDown()
    }

    func testExecute_success_returnsExpectedResponse() {
        // Given
        let expectedResponse = createGalleryResponse()
        let expectation = expectation(description: "Success response from repo")

        mockRepository.fetchGalleryItemsHandler = { page in
            return Just(expectedResponse)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }

        var result: GalleryResponse?

        // When
        sut.execute(1)
            .sink(receiveCompletion: { _ in expectation.fulfill() },
                  receiveValue: { value in result = value })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertEqual(result, expectedResponse)
        XCTAssertEqual(mockRepository.fetchGalleryItemsCallCount, 1)
    }

    func testExecute_failure_returnsExpectedError() {
        // Given
        let expectedError = ApiError.failToDecode
        let expectation = expectation(description: "Failure response from repo")

        mockRepository.fetchGalleryItemsHandler = { _ in
            return Fail(error: expectedError)
                .eraseToAnyPublisher()
        }

        var receivedError: Error?

        // When
        sut.execute(2)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    receivedError = error
                }
                expectation.fulfill()
            }, receiveValue: { _ in })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNotNil(receivedError)
        XCTAssertEqual(String(describing: receivedError!), String(describing: expectedError))
        XCTAssertEqual(mockRepository.fetchGalleryItemsCallCount, 1)
    }
}
