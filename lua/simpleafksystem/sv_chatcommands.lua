-- Copyright 2017 viral32111. https://github.com/viral32111/simple-afk-system/blob/master/LICENCE

if ( CLIENT ) then return end

hook.Add( "PlayerSay", "SimpleAFKSystemAFK", function( ply, text, team )
	local text = string.lower( text )
	if ( string.sub( text, 1, 4 ) == "!afk" ) then
		if ( string.sub( text, 6 ) != "" ) then
			if ( ply:GetNWBool("IsAFK", false ) ) then
				ply:SendLua([[ chat.AddText( Color( 26, 198, 255 ), "(Simple AFK System) ", Color( 255, 255, 255 ), "You are already AFK" ) ]])
			else
				for k, v in pairs( player.GetAll() ) do
					net.Start("SimpleAFKSystemAnnounce")
						net.WriteBool( true )
						net.WriteEntity( ply )
						net.WriteString( string.sub( text, 6 ) )
					net.Send( v )
					v:SendLua([[ surface.PlaySound("ambient/levels/canals/windchine1.wav") ]])
				end
				ply:StripAmmo()
	  			ply:StripWeapons()
	  			ply:Lock()
	  			ply:SetCollisionGroup( 20 )
	  			ply:SetColor( Color( 255, 255, 255, 200 ) )
				ply:SetRenderMode( RENDERMODE_TRANSALPHA )
	  			ply:SetNWBool("IsAFK", true )
	  		end
		else
			ply:SendLua([[ chat.AddText( Color( 26, 198, 255 ), "(Simple AFK System) ", Color( 255, 255, 255 ), "Please provide a reason for being AFK" ) ]])
		end
		return ""
	end
end )

hook.Add( "PlayerSay", "SimpleAFKSystemReturn", function( ply, text, team )
	local text = string.lower( text )
	if ( string.sub( text, 1, 7 ) == "!notafk" ) then
		if ( ply:GetNWBool("IsAFK", false ) ) then
			for k, v in pairs( player.GetAll() ) do
				net.Start("SimpleAFKSystemAnnounce")
					net.WriteBool( false )
					net.WriteEntity( ply )
				net.Send( v )
				v:SendLua([[ surface.PlaySound("ambient/levels/canals/windchime2.wav") ]])
			end
			if not ( ply:Alive() ) then
				ply:Spawn()
			end
			ply:StripAmmo()
	  		ply:StripWeapons()
	  		ply:Give("weapon_physgun")
	  		ply:Give("weapon_physcannon")
		    ply:Give("gmod_tool")
		    ply:Give("gmod_camera")
		    ply:SelectWeapon("weapon_physgun")
		    ply:UnLock()
		    ply:SetCollisionGroup( 0 )
		    ply:SetColor( Color( 255, 255, 255, 255 ) )
			ply:SetRenderMode( RENDERMODE_NORMAL )
		    ply:SetNWBool("IsAFK", false )
		else
			ply:SendLua([[ chat.AddText( Color( 26, 198, 255 ), "(Simple AFK System) ", Color( 255, 255, 255 ), "You are not AFK" ) ]])
		end
		return ""
	end
end )