### Пока в разработке 

## Старый плагин в нем можно подсмотреть реализацию /oldMod

### Исходник старого мода https://steamcommunity.com/sharedfiles/filedetails/?id=2256147202

### Исходник для нового мода https://steamcommunity.com/sharedfiles/filedetails/?id=198414240&searchtext=urik



#### Как это работает?
- В resource\ui\l4d360ui\mutations\custommutationsflyout.res определяется Икнока для главного экрана там же прописываются режимы игры
- По умолчанию я оставил versus и coop, но при желание можно раскоментрировать что бы были и другие (если есть конечно сервера с такими режимами)

#### А как добавить свой сервер? 
- Сначала нужно добавить разметку для своего сервера в список всех серверов
- Подсмотреть можно в файле выше custommutationsflyout имеет параметр "command"				"FlmVersusMutationsFlyout" где FlmVersusMutationsFlyout это разметка для этого файла
- Переходим в файл где определяются пути до разметок resource\ui\l4d360ui\mainmenu.res и ищем по ключевому слову "FlmVersusMutationsFlyout"
  ```
	"FlmVersusMutationsFlyout"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlmVersusMutationsFlyout"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnMutationList1"
		"ResourceFile"			"resource/UI/L4D360UI/Mutations/Versusmutationsflyout.res"
	}
  ```
  Как видно тут указан путь к файлу где содержатся названия всех проектов идем в него Versusmutationsflyout
Там внимательно изучаем разметку
```
	"BtnProject2"
	{
		"ControlName"			"L4D360HybridButton"
		"fieldName"				"BtnProject2"
		"xpos"					"0"
		"ypos"					"20" <- всегда + 20 к следующему элементу что бы они не наползли друг на друга
		"wide"					"150"
		"tall"					"20"
		"autoResize"			"1"
		"pinCorner"				"0"
		"visible"				"1"
		"enabled"				"1"
		"tabPosition"			"0"
		"wrap"					"1"		
		"navUp"					"BtnProject1" <- желательно указать какой элемент выше него
		"navDown"				"BtnProject3" <- желательно указать какой элемент ниже него, сони бои оценят
		"labelText"				"Freiheit Servers"
		"tooltiptext"			"#L4D360UI_MainMenu_PlayCoOpWithAnyone_Tip"
		"disabled_tooltiptext"	"#L4D360UI_MainMenu_PlayCoOpWithAnyone_Tip_Disabled"
		"style"					"FlyoutMenuButton"
		"command"				"FlyoutProjectFreiheit" <- наша разметка для самих серверов внутри где мы настраиваем подключение
	}
```
- Тут мы добавляем им нашего проекта а там где command "FlyoutProjectFreiheit" берем и снова идем в mainmenu
Ищем по ключевому слову и находим 3 записи

Превое что н ужно это создать хук поэтмоу копируем и делаем такое же меня Freiheit на свой проект SUPERPROJECT
```
	// SUPERPROJECT Servers
	"BtnSUPERPROJECTServers"
	{
		"ControlName"                           "L4D360HybridButton"
		"FieldName"                             "Btn1L2LMutations"
		"xpos"                                  "c-177"//flyouts xpos. This has to be adjusted to match gamemodes' initial flyouts xpos, which depend on "wideatopen" setting
		"ypos"                                  "160"//flyouts ypos
		"wide"                                  "0"//flyouts width
		"tall"                                  "20"
		"visible"                               "0"
		"enabled"                               "1"
		"labeltext"                             ""
		"tooltiptext"                           ""
		"style"                                 "MainMenuButton"
		"command"                               "FlyoutProjectSUPERPROJECT"
	}
```

Справились? супер! запоминаем что написали в command в данном случае FlyoutProjectSUPERPROJECT
- Опускаемся ниже до и копируем такую же строчку
  ```
	// Freiheit Servers
	"FlyoutProjectFreiheit"
	{
		"ControlName"			"FlyoutMenu"
		"fieldName"				"FlyoutProjectFreiheit"
		"visible"				"0"
		"wide"					"0"
		"tall"					"0"
		"zpos"					"3"
		"InitialFocus"			"BtnPlayMutation1"
		"ResourceFile"			"resource/UI/L4D360UI/Project/freiheit.res"
	}
  ```

  И в своей строке меняем FlyoutProjectFreiheit на FlyoutProjectSUPERPROJECT не забываем про fieldName

  Однако тут указан так же путь к нашим серверам "ResourceFile"			"resource/UI/L4D360UI/Project/freiheit.res"
  Мы же меняем на свой "ResourceFile"			"resource/UI/L4D360UI/Project/SUPERPROJECT.res"

  - Идем в эту папку и копируем freiheit.res что бы на его основе добавить свои сервера
  - Дальше думаю разобраться не составит проблем
  - Главное менять
    		"labelText"				"Freiheit 1"
		"command"				"#con_enable 1;connect 46.174.48.163:27001"

и не забывать про размеры ypos у каждого элемента
Если ваших серверов слишком много то у PnlBackground меняем tall на (ypos вашего последнего элемента + 25)
