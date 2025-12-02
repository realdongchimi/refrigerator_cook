import SwiftUI

/// 감지된 식재료 목록을 보여주는 가로 스크롤 섹션 뷰입니다.
/// "감지된 식재료" 타이틀과 식재료 카드 리스트를 포함합니다.
struct IngredientRow: View {
    /// 표시할 식재료 리스트
    let ingredients: [Ingredient]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // 1. 섹션 타이틀
            Text(Constants.UI.ingredientsTitle)
                .font(.system(size: 20, weight: .heavy)) // 목업과 유사한 굵은 폰트
                .foregroundColor(.green)
                .padding(.horizontal) // 좌우 여백
            
            // 2. 가로 스크롤 리스트
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(ingredients) { ingredient in
                        IngredientCard(ingredient: ingredient)
                    }
                }
                .padding(.horizontal) // 컨텐츠 좌우 여백
                .padding(.bottom, 10) // 그림자 잘림 방지 여백
            }
        }
    }
}

/// 개별 식재료를 보여주는 카드 뷰 (내부 전용)
private struct IngredientCard: View {
    let ingredient: Ingredient
    
    var body: some View {
        VStack(spacing: 5) {
            // 아이콘 (크게)
            Text(ingredient.icon)
                .font(.system(size: 40))
            
            // 이름 (작게)
            Text(ingredient.name)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.DarkText)
                .lineLimit(1)
        }
        .frame(width: 80, height: 100)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Previews
struct IngredientRow_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.Cream.ignoresSafeArea()
            
            VStack {
                Spacer()
                IngredientRow(ingredients: [
                    Ingredient(name: "토마토", icon: "🍅"),
                    Ingredient(name: "계란", icon: "🥚"),
                    Ingredient(name: "시금치", icon: "🥬"),
                    Ingredient(name: "당근", icon: "🥕")
                ])
            }
        }
    }
}
