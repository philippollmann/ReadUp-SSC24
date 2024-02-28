import SwiftUI


struct StartView: View {
    
    @State var viewModel: StartViewModel = StartViewModel()
    @AppStorage("onboardingSeen") private var onboardingSeen: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
               TabView(selection: $viewModel.currentBook) {
                   Group {
                       ForEach(Array(viewModel.books.enumerated()), id: \.offset) { index, book in
                           createBookView(book: book)
                               .tag(index)
                       }
                   }
                    .padding(Spacing.spacingM)
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .animation(.interactiveSpring, value: viewModel.currentBook)
                
                HStack(alignment: .center) {
                    CustomIconButton(icon: Image(systemName: "arrow.backward")) {
                        viewModel.navigateBook(direction: .backward)
                    }
                    
                    Spacer()
                    
                    CustomIconButton(icon: Image(systemName: "arrow.forward")) {
                        viewModel.navigateBook(direction: .forward)
                    }
                }
                .padding(Spacing.spacingM)
            }
            .background {
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            }
            .toolbar {
                Button {
                    viewModel.showInfoSheet = true
                } label: {
                    Image(systemName: "info.circle.fill")
                        .foregroundStyle(Color.flixoDarkGray)
                }
            }
            .navigationDestination(isPresented: $viewModel.showBook) {
                PageView(book: viewModel.books[viewModel.currentBook])
            }
            .navigationBarBackButtonHidden()
            .onAppear {
                if !onboardingSeen {
                    viewModel.showOnboarding = true
                    onboardingSeen = true
                }
            }
            .sheet(isPresented: $viewModel.showOnboarding) {
                OnboardingView()
            }
            .sheet(isPresented: $viewModel.showInfoSheet) {
                InfoView()
            }
        }
    }
    
    
    func createBookView(book: Book) -> some View {
        return VStack(spacing: Spacing.spacingS) {
            Spacer()
            Image(book.coverName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight: 300)
                .overlay {
                    if book.comingSoon {
                        Text("Coming Soon")
                            .style(.headline2, color: .white)
                            .padding(Spacing.spacingXL)
                            .padding(.horizontal, Spacing.spacingXL)
                            .background(Color.flixoTertiary.opacity(0.6))
                            .clipShape(.rect(cornerRadius: 24))
                            .rotationEffect(.degrees(-25))
                            .fixedSize(horizontal: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                    }
                }
            
            Text(book.title)
                .style(.title_1)
                .padding(.horizontal, Spacing.spacing2XL)
                .multilineTextAlignment(.center)
            
            Text(book.description)
                .style(.subtitle2, color: Color.flixoDarkGray)
                .multilineTextAlignment(.center)
                .padding(Spacing.spacingXL)
            
            Spacer()
            
            if !book.comingSoon {
                CustomButton(text: "Start Reading"){
                    print("Start Reading")
                    viewModel.showBook = true
                }
            }
            
            Spacer()
        }
        .padding(Spacing.spacingXL)
    }
}

#Preview("StartView") {
    StartView()
}
