//
//  DetailScreen.swift
//  ArtGallery
//
//  Created by aulia_nastiti on 29/05/25.
//

import SwiftUI
import Kingfisher
import SwiftData

struct DetailScreen: View {
    var galleryInfo: Gallery
    var imageUrl: String
    @Environment(\.modelContext) private var context
    @State var isSaved: Bool = false
    @State var savedGallery: SavedGallery? = nil
    
    @Query private var images: [SavedGallery]
    
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
                  .clipped() // Ensures the image doesn't overflow its frame
                  .cornerRadius(20)
                Text(galleryInfo.title ?? "Unknwon Title").font(.title)
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(galleryInfo.artistTitle ?? "Unknown") (\(galleryInfo.placeOfOrigin ?? "-"))")
                        Text("Credit: \(galleryInfo.creditLine ?? "-")").foregroundStyle(.gray).italic()
                    }
                    Spacer()
                    Button(isSaved ? "Saved" : "Save") {
                        if isSaved == false {
                            
                            print("++++save")
                            let savedGallery = galleryInfo.toSavedGallery()
                            context.insert(savedGallery)
                            
                            do {
                                try context.save()
                                isSaved = true
                                self.savedGallery = savedGallery
                            } catch {
                                print("=== error \(error.localizedDescription)")
                            }
                        } else {
                            print("++++delete")
                            if let gallery = savedGallery {
                                context.delete(gallery)
                                do {
                                    try context.save()
                                    isSaved = false
                                    savedGallery = nil
                                } catch {
                                    print("=== error \(error.localizedDescription)")
                                }
                            }
                            
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle(radius: 10))
                    .tint(isSaved ? .gray : .red)

                }
                
                Text("Description").bold().padding(.top, 10)
                Text("\(galleryInfo.desc ?? galleryInfo.shortDescription ?? "No Desc")")
                Text("Provenance History").bold().padding(.top, 10)
                if let provenanceText = galleryInfo.provenanceText {
                    Text(provenanceText)
                } else {
                    Text("No Record")
                }
                
                Text("Exhibition History").bold().padding(.top, 10)
                
                if let exhibitionHistory = galleryInfo.exhibitionHistory {
                    Text(exhibitionHistory)
                } else {
                    Text("No Record")
                }
            }.padding()
        }.navigationTitle("Detail")
            .navigationBarTitleDisplayMode(.automatic)
            .onAppear {
                if let savedGallery = images.first(where: { saved in
                    saved.id == galleryInfo.id
                }) {
                    isSaved = true
                    self.savedGallery = savedGallery
                }
            }
    }
}
