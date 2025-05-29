//
//  DetailScreen.swift
//  ArtGallery
//
//  Created by aulia_nastiti on 29/05/25.
//

import SwiftUI
import Kingfisher

struct DetailScreen: View {
    var galleryInfo: Gallery
    var imageUrl: String
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                KFImage(URL(string: "\(imageUrl)/\(galleryInfo.imageId ?? "")\(ApiConstant.imageUrlPath)")!)
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
                Text("\(galleryInfo.artistTitle ?? "Unknown") (\(galleryInfo.placeOfOrigin ?? "-"))")
                Text("Credit: \(galleryInfo.creditLine ?? "")").foregroundStyle(.gray)
                Text("Description").bold().padding(.top, 10)
                Text("\(galleryInfo.desc ?? galleryInfo.shortDescription ?? "No Desc")")
                Text("Provenance History").bold().padding(.top, 10)
                Text(galleryInfo.provenanceText ?? "No Record")
                Text("Exhibition History").bold().padding(.top, 10)
                Text(galleryInfo.exhibitionHistory ?? "No Record")
            }.padding()
        }.navigationTitle("Detail")
            .navigationBarTitleDisplayMode(.automatic)
    }
}
