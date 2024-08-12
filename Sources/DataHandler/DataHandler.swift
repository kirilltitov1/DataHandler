//
//  DataHandler.swift
//  iosApp
//
//  Created by Kirill Titov on 01.08.2024.
//

import SwiftData

/// Протокол `CRUDHandler` предоставляет интерфейс для выполнения CRUD операций с персистентными моделями данных.
/// Он обеспечивает универсальный способ взаимодействия с объектами, которые можно конвертировать между DTO и персистентными моделями.
///
/// `Item` должен соответствовать протоколу `DTOConvertible`, который определяет способность конвертации между DTO и моделью.
public protocol CRUDHandler {

	/// Создает несколько новых объектов на основе переданных DTO и сохраняет их в базе данных.
	/// - Parameter dto: Один или несколько объектов типа `DTO`, которые будут конвертированы и сохранены.
	/// - Parameter type: Тип модели `Item`, который соответствует протоколу `DTOConvertible` и будет создан на основе переданного DTO.
	/// - Returns: Массив идентификаторов `PersistentIdentifier` вновь созданных объектов.
	/// - Throws: Ошибка, если создание или сохранение объектов завершилось неудачей.
	@discardableResult
	func createItems<Item: DTOConvertible>(dto: [Item.DTO], type: Item.Type) async throws -> [PersistentIdentifier]

	/// Создает новый объект на основе переданного DTO и сохраняет его в базе данных.
	/// - Parameter dto: Объект типа `DTO`, который будет конвертирован и сохранен.
	/// - Parameter type: Тип модели `Item`, который соответствует протоколу `DTOConvertible` и будет создан на основе переданного DTO.
	/// - Returns: Идентификатор `PersistentIdentifier` вновь созданного объекта.
	/// - Throws: Ошибка, если создание или сохранение объекта завершилось неудачей.
	@discardableResult
	func createItem<Item: DTOConvertible>(dto: Item.DTO, type: Item.Type) async throws -> PersistentIdentifier

	/// Считывает несколько объектов из базы данных по их идентификаторам.
	/// - Parameter ids: Массив идентификаторов `PersistentIdentifier` для объектов, которые нужно считать.
	/// - Parameter type: Тип модели `Item`, который соответствует протоколу `DTOConvertible` и будет создан на основе переданного DTO.
	/// - Returns: Массив объектов типа `Item`, которые соответствуют переданным идентификаторам.
	/// - Throws: Ошибка, если чтение объектов завершилось неудачей.
	func readItems<Item: DTOConvertible>(ids: [PersistentIdentifier], type: Item.Type) async throws -> [Item]

	/// Считывает один объект из базы данных по его идентификатору.
	/// - Parameter id: Идентификатор `PersistentIdentifier` объекта, который нужно считать.
	/// - Parameter type: Тип модели `Item`, который соответствует протоколу `DTOConvertible` и будет создан на основе переданного DTO.
	/// - Returns: Объект типа `Item`, соответствующий переданному идентификатору, или `nil`, если объект не найден.
	/// - Throws: Ошибка, если чтение объекта завершилось неудачей.
	func readItem<Item: DTOConvertible>(id: PersistentIdentifier, type: Item.Type) async throws -> Item?

	/// Обновляет существующий объект в базе данных, используя данные из переданного DTO.
	/// - Parameters:
	///   - id: Идентификатор `PersistentIdentifier` объекта, который нужно обновить.
	///   - dto: Объект типа `DTO`, содержащий обновленные данные.
	///   - customAction: Тип модели `Item`, который соответствует протоколу `DTOConvertible` и будет создан на основе переданного DTO.
	/// - Throws: Ошибка, если обновление объекта завершилось неудачей.
	func updateItem<Item: DTOConvertible>(
		id: PersistentIdentifier,
		dto: Item.DTO?,
		type: Item.Type
	) async throws

	/// Удаляет объект из базы данных по его идентификатору.
	/// - Parameter id: Идентификатор `PersistentIdentifier` объекта, который нужно удалить.
	/// - Parameter type: Тип модели `Item`, который соответствует протоколу `DTOConvertible` и будет создан на основе переданного DTO.
	/// - Throws: Ошибка, если удаление объекта завершилось неудачей.
	func deleteItem<Item: DTOConvertible>(id: PersistentIdentifier, type: Item.Type) async throws
	
	///	Удаляет объекты из базы данных по их идентификаторам.
	/// - Parameters:
	///   - ids: Идентификаторы `PersistentIdentifier` объектов, которые нужно удалить.
	///   - type: Тип модели `Item`, который соответствует протоколу `DTOConvertible` и будет создан на основе переданного DTO.
	func deleteItems<Item: DTOConvertible>(ids: [PersistentIdentifier], type: Item.Type) async throws

