//
//  DataHandlerKey.swift
//
//
//  Created by Kirill Titov on 02.08.2024.
//

import SwiftUI

/// Класс `DataHandlerKey` определяет ключ для использования в `Environment` SwiftUI.
/// Этот ключ используется для хранения и доступа к асинхронному замыканию, которое возвращает объект, соответствующий протоколу `CRUDHandler`, или `nil`.
/// Замыкание возвращается асинхронно, что позволяет осуществлять асинхронные операции при доступе к обработчику данных.
public class DataHandlerKey: EnvironmentKey {

	/// Значение по умолчанию для ключа `DataHandlerKey`.
	/// По умолчанию это замыкание, которое возвращает `nil`, что означает отсутствие обработчика данных в окружении.
	public static let defaultValue: @Sendable () async -> (any CRUDHandler)? = { nil }
}
