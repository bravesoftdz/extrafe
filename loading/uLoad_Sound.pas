unit uLoad_Sound;

interface
uses
  System.Classes,
  Winapi.Windows,
  FMX.Dialogs,
  Bass;

  procedure uLoad_Sound_StartSoundSystem;
  procedure uLoad_Sound_LoadSounds;

implementation
uses
  main,
  uLoad_AllTypes;

procedure uLoad_Sound_StartSoundSystem;
begin
// Edo ola prepei na mpoune se katastasi try with expections.

  if (HiWord(BASS_GetVersion) <> BASSVERSION) then
	  begin
		  MessageBox(0,'An incorrect version of BASS.DLL was loaded',nil,MB_ICONERROR);
  		Halt;
	  end;
  if not BASS_Init(-1, 44100, BASS_DEVICE_SPEAKERS, Winapi.Windows.HANDLE_PTR(Main_Form), nil) then
      MessageBox(0,'Error initializing audio!',nil,MB_ICONERROR);
  if BASS_PluginLoad(PChar(extrafe.prog.Paths.Lib+ 'bass_fx.dll'), 0)= 0 then
    begin

    end;
end;

procedure uLoad_Sound_LoadSounds;
begin
  //Add Sound Effects
  //MainMenu 1-10
  sound.str_fx[1]:= BASS_StreamCreateFile(False, PChar(extrafe.prog.Path + 'data\sounds\click.mp3'), 0, 0, 0 {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF});
  sound.str_fx[2]:= BASS_StreamCreateFile(False, PChar(extrafe.prog.Path + 'data\sounds\no.mp3'), 0, 0, 0 {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF});
  //Gui_System
  //Virtual_Keyboard 11-20
  sound.str_fx[11]:= BASS_StreamCreateFile(False, PChar(extrafe.prog.Path + 'data\sounds\tick.mp3'), 0, 0, 0 {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF});
  sound.str_fx[12]:= BASS_StreamCreateFile(False, PChar(extrafe.prog.Path + 'data\sounds\wrong.mp3'), 0, 0, 0 {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF});
  //Configuration sound effects 21-30
  sound.str_fx[21]:= BASS_StreamCreateFile(False, PChar(extrafe.prog.Path + 'data\sounds\gui_button_click.mp3'), 0, 0, 0 {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF});

  //Emulators Sound Effects 101-300
  //Arcade
  sound.str_fx[101]:= BASS_StreamCreateFile(False, PChar(extrafe.prog.Path + 'data\sounds\Emulators\Arcade\Emulators_Arcade.mp3'), 0, 0, 0 {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF});
  sound.str_fx[102]:= BASS_StreamCreateFile(False, PChar(extrafe.prog.Path + 'data\sounds\Emulators\Arcade\Emulators_Arcade_Mame.mp3'), 0, 0, 0 {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF});
  sound.str_fx[103]:= BASS_StreamCreateFile(False, PChar(extrafe.prog.Path + 'data\sounds\Emulators\Arcade\Emulators_Arcade_Zinc.mp3'), 0, 0, 0 {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF});

  //Widgets Sound Effects
  //SoundPlayer 301-350
  sound.str_fx[301]:= BASS_StreamCreateFile(False, PChar(extrafe.prog.Path + 'data\sounds\widgets\soundplayer\w_sp_s_dropstylus.mp3'), 0, 0, 0 {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF});


end;

end.
