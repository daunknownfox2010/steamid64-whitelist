-- SteamID64 Server Whitelist by D4 the (Perth) Fox

-- Local variables
local WHITELISTED_STEAMID64 = {};

-- Console variables
local id64wl_enabled = CreateConVar( "id64wl_enabled", 1, FCVAR_ARCHIVE, "Enables SteamID64 whitelisting.", 0, 1 );
local id64wl_message = CreateConVar( "id64wl_message", "#GameUI_ConnectionFailed", FCVAR_ARCHIVE, "The disconnection reason if a player is not whitelisted." );

-- Functions below

-- Writes to the data file
local function WriteTableData()

	-- Create this folder if we don't have it
	if ( !file.Exists( "id64wl", "DATA" ) ) then file.CreateDir( "id64wl" ); end

	-- Convert the 64-bit IDs to regular IDs for saving
	local tab = {};
	for k, v in pairs( WHITELISTED_STEAMID64 ) do
	
		local convertedID = util.SteamIDFrom64( k );
		table.insert( tab, convertedID );
	
	end

	local jsonData = util.TableToJSON( tab );
	file.Write( "id64wl/whitelist.dat", jsonData );

end


-- Read the data file
local function ReadTableData()

	if ( file.Exists( "id64wl/whitelist.dat", "DATA" ) ) then
	
		local tableData = util.JSONToTable( file.Read( "id64wl/whitelist.dat" ) );
	
		-- Convert the regular IDs back to 64-bit IDs
		local tab = {};
		for k, v in ipairs( tableData ) do
		
			local convertedID = util.SteamIDTo64( v );
			tab[ convertedID ] = true;
		
		end
	
		return tab;
	
	end

	return {};

end


-- Initialize the addon
local function InitID64WL()

	-- Read the table data if we have it saved
	WHITELISTED_STEAMID64 = ReadTableData();

	-- Print some information
	print( "-= SteamID64 Whitelist (ID64WL) =-" );
	print( "-== ID64WL was created by D4 the (Perth) Fox ==-" );

end
hook.Add( "Initialize", "InitID64WL", InitID64WL );


-- Use the CheckPassword function
local function CheckWhitelisting( steamID64 )

	if ( id64wl_enabled:GetBool() && !WHITELISTED_STEAMID64[ steamID64 ] ) then
	
		local disconnectMessage = "#GameUI_ConnectionFailed";
		if ( id64wl_message ) then
		
			disconnectMessage = id64wl_message:GetString();
		
		end
	
		return false, disconnectMessage;
	
	end

end
hook.Add( "CheckPassword", "SteamID64CheckWhitelisting", CheckWhitelisting );


