//
//  SavedScreen.swift
//  ArtGallery
//
//  Created by aulia_nastiti on 29/05/25.
//

import SwiftUI
import SwiftData
import Kingfisher

struct SavedScreen: View {
    
    @Query private var images: [SavedGallery]
    @State var imageUrl: String = (UserDefaults.standard.string(forKey: "imageUrl") ?? "")
    @Environment(\.modelContext) private var context
    @EnvironmentObject var navigationState: NavigationState
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                Text("Saved Image").font(.title)
                ForEach(
                  images, id: \.id
                ) { image in
                    VStack {
                        KFImage(URL(string: "\(imageUrl)/\(image.imageId ?? "")\(ApiConstant.imageUrlPath)")!)
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
                          .cornerRadius(10.0)
                          .aspectRatio(1, contentMode: .fill)
                        HStack {
                            
                            VStack(alignment: .leading) {
                                Text(image.title ?? "Unknwon Title")
                                Text(image.artistTitle ?? "Unknwon Artist").font(.caption)
                                Text(image.desc ?? image.shortDescription ?? "No description.")
                                
                            }
                            Spacer()
                            Image(systemName: "trash").foregroundStyle(.red).onTapGesture {
                                context.delete(image)
                                do {
                                    try context.save()
                                }catch {
                                    print("== failed to delete")
                                }
                                
                            }
                        }
                    }
                    .onTapGesture {
                        navigationState.routes.append(.detail(gallery: image.toGallery(), imageUrl: imageUrl))
                    }
                    
                }
            }.padding()
        }
    }
}
