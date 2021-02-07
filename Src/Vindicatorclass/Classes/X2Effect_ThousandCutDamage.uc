class X2Effect_ThousandCutDamage extends X2Effect_Persistent config (LWRAbility);

var config float TC_DAMAGE_MODIFIER;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local XComGameState_Unit TargetUnit;
	local int WeakenDamage;

	
	TargetUnit = XComGameState_Unit(TargetDamageable);
	if (AbilityState.GetMyTemplateName() ==  'LWR_ThousandCuts')
	{
		if (TargetUnit != None && class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
		{
				WeakenDamage = CurrentDamage  * default.TC_DAMAGE_MODIFIER;
				if (WeakenDamage > 0)
					{
					return -WeakenDamage;
					}
		}
	}
	return 0;
}

defaultproperties
{
	DuplicateResponse = eDupe_Ignore

}