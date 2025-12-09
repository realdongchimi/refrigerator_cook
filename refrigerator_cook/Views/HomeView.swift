import SwiftUI

// Re-saving to fix preview error

/// 앱의 메인 화면입니다.
/// 상단 헤더, 사진 촬영/업로드, 추천 메뉴, 식재료 리스트를 포함하며 탭 바를 제공합니다.
struct HomeView: View {
    /// 뷰 모델 (상태 관리)
    @StateObject private var viewModel = HomeViewModel()
    
    /// 현재 선택된 탭 인덱스
    @State private var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // 1. 홈 탭
            ZStack {
                Color.Cream.ignoresSafeArea() // 전체 배경색
                
                VStack(spacing: 0) {
                    // 헤더 (고정)
                    HeaderView()
                    
                    // 스크롤 가능한 컨텐츠 영역
                    ScrollView {
                        VStack(spacing: 20) {
                            // 1. 사진 촬영/업로드 뷰
                            TakePhotoView(
                                showCamera: $viewModel.showCamera,
                                showPhotoPicker: $viewModel.showPhotoPicker
                            )
                            
                            // 2. 최근 추천 메뉴
                            // 뷰 모델의 추천 레시피 데이터를 전달
                            RecommendMenuView(recipes: viewModel.recommendedRecipes)
                            
                            // 3. 감지된 식재료
                            // 뷰 모델의 식재료 데이터를 전달
                            IngredientRow(ingredients: viewModel.ingredients)
                                .padding(.bottom, 20) // 하단 여백
                        }
                        .padding(.top, 10.0)
                    }
                }
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("홈")
            }
            .tag(0)
            
            // 2. 레시피 탭 (플레이스홀더)
            ZStack {
                Color.Cream.ignoresSafeArea()
                Text("레시피 화면 준비 중...")
                    .font(.headline)
                    .foregroundColor(.gray)
            }
            .tabItem {
                Image(systemName: "book.closed.fill")
                Text("레시피")
            }
            .tag(1)
        }
        .accentColor(.SoftGreen) // 탭 바 선택 색상
        .onAppear {
            // 테스트용 Mock 데이터 로드 (실제 앱에서는 제거하거나 필요 시 사용)
            viewModel.loadMockData()
        }
        // 카메라 시트
        .sheet(isPresented: $viewModel.showCamera) {
            ImagePicker(image: $viewModel.inputImage, sourceType: .camera)
        }
        // 사진 보관함 시트
        .sheet(isPresented: $viewModel.showPhotoPicker) {
            ImagePicker(image: $viewModel.inputImage, sourceType: .photoLibrary)
        }
        // 이미지가 선택되면 분석 시작
        .onChange(of: viewModel.inputImage) { newImage in
            if newImage != nil {
                viewModel.analyzeSelectedImage()
            }
        }
        // 에러 알림
        .alert(item: Binding<AlertError?>(
            get: { viewModel.errorMessage.map { AlertError(message: $0) } },
            set: { _ in viewModel.errorMessage = nil }
        )) { error in
            Alert(title: Text("오류"), message: Text(error.message), dismissButton: .default(Text("확인")))
        }
        // 분석 결과 알림
        .alert(isPresented: $viewModel.showAnalysisResult) {
            Alert(
                title: Text(viewModel.analysisResultTitle),
                message: Text(viewModel.analysisResultMessage),
                dismissButton: .default(Text("확인"))
            )
        }
        // 로딩 인디케이터
        .overlay {
            if viewModel.isLoading {
                ZStack {
                    Color.black.opacity(0.4).ignoresSafeArea()
                    VStack(spacing: 15) {
                        ProgressView()
                            .scaleEffect(1.5)
                            .progressViewStyle(CircularProgressViewStyle(tint: .SoftGreen))
                        Text(viewModel.loadingStage.message)
                            .font(.headline)
                            .foregroundColor(.DarkText)
                    }
                    .padding(30)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                }
            }
        }
    }
}

struct AlertError: Identifiable {
    let id = UUID()
    let message: String
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
