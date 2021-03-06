### Тестовое задание для Own-Script
Выполнил Чибисов Михаил

![DB schema](https://i.imgur.com/E584qKP.png)

### Реализация дерева категорий
Если же дизайн остальной части схемы данных не вызывает вопросов, то для 
выбора оптимальной структуры хранения дерева категорий придется выбирать 
между несколькими вариантами. Основными способами организации являются 
Adjacency List, Nested Set и Materialized Path. И у каждого варианта есть 
свои превосходства и недостатки.

Так, Adjacency List прекрасно справляется с поиском потомков первого уровня 
вложенности и с модификацией дерева, однако получение всех подкатегорий 
вглубь - процедура очень неуклюжая из-за большого количества JOIN'ов. 
Nested Set без проблем справляется и с первой подкатегорией, и со всеми 
подкатегориями в глубину, но любое изменение древа ведет к пересчету 
значений двоичного древа, из-за чего такое решение подходит только для 
около-статичных деревьев. Materialized Path эффективен в поиске вглубь и 
добавлении узлов в конец веток, однако вставка в середину - весьма 
проблематична.

По условию задания нам необходимо выбрать структуру, позволяющую 
"безболезненно добавлять категории любого уровня вложенности". 
Безболезненое изменение дерева - это не про Nested Set, поэтому его мы 
сразу отметаем. Нам также важно быстро получать потомков категории первого 
поколения, с чем отлично справляется Adjacency List, но не стоит забывать 
про неограниченный уровень вложенности и потенциальные проблемы с ним(а ведь 
получения поддрева для конкретного узла - операция довольно важная для 
интернет-магазина).

В качестве наилучшего варианта в этой ситуации я предлагаю совместить 
Adjacency List(AL) и Materialized Path(MP). Такой вариант является 
компромиссным 
между большим уровнем вложенности и быстрым получением потомков первого 
поколения с индексом btree. Добавление новых узлов также происходит гладко, 
только если это не вставка в середину уже сформированной ветви.

Эффективность такого подхода подтверждается анализом запросов. В ходе 
тестирования использовалась локальная база с автосгенерированными 10000 
категориями. Так, поиск потомков первого поколения через MP в среднем 
проходил за 4-8 ms, тогда как аналогичная операция при помощи AL и btree 
индекса выполняется за 0.02-0.03 ms. С запросами вглубь ситуация 
кардинально другая: при получении всего поддрева одной из первых нод AL 
показывает результат в 50-60 ms, ML же выполняется за 4-6 ms.


