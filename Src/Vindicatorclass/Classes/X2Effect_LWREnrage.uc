class X2Effect_LWREnrage extends X2Effect_PersistentStatChange;

var float fDamageMultiplier;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{ 
	//	Apply bonus damage to any melee attack
	if (AbilityState.IsMeleeAbility())
	{
		return CurrentDamage * fDamageMultiplier; 
	}
	return 0;
}

defaultproperties
{
	EffectName = "LWR_Enrage"
}