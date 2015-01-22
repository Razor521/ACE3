/**
 * fn_addOpenWounds.sqf
 * @Descr: Add open wounds to unit.
 * @Author: Glowbal
 *
 * @Arguments: [unit OBJECT (The object that will recieve the wound), bodyPart STRING, type STRING (Small, medium or large), amount NUMBER (The amount of open wounds added)]
 * @Return: void
 * @PublicAPI: true
 */

#include "script_component.hpp"

private ["_unit", "_bodyPart", "_type", "_openWounds", "_selection", "_amount", "_newAmount", "_global"];
_unit = _this select 0;
_bodyPart = _this select 1;
_type = _this select 2;
_amount = _this select 3;
_global = if (count _this > 4) then {_this select 4} else {true};

if (typeName _bodyPart == "STRING") then {
    _bodyPart = [_bodyPart] call FUNC(getBodyPartNumber);
};
if (typeName _type == "STRING") then {
    _type = switch (toLower _type) do {
        case "small": {0};
        case "medium": {1};
        case "large": {2};
        default {-1};
    };
};

if (_type < 0) exitwith {
    [format["Adding an injury with an invalid type: %1",_this], 0] call EFUNC(common,debug);
};

_openWounds = [_unit,QGVAR(openWounds)] call EFUNC(common,getDefinedVariable);
_selection = _openWounds select _bodyPart;
_newAmount = (_selection select _type) + _amount;
if (_newAmount < 0) then {
    _newAmount = 0;
};
_selection set [ _type, _newAmount];
_openWounds set [ _bodyPart , _selection];
[_unit, QGVAR(openWounds),_openWounds, _global] call EFUNC(common,setDefinedVariable);

[_unit] call FUNC(addToInjuredCollection);
["Medical_onOpenWoundsAdded", [_unit, _bodyPart, _type, _amount]] call ace_common_fnc_localEvent;