-- ConCommand to add IDs
local function AddSteamID64AC( cmd, stringArgs )

	local stringArgs = string.Trim( stringArgs );

	local args = string.Explode( " ", stringArgs );
	local steamID = args[ #args ] || "";

	local tab = {};
	for k, v in ipairs( player.GetAll() ) do
	
		local plySteamID = v:SteamID64();
	
		if ( string.find( plySteamID, steamID ) ) then
		
			local autoComplete = cmd .. " ";
		
			for i = 1, #args - 1 do
			
				autoComplete = autoComplete .. "" .. args[ i ] .. " ";
			
			end
		
			autoComplete = autoComplete .. "\"" .. plySteamID .. "\"";
		
			table.insert( tab, autoComplete );
		
		end
	
	end

	return tab;

end

local function AddSteamID64( ply, cmd, args )

	if ( IsValid( ply ) && !ply:IsSuperAdmin() ) then return; end

	for k, v in pairs( args ) do
	
		ply:PrintMessage( HUD_PRINTCONSOLE, "[ID64WL] Adding ID: " .. v );
	
		WHITELISTED_STEAMID64[ v ] = true;
	
	end

	WriteTableData();

end
concommand.Add( "id64wl_addid64", AddSteamID64, AddSteamID64AC, "Add a user's SteamID64 to the whitelist." );


-- ConCommand to remove IDs
local function RemoveSteamID64AC( cmd, stringArgs )

	local stringArgs = string.Trim( stringArgs );

	local args = string.Explode( " ", stringArgs );
	local steamID = args[ #args ] || "";

	local tab = {};
	for k, v in pairs( WHITELISTED_STEAMID64 ) do
	
		local plySteamID = k;
	
		if ( string.find( plySteamID, steamID ) ) then
		
			local autoComplete = cmd .. " ";
		
			for i = 1, #args - 1 do
			
				autoComplete = autoComplete .. "" .. args[ i ] .. " ";
			
			end
		
			autoComplete = autoComplete .. "\"" .. plySteamID .. "\"";
		
			table.insert( tab, autoComplete );
		
		end
	
	end

	return tab;

end

local function RemoveSteamID64( ply, cmd, args )

	if ( IsValid( ply ) && !ply:IsSuperAdmin() ) then return; end

	for k, v in pairs( args ) do
	
		ply:PrintMessage( HUD_PRINTCONSOLE, "[ID64WL] Removing ID: " .. v );
	
		WHITELISTED_STEAMID64[ v ] = nil;
	
	end

	WriteTableData();

end
concommand.Add( "id64wl_removeid64", RemoveSteamID64, RemoveSteamID64AC, "Remove a user's SteamID64 in the whitelist." );


-- ConCommand to add IDs via normal SteamIDs
local function AddSteamIDAC( cmd, stringArgs )

	local stringArgs = string.Trim( stringArgs );

	local args = string.Explode( " ", stringArgs );
	local steamID = args[ #args ] || "";

	local tab = {};
	for k, v in ipairs( player.GetAll() ) do
	
		local plySteamID = v:SteamID();
	
		if ( string.find( plySteamID, steamID ) ) then
		
			local autoComplete = cmd .. " ";
		
			for i = 1, #args - 1 do
			
				autoComplete = autoComplete .. "" .. args[ i ] .. " ";
			
			end
		
			autoComplete = autoComplete .. "\"" .. plySteamID .. "\"";
		
			table.insert( tab, autoComplete );
		
		end
	
	end

	return tab;

end

local function AddSteamID( ply, cmd, args )

	if ( IsValid( ply ) && !ply:IsSuperAdmin() ) then return; end

	for k, v in pairs( args ) do
	
		ply:PrintMessage( HUD_PRINTCONSOLE, "[ID64WL] Adding ID: " .. v );
	
		local steamID = util.SteamIDTo64( v );
		WHITELISTED_STEAMID64[ steamID ] = true;
	
	end

	WriteTableData();

end
concommand.Add( "id64wl_addid", AddSteamID, AddSteamIDAC, "Add a user's SteamID to the whitelist." );


-- ConCommand to remove IDs via normal SteamIDs
local function RemoveSteamIDAC( cmd, stringArgs )

	local stringArgs = string.Trim( stringArgs );

	local args = string.Explode( " ", stringArgs );
	local steamID = args[ #args ] || "";

	local tab = {};
	for k, v in pairs( WHITELISTED_STEAMID64 ) do
	
		local plySteamID = util.SteamIDFrom64( k );
	
		if ( string.find( plySteamID, steamID ) ) then
		
			local autoComplete = cmd .. " ";
		
			for i = 1, #args - 1 do
			
				autoComplete = autoComplete .. "" .. args[ i ] .. " ";
			
			end
		
			autoComplete = autoComplete .. "\"" .. plySteamID .. "\"";
		
			table.insert( tab, autoComplete );
		
		end
	
	end

	return tab;

end

local function RemoveSteamID( ply, cmd, args )

	if ( IsValid( ply ) && !ply:IsSuperAdmin() ) then return; end

	for k, v in pairs( args ) do
	
		ply:PrintMessage( HUD_PRINTCONSOLE, "[ID64WL] Removing ID: " .. v );
	
		local steamID = util.SteamIDTo64( v );
		WHITELISTED_STEAMID64[ steamID ] = nil;
	
	end

	WriteTableData();

end
concommand.Add( "id64wl_removeid", RemoveSteamID, RemoveSteamIDAC, "Remove a user's SteamID in the whitelist." );


-- ConCommand to clear the IDs in the table
local function ClearTableIDs( ply )

	if ( IsValid( ply ) && !ply:IsSuperAdmin() ) then return; end

	WHITELISTED_STEAMID64 = {};

	WriteTableData();

end
concommand.Add( "id64wl_clear", ClearTableIDs, nil, "Clears all IDs in the whitelist." );


-- ConCommand to print IDs in the table
local function PrintTableIDs( ply )

	if ( IsValid( ply ) && !ply:IsSuperAdmin() ) then return; end

	ply:PrintMessage( HUD_PRINTCONSOLE, "Whitelisted IDs:" );
	ply:PrintMessage( HUD_PRINTCONSOLE, "---------------------" );

	for k, v in pairs( WHITELISTED_STEAMID64 ) do
	
		ply:PrintMessage( HUD_PRINTCONSOLE, "\"" .. k .. "\"" );
	
	end

	ply:PrintMessage( HUD_PRINTCONSOLE, "---------------------" );

end
concommand.Add( "id64wl_print", PrintTableIDs, nil, "Prints the IDs in the whitelist." );
