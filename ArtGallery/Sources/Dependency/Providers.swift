//
//  ViewModelProvider.swift
//  ArtGallery
//
//  Created by aulia_nastiti on 29/05/25.
//

import Foundation

class RepositoryProvider {
  private let serviceProvider = ServiceProvider.instance

  static let instance = RepositoryProvider()

  func provideGalleryRepository() -> GalleryRepositoryImpl {
    let apiService = serviceProvider.provideAPIService()
    
    return GalleryRepositoryImpl(apiService)
  }
}

class ServiceProvider {
  static let instance = ServiceProvider()

  func provideAPIService() -> APIServiceImpl {
    return APIServiceImpl(.shared)
  }
}

class ViewModelProvider {
  private let usecaseProvider = UsecaseProvider.instance
  static let instance = ViewModelProvider()

  func provideHomeViewModel() -> HomeViewModel {
    let fetchGallery = usecaseProvider.provideFetchGallery()
    let searchGallery = usecaseProvider.provideSearchGallery()

    return HomeViewModel(fetchGallery, searchGallery)
  }
}

class UsecaseProvider {
  private let repositoryProvider = RepositoryProvider.instance
  static let instance = UsecaseProvider()

  func provideFetchGallery() -> FetchGalleryImpl {
    let galleryRepository = repositoryProvider.provideGalleryRepository()

    return FetchGalleryImpl(galleryRepository)
  }
  
  func provideSearchGallery() -> SearchGalleryImpl {
    let galleryRepository = repositoryProvider.provideGalleryRepository()

    return SearchGalleryImpl(galleryRepository)
  }
}
