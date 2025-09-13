class WMPlayerReplicationInfo extends KFPlayerReplicationInfo;


// Structs for better organization
struct PerkPurchaseStruct
{
	var byte level;
	var bool bUnlocked;

	structdefaultproperties
	{
		level=0
		bUnlocked=False
	}
};

struct SkillPurchaseStruct
{
	var bool bPurchased;
	var bool bUnlocked;
	var bool bDeluxe;

	structdefaultproperties
	{
		bPurchased=False
		bUnlocked=False
		bDeluxe=False
	}
};

//Replicated arrays
var repnotify PerkPurchaseStruct bPerkUpgrade[255];
var repnotify byte bWeaponUpgrade_1[255];
var repnotify byte bWeaponUpgrade_2[255];
var repnotify byte bWeaponUpgrade_3[255];
var repnotify byte bWeaponUpgrade_4[255];
var repnotify byte bWeaponUpgrade_5[255];
var repnotify byte bWeaponUpgrade_6[255];
var repnotify byte bWeaponUpgrade_7[255];
var repnotify byte bWeaponUpgrade_8[255];
var repnotify byte bWeaponUpgrade_9[255];
var repnotify byte bWeaponUpgrade_10[255];
var repnotify byte bWeaponUpgrade_11[255];
var repnotify byte bWeaponUpgrade_12[255];
var repnotify byte bWeaponUpgrade_13[255];
var repnotify byte bWeaponUpgrade_14[255];
var repnotify byte bWeaponUpgrade_15[255];
var repnotify byte bWeaponUpgrade_16[255];
var repnotify SkillPurchaseStruct bSkillUpgrade_1[255];
var repnotify SkillPurchaseStruct bSkillUpgrade_2[255];
var repnotify SkillPurchaseStruct bSkillUpgrade_3[255];
var repnotify SkillPurchaseStruct bSkillUpgrade_4[255];
var repnotify byte bEquipmentUpgrade[255];
var byte bSidearmItem[255];

// Current "perk" : perk's icon reflects where player spend his dosh (perk upgrades and skill upgrades)
var repnotify int PerkIconIndex;
var texture2D CurrentIconToDisplay;
var int MaxDoshSpent;
var array<int> DoshSpentOnPerk;
var int PlayerLevel;

//UI Menu
var private WMUI_Menu UPGMenuManager;

// Sync variables
var repnotify bool SyncTrigger;
var bool SyncCompleted;
var private WMUI_UPGMenu SyncMenuObject;
var int SyncItemDefinition;
var byte SyncLoopCounter;

// dynamic array used to track purchases of player (on server and client sides)
// used in WMPerk
var array<int> Purchase_PerkUpgrade, Purchase_SkillUpgrade, Purchase_WeaponUpgrade, Purchase_EquipmentUpgrade;

// For scoreboard updates
var int UncompressedPing;
var int PlayerHealthInt;
var int PlayerArmorInt;
var byte PlatformType;

// For skip trader voting
var bool bHasVoted;
var bool bVotingActive;

//For skill reroll
var repnotify bool RerollSyncTrigger;
var bool RerollSyncCompleted;
var int RerollCounter;

//For first login
var bool bHasPlayed;

//For Supplier
var bool bPerkTertiarySupplyUsed;

//For current sidearm index
var byte SelectedSidarmIndex;

replication
{
	if (bNetDirty && (Role == Role_Authority))
		bEquipmentUpgrade,
		bPerkUpgrade,
		bSidearmItem,
		bSkillUpgrade_1,
		bSkillUpgrade_2,
		bSkillUpgrade_3,
		bSkillUpgrade_4,
		bWeaponUpgrade_1,
		bWeaponUpgrade_2,
		bWeaponUpgrade_3,
		bWeaponUpgrade_4,
		bWeaponUpgrade_5,
		bWeaponUpgrade_6,
		bWeaponUpgrade_7,
		bWeaponUpgrade_8,
		bWeaponUpgrade_9,
		bWeaponUpgrade_10,
		bWeaponUpgrade_11,
		bWeaponUpgrade_12,
		bWeaponUpgrade_13,
		bWeaponUpgrade_14,
		bWeaponUpgrade_15,
		bWeaponUpgrade_16;

	if (bNetDirty)
		bHasPlayed,
		PerkIconIndex,
		PlatformType,
		PlayerArmorInt,
		PlayerHealthInt,
		PlayerLevel,
		RerollCounter,
		RerollSyncTrigger,
		SelectedSidarmIndex,
		SyncTrigger,
		UncompressedPing;
}

