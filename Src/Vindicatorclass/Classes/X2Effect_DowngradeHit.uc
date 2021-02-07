class X2Effect_DowngradeHit extends X2Effect_Persistent config(LWRAbility);

var int FocusDowngradeChance;

//Based on Iridars Shield block
function bool ChangeHitResultForTarget(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit TargetUnit, XComGameState_Ability AbilityState, bool bIsPrimaryTarget, const EAbilityHitResult CurrentResult, out EAbilityHitResult NewHitResult)
{
	local XComGameState_Effect_TemplarFocus FocusState;
	local int  TargetRoll, RandRoll;
	//	don't change a natural miss
	if (!class'XComGameStateContext_Ability'.static.IsHitResultHit(CurrentResult))
		return false;

	//	Do nothing if soldier could not have blocked the attack, e.g. was stunned
	if (!TargetUnit.IsAbleToAct())
		return false;

	//	Get the focus amount
	FocusState = TargetUnit.GetTemplarFocusEffectState();
	if (FocusState != none)
	{
		TargetRoll = FocusState.FocusLevel * default.FocusDowngradeChance;
		RandRoll = `SYNC_RAND_STATIC(100);
		if( RandRoll < TargetRoll )	
		{	
			NewHitResult = DowngradeResult(CurrentResult);
			`log("Downgraded hit result:" @ NewHitResult, , 'LWR_Vindicator');
			return true;
		}
	}
	return false;
}

static function EAbilityHitResult DowngradeResult(const EAbilityHitResult CurrentResult)
{	
	switch (CurrentResult)
	{
		case eHit_Crit:
			return eHit_Success;
		case eHit_Success:
			return eHit_Graze;
		case eHit_Graze:
			return eHit_LightningReflexes;
		default:
			return CurrentResult;
	}
}
defaultproperties
{

	DuplicateResponse = eDupe_Ignore
	EffectName = "LWR_DowngradeHit"
}