	/// Добавляет связь между родительской сущностью и набором дочерних сущностей в контексте.
	/// - Parameters:
	///   - parentID: Уникальный идентификатор родительской сущности, к которой будут добавлены дочерние сущности.
	///   - parentType: Тип родительской сущности (должен соответствовать протоколу `DTOConvertible`).
	///   - childIDs: Массив уникальных идентификаторов дочерних сущностей, которые будут связаны с родительской.
	///   - childType: Тип дочерних сущностей (должен соответствовать протоколу `DTOConvertible`).
	///   - relationKeyPath: Ключевой путь, указывающий на свойство отношения родительской сущности, куда будут добавлены дочерние сущности.
	func addRelation<Parent: DTOConvertible, Child: DTOConvertible>(
		parentID: PersistentIdentifier,
		parentType: Parent.Type,
		childIDs: [PersistentIdentifier],
		childType: Child.Type,
		relationKeyPath: ReferenceWritableKeyPath<Parent, [Child]>
	) async throws
	
	/// Выполняет кастомный запрос в базе данных и возвращает идентификаторы найденных объектов.
	/// - Parameter fetchDescriptor: Описание запроса, включающее предикаты,
	///  сортировку и другие параметры для фильтрации объектов типа `Item`.
	/// - Returns: Массив `PersistentIdentifier`, содержащий идентификаторы найденных объектов.
	/// - Throws: Ошибка, если запрос не может быть выполнен.
	func fetchItems<Item: PersistentModel>(
		with fetchDescriptor: FetchDescriptor<Item>
	) async throws -> [PersistentIdentifier]
}

@ModelActor
public actor DataHandler: CRUDHandler {

	/// Ошибки бросающие репозиторием рецептов
	public enum HandlerError: Error {
		case invalideData
		case itemNotFound

		case creationFailed
		case updateFailed
		case deleteFailed
	}

	@discardableResult public func createItems<Item: DTOConvertible>(dto: [Item.DTO], type: Item.Type) throws -> [PersistentIdentifier] {
		try dto.map { try createItem(dto: $0, type: type) }
	}

	@discardableResult public func createItem<Item: DTOConvertible>(dto: Item.DTO, type: Item.Type) throws -> PersistentIdentifier {
		guard let item = Item.convert(from: dto) else {
			throw HandlerError.invalideData
		}
		modelContext.insert(item)
		do {
			try modelContext.save()
			return item.persistentModelID  // предполагается, что модели имеют свойство persistentModelID
		} catch let err {
			print(err)
			throw HandlerError.creationFailed
		}
	}

	public func readItems<Item: DTOConvertible>(ids: [PersistentIdentifier], type: Item.Type) throws -> [Item] {
		try ids.compactMap { try readItem(id: $0, type: type) }
	}

	public func readItem<Item: DTOConvertible>(id: PersistentIdentifier, type: Item.Type) throws -> Item? {
		guard let item = self[id, as: Item.self] else {
			throw HandlerError.itemNotFound
		}
		return item
	}

	public func updateItem<Item: DTOConvertible>(
		id: PersistentIdentifier,
		dto: Item.DTO? = nil,
		type: Item.Type
	) throws {
		guard let existedItem = self[id, as: Item.self] else {
			throw HandlerError.itemNotFound
		}
		if let dto = dto,
		   let item = Item.convert(from: dto) {
			existedItem.update(newItem: item)
		}

		do {
			try modelContext.save()
		} catch {
			throw HandlerError.updateFailed
		}
	}

	public func deleteItems<Item: DTOConvertible>(ids: [PersistentIdentifier], type: Item.Type) throws {
		try ids.forEach { try deleteItem(id: $0, type: type) }
	}

	public func deleteItem<Item: DTOConvertible>(id: PersistentIdentifier, type: Item.Type) throws {
		guard let item = self[id, as: Item.self] else {
			throw HandlerError.itemNotFound
		}
		modelContext.delete(item)
		do {
			try modelContext.save()
		} catch {
			throw HandlerError.deleteFailed
		}
	}

	public func fetchItems<Item: PersistentModel>(
		with fetchDescriptor: FetchDescriptor<Item>
	) throws -> [PersistentIdentifier] {
		// Выполняем запрос с использованием переданного FetchDescriptor
		return try modelContext.fetch(fetchDescriptor).map(\.persistentModelID)
	}

	public func addRelation<Parent: DTOConvertible, Child: DTOConvertible>(
		parentID: PersistentIdentifier,
		parentType: Parent.Type,
		childIDs: [PersistentIdentifier],
		childType: Child.Type,
		relationKeyPath: ReferenceWritableKeyPath<Parent, [Child]>
	) throws {
		// Чтение родительского элемента
		guard let parent = try readItem(id: parentID, type: parentType) else {
			throw HandlerError.itemNotFound
		}

		// Чтение дочерних элементов
		let children: [Child] = try childIDs.compactMap { try readItem(id: $0, type: childType) }

		// Фильтрация новых дочерних элементов, которые уже есть в массиве
		let existingChildren = parent[keyPath: relationKeyPath]
		let newChildren = children.filter { !existingChildren.contains($0) }

		// Добавление только уникальных дочерних элементов
		newChildren.forEach {
			parent[keyPath: relationKeyPath].append($0)
		}

		// Сохранение изменений в контексте
		do {
			try modelContext.save()
		} catch {
			throw HandlerError.updateFailed
		}
	}
}
