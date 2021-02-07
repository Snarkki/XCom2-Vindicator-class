//class X2Effect_Stoneform extends X2Effect_ModifyStats;
class X2Effect_Stoneform extends X2Effect_ModifyStats config(LWRAbility);
var int BaseShieldHPIncrease;;
var int AdditionalHPPerFocus;
var int ArmorPerFocus;
var int DefenseMinus;

var const config WillEventRollData StoneformWillRollData;
//var float IronFormDR;
//
//function int GetDefendingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, optional XComGameState NewGameState)
//{
////IronForm Ability
	//local XComGameStateHistory History;
	//local XComGameState_Unit SourceUnit;
//
//
	//History = `XCOMHISTORY;
//
	//SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
//
	//if (SourceUnit != none && SourceUnit.HasSoldierAbility('LWR_IronForm'))
	//{
			//return -CurrentDamage * IronFormDR; 
	//}
//
	//return 0;
//}

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local StatChange			ShieldHPChange;
	local StatChange			ArmorChange;
	local StatChange			DefenseChange;
	local XComGameState_Unit	Target;
	local XComGameState_Effect_TemplarFocus FocusState;

	ShieldHPChange.StatType = eStat_ShieldHP;
	ArmorChange.StatType = eStat_ArmorMitigation;
	DefenseChange.StatType = eStat_Defense;

	Target = XComGameState_unit (kNewTargetState);

	ShieldHPChange.StatAmount = BaseShieldHPIncrease;

	FocusState = Target.GetTemplarFocusEffectState();
	if (FocusState != none)
		{
			ShieldHPChange.StatAmount = BaseShieldHPIncrease + FocusState.FocusLevel * AdditionalHPPerFocus;
			ArmorChange.StatAmount = FocusState.FocusLevel * ArmorPerFocus;
		}

	Target.SetUnitFloatValue('StoneFormShieldHP', ShieldHPChange.StatAmount, eCleanup_BeginTactical);
	Target.SetUnitFloatValue('PreStoneFormShieldHP', Target.GetCurrentStat(eStat_ShieldHP), eCleanup_BeginTactical);
	DefenseChange.StatAmount = DefenseMinus; 
	NewEffectState.StatChanges.AddItem(ShieldHPChange);
	NewEffectState.StatChanges.AddItem(ArmorChange);
	NewEffectState.StatChanges.AddItem(DefenseChange);


	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);

}

//based on LWOTC mind merge - need to know what the pre stoneform HP was so regular shield hp is not removed
simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
	local int StoneFormGrantedShieldHP, PreStoneFormShieldHP, PreRemovalShieldHP, FullyShieldedHP, ShieldHPDamage, NewShieldHP;
	local XComGameState_Unit UnitState;
	local UnitValue StoneFormShieldHP, OtherShieldHP;

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	PreRemovalShieldHP = UnitState.GetCurrentStat(eStat_ShieldHP);

    super.OnEffectRemoved(ApplyEffectParameters, NewGameState, bCleansed, RemovedEffectState);

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	UnitState.GetUnitValue('StoneFormShieldHP', StoneFormShieldHP);
	UnitState.GetUnitValue('PreStoneFormShieldHP', OtherShieldHP);
	StoneFormGrantedShieldHP = int(StoneFormShieldHP.fValue);		// How many you got
	PreStoneFormShieldHP = int(OtherShieldHP.fValue);				// how many you had
	FullyShieldedHP = PreStoneFormShieldHP + StoneFormGrantedShieldHP;
	//ShieldHP = UnitState.GetCurrentStat(eStat_ShieldHP);						// how many you have now

	ShieldHPDamage = FullyShieldedHP - PreRemovalShieldHP;
	if (ShieldHPDamage > 0 && PreStoneFormShieldHP > 0 && ShieldHPDamage < FullyShieldedHP)
	{
		NewShieldHP = Clamp (PreStoneFormShieldHP + StoneFormGrantedShieldHP - ShieldHPDamage, 0, PreStoneFormShieldHP);
		UnitState = XComGameState_Unit(NewGameState.CreateStateObject(UnitState.Class, UnitState.ObjectID));
		UnitState.SetCurrentStat(estat_ShieldHP, NewShieldHP);
		NewGameState.AddStateObject(UnitState);
	}
}


defaultproperties
{
	EffectName="LWR_StoneForm"
	DuplicateResponse=eDupe_Allow
}

