import Foundation

/// 식재료 정보를 담는 데이터 모델입니다.
/// Gemini API로부터 받은 JSON 응답을 이 구조체로 자동 변환하기 위해 Codable 프로토콜을 채택했습니다.
struct Ingredient: Identifiable, Codable {
    /// 리스트에서 고유하게 식별하기 위한 ID (UUID 자동 생성)
    let id: UUID
    
    /// 식재료 이름 (예: "토마토", "계란")
    let name: String
    
    /// 식재료를 나타내는 이모지 아이콘 (예: "🍅", "🥚")
    let icon: String
    
    /// 식재료의 양 (선택 사항, 예: "2개", "300g")
    var quantity: String?
    
    /// 초기화 메서드
    /// - Parameters:
    ///   - id: 고유 ID (기본값은 새로운 UUID)
    ///   - name: 식재료 이름
    ///   - icon: 이모지 아이콘
    ///   - quantity: 수량 (옵션)
    init(id: UUID = UUID(), name: String, icon: String, quantity: String? = nil) {
        self.id = id
        self.name = name
        self.icon = icon
        self.quantity = quantity
    }
    
    // Gemini API와의 통신을 위한 키 매핑 (JSON 키와 변수명이 다를 경우 사용)
    // 현재는 변수명과 JSON 키가 같다고 가정하여 생략 가능하지만, 명시적으로 적어두면 관리에 용이합니다.
    enum CodingKeys: String, CodingKey {
        case name
        case icon
        case quantity
        // id는 로컬에서 생성하므로 디코딩 시 제외하거나, 서버에서 주지 않는 경우 처리가 필요합니다.
        // 여기서는 디코딩 시 id는 제외하고 초기화할 수 있도록 확장이 필요할 수 있습니다.
        // 하지만 간단하게 Gemini가 id를 주지 않는다고 가정하고, Decodable init을 커스텀하거나
        // id를 var로 선언하고 디코딩 후 할당하는 방식을 쓸 수 있습니다.
        // 가장 깔끔한 방법은 Decodable을 커스텀 구현하는 것입니다.
    }
    
    // Decodable 커스텀 구현: JSON에 id가 없어도 자동으로 UUID를 생성하도록 함
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID() // 로컬에서 새로운 ID 생성
        self.name = try container.decode(String.self, forKey: .name)
        self.icon = try container.decode(String.self, forKey: .icon)
        self.quantity = try container.decodeIfPresent(String.self, forKey: .quantity)
    }
    
    // Encodable 기본 구현 사용 (id 포함 여부는 서버 요구사항에 따라 결정)
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(icon, forKey: .icon)
        try container.encode(quantity, forKey: .quantity)
    }
}
