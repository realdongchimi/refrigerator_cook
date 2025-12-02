import SwiftUI

/// 최근 추천 메뉴를 보여주는 뷰입니다.
/// 목업 디자인에 맞춰 오렌지색 타이틀과 메뉴 카드 리스트를 표시합니다.
struct RecommendMenuView: View {
    /// 표시할 레시피 리스트 (외부에서 주입)
    let recipes: [Recipe]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // 1. 섹션 타이틀
            Text(Constants.UI.recommendationTitle)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.orange)
                .padding(.horizontal)
            
            // 2. 가로 스크롤 메뉴 리스트
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    if recipes.isEmpty {
                        // 레시피가 없을 때 표시할 플레이스홀더 또는 안내 문구
                        Text("식재료를 분석하면 메뉴를 추천해드려요!")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .padding()
                            .frame(height: 140)
                    } else {
                        ForEach(recipes) { recipe in
                            MenuCard(recipe: recipe)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 10) // 그림자 잘림 방지
            }
        }
    }
}

/// 개별 메뉴를 보여주는 카드 뷰 (내부 전용)
private struct MenuCard: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 메뉴 이미지 (AsyncImage 사용)
            if let keyword = recipe.imageKeyword, !keyword.isEmpty {
                // Unsplash Source를 사용하여 고품질 음식 이미지 로드
                // 'food' 태그를 강제로 추가하여 음식 관련 이미지만 나오도록 함
                let safeKeyword = keyword.replacingOccurrences(of: " ", with: ",")
                AsyncImage(url: URL(string: "https://source.unsplash.com/featured/320x240/?food,\(safeKeyword)")) { phase in
                    switch phase {
                    case .empty:
                        Color.gray.opacity(0.2) // 로딩 중
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        Image(systemName: "photo") // 로드 실패 시
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 140, height: 120)
                .clipped()
                .cornerRadius(12)
                .padding(10)
            } else {
                // 키워드가 없거나 로드 실패 시 기본 이미지
                Image("omelet") // 기본 에셋 사용 (없으면 시스템 이미지로 대체 고려)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 140, height: 120)
                    .clipped()
                    .cornerRadius(12)
                    .padding(10)
            }
            
            // 메뉴 정보 (이름 + 별)
            HStack {
                Text(recipe.name)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.DarkText)
                    .lineLimit(1)
                
                Spacer()
                
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .font(.system(size: 14))
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 15)
        }
        .frame(width: 160) // 카드 고정 너비
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

struct RecommendMenuView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.Cream.ignoresSafeArea()
            VStack {
                Spacer()
                RecommendMenuView(recipes: [
                    Recipe(name: "테스트 파스타", description: "설명", ingredients: [], steps: [], time: "10분", difficulty: "쉬움", imageKeyword: "pasta"),
                    Recipe(name: "테스트 피자", description: "설명", ingredients: [], steps: [], time: "20분", difficulty: "보통", imageKeyword: "pizza")
                ])
                Spacer()
            }
        }
    }
}
