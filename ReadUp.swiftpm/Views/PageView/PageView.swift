import SwiftUI
import AVFoundation

struct PageView: View {
    
    let book: Book
    
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: PageViewModel = PageViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
    
                Group {
                    if let page = viewModel.currentPage as? TextPage {
                        TextPageView(page: page)
                    } else if let page = viewModel.currentPage as? QuizPage {
                        QuizPageView(page: page)
                    } else if let page = viewModel.currentPage as? CollectionPage {
                        ARCollectView(page: page)
                    }
                }
                .environment(viewModel)
                .frame(maxHeight: .infinity)
                .animation(.bouncy, value: viewModel.currentPageIndex)
                .transition(.scale)
                
                if viewModel.currentPage?.type != .collect {
                    CustomPageIndicator(numPages: book.pages.count, currentPage: viewModel.currentPageIndex + 1)
                        .padding(.vertical, Spacing.spacingXL)
                        .padding(.bottom, Spacing.spacingXL)
                }
            }
            .onChange(of: viewModel.showStartView) {
                if viewModel.showStartView == true {
                    dismiss()
                }
            }
            .navigationDestination(isPresented: $viewModel.showFinishView){
                FinishView(correctWords: viewModel.correctWords, wrongWords: viewModel.wrongWords)
                .environmentObject(viewModel)
            }
            .overlay(alignment: .topTrailing){
                CustomIconButton(icon: viewModel.showPauseOverlay ? Image(systemName: "play.fill") : Image(systemName: "pause.fill")){
                    withAnimation {
                        viewModel.showPauseOverlay.toggle()
                    }
                }
                .padding(Spacing.spacingXL)
            }
            .onAppear {
                viewModel.setup(book: book)
                UIScrollView.appearance().isScrollEnabled = false
            }
            .background {
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
            }
            .overlay {
                if viewModel.showPauseOverlay {
                    PauseOverlay(correctWords: viewModel.correctWords, wrongWords: viewModel.wrongWords) {
                        withAnimation {
                            viewModel.showPauseOverlay = false
                        }
                    } skipPageAction: {
                        withAnimation {
                            viewModel.showPauseOverlay = false
                            viewModel.nextPage()
                        }
                    } homeAction: {
                        viewModel.showStartView = true
                    }
                    .environmentObject(viewModel)
                }
            }
        }
        .toolbar(.hidden)
        .sensoryFeedback(.increase, trigger: viewModel.currentPageIndex)
    }
}

#Preview("PageView") {
    PageView(book: Book.bookFixture)
}
