params ["_startpoint","_bothWays"];

_endpoint = (synchronizedObjects _startpoint) select 0;

_pole_start = createVehicle ["Land_PowerPoleConcrete_F", position _startpoint, [], 0, "CAN_COLLIDE"];
_pole_end   = createVehicle ["Land_PowerPoleConcrete_F", position _endpoint, [], 0, "CAN_COLLIDE"];

_dirToEndpoint = _startpoint getDirVisual _endpoint;
{
    _x setDir _dirToEndpoint;
    _x setVectorUp [0,0,1];
    _x setPos (getPos _x vectorAdd [0,0,-7]);
} forEach [_pole_start, _pole_end];

_bbStart = boundingBoxReal _pole_start;
_bbEnd   = boundingBoxReal _pole_end;

_topZStart = (_bbStart select 1) select 2;
_topZEnd   = (_bbEnd select 1) select 2;

_zipline_start_pos = _pole_start modelToWorld [0,0,_topZStart - 0.15];
_zipline_end_pos   = _pole_end   modelToWorld [0,0,_topZEnd - 0.15];

_zipline_start = createVehicle ["Sign_Sphere25cm_F", _zipline_start_pos, [], 0, "CAN_COLLIDE"];
_zipline_end   = createVehicle ["Sign_Sphere25cm_F", _zipline_end_pos, [], 0, "CAN_COLLIDE"];

_zipline_start setObjectTextureGlobal [0,""];
_zipline_end setObjectTextureGlobal [0,""];

addMissionEventHandler ["EachFrame", 
{
	_thisArgs params ["_zipline_start_pos","_zipline_end_pos"];
	drawLine3D [_zipline_start_pos, _zipline_end_pos, [1,1,1,1],5] 
},
[_zipline_start_pos,_zipline_end_pos]];

_pole_start addAction
[
	"Use Zipline",	// title
	{
		params ["_target", "_caller", "_actionId", "_arguments"]; // script
		_arguments params ["_zipline_start","_zipline_end"];
		
		_distance = _zipline_start distance _zipline_end;
		_velocity = 8.3333;
		_time = _distance / _velocity;
		_t0 = time;
		
		_currentPos = getPosASL _zipline_start;
		_nextPos   = getPosASL _zipline_end;
		_currentVelocity = velocity _zipline_start;
		_nextVelocity = velocity _zipline_end;
		_currentVectorDir = vectorDir _zipline_start;
		_nextVectorDir = vectorDir _zipline_end;
		_currentVectorUp = vectorUp _zipline_start;
		_nextVectorUp = vectorUp _zipline_end;
		
		_caller attachTo [_zipline_start, [0,0,-2]];
		_vectorDir = vectorNormalized (_nextPos vectorDiff _currentPos);
		_caller setVectorDirAndUp [_vectorDir, [0,0,1]];
		
		_caller switchMove "Acts_JetsMarshallingEmergencyStop_loop";
		
		while {time < _t0 + _time} do {
			_interval = (time - _t0) / _time;
			
			_zipline_start setVelocityTransformation
			[
				_currentPos,
				_nextPos,
				_currentVelocity,
				_nextVelocity,
				_currentVectorDir,
				_nextVectorDir,
				_currentVectorUp,
				_nextVectorUp,
				_interval
			];

			sleep 0.01;
		};
		
		detach _caller;
		_caller switchMove "";
		
		_zipline_start setPosASL _currentPos;
	},
	[_zipline_start,_zipline_end],		// arguments
	1.5,		// priority
	true,		// showWindow
	true,		// hideOnUse
	"",			// shortcut
	"true",		// condition
	5,			// radius
	false,		// unconscious
	"",			// selection
	""			// memoryPoint
];

if (_bothWays == true) then {
	_pole_end addAction
	[
		"Use Zipline",	// title
		{
			params ["_target", "_caller", "_actionId", "_arguments"]; // script
			_arguments params ["_zipline_end","_zipline_start"];
			
			_distance = _zipline_start distance _zipline_end;
			_velocity = 8.3333;
			_time = _distance / _velocity;
			_t0 = time;
			
			_currentPos = getPosASL _zipline_start;
			_nextPos   = getPosASL _zipline_end;
			_currentVelocity = velocity _zipline_start;
			_nextVelocity = velocity _zipline_end;
			_currentVectorDir = vectorDir _zipline_start;
			_nextVectorDir = vectorDir _zipline_end;
			_currentVectorUp = vectorUp _zipline_start;
			_nextVectorUp = vectorUp _zipline_end;
			
			_caller attachTo [_zipline_start, [0,0,-2]];
			_vectorDir = vectorNormalized (_nextPos vectorDiff _currentPos);
			_caller setVectorDirAndUp [_vectorDir, [0,0,1]];
			
			_caller switchMove "Acts_JetsMarshallingEmergencyStop_loop";
			
			while {time < _t0 + _time} do {
				_interval = (time - _t0) / _time;
				
				_zipline_start setVelocityTransformation
				[
					_currentPos,
					_nextPos,
					_currentVelocity,
					_nextVelocity,
					_currentVectorDir,
					_nextVectorDir,
					_currentVectorUp,
					_nextVectorUp,
					_interval
				];

				sleep 0.01;
			};
			
			detach _caller;
			_caller switchMove "";
			
			_zipline_start setPosASL _currentPos;
		},
		[_zipline_start,_zipline_end],		// arguments
		1.5,		// priority
		true,		// showWindow
		true,		// hideOnUse
		"",			// shortcut
		"true",		// condition
		5,			// radius
		false,		// unconscious
		"",			// selection
		""			// memoryPoint
	];
};
