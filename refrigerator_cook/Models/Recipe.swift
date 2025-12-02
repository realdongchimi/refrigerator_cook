import Foundation

/// 요리 레시피 정보를 담는 데이터 모델입니다.
/// Gemini API로부터 추천받은 요리의 상세 정보를 저장합니다.
struct Recipe: Identifiable, Codable {
    /// 리스트에서 고유하게 식별하기 위한 ID (UUID 자동 생성)
    let id: UUID
    
    /// 요리 이름 (예: "토마토 달걀 볶음")
    let name: String
    
    /// 요리에 대한 간단한 설명 (예: "바쁜 아침에 딱 좋은 초간단 영양 반찬")
    let description: String
    
    /// 필요한 재료 목록 (예: ["토마토 2개", "계란 3개", "대파 약간"])
    let ingredients: [String]
    
    /// 조리 순서 (예: ["1. 토마토를 썬다.", "2. 계란을 푼다.", "3. 볶는다."])
    let steps: [String]
    
    /// 예상 조리 시간 (예: "15분")
    let time: String
    
    /// 요리 난이도 (예: "쉬움", "보통", "어려움")
    let difficulty: String
    let imageKeyword: String? // 이미지 검색을 위한 영문 키워드
    
    /// 초기화 메서드
    init(id: UUID = UUID(), name: String, description: String, ingredients: [String], steps: [String], time: String, difficulty: String, imageKeyword: String? = nil) {
        self.id = id
        self.name = name
        self.description = description
        self.ingredients = ingredients
        self.steps = steps
        self.time = time
        self.difficulty = difficulty
        self.imageKeyword = imageKeyword
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case ingredients
        case steps
        case time
        case difficulty
        case imageKeyword
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decode(String.self, forKey: .description)
        self.ingredients = try container.decode([String].self, forKey: .ingredients)
        self.steps = try container.decode([String].self, forKey: .steps)
        self.time = try container.decode(String.self, forKey: .time)
        self.difficulty = try container.decode(String.self, forKey: .difficulty)
        self.imageKeyword = try container.decodeIfPresent(String.self, forKey: .imageKeyword)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(ingredients, forKey: .ingredients)
        try container.encode(steps, forKey: .steps)
        try container.encode(time, forKey: .time)
        try container.encode(difficulty, forKey: .difficulty)
        try container.encode(imageKeyword, forKey: .imageKeyword)
    }
}
