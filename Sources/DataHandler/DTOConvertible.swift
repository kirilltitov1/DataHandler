//
//  DTOConvertible.swift
//  PopFoodsUnitTests
//
//  Created by Kirill Titov on 01.08.2024.
//

import SwiftData

/// Протокол для конвертации и обновления с shared KMM на SwiftData
public protocol DTOConvertible<DTO>: PersistentModel, Codable {
	/// shared ДТО для обновления элемента базы данных
	associatedtype DTO

	/// Приведение типа ДТО из shared KMM к @Model SwiftData
	/// - Parameter dto: shared DTO
	/// - Returns: модель SwiftData
	static func convert(from dto: DTO) -> Self?

	/// Обновление @Model SwiftData
	/// - Parameter newItem: @Model SwiftData
	func update(newItem: Self)
}
