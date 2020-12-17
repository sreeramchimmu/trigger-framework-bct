/*
Class name 	 : flagGlobal
Description  : This Utility class can be utilised for initiating and updating static boolean flags used across various triggers.
Author       : Sreeram. V
Date Created : 19-Mar-2020         

Modified for bug by	: Sreeram. V
Last Modified Date 	: 19-Mar-2020
*/
global class flagGlobal {    
    
    //below flag is used in EnsureOppLineItem.apxt & flagSetOnLineItemUpdation.apxt
	global static boolean flagForLineItemUpdation = true; 
}