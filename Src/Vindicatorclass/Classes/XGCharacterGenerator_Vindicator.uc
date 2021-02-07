class XGCharacterGenerator_Vindicator extends XGCharacterGenerator
	dependson(X2StrategyGameRulesetDataStructures) config(NameList);


//function TSoldier CreateTSoldier( optional name CharacterTemplateName, optional EGender eForceGender, optional name nmCountry = '', optional int iRace = -1, optional name ArmorName )
//{
	//local XComLinearColorPalette HairPalette;
	//local X2SimpleBodyPartFilter BodyPartFilter;
	//local X2CharacterTemplate CharacterTemplate;
	//local TAppearance DefaultAppearance;
//
	//kSoldier.kAppearance = DefaultAppearance;	
	//kSoldier.kAppearance.iGender = eGender_Female;
	//kSoldier.kAppearance.iAttitude = 0; // By the book
		//
	//CharacterTemplate = SetCharacterTemplate(CharacterTemplateName, ArmorName);
	//
	//if (nmCountry == '')
		//nmCountry = PickOriginCountry();
	//
	//SetCountry(nmCountry);
	//SetRace(iRace);
	//kSoldier.iRank = 0;
	//
	//BodyPartFilter = `XCOMGAME.SharedBodyPartFilter;
//
	////When generating new characters, consider the DLC pack filters.
	////Use the player's settings from Options->Game Options to pick which DLC / Mod packs this generated soldier should draw from
	//UpdateDLCPackFilters();
	//
	//SetTorso(BodyPartFilter, CharacterTemplateName);
	//SetArmsLegsAndDeco(BodyPartFilter);
	//SetHead(BodyPartFilter, CharacterTemplate);
	//SetAccessories(BodyPartFilter, CharacterTemplateName);
	//SetUnderlay(BodyPartFilter);
	//SetArmorTints(CharacterTemplate);
	//
	//HairPalette = `CONTENT.GetColorPalette(ePalette_HairColor);
	//kSoldier.kAppearance.iHairColor = ChooseHairColor(kSoldier.kAppearance, HairPalette.BaseOptions); // Only generate with base options
	//kSoldier.kAppearance.iEyeColor = 0; //right now initialized to the first one, todo when we decides which are the base colors for the different races.
		//
	//// SHIP HACK: There are at least 5 base options for every palette. I am not proud. -- jboswell
	//kSoldier.kAppearance.iSkinColor = Rand(5);
//
	//SetVoice(CharacterTemplateName, nmCountry);
//
//
//
	//GenerateName( kSoldier.kAppearance.iGender, kSoldier.nmCountry, kSoldier.strFirstName, kSoldier.strLastName, kSoldier.kAppearance.iRace );
//
	//BioCountryName = kSoldier.nmCountry;
//
	//return kSoldier;
//}

//
//var config array<int> PrimaryArmorColors;
//var config array<int> SecondaryArmorColors;
//var config array<name> MaleHeads;
//var config array<Name> FemaleHeads;
//var config array<name> MaleHelmets;
//var config array<name> FemaleHelmets;
//
//function bool IsSoldier(name CharacterTemplateName)
//{
	//return true;
//}
//
//function X2CharacterTemplate SetCharacterTemplate(name CharacterTemplateName, name ArmorName)
//{
	//MatchArmorTemplateForTorso = (ArmorName == '') ? 'TemplarArmor' : ArmorName;
	//MatchCharacterTemplateForTorso = 'NoCharacterTemplateName'; //Force the selector to use the armor type to filter torsos
//
	//return class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager().FindCharacterTemplate(CharacterTemplateName);
//}
//
//function TSoldier CreateTSoldier(optional name CharacterTemplateName, optional EGender eForceGender, optional name nmCountry = '', optional int iRace = -1, optional name ArmorName)
//{
	//local X2SoldierClassTemplateManager ClassMgr;
	//local X2SoldierClassTemplate ClassTemplate;
//
	//kSoldier = super.CreateTSoldier('LWR_Vindicator', eForceGender, nmCountry, iRace, ArmorName);
	//SetCountry('Country_Templar');
	//ClassMgr = class'X2SoldierClassTemplateManager'.static.GetSoldierClassTemplateManager();
	//ClassTemplate = ClassMgr.FindSoldierClassTemplate('LWR_Vindicator');
	//kSoldier.strNickName = GenerateNickname(ClassTemplate, kSoldier.kAppearance.iGender);
//
	//return kSoldier;
//}
//
//function SetRace(int iRace)
//{
	//kSoldier.kAppearance.iRace = eRace_Hispanic;
//}
//
//function SetHead(X2SimpleBodyPartFilter BodyPartFilter, X2CharacterTemplate CharacterTemplate)
//{
	//super.SetHead(BodyPartFilter, CharacterTemplate);
//
	//if (kSoldier.kAppearance.iGender == eGender_Male)
	//{
		//kSoldier.kAppearance.nmHead = default.MaleHeads[`SYNC_RAND(default.MaleHeads.Length)];
	//}
	//else
	//{
		//kSoldier.kAppearance.nmHead = default.FemaleHeads[`SYNC_RAND(default.FemaleHeads.Length)];
	//}
//}
//
//function SetAccessories(X2SimpleBodyPartFilter BodyPartFilter, name CharacterTemplateName)
//{
	//super.SetAccessories(BodyPartFilter, CharacterTemplateName);
//
	//if (kSoldier.kAppearance.iGender == eGender_Male)
	//{
		//kSoldier.kAppearance.nmHelmet = default.MaleHelmets[`SYNC_RAND(default.MaleHelmets.Length)];
	//}
	//else
	//{
		//kSoldier.kAppearance.nmHelmet = default.FemaleHelmets[`SYNC_RAND(default.FemaleHelmets.Length)];
	//}
//}
//
//function SetArmorTints(X2CharacterTemplate CharacterTemplate)
//{
	//super.SetArmorTints(CharacterTemplate);
//
	//kSoldier.kAppearance.iArmorTint = default.PrimaryArmorColors[`SYNC_RAND(default.PrimaryArmorColors.Length)];
	//kSoldier.kAppearance.iArmorTintSecondary = default.SecondaryArmorColors[`SYNC_RAND(default.SecondaryArmorColors.Length)];
//}
//
//function SetVoice(name CharacterTemplateName, name CountryName)
//{
	//if (IsSoldier(CharacterTemplateName))
	//{
		//kSoldier.kAppearance.nmVoice = GetVoiceFromCountryAndGenderAndCharacter(CountryName, kSoldier.kAppearance.iGender, CharacterTemplateName);
		//
		//if (kSoldier.kAppearance.nmVoice == '')
		//{
			//if (kSoldier.kAppearance.iGender == eGender_Male)
			//{
				//kSoldier.kAppearance.nmVoice = 'TemplarMaleVoice1_Localized';
			//}
			//else
			//{
				//kSoldier.kAppearance.nmVoice = 'TemplarFemaleVoice1_Localized';
			//}
		//}
	//}
//}
//
//function SetAttitude()
//{
	//kSoldier.kAppearance.iAttitude = 0; // Should correspond with Personality_ByTheBook
//}