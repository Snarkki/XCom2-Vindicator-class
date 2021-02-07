class X2Effect_FocusGain extends X2Effect_Persistent config(LWRAbility);

//var name eventid;
//var bool bShowActivation;
var config array<name> FOCUS_HIT_ABILITY;

//function RegisterForEvents(XComGameState_Effect EffectGameState)
//{
	//local XComGameState_Unit UnitState;
	//local X2EventManager EventMgr;
	//local Object EffectObj;
//
	//if (bshowactivation)
	//{
		//EventMgr = `XEVENTMGR;
		//EffectObj = EffectGameState;
		//UnitState = XComGameState_Unit(class'XComGameStateHistory'.static.GetGameStateHistory().GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
		//EventMgr.RegisterForEvent(EffectObj, EventId, EffectGameState.TriggerAbilityFlyover, 1,, UnitState);  
	//}
//}

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	local XComGameState_Unit					TargetUnit;
	local XComGameState_Effect_TemplarFocus FocusState;
	local XComGameState_Ability AbilityState;
	local int AbilityCheck;

	TargetUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));

	if (TargetUnit != none && TargetUnit.IsEnemyUnit(SourceUnit))
	{
	// Find if the ability is valid for focus on hit. default.SHOTFIRED_ABILITYNAMES.Find(ActivatedAbilityState.GetMyTemplateName())
		AbilityCheck = default.FOCUS_HIT_ABILITY.FIND(AbilityContext.InputContext.AbilityTemplateName);
		if (AbilityCheck != INDEX_NONE)
		{
		// hit, graze, grit etc valid for focus gain.
		if (AbilityContext.ResultContext.HitResult == eHit_Success || AbilityContext.ResultContext.HitResult == eHit_Crit || AbilityContext.ResultContext.HitResult == eHit_Graze)
				{
				AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
					if (AbilityState != none)
					{
						FocusState = SourceUnit.GetTemplarFocusEffectState();
							if (FocusState != none)
								{
									if (AbilityContext.ResultContext.HitResult == eHit_Crit && SourceUnit.HasSoldierAbility('LWR_CriticalFocus'))
										{
											FocusState = XComGameState_Effect_TemplarFocus(NewGameState.ModifyStateObject(FocusState.Class, FocusState.ObjectID));
											FocusState.SetFocusLevel(FocusState.FocusLevel + 2, SourceUnit, NewGameState);
											return true;
										}
									FocusState = XComGameState_Effect_TemplarFocus(NewGameState.ModifyStateObject(FocusState.Class, FocusState.ObjectID));
									FocusState.SetFocusLevel(FocusState.FocusLevel + 1, SourceUnit, NewGameState);	
									return true;
								}

					}
				}
		}
	}
	
	return false;
}

