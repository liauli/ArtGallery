//
//  HomeViewModel.swift
//  ArtGallery
//
//  Created by aulia_nastiti on 08/06/25.
//
import XCTest
import Combine
@testable import ArtGallery

final class HomeViewModelTests: XCTestCase {
    private var fetchGalleryMock: FetchGalleryMock!
    private var searchGalleryMock: SearchGalleryMock!
    private var sut: HomeViewModel!
    private var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        fetchGalleryMock = FetchGalleryMock()
        searchGalleryMock = SearchGalleryMock()
        sut = HomeViewModel(fetchGalleryMock, searchGalleryMock)
    }

    override func tearDown() {
        fetchGalleryMock = nil
        searchGalleryMock = nil
        sut = nil
        cancellables.removeAll()
    }

    func testInitialLoad_Success() {
        let expectedData = createGalleryResponse()
        fetchGalleryMock.executeHandler = success(expectedData)

        loadData(expectedData) {
            sut.initialLoad()
        }
    }

    func testInitialLoad_Failed() {
        let error = ApiError.failToDecode
        fetchGalleryMock.executeHandler = failed(error)

        loadDataFailed(error) {
            sut.initialLoad()
        }
    }

    func testSearch_success() {
        let expectedQuery = randomString(2)
        let expectedData = createGalleryResponse()
        searchGalleryMock.executeHandler = searchSuccess(expectedData)

        loadData(expectedData, expectedQuery) {
            sut.search(expectedQuery)
        }
    }

    func testSearch_Failed() {
        let error = ApiError.failToDecode
        searchGalleryMock.executeHandler = searchFailed(error)

        loadDataFailed(error) {
            sut.search(randomString(2))
        }
    }

    private func loadData(_ expectedData: GalleryResponse, _ expectedQuery: String = "", _ action: () -> Void) {
        let expectedViewState = HomeViewState(
            isLoading: false,
            gallery: expectedData.data,
            currentPage: expectedData.pagination.currentPage,
            imageUrl: expectedData.config.iiifUrl,
            isSearchMode: !expectedQuery.isEmpty,
            query: expectedQuery,
            error: nil
        )

        let expectation = self.expectation(description: "Load completes")
        var receivedValues: [HomeViewState] = []

        sut.$viewState.sink { state in
            receivedValues.append(state)
            if receivedValues.count == 3 {
                expectation.fulfill()
            }
        }.store(in: &cancellables)

        action()

        waitForExpectations(timeout: 5.0, handler: nil)
        XCTAssertEqual(receivedValues.last, expectedViewState)
    }

    private func loadDataFailed(_ error: Error, _ action: () -> Void) {
        let expectedError = HomeErrorState.errorEmptyData

        let expectation = self.expectation(description: "Load fails")
        var receivedValues: [HomeViewState] = []

        sut.$viewState.sink { state in
            print("=== received! \(state)")
            receivedValues.append(state)
            if receivedValues.count == 2 {
                expectation.fulfill()
            }
        }.store(in: &cancellables)

        action()

        waitForExpectations(timeout: 5.0, handler: nil)
        XCTAssertEqual(receivedValues.last?.error, expectedError)
    }
}

// MARK: - Helpers

func success(_ data: GalleryResponse) -> (Int) -> AnyPublisher<GalleryResponse, Error> {
    { _ in Just(data).setFailureType(to: Error.self).eraseToAnyPublisher() }
}

func failed(_ error: Error) -> (Int) -> AnyPublisher<GalleryResponse, Error> {
    { _ in Fail(error: error).eraseToAnyPublisher() }
}

func searchSuccess(_ data: GalleryResponse) -> (String, Int) -> AnyPublisher<GalleryResponse, Error> {
    { _, _ in Just(data).setFailureType(to: Error.self).eraseToAnyPublisher() }
}

func searchFailed(_ error: Error) -> (String, Int) -> AnyPublisher<GalleryResponse, Error> {
    { _, _ in Fail(error: error).eraseToAnyPublisher() }
}
