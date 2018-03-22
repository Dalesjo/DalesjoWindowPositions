;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;
; https://github.com/Dalesjo/DalesjoWindowPositions/
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;
; Set workingdirectory to scripts directory and config file name
; make sure you have writing persmissions to be able to save
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;
SetWorkingDir %A_ScriptDir%
config = %A_AppData%\DalesjoWindowPositions.ini

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;
; Reading default names of the diffrent membank names. we have a total of 
; 11 membanks each with 9 memories
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;
IniRead, memname_0, %config%, Windows, memname_0, Membank 1
IniRead, memname_9, %config%, Windows, memname_9, Membank 2
IniRead, memname_18, %config%, Windows, memname_18, Membank 3
IniRead, memname_27, %config%, Windows, memname_27, Membank 4
IniRead, memname_36, %config%, Windows, memname_36, Membank 5
IniRead, memname_45, %config%, Windows, memname_45, Membank 6
IniRead, memname_54, %config%, Windows, memname_54, Membank 7
IniRead, memname_63, %config%, Windows, memname_63, Membank 8
IniRead, memname_72, %config%, Windows, memname_72, Membank 9
IniRead, memname_81, %config%, Windows, memname_81, Membank 10
IniRead, memname_90, %config%, Windows, memname_90, Membank 11

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;
; Reading default memories, we have a total of 99 memories in 11 different membanks.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;
Loop, 99
{
	IniRead, W%A_Index%, %config%, Windows, W%A_Index%
	IniRead, H%A_Index%, %config%, Windows, H%A_Index%
	IniRead, X%A_Index%, %config%, Windows, X%A_Index%
	IniRead, Y%A_Index%, %config%, Windows, Y%A_Index%
	
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;
; Startup configuration, setting first membank and allowed membank numbers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;
IniRead, membank, %config%, Windows, membank, 0
o_start := membank+1
o_stop := membank+9


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;
; Saves active windows current position in x/y width and height
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;
winp_save(i)
{
	global
	o := i+membank
	
	WinGetActiveStats Title, W%o%, H%o%, X%o%, Y%o%
	
	IniWrite, % W%o%, %config%, Windows, W%o%
	IniWrite, % H%o%, %config%, Windows, H%o%
	IniWrite, % X%o%, %config%, Windows, X%o%
	IniWrite, % Y%o%, %config%, Windows, Y%o%
	
	
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;
; sets active windows to saved position in x/y width and height
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;
winp_load(i)
{
	global
	
	o := i+membank
	
	WinGetTitle, Title, A	
	WinGet isMaximized, MinMax, %Title%
	

	if (isMaximized == 1)
	{
		WinRestore, %Title% 
	}
	
	WinMove, %Title%, , % X%o%, % Y%o%, % W%o%, % H%o%, ,
	
	
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;
; Allows user to set username
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;
membank_name()
{
	global

	InputBox memname_%membank%, Memorybank, New name of memorybank %o_start% till %o_stop%,,400,130,,,,, % memname_%membank%
	
	IniWrite, % memname_%membank%, %config%, Windows, memname_%membank%
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;
; Loads one of the 9 different membanks.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;
membank_set(i)
{
	global
	
	membank := membank+(i*9)
	
	if (membank < 0)
	{
		membank = 90
	}
	
	if (membank > 90)
	{
		membank = 0
	}	

	IniWrite, %membank%, %config%, Windows, membank	
	o_start := membank+1
	o_stop := membank+9	

	tmp_mem_name =  % memname_%membank%	
	TrayTip WindowPositions,Loading memory %tmp_mem_name%,10,1
}	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;
; All Keybindnings.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;

; control + win + numpad
^#Numpad1::winp_save(1)
^#Numpad2::winp_save(2)
^#Numpad3::winp_save(3)
^#Numpad4::winp_save(4)
^#Numpad5::winp_save(5)
^#Numpad6::winp_save(6)
^#Numpad7::winp_save(7)
^#Numpad8::winp_save(8)
^#Numpad9::winp_save(9)

; win + numpad
#Numpad1::winp_load(1)
#Numpad2::winp_load(2)
#Numpad3::winp_load(3)
#Numpad4::winp_load(4)
#Numpad5::winp_load(5)
#Numpad6::winp_load(6)
#Numpad7::winp_load(7)
#Numpad8::winp_load(8)
#Numpad9::winp_load(9)

#NumpadAdd::membank_set(1)
#NumpadSub::membank_set(-1)

#NumpadDot::membank_name()

#NumpadMult::
	WinGetTitle, Title, A
	InputBox, newTitle, New name, Change name of the active window %Title%, , 800, 150,,,,, %Title%
	WinSetTitle, %Title%,,%newTitle%
RETURN

^#Numpad0::
#Numpad0::
	WinGetPos,X,Y,W,H,A
	
	InputBox , w_width, Width, Set width of window: , , 160, 130, , , , , %W%
	InputBox , w_height, Height, Set height of window , , 160, 130, , , , , %H%
	
	InputBox , X, Position X, Set Position X in pixels , , 180, 130, , , , , %X%
	InputBox , Y, Position Y, Set Position Y in pixels , , 180, 130, , , , , %Y%

	WinMove,A,,%X%,%Y%,%w_width%,%w_height%

return

^#NumpadEnter::
#NumpadEnter::
	
	WinGetActiveStats Title, window_w, window_h, window_x, window_y
	msgbox Title: %Title%  `nWidth: %window_w% `nHeight: %window_h% `nPosition X: %window_x% `nPosition Y: %window_y%
return