simulated event ReplicatedEvent(name VarName)
{
	switch (VarName)
	{
		case 'SyncTrigger':
			break; //do nothing

		case 'RerollSyncTrigger':
			RerollSyncCompleted = True;
			break;

		case 'PerkIconIndex':
			ClientUpdateCurrentIconToDisplay();
			break;

		case 'bPerkUpgrade':
		case 'bSkillUpgrade_1':
		case 'bSkillUpgrade_2':
		case 'bSkillUpgrade_3':
		case 'bSkillUpgrade_4':
		case 'bEquipmentUpgrade':
		case 'bWeaponUpgrade_1':
		case 'bWeaponUpgrade_2':
		case 'bWeaponUpgrade_3':
		case 'bWeaponUpgrade_4':
		case 'bWeaponUpgrade_5':
		case 'bWeaponUpgrade_6':
		case 'bWeaponUpgrade_7':
		case 'bWeaponUpgrade_8':
		case 'bWeaponUpgrade_9':
		case 'bWeaponUpgrade_10':
		case 'bWeaponUpgrade_11':
		case 'bWeaponUpgrade_12':
		case 'bWeaponUpgrade_13':
		case 'bWeaponUpgrade_14':
		case 'bWeaponUpgrade_15':
		case 'bWeaponUpgrade_16':
			SyncCompleted = True;
			ClientUpdateCurrentIconToDisplay();
			break;

		default:
			super.ReplicatedEvent(VarName);
			break;
	}
}

function CopyProperties(PlayerReplicationInfo PRI)
{
	local WMPlayerReplicationInfo WMPRI;
	local byte i;

	WMPRI = WMPlayerReplicationInfo(PRI);

	if (WMPRI != None)
	{
		for (i = 0; i < 255; ++i)
		{
			WMPRI.bPerkUpgrade[i] = bPerkUpgrade[i];
			WMPRI.bWeaponUpgrade_1[i] = bWeaponUpgrade_1[i];
			WMPRI.bWeaponUpgrade_2[i] = bWeaponUpgrade_2[i];
			WMPRI.bWeaponUpgrade_3[i] = bWeaponUpgrade_3[i];
			WMPRI.bWeaponUpgrade_4[i] = bWeaponUpgrade_4[i];
			WMPRI.bWeaponUpgrade_5[i] = bWeaponUpgrade_5[i];
			WMPRI.bWeaponUpgrade_6[i] = bWeaponUpgrade_6[i];
			WMPRI.bWeaponUpgrade_7[i] = bWeaponUpgrade_7[i];
			WMPRI.bWeaponUpgrade_8[i] = bWeaponUpgrade_8[i];
			WMPRI.bWeaponUpgrade_9[i] = bWeaponUpgrade_9[i];
			WMPRI.bWeaponUpgrade_10[i] = bWeaponUpgrade_10[i];
			WMPRI.bWeaponUpgrade_11[i] = bWeaponUpgrade_11[i];
			WMPRI.bWeaponUpgrade_12[i] = bWeaponUpgrade_12[i];
			WMPRI.bWeaponUpgrade_13[i] = bWeaponUpgrade_13[i];
			WMPRI.bWeaponUpgrade_14[i] = bWeaponUpgrade_14[i];
			WMPRI.bWeaponUpgrade_15[i] = bWeaponUpgrade_15[i];
			WMPRI.bWeaponUpgrade_16[i] = bWeaponUpgrade_16[i];
			WMPRI.bSkillUpgrade_1[i] = bSkillUpgrade_1[i];
			WMPRI.bSkillUpgrade_2[i] = bSkillUpgrade_2[i];
			WMPRI.bSkillUpgrade_3[i] = bSkillUpgrade_3[i];
			WMPRI.bSkillUpgrade_4[i] = bSkillUpgrade_4[i];
			WMPRI.bEquipmentUpgrade[i] = bEquipmentUpgrade[i];
			WMPRI.bSidearmItem[i] = bSidearmItem[i];
		}

		WMPRI.PlayerLevel = PlayerLevel;
		WMPRI.RerollCounter = RerollCounter;
		WMPRI.bHasPlayed = bHasPlayed;
		WMPRI.SelectedSidarmIndex = SelectedSidarmIndex;
	}

	super.CopyProperties(PRI);
}

