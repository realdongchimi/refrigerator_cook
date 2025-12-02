import SwiftUI
import PhotosUI

/// 메인 화면의 상태와 비즈니스 로직을 관리하는 ViewModel입니다.
/// GeminiService와 View 사이의 중재자 역할을 합니다.
@MainActor
class HomeViewModel: ObservableObject {
    
    // MARK: - Published Properties (UI 상태)
    
    /// 감지된 식재료 목록
    @Published var ingredients: [Ingredient] = []
    
    /// 추천된 레시피 목록
    @Published var recommendedRecipes: [Recipe] = []
    
    /// 로딩 상태 (API 호출 중일 때 true)
    @Published var isLoading: Bool = false
    
    /// 로딩 단계 (사용자 피드백용)
    enum LoadingStage {
        case none
        case analyzingIngredients
        case recommendingRecipes
        
        var message: String {
            switch self {
            case .analyzingIngredients: return "식재료 분석 중..."
            case .recommendingRecipes: return "메뉴 추천 중..."
            default: return ""
            }
        }
    }
    @Published var loadingStage: LoadingStage = .none
    
    /// 분석 결과 팝업 표시 여부
    @Published var showAnalysisResult: Bool = false
    @Published var analysisResultTitle: String = ""
    @Published var analysisResultMessage: String = ""
    
    /// 에러 메시지 (에러 발생 시 표시)
    @Published var errorMessage: String?
    
    /// 카메라 뷰 표시 여부
    @Published var showCamera: Bool = false
    
    /// 사진 보관함(앨범) 표시 여부
    @Published var showPhotoPicker: Bool = false
    
    /// 사용자가 선택하거나 촬영한 이미지
    @Published var inputImage: UIImage?
    
    // MARK: - Dependencies
    
    /// Gemini API 서비스 인스턴스
    private let geminiService = GeminiService.shared
    
    // MARK: - Methods
    
    /// 이미지가 선택되거나 촬영되었을 때 호출되는 메서드
    /// 이미지를 분석하여 식재료를 추출합니다.
    func analyzeSelectedImage() {
        guard let image = inputImage else { return }
        
        isLoading = true
        loadingStage = .analyzingIngredients
        errorMessage = nil
        
        Task {
            do {
                // 1. 이미지 분석 요청 (Gemini)
                let detectedIngredients = try await geminiService.analyzeImage(image: image)
                self.ingredients = detectedIngredients
                
                // 2. 식재료가 감지되었다면, 자동으로 레시피 추천도 요청
                if !detectedIngredients.isEmpty {
                    self.loadingStage = .recommendingRecipes
                    try await recommendRecipes(using: detectedIngredients)
                    
                    // 3. 분석 완료 팝업 설정
                    self.analysisResultTitle = "분석 완료"
                    self.analysisResultMessage = "총 \(detectedIngredients.count)개의 식재료가 감지되었습니다.\n(\(detectedIngredients.map { $0.name }.joined(separator: ", ")))"
                    self.showAnalysisResult = true
                } else {
                    self.analysisResultTitle = "분석 완료"
                    self.analysisResultMessage = "감지된 식재료가 없습니다."
                    self.showAnalysisResult = true
                }
                
            } catch {
                self.errorMessage = "분석 중 오류가 발생했습니다: \(error.localizedDescription)"
                print("Error analyzing image: \(error)")
            }
            
            self.isLoading = false
            self.loadingStage = .none
        }
    }
    
    /// 식재료 목록을 기반으로 레시피를 추천받는 메서드
    func recommendRecipes(using ingredients: [Ingredient]) async throws {
        let recipes = try await geminiService.recommendRecipes(ingredients: ingredients)
        self.recommendedRecipes = recipes
    }
    
    /// UI 테스트를 위한 Mock 데이터 로드 (개발용)
    func loadMockData() {
        self.ingredients = [
            Ingredient(name: "토마토", icon: "🍅"),
            Ingredient(name: "계란", icon: "🥚"),
            Ingredient(name: "파프리카", icon: "🫑"),
            Ingredient(name: "시금치", icon: "🥬")
        ]
        
        self.recommendedRecipes = [
            Recipe(name: "토마토 달걀 볶음", description: "간단하고 건강한 반찬", ingredients: ["토마토", "계란"], steps: ["토마토를 썬다", "계란을 푼다", "볶는다"], time: "10분", difficulty: "쉬움", imageKeyword: "tomato egg stir fry"),
            Recipe(name: "시금치 프리타타", description: "이탈리아식 오믈렛", ingredients: ["시금치", "계란", "토마토"], steps: ["재료를 섞는다", "오븐에 굽는다"], time: "20분", difficulty: "보통", imageKeyword: "spinach frittata")
        ]
    }
}
