//
//  CorrectWordsView.swift
//  ReadTracker
//
//  Created by Philipp Ollmann on 24.02.24.
//

import SwiftUI

struct ReadWordsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var pageViewModel: PageViewModel
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(pageViewModel.readWords.keys.sorted(), id: \.description){ key in
                    if let value = pageViewModel.readWords[key] {
                        if value {
                            Text(key)
                                .foregroundStyle(Color.flixoSuccess)
                            
                        } else {
                            Text(key)
                                .foregroundStyle(Color.flixoError)
                        }
                    }
                }
            }
            .style(.body3)
            .navigationTitle("Read Words")
            .toolbar {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(Color.flixoDarkGray)
                }
            }
        }
    }
}

#Preview {
    ReadWordsView()
        .environmentObject(PageViewModel())
}