function UpdateReplicatedPlayerHealth()
{
	local WMPawn_Human OwnerPawn;

	if (KFPlayerOwner != None)
	{
		OwnerPawn = WMPawn_Human(KFPlayerOwner.Pawn);
		if (OwnerPawn != None)
		{
			if (OwnerPawn.Health != PlayerHealthInt)
			{
				PlayerHealthInt = OwnerPawn.Health;
				PlayerHealth = FloatToByte(float(OwnerPawn.Health) / float(OwnerPawn.HealthMax));
				PlayerHealthPercent = PlayerHealth;
			}

			if (OwnerPawn.ZedternalArmor != PlayerArmorInt)
				PlayerArmorInt = OwnerPawn.ZedternalArmor;
		}
	}
}

simulated function byte GetActivePerkLevel()
{
	return PlayerLevel;
}

simulated function byte GetActivePerkPrestigeLevel()
{
	return 0;
}

simulated function Texture2D GetCurrentIconToDisplay()
{
	return CurrentIconToDisplay;
}

simulated function ClientUpdateCurrentIconToDisplay()
{
	local WMGameReplicationInfo WMGRI;

	WMGRI = WMGameReplicationInfo(WorldInfo.GRI);

	if (WMGRI != None && PerkIconIndex != INDEX_NONE)
		CurrentIconToDisplay = WMGRI.PerkUpgradesList[PerkIconIndex].PerkUpgrade.static.GetUpgradeIcon(bPerkUpgrade[PerkIconIndex].level - 1);
}

function UpdateCurrentIconToDisplay(int lastBoughtIndex, int doshSpent, int lvl)
{
	// function called every time a perk upgrade or skill upgrade is bought
	// will update perk icon based on dosh spent by the player
	// will also increase player level by one

	local WMGameReplicationInfo WMGRI;
	local byte i;

	WMGRI = WMGameReplicationInfo(WorldInfo.GRI);

	if (WMGRI != None)
	{
		// initialize doshRecord if needed
		if (PerkIconIndex == INDEX_NONE)
		{
			MaxDoshSpent = 0;
			for (i = 0; i < WMGRI.PerkUpgradesList.length; ++i)
			{
				DoshSpentOnPerk[i] = 0;
			}
		}

		// record dosh spent on perk[index] related upgrades
		DoshSpentOnPerk[lastBoughtIndex] += doshSpent;

		// check and update player's perk icon index
		if (PerkIconIndex == INDEX_NONE || DoshSpentOnPerk[lastBoughtIndex] >= MaxDoshSpent)
		{
			CurrentIconToDisplay = WMGRI.PerkUpgradesList[lastBoughtIndex].PerkUpgrade.static.GetUpgradeIcon(bPerkUpgrade[lastBoughtIndex].level - 1);
			MaxDoshSpent = DoshSpentOnPerk[lastBoughtIndex];
			PerkIconIndex = lastBoughtIndex;
		}

		// increase player level
		PlayerLevel += lvl;
	}
}

reliable client function UpdateClientPurchase()
{
	UpdatePurchase();
}

reliable server function UpdateServerPurchase()
{
	UpdatePurchase();
	SetTimer(5.0f, False, NameOf(RecalculatePlayerLevel)); //Give server some time before it updates the HUD
}

