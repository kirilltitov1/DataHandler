# SwiftDataHandler Library

## Требования

- Swift 6.0 и выше
- iOS 16.0 и выше
- Xcode 14.0 и выше

## Описание

Эта библиотека предоставляет универсальный обработчик данных `DataHandler` для работы с `SwiftData` в приложениях на Swift. `DataHandler` предлагает удобные и обобщенные функции для создания, чтения, обновления и удаления (CRUD) объектов в базе данных, а также управления связями между моделями. Эта библиотека предназначена для использования в проектах, где требуется работа с различными типами моделей в одном контексте `SwiftData`.

Основные функции `DataHandler` включают:

- **Создание объектов**: Создание новых объектов на основе переданных DTO (Data Transfer Objects) и их сохранение в базе данных.
- **Чтение объектов**: Извлечение объектов из базы данных по их уникальным идентификаторам (`PersistentIdentifier`).
- **Обновление объектов**: Обновление существующих объектов с использованием данных из переданных DTO.
- **Удаление объектов**: Удаление объектов из базы данных по их идентификаторам.
- **Управление связями**: Установка и управление отношениями между различными моделями данных в контексте `SwiftData`.

Библиотека построена на использовании `@ModelActor`, что обеспечивает безопасность при работе с многопоточностью и позволяет выполнять операции с данными асинхронно.

## Установка

Вы можете добавить `SwiftDataHandler` в ваш проект с помощью Swift Package Manager или склонировать репозиторий и интегрировать его в ваш проект вручную.

## Использование HandlerKey

### Создание DataProvider

```swift
import Foundation
import SwiftData
import DataHandler

public final class DataProvider: Sendable {
  public static let shared = DataProvider()

  public let sharedModelContainer: ModelContainer = {
    let schema = Schema(CurrentScheme.models)
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

    do {
      let modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
      print("🚧 " + (modelContainer.configurations.first?.url.path(percentEncoded: false) ?? ""))
      return modelContainer
    } catch {
      fatalError("Could not create ModelContainer: \(error)")
    }
  }()

  public let previewContainer: ModelContainer = {
    let schema = Schema(CurrentScheme.models)
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
    do {
      return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
      fatalError("Could not create ModelContainer: \(error)")
    }
  }()

  public init() {}
}
```

### Создание DataProvider+EnvironmentKey

```swift
import DataHandler
import SwiftUI

extension DataProvider {
  public func handlerCreator(preview: Bool = false) -> @Sendable () async -> CRUDHandler {
    let container = preview ? previewContainer : sharedModelContainer
    return { DataHandler(modelContainer: container) }
  }
}

public class HandlerKey: EnvironmentKey {
  public static let defaultValue: @Sendable () async -> CRUDHandler? = { nil }
}

extension EnvironmentValues {
  public var createDataHandler: @Sendable () async -> CRUDHandler? {
    get { self[HandlerKey.self] }
    set { self[HandlerKey.self] = newValue }
  }
}
```



## Интеграция в App

```swift
@main
struct MyApp: App {
  let dataProvider = DataProvider.shared

  var body: some Scene {
    WindowGroup {
      Main.Screen()
      .environment(\.createDataHandler, dataProvider.handlerCreator())
    }
    .modelContainer(dataProvider.sharedModelContainer)
  }
}
```



## Использование DataHandler

### Пример создания и чтения объектов

```swift
// Создание нового рецепта
let recipeId = try await dataHandler.createItem(dto: sharedRecipeDTO, type: RecipeModel.self)

// Чтение существующего рецепта по идентификатору
if let existingRecipe = try await dataHandler.readItem(id: recipeId, type: RecipeModel.self) {
  print("Recipe: \(existingRecipe.name)")
}
```

### Пример обновления объекта

```swift
// Обновление существующего рецепта
try await dataHandler.updateItem(id: recipeId, dto: updatedRecipeDTO, type: RecipeModel.self)
```

### Пример удаления объекта

```swift
// Удаление рецепта по его идентификатору
try await dataHandler.deleteItem(id: recipeId, type: RecipeModel.self)
```

### Пример управления связями

```swift
// Добавление ингредиентов к рецепту
try await dataHandler.addRelation(
  parentID: recipeId,
  parentType: RecipeModel.self,
  childIDs: ingredientIDs,
  childType: IngredientModel.self,
  relationKeyPath: \RecipeModel.ingredients
)
```

## Вклад

Если вы хотите внести свой вклад в развитие этой библиотеки, пожалуйста создавайте issues для обсуждения возможных улучшений и новых функций.

Спасибо!

---

