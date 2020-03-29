# GoodlyPRO
GoodlyPRO

## Тестовое задание для разработчика.

 Создание всплывающих окон (попапов) для сайта.  Пример всплывающего окна в приложении    Задачи

1.Реализовать сущность Попапа 
	- Название
	- Текст содержимого
	- Включен он или выключен

2. Реализовать административную часть CRUD операции для попапа.  

3. Реализовать статистику по количеству показов. В списке попапов для каждой записи должно быть выведено количество показов данного попапа.

4. Реализовать демонстративную страницу на которой будет установлен код попапа.  5. Реализовать произвольный эффект появления и закрытия всплывающего окна (анимацию).  Примечание: Все таблицы для БД должны быть созданы при помощи миграций  Общее описание задачи  

После создания попапа должна генерироваться ссылка на js скрипт, который возможно поставить на любой сайт. Скрипт устанавливается единожды.  Все внесенные в попап изменения должны быть применены к уже установленным попапам.

При подключении данного скрипта через 10 секунд после загрузки страницы должно отображаться созданное пользователем всплывающее окно. Если попап был отключен пользователем в административной части, то он не должен быть показан.  По каждому попапу в административной части должна быть информация о количестве показов.  

Результат предоставить ссылкой на репозиторий. 

## Запуск

Создание образа: `docker-compose build`

Запуск образа: `docker-compose up`

Остановка образа: [ CTRL + C ] и `docker-compose down`

Смотрим:  http://localhost:9090

## Структура среды разработки

+ :file_folder: `develop` - директория разработки

+ :file_folder: `develop/client` - директория front-end

+ :file_folder: `develop/server` - директория back-end