simulated function UpdatePurchase()
{
	local int i;

	Purchase_PerkUpgrade.length = 0;
	for (i = 0; i < 255; ++i)
	{
		if (bPerkUpgrade[i].level > 0)
			Purchase_PerkUpgrade.AddItem(i);
	}

	Purchase_SkillUpgrade.length = 0;
	for (i = 0; i < 1020; ++i)
	{
		if (GetSkillUpgrade(i) > 0)
			Purchase_SkillUpgrade.AddItem(i);
	}

	Purchase_EquipmentUpgrade.length = 0;
	for (i = 0; i < 255; ++i)
	{
		if (bEquipmentUpgrade[i] > 0)
			Purchase_EquipmentUpgrade.AddItem(i);
	}

	Purchase_WeaponUpgrade.length = 0;
	for (i = 0; i < `MAXWEAPONUPGRADES; ++i)
	{
		if (GetWeaponUpgrade(i) > 0)
			Purchase_WeaponUpgrade.AddItem(i);
	}
}

function RecalculatePlayerLevel()
{
	local int index, level;
	local WMGameReplicationInfo WMGRI;

	WMGRI = WMGameReplicationInfo(WorldInfo.GRI);

	if (WMGRI != None)
	{
		PlayerLevel = 0;
		PerkIconIndex = INDEX_NONE;

		foreach Purchase_PerkUpgrade(index)
		{
			for (level = 0; level < bPerkUpgrade[index].level; ++level)
			{
				UpdateCurrentIconToDisplay(index, WMGRI.PerkUpgPrice[level], 1);
			}
		}

		foreach Purchase_SkillUpgrade(index)
		{
			for (level = 0; level < WMGRI.PerkUpgradesList.length; ++level)
			{
				if (PathName(WMGRI.PerkUpgradesList[level].PerkUpgrade) ~= WMGRI.SkillUpgradesList[index].PerkPathName)
					break;
			}

			if (IsSkillDeluxe(index))
				UpdateCurrentIconToDisplay(level, WMGRI.SkillUpgDeluxePrice, 3);
			else
				UpdateCurrentIconToDisplay(level, WMGRI.SkillUpgPrice, 1);
		}

		foreach Purchase_EquipmentUpgrade(index)
		{
			PlayerLevel += bEquipmentUpgrade[index];
		}
	}
}

simulated function CreateUPGMenu()
{
	local WMPlayerController WMPC;

	WMPC = WMPlayerController(Owner);
	if (WMPC == None || WMPC.bUpgradeMenuOpen)
		return;

	WMPC.bUpgradeMenuOpen = True;

	UPGMenuManager = new class'ZedternalReborn.WMUI_Menu';
	UPGMenuManager.Owner = WMPawn_Human(WMPC.Pawn);
	UPGMenuManager.WMPC = WMPC;
	UPGMenuManager.WMPRI = WMPlayerReplicationInfo(WMPC.PlayerReplicationInfo);
	UPGMenuManager.SetTimingMode(TM_Real);
	UPGMenuManager.Init(LocalPLayer(WMPC.Player));
}

simulated function CloseUPGMenu()
{
	//If a sync is in progress, cancel it before it can go through
	SyncMenuObject = None;
	SyncItemDefinition = -1;
	ClearTimer(NameOf(SyncTimerLoop));
	SyncCompleted = True;

	if (UPGMenuManager != None)
		UPGMenuManager.CloseMenu();
}

reliable client function CloseUPGMenuServer()
{
	local WMPlayerController WMPC;

	WMPC = WMPlayerController(Owner);

	if (WMPC != None && WMPC.bUpgradeMenuOpen)
		CloseUPGMenu();
}

reliable client function ShowSkipTraderVote(PlayerReplicationInfo PRI, byte VoteDuration, bool bShowChoices)
{
	super.ShowSkipTraderVote(PRI, VoteDuration, bShowChoices);
	bVotingActive = True;
}

reliable client function HideSkipTraderVote()
{
	super.HideSkipTraderVote();
	bHasVoted = False;
	bVotingActive = False;
}

simulated function RequestSkiptTrader(PlayerReplicationInfo PRI)
{
	super.RequestSkiptTrader(PRI);
	bHasVoted = True;
}

simulated function CastSkipTraderVote(PlayerReplicationInfo PRI, bool bSkipTrader)
{
	super.CastSkipTraderVote(PRI, bSkipTrader);
	bHasVoted = True;
}

simulated function NotifyWaveEnded()
{
	super.NotifyWaveEnded();

	bHasVoted = False;
	bVotingActive = False;
}

reliable client function MarkSupplierOwnerUsedZedternal(WMPlayerReplicationInfo SupplierPRI, optional bool bReceivedPrimary=True, optional bool bReceivedSecondary=True, optional bool bReceivedTertiary=True)
{
	if (SupplierPRI != None)
	{
		SupplierPRI.MarkSupplierUsedZedternal(bReceivedPrimary, bReceivedSecondary, bReceivedTertiary);
	}
}

simulated function MarkSupplierUsedZedternal(bool bReceivedPrimary, bool bReceivedSecondary, bool bReceivedTertiary)
{
	bPerkPrimarySupplyUsed = bPerkPrimarySupplyUsed || bReceivedPrimary;
	bPerkSecondarySupplyUsed = bPerkSecondarySupplyUsed || bReceivedSecondary;
	bPerkTertiarySupplyUsed = bPerkTertiarySupplyUsed || bReceivedTertiary;
}

simulated function NotifyWaveStart()
{
	super.NotifyWaveStart();

	bPerkTertiarySupplyUsed = False;
}

simulated function byte GetSkillLevel(SkillPurchaseStruct skill)
{
	if (skill.bPurchased)
	{
		if (skill.bDeluxe)
			return 2;
		else
			return 1;
	}

	return 0;
}

simulated function byte GetSkillUpgrade(int index)
{
	local int div, normalized;

	div = index / 255;
	normalized = index - div * 255;

	switch (div)
	{
		case 0:
			return GetSkillLevel(bSkillUpgrade_1[normalized]);

		case 1:
			return GetSkillLevel(bSkillUpgrade_2[normalized]);

		case 2:
			return GetSkillLevel(bSkillUpgrade_3[normalized]);

		case 3:
			return GetSkillLevel(bSkillUpgrade_4[normalized]);

		default:
			return 0;
	}
}

simulated function bool IsSkillUnlocked(int index)
{
	local int div, normalized;

	div = index / 255;
	normalized = index - div * 255;

	switch (div)
	{
		case 0:
			return bSkillUpgrade_1[normalized].bUnlocked;

		case 1:
			return bSkillUpgrade_2[normalized].bUnlocked;

		case 2:
			return bSkillUpgrade_3[normalized].bUnlocked;

		case 3:
			return bSkillUpgrade_4[normalized].bUnlocked;

		default:
			return False;
	}
}

simulated function bool IsSkillDeluxe(int index)
{
	local int div, normalized;

	div = index / 255;
	normalized = index - div * 255;

	switch (div)
	{
		case 0:
			return bSkillUpgrade_1[normalized].bDeluxe;

		case 1:
			return bSkillUpgrade_2[normalized].bDeluxe;

		case 2:
			return bSkillUpgrade_3[normalized].bDeluxe;

		case 3:
			return bSkillUpgrade_4[normalized].bDeluxe;

		default:
			return False;
	}
}

simulated function UnlockSkillUpgrade(int index, bool bDeluxe)
{
	local int div, normalized;

	div = index / 255;
	normalized = index - div * 255;

	switch (div)
	{
		case 0:
			bSkillUpgrade_1[normalized].bUnlocked = True;
			bSkillUpgrade_1[normalized].bDeluxe = bDeluxe;
			return;

		case 1:
			bSkillUpgrade_2[normalized].bUnlocked = True;
			bSkillUpgrade_2[normalized].bDeluxe = bDeluxe;
			return;

		case 2:
			bSkillUpgrade_3[normalized].bUnlocked = True;
			bSkillUpgrade_3[normalized].bDeluxe = bDeluxe;
			return;

		case 3:
			bSkillUpgrade_4[normalized].bUnlocked = True;
			bSkillUpgrade_4[normalized].bDeluxe = bDeluxe;
			return;

		default:
			return;
	}
}

simulated function PurchaseSkillUpgrade(int index)
{
	local int div, normalized;

	div = index / 255;
	normalized = index - div * 255;

	switch (div)
	{
		case 0:
			bSkillUpgrade_1[normalized].bPurchased = True;
			return;

		case 1:
			bSkillUpgrade_2[normalized].bPurchased = True;
			return;

		case 2:
			bSkillUpgrade_3[normalized].bPurchased = True;
			return;

		case 3:
			bSkillUpgrade_4[normalized].bPurchased = True;
			return;

		default:
			return;
	}
}

simulated function ResetSkillUpgrade(int index)
{
	local int div, normalized;

	div = index / 255;
	normalized = index - div * 255;

	switch (div)
	{
		case 0:
			bSkillUpgrade_1[normalized].bPurchased = False;
			bSkillUpgrade_1[normalized].bUnlocked = False;
			bSkillUpgrade_1[normalized].bDeluxe = False;
			return;

		case 1:
			bSkillUpgrade_2[normalized].bPurchased = False;
			bSkillUpgrade_2[normalized].bUnlocked = False;
			bSkillUpgrade_2[normalized].bDeluxe = False;
			return;

		case 2:
			bSkillUpgrade_3[normalized].bPurchased = False;
			bSkillUpgrade_3[normalized].bUnlocked = False;
			bSkillUpgrade_3[normalized].bDeluxe = False;
			return;

		case 3:
			bSkillUpgrade_4[normalized].bPurchased = False;
			bSkillUpgrade_4[normalized].bUnlocked = False;
			bSkillUpgrade_4[normalized].bDeluxe = False;
			return;

		default:
			return;
	}
}

simulated function byte GetWeaponUpgrade(int index)
{
	local int div, normalized;

	div = index / 255;
	normalized = index - div * 255;

	switch (div)
	{
		case 0:
			return bWeaponUpgrade_1[normalized];

		case 1:
			return bWeaponUpgrade_2[normalized];

		case 2:
			return bWeaponUpgrade_3[normalized];

		case 3:
			return bWeaponUpgrade_4[normalized];

		case 4:
			return bWeaponUpgrade_5[normalized];

		case 5:
			return bWeaponUpgrade_6[normalized];

		case 6:
			return bWeaponUpgrade_7[normalized];

		case 7:
			return bWeaponUpgrade_8[normalized];

		case 8:
			return bWeaponUpgrade_9[normalized];

		case 9:
			return bWeaponUpgrade_10[normalized];

		case 10:
			return bWeaponUpgrade_11[normalized];

		case 11:
			return bWeaponUpgrade_12[normalized];

		case 12:
			return bWeaponUpgrade_13[normalized];

		case 13:
			return bWeaponUpgrade_14[normalized];

		case 14:
			return bWeaponUpgrade_15[normalized];

		case 15:
			return bWeaponUpgrade_16[normalized];

		default:
			return 0;
	}
}

simulated function IncermentWeaponUpgrade(int index)
{
	local int div, normalized;

	div = index / 255;
	normalized = index - div * 255;

	switch (div)
	{
		case 0:
			++bWeaponUpgrade_1[normalized];
			break;

		case 1:
			++bWeaponUpgrade_2[normalized];
			break;

		case 2:
			++bWeaponUpgrade_3[normalized];
			break;

		case 3:
			++bWeaponUpgrade_4[normalized];
			break;

		case 4:
			++bWeaponUpgrade_5[normalized];
			break;

		case 5:
			++bWeaponUpgrade_6[normalized];
			break;

		case 6:
			++bWeaponUpgrade_7[normalized];
			break;

		case 7:
			++bWeaponUpgrade_8[normalized];
			break;

		case 8:
			++bWeaponUpgrade_9[normalized];
			break;

		case 9:
			++bWeaponUpgrade_10[normalized];
			break;

		case 10:
			++bWeaponUpgrade_11[normalized];
			break;

		case 11:
			++bWeaponUpgrade_12[normalized];
			break;

		case 12:
			++bWeaponUpgrade_13[normalized];
			break;

		case 13:
			++bWeaponUpgrade_14[normalized];
			break;

		case 14:
			++bWeaponUpgrade_15[normalized];
			break;

		case 15:
			++bWeaponUpgrade_16[normalized];
			break;

		default:
			return;
	}
}

simulated function SetWeaponUpgrade(int index, int value)
{
	local int div, normalized;

	div = index / 255;
	normalized = index - div * 255;

	switch (div)
	{
		case 0:
			bWeaponUpgrade_1[normalized] = value;
			break;

		case 1:
			bWeaponUpgrade_2[normalized] = value;
			break;

		case 2:
			bWeaponUpgrade_3[normalized] = value;
			break;

		case 3:
			bWeaponUpgrade_4[normalized] = value;
			break;

		case 4:
			bWeaponUpgrade_5[normalized] = value;
			break;

		case 5:
			bWeaponUpgrade_6[normalized] = value;
			break;

		case 6:
			bWeaponUpgrade_7[normalized] = value;
			break;

		case 7:
			bWeaponUpgrade_8[normalized] = value;
			break;

		case 8:
			bWeaponUpgrade_9[normalized] = value;
			break;

		case 9:
			bWeaponUpgrade_10[normalized] = value;
			break;

		case 10:
			bWeaponUpgrade_11[normalized] = value;
			break;

		case 11:
			bWeaponUpgrade_12[normalized] = value;
			break;

		case 12:
			bWeaponUpgrade_13[normalized] = value;
			break;

		case 13:
			bWeaponUpgrade_14[normalized] = value;
			break;

		case 14:
			bWeaponUpgrade_15[normalized] = value;
			break;

		case 15:
			bWeaponUpgrade_16[normalized] = value;
			break;

		default:
			return;
	}
}

simulated function SetSyncTimer(const WMUI_UPGMenu Menu, int ItemDefinition)
{
	SyncMenuObject = Menu;
	SyncItemDefinition = ItemDefinition;
	SyncLoopCounter = 0;
	SetTimer(0.375f, True, NameOf(SyncTimerLoop));
}

simulated function SyncTimerLoop()
{
	if (SyncCompleted || SyncLoopCounter >= 7)
	{
		SyncCompleted = True; //For timeout case
		ClearTimer(NameOf(SyncTimerLoop));

		if (SyncMenuObject != None)
			SyncMenuObject.Callback_Equip(SyncItemDefinition);

		SyncMenuObject = None;
		SyncItemDefinition = -1;
	}

	++SyncLoopCounter;
}

simulated function SetRerollSyncTimer(const WMUI_UPGMenu Menu, int PerkIndex)
{
	SyncMenuObject = Menu;
	SyncItemDefinition = PerkIndex;
	SyncLoopCounter = 0;
	SetTimer(0.375f, True, NameOf(SyncRerollTimerLoop));
}

simulated function SyncRerollTimerLoop()
{
	if (RerollSyncCompleted || SyncLoopCounter >= 7)
	{
		RerollSyncCompleted = True; //For timeout case
		ClearTimer(NameOf(SyncRerollTimerLoop));

		if (SyncMenuObject != None)
			SyncMenuObject.SkillRerollUnlock(SyncItemDefinition);

		SyncMenuObject = None;
		SyncItemDefinition = -1;
	}

	++SyncLoopCounter;
}

simulated function bool SyncTimerActive()
{
	return IsTimerActive(NameOf(SyncTimerLoop)) || IsTimerActive(NameOf(SyncRerollTimerLoop));
}

defaultproperties
{
	PlayerLevel=0
	PerkIconIndex=INDEX_NONE
	CurrentIconToDisplay=Texture2D'UI_PerkIcons_TEX.UI_Horzine_H_Logo'
	SyncCompleted=True
	RerollSyncCompleted=True
	PlatformType=0
	bHasVoted=False
	bVotingActive=False
	bHasPlayed=False

	Name="Default__WMPlayerReplicationInfo"
}
