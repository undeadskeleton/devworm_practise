extends Node

var playerWeaponEquip : bool
var playerBody : CharacterBody2D

var playerDamageZone : Area2D
var playerDamageDone : int
var playerAlive : bool
var playerHitZone : Area2D

var batDamageZone : Area2D
var batDamage : int
var batAlive : bool

var frogDamage: int 
var frogDamageZone : Area2D

var high_score : int = 0
var current_score : int 
var previous_score : int 
var current_wave : int 
