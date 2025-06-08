//
//  HomeScreen.swift
//  ArtGallery
//
//  Created by aulia_nastiti on 19/05/25.
//

import SwiftUI
import Kingfisher

struct HomeScreen: View {
    @StateObject private var viewModel: HomeViewModel = ViewModelProvider.instance
        .provideHomeViewModel()
      
    @State var query: String = ""
    @EnvironmentObject var navigationState: NavigationState

      private let columns = [
        GridItem(.flexible(minimum: 40)),
        GridItem(.flexible(minimum: 40)),
        GridItem(.flexible(minimum: 40)),
      ]
      
      var body: some View {
        VStack {
          searchTextField
          if viewModel.viewState.error == .errorEmptyData {
            Spacer()
            showErrorMessage("Failed to load data") {
              viewModel.initialLoad()
            }
            Spacer()
          } else {
            scrollView.onAppear {
              viewModel.initialLoad()
            }
          }
        }
      }
      
      private var searchTextField: some View {
          ZStack {
              RoundedRectangle(cornerRadius: 8.0).fill(.gray).frame(height: 48)
              HStack(alignment: .top) {
                Image(systemName: "magnifyingglass")
                  .resizable()
                  .frame(width: 24, height: 24)
                  .padding(.leading, 10)
                TextField("Search", text: $viewModel.queryText)
                  .autocapitalization(.none)
                  .autocorrectionDisabled()
                  .foregroundStyle(.white)
                  
                  .padding(.horizontal, 4)
              }
          }
        
          .padding(.vertical, 10)
          .padding(.horizontal, 4)
        //.overlay(
         //   RoundedRectangle(cornerRadius: 8.0)
       // )
        .padding(.horizontal)
        .onChange(of: viewModel.debouncedText, perform: { newValue in
          if newValue.isEmpty {
            viewModel.initialLoad()
          } else if !newValue.isEmpty {
            viewModel.search(newValue)
          }
        })
      }
      
      private var scrollView: some View {
        ScrollView {
          LazyVGrid(columns: columns) {
            ForEach(
              Array(viewModel.viewState.gallery.enumerated()), id: \.element.id
            ) { index, image in
              ZStack {
                  showImage(image.imageId ?? "")
                    
              }.onAppear {
                viewModel.checkIfLoadNext(image.id)
              }
              .onTapGesture {
                  print("===== TAP TAP")
                  navigationState.routes.append(.detail(gallery: image, imageUrl: viewModel.viewState.imageUrl))
              }
            }
          }.padding(.horizontal, 4)
          
          if viewModel.viewState.isLoading {
              ProgressView().padding(.vertical)
          }
          
          if viewModel.viewState.error == .errorOnScroll {
            showErrorMessage("Failed to load next page") {
              if let itemId = viewModel.viewState.gallery.last?.id {
                viewModel.checkIfLoadNext(itemId)
              }
            }
          }
        }
      }
      
      @ViewBuilder
      private func showErrorMessage(
        _ message: String,
        _ action: @escaping () -> ()
      ) -> some View {
        VStack {
          Text(message)
          Button(action: action) {
            Text("Refresh")
          }
        }.padding()
      }
      
      @ViewBuilder
      private func showImage(_ imageId: String) -> some View {
        KFImage(URL(string: "\(viewModel.viewState.imageUrl)/\(imageId)\(ApiConstant.imageUrlPath)")!)
          .resizable()
          .backgroundDecode()
          .cacheMemoryOnly()
          .resizable()
          .placeholder {
            Image("brokenImage")
              .resizable()
              .frame(width: 50, height: 50)
          }
          .fade(duration: 0.25)
          .aspectRatio(1, contentMode: .fill)
      }
}

