// init.sqf (clash.sqf)

// выбрать локацию из всех локаций заданного типа и получить её координату

	// определить центр и радиус острова
	
		// находим длину сторону карты 
				
		_edge = worldSize ; 
		
			// техническая вставка 
			
				/*
				// хинт worldSize
				
				hint (str _edge);
				
				// копирование в буфер обмена значения worldSize
				
				copyToClipboard (str _edge);
				*/
				
		// получаем её половину
		
		_half = _edge / 2;
		
		// определяем центр острова
		
		_centerOfMap = [_half,_half];
		
			// техническая вставка (маркер на центр карты)
			
			/*
			_mkr = createMarker ["markerCenterOfMap",_centerOfMap];
			_mkr setMarkerType "mil_dot";
			_mkr setMarkerColor "ColorRed";
			*/
			
		// по теореме Пифагора определяем радиус
		
		_radius = sqrt((_half ^ 2) + (_half ^ 2));		
	
	// командой nearestLocations получить список всех локаций заданного типа ("NameVillage")
	
	_nearestLocations = nearestLocations [_centerOfMap, ["NameVillage"], _radius];
	
	// из всех полученных локаций выбрать одну случайную 
	
	_location = selectRandom _nearestLocations;
	
	// получить координату выбранной локации
	
	_position = locationPosition _location;
	
// техническая вставка (маркеры на все локации и хинт на их количество)

	/*
	// маркеры на все локации
	
	{
		_mkr = createMarker ["mkr" + (str _forEachIndex),locationPosition _x];
		_mkr setMarkerType "mil_dot";
		_mkr setMarkerColor "ColorBlue";
	} forEach _nearestLocations;
	
	// хинт на количество локаций заданного типа (типов)
	
	hint str count _nearestLocations;
	*/
	
// по полученной координате создать один отряд противника 

	// использую список типов противника и цикл создать один отряд противника на полученной позиции
	
		// задаём список (массив) типов противника
		
		_enemyUnitTypes = ["O_G_Soldier_F","O_G_Soldier_SL_F","O_G_Soldier_F"];
		
		// создать группу, в которую будут добавлены противники
		
		_groupEnemy = createGroup [east,true];
		
		// выполняем цикл на создание отряда противника
		
		for [{_i = 0},{_i < (count _enemyUnitTypes)},{_i = _i + 1}]
		do
		{
			_groupEnemy createUnit [(_enemyUnitTypes select _i), _position,[],0,"FORM"];
		};
	
// на полученную позицию (но с удалением 50 метров от неё) перенести игрока
	
	// выбрать позицию на удалении 50 метров от позиции локации 
	
	_playerPosition = _position getPos [50, random 360];
	
	// перенести на неё игрока
	
	player setPos _playerPosition;
	
// создать игроку отряд

	// используя список типов союзников игрока и цикл создать отряд для игрока
	
		// определить список (массив) типов союзников
		
		_alliasUnitTypes = ["B_Soldier_F","B_Soldier_F","B_Soldier_F"];
		
		// выполнить цикл на создание союзников 
		
		for [{_i = 0},{_i < (count _alliasUnitTypes)},{_i = _i + 1}]
		do
		{
			(group player) createUnit [(_alliasUnitTypes select _i), _playerPosition,[],0,"FORM"];
		};
		
// создать задачу (стандартный task) и представить её для игрока

	// создать задачу
		
	[player, "task_1", ["Attack hostiles in village and clear it.", "Attack them", "attack"], _position, "CREATED", -1, false, "attack", true] call  BIS_fnc_taskCreate;
		
	// назначить задачу
		
	["task_1", "ASSIGNED", true] call BIS_fnc_taskSetState;
	
// осуществлять проверку выполнения условия задачи и завершить сценарий

	// определиться с условием завершения сценария
	
		// условие : все противник убиты
		
	// реализовать проверку условия  
		
	waitUntil {(east countSide allUnits) == 0};
	
	// установить task как выполненный
	
	["task_1", "SUCCEEDED", true] call BIS_fnc_taskSetState;
	
	// подождать 3 секунды
	
	sleep 3;
	
	// завершить сценарий
	
	endMission "END1";











