 
# Резервное копирования и восстановления сервера с запущенным своим проектом
## *Опция 6* 

1. запуск проекта
> Для запуска проекта создан скрипт start.bash. Он сначала  запускает cкрипт создания базы данных 
create_database.sql, а затем запускает приложение в форме демона используя диспетчер процессов pm2 
[Подробнее о pm2](https://pm2.keymetrics.io/)
2. внесение первичных данных в запущенное решение (например скрипт загрузки данных, либо эмуляции работы пользователя)
> Для заполнения данными используется скрипт add_data.bash. Данный скрипт принимает на вход число, количество записей, которое должно быть в таблицах.
3. запуск скрипта резервного копирования
> Для запуска резервного копирования используется скрипт reco_data.bash он создает новую директорию (backaps) в корневом катологе сервера, создает резервную копию базы данных и копию каталога проекта с всеми подкатологами 
4. внесение изменений в запущенное решение (например скрипт загрузки очередной порции данных, либо эмуляции работы пользователя, либо скрипт удаления всего приложения и данных)
> Для запуска удаления приложения и данных испольузется скрипт drop_service.bash он удаляет папку с проектом и базу данных сервера
5. запуск скрипта восстановления (аргументом должен быть архив(ы) резервной копии полученных из пункта 3)
> Для востановления используется скрипт restore.bash данный сервис принимает на вход первым аргуметом пусть к резервной копии проекта, а вторым аргументом путь к бэкапу базы данных приложения (Переж этим в случае отсутвия базы данных она создается).
6. описание как проверить что данные восстановились и изменения из пункта 4 отсутствуют в системе.
> Для проверки восстановления данных используется скрипт check_data.bash. Он показывает  все файлы проекта и все таблицы с данными на момент резервного копирования восстановились. Таким образом показывая что все востановилось.

&#169; Тащилин Антон б1-ИФСТ-31